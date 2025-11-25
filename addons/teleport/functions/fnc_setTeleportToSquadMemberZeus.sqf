#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_setTeleportToSquadMemberZeus.sqf
Parameters: position ASL and unit clicked
Return: none

Sets the selected object to give the option to all players of "teleport to squadmate" on scrollwheel. 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// exit if not a vehicle
if (isNull _unit) exitWith { ["STR_CROWSZA_Teleport_action_error"] call EFUNC(main,showHint); };

// set object as teleport 2 squadmate
[_unit, [localize "STR_CROWSZA_Teleport_action_teleport_to_squadmate", {[[],player] call FUNC(teleportToSquadMember)}]] remoteExec ['addAction', ([0, -2] select isDedicated), true];

// TODO... this only works for players that has the mod loaded... So if used as optional clientside, then whoever do not have the mod loaded won't be able to use it...
