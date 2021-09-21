#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_disablePingBoxHUD.sqf
Parameters: 
Return: none

disabled pingbox hud

*///////////////////////////////////////////////

// remove handler 
[crowsZA_pingbox_handler] call CBA_fnc_removePerFrameHandler;

// remove zeus ping eventhandler
if (!isNil "crowsZA_pingbox_ping_EH") then {
	(getAssignedCuratorLogic player) removeEventHandler ["CuratorPinged", crowsZA_pingbox_ping_EH];
};

// remove layer 
"crowsZA_pingbox_layer" cutText ["","PLAIN"];
