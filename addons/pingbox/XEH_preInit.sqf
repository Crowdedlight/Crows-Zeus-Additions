#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

GVAR(ping_list) = [];
GVAR(faded) = false;
GVAR(ping_list_update) = 0;
GVAR(hidden) = false;

// CBA Settings // 

// custom CBA setting to disable pingbox
[
	QGVAR(CBA_Setting_enabled),
	"CHECKBOX",
	[localize "STR_CROWSZA_Pingbox_setting_enable", localize "STR_CROWSZA_Pingbox_setting_enable_tooltip"],
	["Crows Zeus Additions", "PingBox"],
	true,
	0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	FUNC(enablePingBoxHUD) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
	QGVAR(CBA_Setting_Pingbox_Size), 
	"LIST",     
	[localize "STR_CROWSZA_Pingbox_setting_size", localize "STR_CROWSZA_Pingbox_setting_size_tooltip"], 
	["Crows Zeus Additions", "PingBox"], 
	[[3, 5, 7], [localize "STR_CROWSZA_Pingbox_setting_size_option_small",
         localize "STR_CROWSZA_Pingbox_setting_size_option_medium",
         localize "STR_CROWSZA_Pingbox_setting_size_option_large"
	], 0],
	0,
	FUNC(resizePingBoxHUD)
] call CBA_fnc_addSetting;

// TIME before removing old entries
[
	QGVAR(CBA_Setting_oldLimit),
	"SLIDER",
	[localize "STR_CROWSZA_Pingbox_setting_threshold", localize "STR_CROWSZA_Pingbox_setting_threshold_tooltip"],
	["Crows Zeus Additions", "PingBox"],
	[1, 900, 600, 0] // data for this setting: [min, max, default, number of shown trailing decimals]
] call CBA_fnc_addSetting;

// TIME window where pings would be grouped together into one spam ping
[
	QGVAR(CBA_Setting_spamPing_threshold),
	"SLIDER",
	[localize "STR_CROWSZA_Pingbox_setting_spamPing_threshold", localize "STR_CROWSZA_Pingbox_setting_spamPing_threshold_tooltip"],
	["Crows Zeus Additions", "PingBox"],
	[0, 120, 60, 0] // data for this setting: [min, max, default, number of shown trailing decimals]
] call CBA_fnc_addSetting;

// FADE OUT for pingbox
[
	QGVAR(CBA_Setting_fade_enabled),
	"CHECKBOX",
	[localize "STR_CROWSZA_Pingbox_setting_fading", localize "STR_CROWSZA_Pingbox_setting_fading_tooltip"],
	["Crows Zeus Additions", "PingBox"],
	true,
	nil,
	{
		params ["_value"];
		// if we are faded and disable fading, we should redraw
		if (!_value && GVAR(faded)) then {GVAR(faded) = false; QGVAR(layer) cutRsc ["crowsza_pingbox_hud", "PLAIN", 0, true];};
	}
] call CBA_fnc_addSetting;

// TIME BEFORE FADEOUT
[
	QGVAR(CBA_Setting_fade_duration),
	"SLIDER",
	[localize "STR_CROWSZA_Pingbox_setting_fade_duration", localize "STR_CROWSZA_Pingbox_setting_fade_duration_tooltip"],
	["Crows Zeus Additions", "PingBox"],
	[1, 900, 300, 0]
] call CBA_fnc_addSetting;