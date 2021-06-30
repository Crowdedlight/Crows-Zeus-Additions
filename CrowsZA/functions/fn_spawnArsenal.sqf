/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_spawnArsenal.sqf
Parameters: pos, _unit
Return: none

spawns an nato supply crate and set as ace arsenal

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _posAGL = ASLToAGL _pos;

//spawn nato supply create at position
private _crate = "B_supplyCrate_F" createVehicle _posAGL;

//ZEN event that registers the object as editable by zeus. Remember the function wants array not single object
["zen_common_addObjects", [[_crate], objNull]] call CBA_fnc_serverEvent;

//set item as ACE Arsenal - Removing any arsenal from it first, for safety
if (crowsZA_common_aceModLoaded) then {
	[_crate, true] call ace_arsenal_fnc_removeBox;
	[_crate, true] call ace_arsenal_fnc_initBox;
} else {
	// set as default arsenal
	// Removes Arsenal from player object
	["AmmoboxExit", _crate] call BIS_fnc_arsenal;
	
	// Adds full Arsenal to the player object and makes the action available when the player is closer than 10 meters from ammoBox
	["AmmoboxInit", [_crate, true, { _this distance _target  < 10 }]] call BIS_fnc_arsenal;
};