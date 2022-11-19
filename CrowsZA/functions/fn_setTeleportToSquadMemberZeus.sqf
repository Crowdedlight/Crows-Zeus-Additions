/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_setTeleportToSquadMemberZeus.sqf
Parameters: position ASL and unit clicked
Return: none

Sets the selected object to give the option to all players of "teleport to squadmate" on scrollwheel. 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// exit if not a vehicle
if (isNull _unit) exitWith { ["You must select an object"] call crowsZA_fnc_showHint; };

// set object as teleport 2 squadmate
[_unit, ["<t color=""#FFFF00"">Teleport To Squadmate", {[[],player] call crowsZA_fnc_teleportToSquadMember}]] remoteExec ['addAction', ([0, -2] select isDedicated), true];