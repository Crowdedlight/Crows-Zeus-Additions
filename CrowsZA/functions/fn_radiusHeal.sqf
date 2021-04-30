/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_radiusHeal.sqf
Parameters: pos
Return: none

heals all players in a radius around the spot clicked

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
	
	//get all players in radius
	_list = ASLToAGL _pos nearEntities [["Man"], _radius];

	//ace heal 
	{
		["ace_medical_treatment_fullHealLocal", [_X], _x] call CBA_fnc_targetEvent;
	} forEach _list;
	
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
