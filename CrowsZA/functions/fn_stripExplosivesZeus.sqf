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
	_dialogResult params [
		["_side", east, [east]],
		["_ignorePlayers", true, [true]],
		["_signalGrenades", 2, [2]],
		["_grenades", 0, [0]],
		["_launchers", 0, [0]],
		["_explosives", 0, [0]],
		["_ugl", 0, [0]]
	];
	_in params [["_pos",[0,0,0],[[]],3], "_unit"];

	//log
	private _logItems = [];
	if(_signalGrenades > 0) then { _logItems pushBack "signal grenades"; };
	if(_grenades > 0) then { _logItems pushBack "explosive grenades"; };
	if(_launchers > 0) then { _logItems pushBack "launchers"; };
	if(_explosives > 0) then { _logItems pushBack "explosives"; };
	if(_ugl > 0) then { _logItems pushBack "ugl grenades"; };
	private _logPlayers = switch(_ignorePlayers) do {
		case true: { "(ignoring players)" };
		case false: { "(INCLUDING players)" };
	};
	diag_log format ["crowsZA-stripExplosives: Stripping %1 from %2 side %3", _logItems joinString ", ", _side, _logPlayers];

	[_side, _ignorePlayers, _signalGrenades, _grenades, _launchers, _explosives, _ugl, _logItems] spawn {
		params["_side", "_ignorePlayers", "_signalGrenades", "_grenades", "_launchers", "_explosives", "_ugl", "_logItems"];
		{
			if(side _x == _side && (!(isPlayer _x) || !_ignorePlayers)) then {
				[_x, _signalGrenades, _grenades, _launchers, _explosives, _ugl] call crowsZA_fnc_stripExplosives;
				if (isPlayer _x) then {
				    (format ["Zeus has removed or altered your %1", _logItems joinString ", "]) remoteExec ["hint", _x];
				};
				sleep 0.01;
			};
		} foreach allUnits;
	};
};

private _onUnit =
{
	params ["_dialogResult","_in"];
	_dialogResult params [
		["_ignorePlayers", true, [true]],
		["_group", true, [true]],
		["_signalGrenades", 2, [2]],
		["_grenades", 0, [0]],
		["_launchers", 0, [0]],
		["_explosives", 0, [0]],
		["_ugl", 0, [0]]
	];
	_in params [["_pos",[0,0,0],[[]],3], "_unit"];

	//log
	private _logItems = [];
	if(_signalGrenades > 0) then { _logItems pushBack "signal grenades"; };
	if(_grenades > 0) then { _logItems pushBack "explosive grenades"; };
	if(_launchers > 0) then { _logItems pushBack "launchers"; };
	if(_explosives > 0) then { _logItems pushBack "explosives"; };
	if(_ugl > 0) then { _logItems pushBack "ugl grenades"; };
	private _logEntity = switch(_group) do {
		case true: { format ["group %1", group _unit] };
		case false: { format ["unit %1", _unit] };
	};
	private _logPlayers = switch(_ignorePlayers) do {
		case true: { "(ignoring players)" };
		case false: { "(INCLUDING players)" };
	};
	diag_log format ["crowsZA-stripExplosives: Stripping %1 from %2 %3", _logItems joinString ", ", _logEntity, _logPlayers];

	private _units = switch(_group) do {
		case true: { units (group _unit) };
		default { [_unit] };
	};
	
	[_ignorePlayers, _units, _signalGrenades, _grenades, _launchers, _explosives, _ugl, _logItems] spawn {
		params["_ignorePlayers", "_units", "_signalGrenades", "_grenades", "_launchers", "_explosives", "_ugl", "_logItems"];
		{
			if(!(isPlayer _x) || !_ignorePlayers) then {
				[_x, _signalGrenades, _grenades, _launchers, _explosives, _ugl] call crowsZA_fnc_stripExplosives;
				if (isPlayer _x) then {
				    (format ["Zeus has removed or altered your %1", _logItems joinString ", "]) remoteExec ["hint", _x];
				};
				sleep 0.01;
			};
		} foreach _units;
	};
};


private _controls = [
		["SIDES", "Side", east],
		["CHECKBOX", "Ignore players", true],
		["CHECKBOX", ["Whole Group", "Remove items from this unit's group"], true],
		["TOOLBOX", ["Signal Grenades", """Replace"" will replace each instance with a base-game white smoke"], [2, 1, 3, ["Ignore", "Remove", "Replace"]]],
		["TOOLBOX", ["Explosive Grenades", """Replace"" will replace each instance with a base-game RGN grenade"], [0, 1, 3, ["Ignore", "Remove", "Replace"]]],
		["TOOLBOX", "Launchers", [0, 1, 2, ["Ignore", "Remove"]]],
		["TOOLBOX", "Explosives", [0, 1, 2, ["Ignore", "Remove"]]],
		["TOOLBOX", "UGL Grenades", [0, 1, 2, ["Ignore", "Remove"]]]
];

private "_onConfirm";
if(isNull _unit) then {
	_controls deleteAt 2;
	_onConfirm =_onSide;
}
else{
	_controls deleteAt 0;
	_onConfirm =_onUnit;
};

[
	"Remove Explosives",
	_controls,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
