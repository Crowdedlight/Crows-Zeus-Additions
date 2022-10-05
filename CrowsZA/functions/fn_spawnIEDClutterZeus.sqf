/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_spawnIEDClutterZeus.sqf
Parameters: pos
Return: none

Spawns item clutter (e.g. garbage piles) and hidden IEDs

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// open dialog
//ZEN
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
[
	"Spawn IED Clutter", 
	[
		["SLIDER:RADIUS", "Radius", [1, 30, 10, 0, ASLtoAGL _pos, [1, 0, 0, 0.7]]],
		["SLIDER:PERCENT", "Density", [0.1, 1, 0.4, 0]],
		["COMBO", "Max Clutter Size", [[1, 0.9, 0], ["Large", "Medium", "Small"], 1]], // Not a huge fan of using these "magic numbers", as they have to match up with a switch statement in crowsZA_fnc_spawnIEDClutter
		// ["CHECKBOX", "Junk", [true]],
		// ["CHECKBOX", "Luggage", [true]],
		// ["CHECKBOX", "Electronics", [true]],
		// ["CHECKBOX", "Wrecks", [false]],
		["COMBO", "IED Size", [["small", "large", "random"], ["Small", "Large", "Random"], 2]],
		["COMBO", "IED Type", [["urban", "dug-in", "random"],
			[
				"Urban",
				"Dug-in",
				// TODO: Mode to place an invisible IED on the same position as a piece of clutter;
				// unclear if this would work with minedetectors/defusal
				//["Clutter (Experimental)", "Transforms a random object of clutter into an IED"],
				"Random"
			],
		0]],
		["SLIDER", "IED Amount", [0, 8, 1, 0]]
	],
	_onConfirm,
	{},
	_this,
	"crow_spawn_ied_id"
] call zen_dialog_fnc_create;
