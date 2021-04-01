/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_setNumberplate.sqf
Parameters: pos, _unit
Return: none

Set numberplate of VIC to what you want

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_numberplate"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	//if unit is zero, exit
	if (isNull _unit) exitWith { };
	
	//Run teleport script
	_unit setPlateNumber _numberplate;
};
[
	"Set Numberplate", 
	[
		["EDIT","Text"] //all defaults, no sanitizing function as we shouldn't need it
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
