#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_radiusHealDialog.sqf
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

	[_position, _radiusSelect] call FUNC(radiusHeal);
};

[
	localize "STR_CROWSZA_Misc_radius_to_heal", 
	[
		["SLIDER", localize "STR_CROWSZA_Misc_surrender_chance_radius",[0,500,10,0]] //0 to 500, default 10 and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
