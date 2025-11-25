#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

GVAR(medical_status_players) = [];

// register CBA keybinding to toggle zeus-drawn text
[
	["Crows Zeus Additions", "Zeus"],
	QGVAR(medicalDisplay),
	[localize "STR_CROWSZA_zeustext_setting_medical_overlay", localize "STR_CROWSZA_zeustext_setting_medical_overlay_tooltip"],
	{GVAR(medicalDisplay) = !GVAR(medicalDisplay)},
	"",
	[DIK_H, [true, true, false]] // [DIK code, [Shift?, Ctrl?, Alt?]] => default: ctrl + shift + h
] call CBA_fnc_addKeybind;

// setting CBA settings
[
	QGVAR(CBA_Setting_zeusTextLine1), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [localize "STR_CROWSZA_zeustext_num_wounds", localize "STR_CROWSZA_zeustext_num_wounds_tooltip"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_medical_hud"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true // data for this setting
] call CBA_fnc_addSetting;

[
	QGVAR(CBA_Setting_zeusTextLine2),
    "CHECKBOX",
    [localize "STR_CROWSZA_zeustext_show_pain", localize "STR_CROWSZA_zeustext_show_pain_tooltip"],
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_medical_hud"],
    true
] call CBA_fnc_addSetting;

[
	QGVAR(CBA_Setting_zeusTextLine3),
    "CHECKBOX",
    [localize "STR_CROWSZA_zeustext_show_medications", localize "STR_CROWSZA_zeustext_show_medications_tooltip"],
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_medical_hud"],
    false
] call CBA_fnc_addSetting;

// ZEUS RC HELPER
[
	QGVAR(CBA_Setting_rc_helper),
    "CHECKBOX",
    [localize "STR_CROWSZA_zeustext_show_rc_icon", localize "STR_CROWSZA_zeustext_show_rc_icon_tooltip"],
    ["Crows Zeus Additions","Zeus RC"],
    true
] call CBA_fnc_addSetting;

// ZEUS RC HELPER - COLOR
[
	QGVAR(CBA_Setting_rc_helper_color),
    "COLOR",
    [localize "STR_CROWSZA_zeustext_icon_colour", localize "STR_CROWSZA_zeustext_icon_colour_tooltip"],
    ["Crows Zeus Additions","Zeus RC"],
    [1,1,1,1]
] call CBA_fnc_addSetting;


// ZEUS SURRENDER HELPER
[
    QGVAR(CBA_Setting_surrender_helper),
    "CHECKBOX",
    [localize "STR_CROWSZA_zeustext_surrender_icon", localize "STR_CROWSZA_zeustext_surrender_icon_tooltip"],
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_surrender_chance"],
    true
] call CBA_fnc_addSetting;

// ZEUS SURRENDER HELPER - COLOR
[
    QGVAR(CBA_Setting_surrender_helper_color),
    "COLOR",
    [localize "STR_CROWSZA_zeustext_surrender_icon_colour", localize "STR_CROWSZA_zeustext_surrender_icon_colour_tooltip"],
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_surrender_chance"],
    [1,1,1,1]
] call CBA_fnc_addSetting;

// ZEUS KILLED EH HELPER
[
    QGVAR(CBA_Setting_OnKilledModule_helper),
    "CHECKBOX",
    [localize "STR_CROWSZA_zeustext_onkilled_icon", localize "STR_CROWSZA_zeustext_onkilled_icon_tooltip"],
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_onkilled"],
    true
] call CBA_fnc_addSetting;

// ZEUS KILLED EH HELPER - COLOR
[
    QGVAR(CBA_Setting_OnKilledModule_helper_color),
    "COLOR",
    [localize "STR_CROWSZA_zeustext_onkilled_icon_colour", localize "STR_CROWSZA_zeustext_onkilled_icon_colour_tooltip"],
    ["Crows Zeus Additions", localize "STR_CROWSZA_zeustext_onkilled"],
    [1,1,1,1]
] call CBA_fnc_addSetting;
