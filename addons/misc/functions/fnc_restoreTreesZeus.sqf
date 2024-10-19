#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_restoreTreesZeus.sqf
Parameters: pos
Return: none

Removes trees in an area around the selected point

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
		"_treeRemoval",
		"_bushRemoval",
		"_stoneRemoval"
	];
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	//restore trees
	[_pos, _radius, _treeRemoval, _bushRemoval, _stoneRemoval] call FUNC(restoreTrees);
		
};
[
	localize "STR_CROWSZA_Misc_restore_trees_dialog", 
	[
		["SLIDER:RADIUS", localize "STR_CROWSZA_Misc_restore_trees_radius",[0,500,10,0,ASLToAGL _pos, [1, 0, 0, 0.7]]], //0 to 500, default 10 and showing 0 decimal
		["CHECKBOX",[localize "STR_CROWSZA_Misc_restore_trees_trees", localize "STR_CROWSZA_Misc_restore_trees_trees_tooltip"],[true]],
		["CHECKBOX",[localize "STR_CROWSZA_Misc_restore_trees_bushes", localize "STR_CROWSZA_Misc_restore_trees_bushes_tooltip"],[false]],
		["CHECKBOX",[localize "STR_CROWSZA_Misc_restore_trees_stones", localize "STR_CROWSZA_Misc_restore_trees_stones_tooltip"],[false]]
	],
	_onConfirm,
	{},
	_this,
	GVAR(restore_tree_id)
] call zen_dialog_fnc_create;
