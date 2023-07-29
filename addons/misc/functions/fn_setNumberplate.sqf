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

	//only showing dialog to make sure Zeus wants to delete all dead bodies
	crowsZA_fnc_setNumPlate = {
		//params
		params ["_numberPlate","_unit"];
		//log 
		diag_log format["CrowsZA-setNumberPlate: Setting numberplate of %1 to %2", _unit, _numberplate];
		//set numberplate
		_unit setPlateNumber _numberplate;
	};

	//log 
	diag_log format["CrowsZA-setNumberPlate: Setting numberplate of %1 to %2", _unit, _numberplate];

	//set numberplate
	[_numberplate, _unit] remoteExec ["crowsZA_fnc_setNumPlate", 0, true]; //2 = server, 0 == for all players and server, With JIP
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
