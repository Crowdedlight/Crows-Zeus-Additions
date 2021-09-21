/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_registerSettingsCBA.sqf
Parameters: none
Return: none

Register all settings for CBA - As this is run in preStart

*///////////////////////////////////////////////

// check for zen 
private _hasCBA = isClass (configFile >> "CfgPatches" >> "cba_main");
if !(_hasCBA) exitWith
{
	diag_log "******CBA not detected. They are required for Crows Zeus Additions.";
};

//only load for players
if (!hasInterface) exitWith {};

// Setting CBA settings
// custom CBA setting to disable pingbox
[
	"crowsZA_CBA_Setting_pingbox_enabled", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"CHECKBOX", // setting type
	["Enable PingBox", "Pingbox sits in lower left corner and shows the last 3 zeus pings and how long since it was pinged"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
	["Crows Zeus Additions", "PingBox"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
	true, // data for this setting: [min, max, default, number of shown trailing decimals]
	nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	crowsZA_fnc_enablePingBoxHUD // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;
// TIME before removing old entries
[
	"crowsZA_CBA_Setting_pingbox_oldLimit", 
	"SLIDER", 
	["Remove Threshold", "Time before a ping will automatically be removed from the PingBox"], 
	["Crows Zeus Additions", "PingBox"], 
	[1, 900, 600, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
	nil 
] call CBA_fnc_addSetting;
// FADE OUT for pingbox
[
	"crowsZA_CBA_Setting_pingbox_fade_enabled", 
	"CHECKBOX",
	["Enable Fading", "PingBox will fade from view after set duration, and reappear when a new ping is received"], 
	["Crows Zeus Additions", "PingBox"], 
	true, 
	nil,
	{
		params ["_value"];
		// if we are faded and disable fading, we should redraw
		if (!_value && crowsZA_pingbox_faded) then {crowsZA_pingbox_faded = false; "crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true];};
	}
] call CBA_fnc_addSetting;
// TIME BEFORE FADEOUT
[
	"crowsZA_CBA_Setting_pingbox_fade_duration", 
	"SLIDER",
	["Duration Before Fade", "Time before the PingBox will fade from view if Fading is enabled"], 
	["Crows Zeus Additions", "PingBox"], 
	[1, 900, 300, 0], 
	nil 
] call CBA_fnc_addSetting;