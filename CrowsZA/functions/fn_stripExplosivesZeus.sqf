/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosivesZeus.sqf
Parameters: pos, unit
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _onSide =
{
	params ["_dialogResult","_in"];
	_dialogResult params [["_side", east, [east]], ["_ignorePlayers", true, [true]], ["_smokeGrenades", 2, [2]], ["_grenades", 0, [0]], "_launchers", "_explosives"];
	_in params [["_pos",[0,0,0],[[]],3], "_unit"];

	//log
	private _items = [];
	if(_smokeGrenades > 0) then { _items pushBack "smoke grenades"; };
	if(_grenades > 0) then { _items pushBack "explosive grenades"; };
	if(_launchers > 0) then { _items pushBack "launchers"; };
	if(_explosives > 0) then { _items pushBack "explosives"; };
	diag_log format ["crowsZA-stripExplosives: Stripping %1 from %2 side", _items joinString ", ", _side];

	[_side, _ignorePlayers, _smokeGrenades, _grenades, _launchers, _explosives] spawn {
		params["_side", "_ignorePlayers", "_smokeGrenades", "_grenades", "_launchers", "_explosives"];
		{
			if(side _x == _side && (!(isPlayer _x) || !_ignorePlayers)) then {
				[_x, _smokeGrenades, _grenades, _launchers, _explosives] call crowsZA_fnc_stripExplosives;
			};
			sleep 0.01;
		} foreach allUnits;
	};
};

private _onUnit =
{
	params ["_dialogResult","_in"];
	_dialogResult params [["_group", true, [true]], ["_smokeGrenades", 2, [2]], ["_grenades", 0, [0]], ["_launchers", 0, [0]], ["_explosives", 0, [0]]];
	_in params [["_pos",[0,0,0],[[]],3], "_unit"];

	//log
	private _items = [];
	if(_smokeGrenades > 0) then { _items pushBack "smoke grenades"; };
	if(_grenades > 0) then { _items pushBack "explosive grenades"; };
	if(_launchers > 0) then { _items pushBack "launchers"; };
	if(_explosives > 0) then { _items pushBack "explosives"; };
	private _entity = switch(_group) do {
		case true: { format ["group %1", group _unit] };
		case false: { format ["unit %1", _unit] };
	};
	diag_log format ["crowsZA-stripExplosives: Stripping %1 from %2", _items, _entity];

	private _units = switch(_group) do {
		case true: { units (group _unit) };
		default { [_unit] };
	};
	
	[_units, _smokeGrenades, _grenades, _launchers, _explosives] spawn {
		params["_units", "_smokeGrenades", "_grenades", "_launchers", "_explosives"];
		{
			[_x, _smokeGrenades, _grenades, _launchers, _explosives] call crowsZA_fnc_stripExplosives;
			sleep 0.01;
		} foreach _units;
	};
};


private _controls = [
		["SIDES", "Side", east],
		["CHECKBOX", "Ignore players", true],
		["CHECKBOX", ["Whole Group", "Remove items from this unit's group"], true],
		["TOOLBOX", ["Smoke Grenades", """Replace"" will replace each instance with a base-game white smoke"], [2, 1, 3, ["Ignore", "Remove", "Replace"]]],
		["TOOLBOX", ["Explosive Grenades", """Replace"" will replace each instance with a base-game RGN grenade"], [0, 1, 3, ["Ignore", "Remove", "Replace"]]],
		["TOOLBOX", "Launchers", [0, 1, 2, ["Ignore", "Remove"]]],
		["TOOLBOX", "Explosives", [0, 1, 2, ["Ignore", "Remove"]]]
];

private "_onConfirm";
if(isNull _unit) then {
	_controls deleteAt 2;
	_onConfirm =_onSide;
}
else{
	_controls deleteRange [0, 2];
	_onConfirm =_onUnit;
};

[
	"Remove Explosives",
	_controls,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
