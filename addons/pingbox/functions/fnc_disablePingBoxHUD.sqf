#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_disablePingBoxHUD.sqf
Parameters: 
Return: none

disabled pingbox hud

*///////////////////////////////////////////////

// if handler is empty its because we have had this disabled from the start and the initial load just does a "disable"
if (isNil QGVAR(box_handler)) exitWith {};

// remove handler 
[GVAR(box_handler)] call CBA_fnc_removePerFrameHandler;

// remove zeus ping eventhandler
if (!isNil QGVAR(ping_EH)) then {
	(getAssignedCuratorLogic player) removeEventHandler ["CuratorPinged", GVAR(ping_EH)];
};

// remove layer 
QGVAR(layer) cutText ["","PLAIN"];

// remove backspace handler
GVAR(backspace_handler) call CBA_fnc_removeKeyHandler;
GVAR(y_handler) call CBA_fnc_removeKeyHandler;
