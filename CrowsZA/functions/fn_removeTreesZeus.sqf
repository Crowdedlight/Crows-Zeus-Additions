/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_removeTreesZeus.sqf
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
		"_radius"
		"_type"
	];
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	//remove trees as ZEN slider always returns number
	[_pos, _radius, _type] call crowsZA_fnc_removeTrees;
	
};
[
	"Remove Trees and bushes in radius", 
	[
		["SLIDER","Radius",[0,500,10,0]], //0 to 500, default 10 and showing 0 decimal
		["COMBO","Type",[["Trees+Small Trees+Buches", "Trees+Small Trees", "Trees+Buches", "Small Trees+Buches", "Only Trees", "Only Small Trees", "Only Buches"], [0, 5, 4, 6, 1, 2, 3],0]],
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
