#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_enablePingBoxHUD.sqf
Parameters: 
Return: none

Enables and displays the pingbox hud

call crowsza_fnc_enablePingBoxHUD;

*///////////////////////////////////////////////

// don't show if disabled
if (!GVAR(CBA_Setting_enabled)) exitWith {call FUNC(disablePingBoxHUD);};

// don't show in eden or for non-players/non-zeus
if (is3DEN || !hasInterface || isNull (getAssignedCuratorLogic player)) exitWith {};

// clear list
GVAR(ping_list) = [];
GVAR(faded) = false;
GVAR(ping_list_update) = 0;
GVAR(hidden) = false;
GVAR(currentSize) = 0;

//create hud 
QGVAR(layer) cutRsc ["crowsza_pingbox_hud","PLAIN", 0, true]; 

// add zeus ping event handler 
GVAR(ping_EH) = (getAssignedCuratorLogic player) addEventHandler ["CuratorPinged", {
	params ["_curator", "_player"];
	[_player] call FUNC(addEntryPingBoxHUD);
}];

// activate CBA handler
GVAR(box_handler) = [FUNC(refreshPingBoxHUD) , 0.5] call CBA_fnc_addPerFrameHandler; 

// add handler for backspace - to hide display when in screenshot mode
GVAR(backspace_handler) = [DIK_BACK, [false, false, false], {
	// if faded, no need to change, refresh is disabled in screenshot mode
	if (GVAR(faded)) exitWith {};

	// have to spawn function to wait 0.1, as otherwise we check before the variable for screenshot mode is set...
	[] spawn {
		sleep 0.1;
		// check if in screenshot mode then hide ui, otherwise reshow
		if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false] && !isNull(findDisplay 312)) then {
			// hide pingbox
			QGVAR(layer) cutText ["","PLAIN"];
			GVAR(hidden) = true;
		} else {
			if (GVAR(hidden)) then {
				// failsafe to not remake it if not hidden
				QGVAR(layer) cutRsc ["crowsza_pingbox_hud","PLAIN", 0, true]; 
				GVAR(hidden) = false;
			};
		};
	};
}] call CBA_fnc_addKeyHandler;

// handler for exiting zeus view and reenable pingbox
GVAR(y_handler) = [DIK_Y, [false, false, false], {
	// if faded, no need to change, refresh is disabled in screenshot mode
	if (!GVAR(hidden)) exitWith {};

	// have to spawn function to wait 0.1, as otherwise we check before the variable for screenshot mode is set...
	[] spawn {
		sleep 0.1;
		// check if in screenshot mode then hide ui, otherwise reshow
		if (GVAR(hidden) && isNull(findDisplay 312)) then {
			// reshow pingbox
			QGVAR(layer) cutRsc ["crowsza_pingbox_hud","PLAIN", 0, true]; 
			GVAR(hidden) = false;
		};
	};
}] call CBA_fnc_addKeyHandler;
