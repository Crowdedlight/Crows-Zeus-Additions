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
	["Show medical overlay", "Shows medical info for players in zeus view for units. (medical status)"], 
	{crowsZA_zeusTextDisplay = !crowsZA_zeusTextDisplay}, 
	"", 
	[DIK_H, [true, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]] => default: ctrl + shift + h
	false] call CBA_fnc_addKeybind;
[
	"crowsZA_zeusTextLine1", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Show line with number of wounds and heart rate.", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "Crows Zeus Additions", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    //FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
	"crowsZA_zeusTextLine2", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Show if player is in pain and bleeding rate", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "Crows Zeus Additions", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    //FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
	"crowsZA_zeusTextLine3", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Show what medications is effecting the player", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "Crows Zeus Additions", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    false, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    //FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

// add ace medic update handler
crowsZA_PFH_aceMedicTextUpdater = [crowsZA_fnc_aceMedicStatusHandler, 1] call CBA_fnc_addPerFrameHandler; 

// add displayEH
call crowsZA_fnc_addZeusTextDisplayEH;
