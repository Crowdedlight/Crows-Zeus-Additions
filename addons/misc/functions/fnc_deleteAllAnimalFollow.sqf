#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_deleteAllAnimalFollow.sqf
Parameters: pos, _unit (We don't use unit, just pos)
Return: none

Removes all animals agents spawned with the animal follow module

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	//delete all animals that follow players and update global var
	diag_log GVAR(animalFollowList);
	{deleteVehicle _x} forEach GVAR(animalFollowList);

	//update global var
	GVAR(animalFollowList) = [];
	publicVariable QGVAR(animalFollowList);
};
[
	localize "STR_CROWSZA_Misc_delete_animal_followers", 
	[
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
