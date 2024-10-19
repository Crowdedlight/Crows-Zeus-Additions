#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_spawnIEDClutterZeus.sqf
Parameters: pos
Return: none

Spawns item clutter (e.g. garbage piles) and hidden IEDs

*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// ZEN Dialogue
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_radius",
		"_density",
		"_maxClutterSize",
		"_iedSize",
		"_iedType",
		"_iedAmount"
	];
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// Spawn clutter
	[_pos, _radius, _density, _maxClutterSize, _iedSize, _iedType, _iedAmount] call FUNC(spawnIEDClutter);
		
};


// Non-ace ieds can't have their model hidden, so can't be disguised as clutter
private _iedTypeToolbox = if(EGVAR(main,aceLoaded)) then {
	["TOOLBOX", [localize "STR_CROWSZA_Misc_ied_clutter_ied_type", localize "STR_CROWSZA_Misc_ied_clutter_ied_type_tooltip"], [0, 1, 4, [localize "STR_CROWSZA_Misc_ied_clutter_urban", localize "STR_CROWSZA_Misc_ied_clutter_dug_in", localize "STR_CROWSZA_Misc_ied_clutter_clutter", localize "STR_CROWSZA_Misc_ied_clutter_random"]]]
} else {
	["TOOLBOX", [localize "STR_CROWSZA_Misc_ied_clutter_ied_type", localize "STR_CROWSZA_Misc_ied_clutter_ied_type_tooltip"], [0, 1, 3, [localize "STR_CROWSZA_Misc_ied_clutter_urban", localize "STR_CROWSZA_Misc_ied_clutter_dug_in", localize "STR_CROWSZA_Misc_ied_clutter_random"]]]
};

[
	localize "STR_CROWSZA_Misc_ied_clutter_name", 
	[
		["SLIDER:RADIUS", localize "STR_CROWSZA_Misc_ied_clutter_radius", [1, 30, 10, 0, ASLToAGL _pos, [1, 0, 0, 0.7]]],
		["SLIDER:PERCENT", localize "STR_CROWSZA_Misc_ied_clutter_density", [0.1, 1, 0.4, 0]],
		["TOOLBOX", localize "STR_CROWSZA_Misc_ied_clutter_max_clutter_size", [1, 1, 3, [localize "STR_CROWSZA_Misc_ied_clutter_small", localize "STR_CROWSZA_Misc_ied_clutter_medium", localize "STR_CROWSZA_Misc_ied_clutter_large"]]],
		// ["CHECKBOX", "Junk", [true]],
		// ["CHECKBOX", "Luggage", [true]],
		// ["CHECKBOX", "Electronics", [true]],
		// ["CHECKBOX", "Wrecks", [false]],
		["TOOLBOX", localize "STR_CROWSZA_Misc_ied_clutter_ied_size", [0, 1, 3, [localize "STR_CROWSZA_Misc_ied_clutter_small", localize "STR_CROWSZA_Misc_ied_clutter_large", localize "STR_CROWSZA_Misc_ied_clutter_random"]]],
		_iedTypeToolbox,
		["SLIDER", localize "STR_CROWSZA_Misc_ied_clutter_ied_amount", [0, 10, 1, 0]]
	],
	_onConfirm,
	{},
	_this,
	"crow_spawn_ied_id"
] call zen_dialog_fnc_create;
