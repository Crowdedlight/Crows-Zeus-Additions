#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_spawnSupplyDrop.sqf
Parameters: position ASL and unit clicked
Return: none


*///////////////////////////////////////////////

params ["_groupLeader", "_addAmount", "_ammoList", "_itemList", "_rearm"];

scopeName "main"; 

private _airdropPos = [];
private _velocitySet = [0,0,0];
// if array we got a pos, otherwise we got aircraft
if (typeName _groupLeader == "ARRAY") then {
	_airdropPos = _groupLeader;
} else {
	// as this is by waypoint statement it will be executed on all machines. Check for locality to only spawn one.
	if (!local _groupLeader) then {
		breakOut "main";
	};
	// get aircraft
	private _aircraft = vehicle _groupLeader; 
	private _pos = ASLToAGL (getPosASL _aircraft);

	//get bounding box, to know how far back we should spawn the create
	private _model_len = abs(((2 boundingBox _aircraft) select 0) select 0);

	// as we should be over drop-position, we spawn crate 0.8x the distance form pos to end of geometry. 
	_airdropPos = _pos getPos [_model_len*0.8, (getDir _aircraft) - 180];
	_airdropPos set [2, _pos select 2];

	// if in plane we try to match part of current plane velocity
	_velocitySet = velocity _aircraft;
	_velocitySet = [(_velocitySet#0) * 0.2, (_velocitySet#1) * 0.2, (_velocitySet#2) * 0.2];
};

// spawn container 
private _container = createVehicle ["C_IDAP_supplyCrate_F", _airdropPos,[],0,"CAN_COLLIDE"];
_container setVelocity _velocitySet;

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

// use BIS function for parachute, delay it to next frame to ensure its spawned
[{[objNull, _this#0] call BIS_fnc_curatorObjectEdited}, [_container]] call CBA_fnc_execNextFrame;

// attach smoke/chemlight grenade to crate and make it smoke. Spawning function to ensure it keeps smoking and lighting up until at least 5min have passed
private _indicatorSpawn = [_container, 300] spawn {
	params ["_box", "_maxTime"];
	private _startTime = time;

	// blue chemlight ends 
	_supplyLight1 = "Chemlight_blue" createVehicle (position _box);
	_supplyLight1 attachTo [_box, [-0.655,0,0.3]];
	_supplyLight2 = "Chemlight_blue" createVehicle (position _box);
	_supplyLight2 attachTo [_box, [0.655,0,0.3]];

	// blue chemlight sides - rotate object
	_supplyLight3 = "Chemlight_blue" createVehicle (position _box);
	_supplyLight3 attachTo [_box, [0,0.39,0.3]];
	_supplyLight3 setDir 90;

	_supplyLight4 = "Chemlight_blue" createVehicle (position _box);
	_supplyLight4 attachTo [_box, [0,-0.39,0.3]];
	_supplyLight4 setDir 90;

	_supplySmoke = "SmokeShellBlue" createVehicle (position _box);
	_supplySmoke attachTo [_box, [0,0,0]];

	// repeat until time is up
	while {(time - _startTime) <= _maxTime} do {
		// chemlights respawn
		if (isNull _supplyLight1) then {
			_supplyLight1 = "Chemlight_blue" createVehicle (position _box);
			_supplyLight1 attachTo [_box, [-0.655,0,0.3]];
		};
		if (isNull _supplyLight2) then {
			_supplyLight2 = "Chemlight_blue" createVehicle (position _box);
			_supplyLight2 attachTo [_box, [0.655,0,0.3]];
		};
		if (isNull _supplyLight3) then {
			_supplyLight3 = "Chemlight_blue" createVehicle (position _box);
			_supplyLight3 attachTo [_box, [0,0.39,0.3]];
			_supplyLight3 setDir 90;
		};
		if (isNull _supplyLight4) then {
			_supplyLight4 = "Chemlight_blue" createVehicle (position _box);
			_supplyLight4 attachTo [_box, [0,-0.39,0.3]];
			_supplyLight4 setDir 90;
		};

		// smoke respawn
		if (isNull _supplySmoke) then {
			_supplySmoke = "SmokeShellBlue" createVehicle (position _box);
			_supplySmoke attachTo [_box, [0,0,0]];
		};
		// don't need to check more than once per second
		sleep 1;
	};
};

// add container to editable
["zen_common_updateEditableObjects", [[_container]]] call CBA_fnc_serverEvent;

// if rearm, set as ace rearm vehicle 
if (_rearm) then {
	[_container] remoteExec ["ace_rearm_fnc_makeSource", 2];
};
