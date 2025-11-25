#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_surrenderChanceZeus.sqf
Parameters: pos, unit
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _onConfirm =
{
	params ["_dialogResult","_in"];
	_in params [["_pos",[0,0,0],[[]],3], "_unit"];

	private _units = if(isNull _unit) then {
		private _u = [];
		{ _u insert [-1, units _x, true]; } forEach ((ASLToAGL _pos) nearEntities [["CAManBase"], (_dialogResult deleteAt 0)]);
		_u
	} else {
		units group _unit
	};
	_dialogResult params [
		["_confrontationRadius", 15, [15]],
		["_surrenderChance", 0.33, [0.33]],
		["_holdFire", true, [true]],
		["_hesitation", 0, [0]]
	];
	{
		if(!(isPlayer _x)) then {
			 [FUNC(surrenderChance), [_x, _confrontationRadius, _surrenderChance, _holdFire, _hesitation], 0.01] call CBA_fnc_waitAndExecute;
		};
	} forEach _units;
};

private _controls = [
		["SLIDER:RADIUS", [localize "STR_CROWSZA_Misc_surrender_chance_radius", localize "STR_CROWSZA_Misc_surrender_chance_radius_tooltip"], [1, 100, 30, 0, ASLToAGL _pos, [1, 0, 0, 0.7]]],
		["SLIDER", [localize "STR_CROWSZA_Misc_surrender_chance_confrontation_radius", localize "STR_CROWSZA_Misc_surrender_chance_confrontation_radius_tooltip"], [5, 50, 15, 0]],
		["SLIDER:PERCENT", localize "STR_CROWSZA_Misc_surrender_chance_name", [0, 1, 0.33, 0]],
		["CHECKBOX", [localize "STR_CROWSZA_Misc_surrender_chance_hold_fire", localize "STR_CROWSZA_Misc_surrender_chance_hold_fire_tooltip"], [true]],
		["SLIDER", [localize "STR_CROWSZA_Misc_surrender_chance_hesitation", localize "STR_CROWSZA_Misc_surrender_chance_hesitation_tooltip"], [0, 5, 0, 1]]
];

if(!(isNull _unit)) then {
	_controls deleteAt 0;
};


[
	localize "STR_CROWSZA_Misc_surrender_chance_name",
	_controls,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;


// TODO: Add possibility to DISABLE this behaviour once set
