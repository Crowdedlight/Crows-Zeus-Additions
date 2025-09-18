#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addEntryPingBoxHUD.sqf
Parameters: 
Return: none

Enables and displays the pingbox hud

[player] call crowsza_fnc_addEntryPingBoxHUD;

*///////////////////////////////////////////////
params ["_player"];

// ARRAY is made so newest entries are first, and oldest pushed at the back
// [[_playername, timeAtPing], ...]

// Remove existing entry for this player (if any)
// This prevents older pings from getting "buried" by spam pinging
private _index = GVAR(ping_list) findIf {(_x select 0) isEqualTo _player};
if (_index > -1) then {
    GVAR(ping_list) deleteAt _index;
};

// check count of global array with entries, if > 3, pop the oldest in array. (FIFO)
if (count GVAR(ping_list) >= 3) then {
	GVAR(ping_list) deleteAt 2;
};

// pushBack to array 
GVAR(ping_list) pushBack [_player, time];

// sort array 
GVAR(ping_list) = [GVAR(ping_list), [], {_x select 1}, "DESC"] call BIS_fnc_sortBy;

// last time we added to array 
GVAR(ping_list_update) = time;

// if display is faded, enable it.
 if (GVAR(faded)) then {
	 QGVAR(layer) cutRsc ["crowsza_pingbox_hud","PLAIN", 0, true];
	 GVAR(faded) = false;
 };
