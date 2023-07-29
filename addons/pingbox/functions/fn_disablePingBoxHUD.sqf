#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_disablePingBoxHUD.sqf
Parameters: 
Return: none

disabled pingbox hud

*///////////////////////////////////////////////

// if handler is empty its because we have had this disabled from the start and the initial load just does a "disable"
if (isNil "crowsZA_pingbox_handler") exitWith {};

// remove handler 
[crowsZA_pingbox_handler] call CBA_fnc_removePerFrameHandler;

// remove zeus ping eventhandler
if (!isNil "crowsZA_pingbox_ping_EH") then {
	(getAssignedCuratorLogic player) removeEventHandler ["CuratorPinged", crowsZA_pingbox_ping_EH];
};

// remove layer 
"crowsZA_pingbox_layer" cutText ["","PLAIN"];

// remove backspace handler
crowsZA_pingbox_backspace_handler call CBA_fnc_removeKeyHandler;
crowsZA_pingbox_y_handler call CBA_fnc_removeKeyHandler;
