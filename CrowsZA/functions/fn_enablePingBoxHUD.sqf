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
crowsZA_pingbox_hidden = false;

//create hud 
"crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true]; 

// add zeus ping event handler 
crowsZA_pingbox_ping_EH = (getAssignedCuratorLogic player) addEventHandler ["CuratorPinged", {
	params ["_curator", "_player"];
	[_player] call crowsZA_fnc_addEntryPingBoxHUD;
}];

// activate CBA handler
crowsZA_pingbox_handler = [crowsZA_fnc_refreshPingBoxHUD , 0.5] call CBA_fnc_addPerFrameHandler; 

// add handler for backspace - to hide display when in screenshot mode
crowsZA_pingbox_backspace_handler = [DIK_BACK, [false, false, false], {
	// if faded, no need to change, refresh is disabled in screenshot mode
	if (crowsZA_pingbox_faded) exitWith {};

	// have to spawn function to wait 0.1, as otherwise we check before the variable for screenshot mode is set...
	[] spawn {
		sleep 0.1;
		// check if in screenshot mode then hide ui, otherwise reshow
		if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false] && !isNull(findDisplay 312)) then {
			// hide pingbox
			"crowsZA_pingbox_layer" cutText ["","PLAIN"];
			crowsZA_pingbox_hidden = true;
		} else {
			if (crowsZA_pingbox_hidden) then {
				// failsafe to not remake it if not hidden
				"crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true]; 
				crowsZA_pingbox_hidden = false;
			};
		};
	};
}] call CBA_fnc_addKeyHandler;

// handler for exiting zeus view and reenable pingbox
crowsZA_pingbox_y_handler = [DIK_Y, [false, false, false], {
	// if faded, no need to change, refresh is disabled in screenshot mode
	if (!crowsZA_pingbox_hidden) exitWith {};

	// have to spawn function to wait 0.1, as otherwise we check before the variable for screenshot mode is set...
	[] spawn {
		sleep 0.1;
		// check if in screenshot mode then hide ui, otherwise reshow
		if (crowsZA_pingbox_hidden && isNull(findDisplay 312)) then {
			// reshow pingbox
			"crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true]; 
			crowsZA_pingbox_hidden = false;
		};
	};
}] call CBA_fnc_addKeyHandler;