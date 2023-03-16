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
	private "_units";

	if(isNull _unit) then {
		_dialogResult params [
			["_side", east, [east]],
			["_confrontationRadius", 15, [15]],
			["_surrenderChance", 0.33, [0.33]],
			["_holdFire", true, [true]],
			["_hesitation", 0, [0]]
		];
		_units = units _side;
		[_units, _confrontationRadius, _surrenderChance, _holdFire, _hesitation] spawn {
			params["_units", "_confrontationRadius", "_surrenderChance", "_holdFire", "_hesitation"];
			{
				if(!(isPlayer _x)) then {
					[_x, _confrontationRadius, _surrenderChance, _holdFire, _hesitation] call crowsZA_fnc_surrenderChance;
					sleep 0.01;
				};
			} foreach _units;
		};
	} else {
		_dialogResult params [
			["_group", true, [true]],
			["_confrontationRadius", 15, [15]],
			["_surrenderChance", 0.33, [0.33]],
			["_holdFire", true, [true]],
			["_hesitation", 0, [0]]
		];
		_units = [[_unit], units group _unit] select _group;
		[_units, _confrontationRadius, _surrenderChance, _holdFire, _hesitation] spawn {
			params["_units", "_confrontationRadius", "_surrenderChance", "_holdFire", "_hesitation"];
			{
				if(!(isPlayer _x)) then {
					[_x, _confrontationRadius, _surrenderChance, _holdFire, _hesitation] call crowsZA_fnc_surrenderChance;
					sleep 0.01;
				};
			} foreach _units;
		};
	};
};

private _controls = [
		["SIDES", "Side", east],
		["CHECKBOX", ["Apply to group", "Apply to the unit's whole group"], [true]],
		["SLIDER", ["Confrontation Radius", "Radius within which pointing a weapon at the unit will trigger a response"], [5, 50, 15, 0]],
		["SLIDER:PERCENT", "Surrender Chance", [0, 1, 0.33, 0]],
		["CHECKBOX", ["Hold Fire", "Units will hold fire until confronted"], [true]],
		["SLIDER", ["Hesitation", "Maximum time (in seconds) that the unit will hesitate for after being confronted"], [0, 5, 0, 1]]
];

if(!(isNull _unit)) then {
	_controls deleteAt 0;
} else {
	_controls deleteAt 1;
};


[
	"Surrender Chance",
	_controls,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;


// TODO: Add possibility to DISABLE this behaviour once set