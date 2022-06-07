#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_activateZeusTextDisplay.sqf
Parameters: 
Return: none

Is called if ace is loaded, adds the toggle keybind and starts the display EH and ace medic status handler  

*///////////////////////////////////////////////

// data array
crowsZA_medical_status_players = [];
crowsZA_zeusTextDisplay = false; // Not showing text by default

// register CBA keybinding to toggle zeus-drawn text
crowsZA_zeusTextDisplayKeybind = [
	["Crows Zeus Additions", "Zeus"],
	"zeus_text_display", 
	["Show help display text", "Shows text in zeus view for units. (medical status)"], 
	{crowsZA_zeusTextDisplay = !crowsZA_zeusTextDisplay}, 
	"", 
	[DIK_H, [true, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]] => default: ctrl + shift + h
	false] call CBA_fnc_addKeybind;

// add ace medic update handler
crowsZA_PFH_aceMedicTextUpdater = [crowsZA_fnc_aceMedicStatusHandler, 1] call CBA_fnc_addPerFrameHandler; 

// add displayEH
call crowsZA_fnc_addZeusTextDisplayEH;
