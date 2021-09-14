/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_resupplyPlayerLoadouts.sqf
Parameters: position ASL and unit clicked
Return: none


*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_zeusMultiplier",
		"_airdrop",
		"_useAircraft",
		"_selectedAircraft",
		"_height",
		"_medical",
		"_rearm"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	private _ammoList = [];
	private _itemList = [];
	private _playerCount = 0;

	// if rearm is null, we set it to false
	if (isNil "_rearm") then { _rearm = false; };

	// run though all players
	{
		// if zeus, skip it
		if (!isNull (getAssignedCuratorLogic _x)) then { continue; };

		// get all magazines from players
		private _mags = magazines [_x, true];

		// append to array
		_ammoList append _mags;

		// get mags loaded from current weapons
		private _weaponsList = weaponsItems _x;
		{
			private _primaryMag = _x select 4;
			private _secondaryMag = _x select 5;

			// if not empty, add the magazines
			if (count _primaryMag == 2) then {
				_ammoList pushBack (_primaryMag select 0);
			};
			if (count _secondaryMag == 2) then {
				_ammoList pushBack (_secondaryMag select 0);
			};
		} forEach _weaponsList;

		// increment players, could get it from playercount, but we are here anyway and can sort zeus out this way
		_playerCount = _playerCount + 1;

	} forEach allPlayers;

	// add medical if enabled. Either ACE or base-game
	if (_medical) then {
		if (crowsZA_common_aceModLoaded) then {
			_itemList append ["ACE_quikclot", "ACE_elasticBandage", "ACE_packingBandage", "ACE_adenosine", "ACE_epinephrine", "ACE_morphine", "ACE_splint", "ACE_salineIV_500", "ACE_tourniquet", "ACE_fieldDressing"];
		} else {
			_itemList append ["FirstAidKit"];
		}
	};

	// got all mags, now get rid of duplicates 
	private _ammoList = _ammoList arrayIntersect _ammoList;
	private _itemList = _itemList arrayIntersect _itemList;

	// add amount
	private _addAmount = _playerCount * _zeusMultiplier;

	// if airdrop is not set, spawn on ground
	if (!_airdrop) then {

		// spawn container 
		private _container = "C_IDAP_supplyCrate_F" createVehicle (ASLToAGL _pos);

		clearWeaponCargoGlobal _container;
		clearMagazineCargoGlobal _container;
		clearItemCargoGlobal _container;
		clearBackpackCargoGlobal _container;

		// go through all mags, and add them to container based on zeus amount set multiplied with player count
		{
			// add to container 
			_container addMagazineCargoGlobal [_x, _addAmount];
		} forEach _ammoList;
		// item list
		{
			_container addItemCargoGlobal [_x, _addAmount];
		} forEach _itemList;

		// add container to editable
		["zen_common_addObjects", [[_container], objNull]] call CBA_fnc_serverEvent;

		// if rearm and ace loaded
		if (_rearm) then {
			[_container] remoteExec ["ace_rearm_fnc_makeSource", 2];
		};
	} 
	// if airdrop is set start prepping for airdrop
	else {

		// check if we just spawn it at pos and altitude, or use aircraft
		if (!_useAircraft) then {
			// spawn crate in air
			// modify pos to altitude
			private _airDropPos = ASLToAGL _pos;
			_airDropPos set [2, _height];

			[_airDropPos, _addAmount, _ammoList, _itemList, _rearm] call crowsZA_fnc_spawnSupplyDrop;

		} else {

			// get random direction from 0 to 7 index and convert to degrees
			private _direction = (random 7) * 45;
			private _distance = 2000;
			private _aircraftType = _selectedAircraft;
			private _speed = ["LIMITED", "NORMAL", "FULL"] select 1;

			// convert to AGL
			_pos = ASLToAGL _pos;
			
			// calculate to and from waypoints for plane, and direction to look. 
			private _startPos = _pos getPos [_distance, _direction - 180];
			private _endPos   = _pos getPos [_distance, _direction];

			// set altitude as flight-height
			_startPos set [2, _height];
			_endPos   set [2, _height];

			// create group - Using civilian so none shoots at it. Set to delete when empty
			private _group = createGroup [civilian, true];

			// spawn plane at start pos and start it flying in direction 
			private _aircraft = createVehicle [_aircraftType, _startPos, [], 0, "FLY"];
			_aircraft setPos _startPos;
			_aircraft setDir _direction;

			// set initial velocity
			_aircraft setVelocity [sin _direction * 100, cos _direction * 100, 0];

			// create aircraft crew
			createVehicleCrew _aircraft;
			crew _aircraft joinSilent _group;
			_group addVehicle _aircraft;

			// set flight height 
			_aircraft flyInHeight _height;

			// make crew handle aircraft better by changing behaviour and ignoring surroundings
			_aircraft setCaptive true;
			{
				_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
				_x disableAI "AUTOCOMBAT";
				_x setCaptive true;
				_x setSkill 1;
			} forEach crew _aircraft;

			// set first waypoint, over dropzone 
			private _waypoint = _group addWaypoint [_pos, -1];
			_waypoint setWaypointType "MOVE";
			_waypoint setWaypointBehaviour "CARELESS";
			_waypoint setWaypointCombatMode "BLUE";
			_waypoint setWaypointSpeed _speed;
			_waypoint setWaypointCompletionRadius 2; // only complete if within 2m of the waypoint

			// when over drop-point, spawn crate below plane and attach chute 
			_waypoint setWaypointStatements ["true", format["[this,%1,%2,%3,%4] call crowsZA_fnc_spawnSupplyDrop;", _addAmount, _ammoList, _itemList, _rearm]];

			// final waypoint 
			private _waypointEnd = _group addWaypoint [_endPos, 1];
			_waypointEnd setWaypointType "MOVE";
			_waypointEnd setWaypointBehaviour "CARELESS";
			_waypointEnd setWaypointCombatMode "BLUE";
			_waypointEnd setWaypointSpeed _speed;

			// cleanup
			_waypointEnd setWaypointStatements ["true", "private _group = group this; private _aircrafts = []; {_aircrafts pushBackUnique vehicle _x; deleteVehicle _x} forEach thisList; {deleteVehicle _x} forEach _aircrafts; deleteGroup _group"];

			// add plane to zeus editable so they can see it coming
			["zen_common_addObjects", [[_aircraft], objNull]] call CBA_fnc_serverEvent;
		};
	};
};

