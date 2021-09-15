#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_enablePingBoxHUD.sqf
Parameters: 
Return: none

Enables and displays the pingbox hud

call crowsZA_fnc_enablePingBoxHUD;

*///////////////////////////////////////////////

// don't show if disabled
if (!crowsZA_CBA_Setting_pingbox_enabled) exitWith {call crowsZA_fnc_disablePingBoxHUD;};

// don't show in eden or for non-players/non-zeus
if (is3DEN || !hasInterface || isNull (getAssignedCuratorLogic player)) exitWith {};

// clear list
crowsZA_pingbox_list = [];
crowsZA_pingbox_faded = false;
crowsZA_pingbox_list_update = 0;

//create hud 
"crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true]; 

// add zeus ping event handler 
crowsZA_pingbox_ping_EH = (getAssignedCuratorLogic player) addEventHandler ["CuratorPinged", {
	params ["_curator", "_player"];
	[_player] call crowsZA_fnc_addEntryPingBoxHUD;
}];

// activate CBA handler
crowsZA_pingbox_handler = [crowsZA_fnc_refreshPingBoxHUD , 0.5] call CBA_fnc_addPerFrameHandler; 
