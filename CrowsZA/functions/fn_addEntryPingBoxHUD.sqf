#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_addEntryPingBoxHUD.sqf
Parameters: 
Return: none

Enables and displays the pingbox hud

[player] call crowsZA_fnc_addEntryPingBoxHUD;

*///////////////////////////////////////////////
params ["_player"];

// ARRAY is made so newest entries are first, and oldest pushed at the back
// [[_playername, timeAtPing], ...]

// check count of global array with entries, if > 3, pop the oldest in array. (FIFO)
if (count crowsZA_pingbox_list >= 3) then {
	crowsZA_pingbox_list deleteAt 2;
};

// pushBack to array 
crowsZA_pingbox_list pushBack [_player, time];

// sort array 
crowsZA_pingbox_list = [crowsZA_pingbox_list, [], {_x select 1}, "DESC"] call BIS_fnc_sortBy;

// last time we added to array 
crowsZA_pingbox_list_update = time;

// if display is faded, enable it.
 if (crowsZA_pingbox_faded) then {
	 "crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true];
	 crowsZA_pingbox_faded = false;
 };
