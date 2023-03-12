/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_spawnIEDClutterZeus.sqf
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
	[_pos, _radius, _density, _maxClutterSize, _iedSize, _iedType, _iedAmount] call crowsZA_fnc_spawnIEDClutter;
		
};


// Non-ace ieds can't have their model hidden, so can't be disguised as clutter
private _iedTypeToolbox = if(crowsZA_common_aceModLoaded) then {
	["TOOLBOX", ["IED Type", """Clutter"" transforms a random object of clutter into an IED"], [0, 1, 4, ["Urban", "Dug-in", "Clutter", "Random"]]]
} else {
	["TOOLBOX", ["IED Type", """Clutter"" transforms a random object of clutter into an IED"], [0, 1, 3, ["Urban", "Dug-in", "Random"]]]
};

[
	"Spawn IED Clutter", 
	[
		["SLIDER:RADIUS", "Radius", [1, 30, 10, 0, ASLtoAGL _pos, [1, 0, 0, 0.7]]],
		["SLIDER:PERCENT", "Density", [0.1, 1, 0.4, 0]],
		["TOOLBOX", "Max Clutter Size", [1, 1, 3, ["Small", "Medium", "Large"]]],
		// ["CHECKBOX", "Junk", [true]],
		// ["CHECKBOX", "Luggage", [true]],
		// ["CHECKBOX", "Electronics", [true]],
		// ["CHECKBOX", "Wrecks", [false]],
		["TOOLBOX", "IED Size", [0, 1, 3, ["Small", "Large", "Random"]]],
		_iedTypeToolbox,
		["SLIDER", "IED Amount", [0, 10, 1, 0]]
	],
	_onConfirm,
	{},
	_this,
	"crow_spawn_ied_id"
] call zen_dialog_fnc_create;
