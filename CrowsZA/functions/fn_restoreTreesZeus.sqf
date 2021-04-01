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
		"_radius"
	];
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	//restore trees
	[_pos, _radius] call crowsZA_fnc_restoreTrees;
	
};
[
	"Restore Trees and bushes in radius", 
	[
		["SLIDER","Radius",[0,500,10,0]] //0 to 500, default 10 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
