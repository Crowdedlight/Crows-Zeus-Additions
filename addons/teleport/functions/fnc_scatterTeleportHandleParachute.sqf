#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_scatterTeleportHandleParachute.sqf
Parameters: _unit
Return: none

Teleports selected vics to the position clicked in a pattern with the selected distance between each and at set altitude over ground. Then it attaches a parachute 

*///////////////////////////////////////////////
params ["_unit"];

// test if backpack is already a parachute, then do nothing


// test if ace is loaded
if (EGVAR(main,aceLoaded)) then {
	// move backpack to chest, and put steearble parachute on back
} else {
	// we are non-ace, so use the code to save backpack and remove it until on the ground. 
	
}













// // get array of TP positions, split into own file for future support of different "shapes"/patterns
// private _tpArray = [_targetPos, count _units, _offset, _targetAltitude] call crowsza_fnc_scatterPatternOutwardSpiral;

// // now run through each unit and tp
// {
// 	//reset velocity 
// 	_x setvelocity [0,0,0];

// 	//set position, use setPos or setVehiclePosition depending on type
// 	if (_x isKindOf "CAManBase") then {
// 		//tp
// 		_x setPos (_tpArray select _forEachIndex);

// 		//create and attach parachute.  Infantry, so steerable smaller ones
// 		private _chute = createvehicle ["Steerable_Parachute_F", (_tpArray select _forEachIndex),[],0,"CAN_COLLIDE"]; 
// 		_x attachTo [_chute,[0,0,1]];
// 	} else {
// 		//tp
// 		_x setVehiclePosition [(_tpArray select _forEachIndex), [], 0, "CAN_COLLIDE"];

// 		//we attach it lower than vic, as it doesn't "disconnect" until parachute anchor hits ground, 
// 		//	and then depending on how much vic went into the ground it bounces back. Doing it like this provide only a little unharmful bounce
// 		private _chute = createvehicle ["i_parachute_02_f", (_tpArray select _forEachIndex),[],0,"CAN_COLLIDE"]; 
// 		_x attachTo [_chute,[0,0,2]];
// 	};

// }
// forEach _units;
