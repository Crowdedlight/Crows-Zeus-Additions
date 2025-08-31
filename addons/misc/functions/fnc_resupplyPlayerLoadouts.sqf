#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_resupplyPlayerLoadouts.sqf
Parameters: position ASL and unit clicked
Return: none


*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _onConfirm =
{
	scopeName "main"; 

	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_zeusMultiplier",
		"_airdrop",
		"_useAircraft",
		"_selectedAircraft",
		"_customAircraft",
		"_flyfrom",
		"_height",
		"_medical",
		"_includeZeus",
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
		if (!isNull (getAssignedCuratorLogic _x) && !_includeZeus) then { continue; };

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
		if (EGVAR(main,aceLoaded)) then {
			_itemList append ["ACE_quikclot", "ACE_elasticBandage", "ACE_packingBandage", "ACE_adenosine", "ACE_epinephrine", "ACE_morphine", "ACE_splint", "ACE_salineIV_500", "ACE_salineIV", "ACE_tourniquet", "ACE_fieldDressing", "ACE_suture"];
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
		["zen_common_updateEditableObjects", [[_container]]] call CBA_fnc_serverEvent;

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

			[_airDropPos, _addAmount, _ammoList, _itemList, _rearm] call FUNC(spawnSupplyDrop);

		} else {
			// test if custom aircraft is given
			if (_customAircraft != "") then {
				// test if classname exists, then save it in _selectedAircraft
				private _validAircraft = isClass (configFile >> "CfgVehicles" >> _customAircraft);
				if (!_validAircraft) then {
					hint localize "STR_CROWSZA_Misc_resupply_loadouts_error"; 
					breakOut "main";
				};
				_selectedAircraft = _customAircraft;
			};

			// Sets what direction the aircraft will fly towards
			private _direction = switch (_flyfrom) do {
				//Fly from is North
				case 0: {180};
				//Fly from is North East
				case 1: {225};
				//Fly from is East
				case 2: {270};
				//Fly from is South East
				case 3: {315};
				//Fly from is South
				case 4: {0};
				//Fly from is South West
				case 5: {45};
				//Fly from is West
				case 6: {90};
				//Fly from is North West
				case 7: {135};
			};
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
			_waypoint setWaypointStatements ["true", format["[this,%1,%2,%3,%4] call %5;", _addAmount, _ammoList, _itemList, _rearm, QFUNC(spawnSupplyDrop)]];

			// final waypoint 
			private _waypointEnd = _group addWaypoint [_endPos, 1];
			_waypointEnd setWaypointType "MOVE";
			_waypointEnd setWaypointBehaviour "CARELESS";
			_waypointEnd setWaypointCombatMode "BLUE";
			_waypointEnd setWaypointSpeed _speed;

			// cleanup
			_waypointEnd setWaypointStatements ["true", "private _group = group this; private _aircrafts = []; {_aircrafts pushBackUnique vehicle _x; deleteVehicle _x} forEach thisList; {deleteVehicle _x} forEach _aircrafts; deleteGroup _group"];

			// add plane to zeus editable so they can see it coming
			["zen_common_updateEditableObjects", [[_aircraft]]] call CBA_fnc_serverEvent;
		};
	};
};

private _dialogOptions = [EGVAR(main,aceLoaded), GVAR(resupply_aircraftList), GVAR(resupply_aircraftDisplayList)] call {
	params ["_aceLoaded", "_aircraftList", "_aircraftDisplayList"];
	private _arr = [];

	_arr = [
		["SLIDER", localize "STR_CROWSZA_Misc_resupply_loadouts_multiplier_dialog",[0,50,5,0]], //0 to 50, default 5 and showing 0 decimal
		["CHECKBOX",[localize "STR_CROWSZA_Misc_resupply_loadouts_airdrop", localize "STR_CROWSZA_Misc_resupply_loadouts_airdrop_tooltip"],[true]],
		["CHECKBOX",[localize "STR_CROWSZA_Misc_resupply_loadouts_aircraft", localize "STR_CROWSZA_Misc_resupply_loadouts_aircraft_tooltip"],[true]],
		["COMBO",[localize "STR_CROWSZA_Misc_resupply_loadouts_choose_aircraft", localize "STR_CROWSZA_Misc_resupply_loadouts_choose_aircraft_tooltip"],[_aircraftList, _aircraftDisplayList,0]],
		["EDIT",[localize "STR_CROWSZA_Misc_resupply_loadouts_custom_type", localize "STR_CROWSZA_Misc_resupply_loadouts_custom_type_tooltip"], "", false],
		["TOOLBOX", localize "STR_CROWSZA_Misc_resupply_loadouts_flyfrom", [0, 1, 8, [localize "STR_CROWSZA_Misc_N", localize "STR_CROWSZA_Misc_NE", localize "STR_CROWSZA_Misc_E", localize "STR_CROWSZA_Misc_SE", localize "STR_CROWSZA_Misc_S", localize "STR_CROWSZA_Misc_SW", localize "STR_CROWSZA_Misc_W", localize "STR_CROWSZA_Misc_NW"]]],
		["SLIDER",localize "STR_CROWSZA_Misc_resupply_loadouts_airdrop_height",[50,1000,200,0]],
		["CHECKBOX",[localize "STR_CROWSZA_Misc_resupply_loadouts_medical", localize "STR_CROWSZA_Misc_resupply_loadouts_medical_tooltip"],[true]],
		["CHECKBOX",[localize "STR_CROWSZA_Misc_resupply_loadouts_zeus", localize "STR_CROWSZA_Misc_resupply_loadouts_zeus_tooltip"],[false]]
	];

	// add options for ace rearm vehicle if ace is used
	if (_aceLoaded) then {
		_arr pushBack ["CHECKBOX",[localize "STR_CROWSZA_Misc_resupply_loadouts_ace_rearm", localize "STR_CROWSZA_Misc_resupply_loadouts_ace_rearm_tooltip"],[false]];
	};
	_arr;
};
[
	localize "STR_CROWSZA_Misc_resupply_loadouts_multiplier", 
	_dialogOptions,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

