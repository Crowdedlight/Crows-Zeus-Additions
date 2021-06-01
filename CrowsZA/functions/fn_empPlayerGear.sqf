/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_empPlayerGear.sqf
Parameters: pos
Return: none

Removes night vision, gps and radio from selected players to simulate the equipment being destroyed by emp. Each option is toggleable

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
		["OWNERS","Units to TP",[[],[],[],1], true], //no preselected defaults, and default tab open is groups. Forcing defaults to deselect tp selection.
		["CHECKBOX",["Trees", "Enable removal of trees"],[true]],
		["CHECKBOX",["Bushes", "Enable removal of bushes"],[false]],
		["CHECKBOX",["Stones", "Enable removal of stones"],[false]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
