/*/////////////////////////////////////////////////
Author: Crowdedlight + Windwalker
			   
File: fn_removeTreesZeus.sqf
Parameters: pos
Return: none

Removes terrain objects in an area around the selected point

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
	
	//remove trees as ZEN slider always returns number
	[_pos, _radius, _treeRemoval, _bushRemoval, _stoneRemoval] call crowsZA_fnc_removeTrees;
	
};
[
	"Remove terrain objects selected in radius", 
	[
		["SLIDER:RADIUS","Radius",[0,500,10,0,ASLtoAGL _pos, [1, 0, 0, 0.7]]], //0 to 500, default 10 and showing 0 decimal
		["CHECKBOX",["Trees", "Enable removal of trees"],[true]],
		["CHECKBOX",["Bushes", "Enable removal of bushes"],[false]],
		["CHECKBOX",["Stones", "Enable removal of stones"],[false]]
	],
	_onConfirm,
	{},
	_this,
	"crow_remove_tree_id"
] call zen_dialog_fnc_create;
