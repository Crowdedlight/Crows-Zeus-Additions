/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_deleteAllAnimalFollow.sqf
Parameters: pos, _unit (We don't use unit, just pos)
Return: none

Removes all animals agents spawned with the animal follow module

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	//delete all animals that follow players and update global var
	diag_log crowsZA_animalFollowList;
	{deleteVehicle _x} forEach crowsZA_animalFollowList;

	//update global var
	crowsZA_animalFollowList = [];
	publicVariable "crowsZA_animalFollowList";
};
[
	"Are you sure you will delete all animals following people?", 
	[
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
