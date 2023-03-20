/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_surrenderChanceZeus.sqf
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
			 [crowsZA_fnc_surrenderChance, [_x, _confrontationRadius, _surrenderChance, _holdFire, _hesitation], 0.01] call CBA_fnc_waitAndExecute;
		};
	} foreach _units;
};

private _controls = [
		["SLIDER:RADIUS", ["Radius", "Apply this effect to all units in radius"], [1, 100, 30, 0, ASLtoAGL _pos, [1, 0, 0, 0.7]]],
		["SLIDER", ["Confrontation Radius", "Radius within which pointing a weapon at the unit will trigger a response"], [5, 50, 15, 0]],
		["SLIDER:PERCENT", "Surrender Chance", [0, 1, 0.33, 0]],
		["CHECKBOX", ["Hold Fire", "Units will hold fire until confronted"], [true]],
		["SLIDER", ["Hesitation", "Maximum time (in seconds) that the unit will hesitate for after being confronted"], [0, 5, 0, 1]]
];

if(!(isNull _unit)) then {
	_controls deleteAt 0;
};


[
	"Surrender Chance",
	_controls,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;


// TODO: Add possibility to DISABLE this behaviour once set