// check if SOG is loaded, then offer the huey as transport
private _aircraftList = ["B_T_VTOL_01_vehicle_F"];
private _aircraftDisplayList = ["Blackfish"];

if (crowsZA_common_sogLoaded) then {
	_aircraftList pushBack "vn_b_air_uh1c_07_07";
	_aircraftDisplayList pushBack "Huey Slick (SOG)";
};

private _dialogOptions = [crowsZA_common_aceModLoaded, _sogLoaded, _aircraftList, _aircraftDisplayList] call {
	params ["_aceLoaded", "_sogLoaded", "_aircraftList", "_aircraftDisplayList"];
	private _arr = [];
	if (_aceLoaded) then {
		_arr = [
			["SLIDER","Multiplier (amount per player)",[0,50,5,0]], //0 to 50, default 5 and showing 0 decimal
			["CHECKBOX",["Airdrop", "Make it airdrop from 300m"],[true]],
			["CHECKBOX",["Aircraft", "Make aircraft drop it"],[true]],
			["COMBO",["Choose Aircraft", "What aircraft to drop the supply from"],[_aircraftList, _aircraftDisplayList,0]],
			["SLIDER","Airdrop height [m]",[50,1000,200,0]],
			["CHECKBOX",["Medical", "Add Medical supplies"],[true]],
			["CHECKBOX",["ACE Rearm", "Set as ACE Rearm vehicle"],[false]]
		];
	} else {
		_arr = [
			["SLIDER","Multiplier (amount per player)",[0,50,5,0]], //0 to 50, default 5 and showing 0 decimal
			["CHECKBOX",["Airdrop", "Make it airdrop from 300m"],[true]],
			["CHECKBOX",["Aircraft", "Make aircraft drop it"],[true]],
			["COMBO",["Choose Aircraft", "What aircraft to drop the supply from"],[_aircraftList, _aircraftDisplayList,0]],
			["SLIDER","Airdrop height [m]",[50,1000,200,0]],
			["CHECKBOX",["Medical", "Add Medical supplies"],[true]]
		];
	};
	_arr;
};
[
	"Set multipler for ammo supply", 
	_dialogOptions,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

