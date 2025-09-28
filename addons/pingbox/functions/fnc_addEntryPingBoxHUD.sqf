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
// [[_playername, timeAtPing, numberOfRecentPings], ...]

// How many times the player has pinged recently
private _numPings = 1;

// Remove existing entry for this player (if any)
// This prevents older pings from getting "buried" by spam pinging
private _index = GVAR(ping_list) findIf {(_x select 0) isEqualTo _player};
if (_index > -1) then {
	private _previousPing = GVAR(ping_list) select _index;
	_previousPing params ["_name", "_previousPingTime", "_previousNumPings"];
	
	// If the last ping was less than a spamPing_threshold seconds ago, we count it as ping-spamming
	private _timeDiff = round(time - _previousPingTime);
	if (_timeDiff < GVAR(CBA_Setting_spamPing_threshold)) then {
		_numPings = _previousNumPings + 1;
	};
	
    GVAR(ping_list) deleteAt _index;
};

// pushBack to array 
GVAR(ping_list) pushBack [_player, time, _numPings];

// check count of global array with entries, if > CBA_Setting_Pingbox_Size, pop the oldest in array. (FIFO)
if (count GVAR(ping_list) > GVAR(CBA_Setting_Pingbox_Size)) then {
	GVAR(ping_list) deleteAt (GVAR(CBA_Setting_Pingbox_Size));
};

// sort array 
GVAR(ping_list) = [GVAR(ping_list), [], {_x select 1}, "DESC"] call BIS_fnc_sortBy;

// last time we added to array 
GVAR(ping_list_update) = time;

// if display is faded, enable it.
 if (GVAR(faded)) then {
	 QGVAR(layer) cutRsc ["crowsza_pingbox_hud","PLAIN", 0, true];
	 GVAR(faded) = false;
 };
