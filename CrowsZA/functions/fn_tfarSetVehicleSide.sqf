/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_tfarSetVehicleSide.sqf
Parameters: position ASL and unit clicked
Return: none

Set TFAR sides for vehicles. Only independent, west and east is available. Civilian doens't have a side, so if setting civilian, then it defaults to independent

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// exit if not a vehicle
if (!(_unit isKindOf "AllVehicles")) exitWith { ["Selected unit is not a vehicle"] call crowsZA_fnc_showHint; };

private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_side"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	// select first element in array, if more than one are selected just take the first
	_side = toLower(str(_side));

	// make variable lowercase and set it. variable only works with "west" or "east" anything else will just be "independent", so even if we click civilian it will still be independent.
	_unit setVariable ["tf_side", _side, false];

	// post result
	private _vicSide = _unit call TFAR_fnc_getVehicleSide;
	[format ["Vehicle TFAR side set to %1", str(_vicSide)], true] call crowsZA_fnc_showHint;
};
[
	"Set TFAR Vehicle Side", 
	[
		["SIDES","TFAR Vehicle Side", west]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;