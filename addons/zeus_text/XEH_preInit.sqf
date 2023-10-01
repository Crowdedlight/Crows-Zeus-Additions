#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

GVAR(medical_status_players) = [];

// register CBA keybinding to toggle zeus-drawn text
[
	["Crows Zeus Additions", "Zeus"],
	QGVAR(medicalDisplay),
	["Show medical overlay", "Shows medical info for players in zeus view for units. (medical status)"],
	{GVAR(medicalDisplay) = !GVAR(medicalDisplay)},
	"",
	[DIK_H, [true, true, false]] // [DIK code, [Shift?, Ctrl?, Alt?]] => default: ctrl + shift + h
] call CBA_fnc_addKeybind;

// setting CBA settings
[
	QGVAR(CBA_Setting_zeusTextLine1), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    ["Show No. of wounds and HR.","Show line with number of wounds and heart rate."], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions","Medical HUD (default:  Ctrl + Shift + H)"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true // data for this setting
] call CBA_fnc_addSetting;

[
	QGVAR(CBA_Setting_zeusTextLine2),
    "CHECKBOX",
    ["Show pain and bleeding rate", "Show if player is in pain and bleeding rate"],
    ["Crows Zeus Additions","Medical HUD (default:  Ctrl + Shift + H)"],
    true
] call CBA_fnc_addSetting;

[
	QGVAR(CBA_Setting_zeusTextLine3),
    "CHECKBOX",
    ["Show medications","Show what medications is effecting the player"],
    ["Crows Zeus Additions","Medical HUD (default:  Ctrl + Shift + H)"],
    false
] call CBA_fnc_addSetting;

// ZEUS RC HELPER
[
	QGVAR(CBA_Setting_rc_helper),
    "CHECKBOX",
    ["Show RC Icon","Shows an zeus icon over units currently being RC'ed by any zeus"],
    ["Crows Zeus Additions","Zeus RC"],
    true
] call CBA_fnc_addSetting;

// ZEUS RC HELPER - COLOR
[
	QGVAR(CBA_Setting_rc_helper_color),
    "COLOR",
    ["Icon Colour","What colour the icon is shown with"],
    ["Crows Zeus Additions","Zeus RC"],
    [1,1,1,1]
] call CBA_fnc_addSetting;


// ZEUS SURRENDER HELPER
[
	QGVAR(CBA_Setting_surrender_helper),
    "CHECKBOX",
    ["Show Surrender Icon","Shows an icon over units with a chance to surrender"],
    ["Crows Zeus Additions","Surrender Chance"],
    true
] call CBA_fnc_addSetting;

// ZEUS SURRENDER HELPER - COLOR
[
	QGVAR(CBA_Setting_surrender_helper_color),
    "COLOR",
    ["Icon Colour","What colour the icon is shown with"],
    ["Crows Zeus Additions","Surrender Chance"],
    [1,1,1,1]
] call CBA_fnc_addSetting;