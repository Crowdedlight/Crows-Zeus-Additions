/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_removeTreesZeus.sqf
Parameters: pos
Return: none

Removes trees in an area around the selected point

*///////////////////////////////////////////////
params ["_pos",[0,0,0],[[]],3];

// open dialog
//either Ares or ZEN
if (crowZA_zen) then 
{
	//ZEN
	private _onConfirm =
	{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_radius",
	];
	_in params [_unit];	
	
	//check that _radius is a number
	private _strArr = _radius splitString "";
	if (count (_strArr select {typeName _x != "SCALAR"}) >= 0) exitWith
	{
		["Radius has to be a number. No letters, spaces or other characters are allowed"] call Achilles_fnc_showZeusErrorMessage;
	}

	//remove trees
	[_pos, _radius] call crowsZA_fnc_removeTrees;
	
};
[
	"Remove Trees and Folliage in radius", 
	[
		["SLIDER","Radius",0,500,5,0], //0 to 500, default 5 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

} else 
{
	//ARES 
	private _dialogResult =
	[
		"Remove Trees in radius",
		[
			["Radius", "", "5"]
		]
	] call Ares_fnc_showChooseDialog;

	if (_dialogResult isEqualTo []) exitWith{};

	_dialogResult params 
	[
		"_radius"
	];

	//check that _radius is a number
	private _strArr = _radius splitString "";
	if (count (_strArr select {typeName _x != "SCALAR"}) >= 0) exitWith
	{
		["Radius has to be a number. No letters, spaces or other characters are allowed"] call Achilles_fnc_showZeusErrorMessage;
	}

	[_pos, parseNumber _radius] call crowsZA_fnc_removeTrees;
};