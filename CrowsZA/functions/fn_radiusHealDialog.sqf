/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_radiusHealDialog.sqf
Parameters: pos
Return: none

heals all players in a radius around the spot clicked

*///////////////////////////////////////////////
params ["_position"];

// open dialog function
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_radiusSelect"
	];
	_in params ["_position"];

	[_position, _radiusSelect] call crowsZA_fnc_radiusHeal;
};

[
	"Radius to heal", 
	[
		["SLIDER","Radius",[0,500,10,0]] //0 to 500, default 10 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
