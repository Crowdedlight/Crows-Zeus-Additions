/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosives.sqf
Parameters: _unit, _smokeGrenades, _grenades, _launchers, _explosives
Return: none

*///////////////////////////////////////////////
params ["_unit", "_smokeGrenades", "_grenades", "_launchers", "_explosives"];

{
	private _item = _x;

	if(_smokeGrenades > 0 && (crowsZA_common_smokeGrenades findIf { [_x, _item] call BIS_fnc_inString }) != -1) then {
		_unit removeMagazineGlobal _x;
		if(_smokeGrenades == 2) then {
			_unit addMagazineGlobal "SmokeShell";
		};
	};

	if(_grenades > 0 && (crowsZA_common_grenades findIf { [_x, _item] call BIS_fnc_inString }) != -1) then {
		_unit removeMagazineGlobal _x;
		if(_grenades == 2) then {
			_unit addMagazineGlobal "MiniGrenade";
		};
	};

	if(_explosives > 0 && (crowsZA_common_explosives findIf { [_x, _item] call BIS_fnc_inString }) != -1) then {
		_unit removeMagazineGlobal _x;
	};
} forEach magazines _unit;

if(_launchers > 0) then {
	// TODO: remove launcher ammo (even if the unit doesn't have a launcher, e.g. AT Assistants)
	_unit removeWeaponGlobal (secondaryWeapon _unit);
};