/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosives.sqf
Parameters:
	unit					- (unit)
	signal grenades			- (int) 0: ignore, 1: remove, 2: replace
	grenades				- (int) 0: ignore, 1: remove, 2: replace
	launchers				- (int) 0: ignore, 1: remove
	explosives				- (int) 0: ignore, 1: remove
	underbarrel grenades	- (int) 0: ignore, 1: remove

Return: bool        		- True if method ran successfully, false if aborted (i.e. bad params were passed)

*///////////////////////////////////////////////
params [
	["_unit", objNull, [objNull]],
	["_signalGrenades", 0, [0]],
	["_grenades", 0, [0]],
	["_launchers", 0, [0]],
	["_explosives", 0, [0]],
	["_ugl", 0, [0]]
];

if(isNull _unit || (_signalGrenades + _grenades + _launchers + _explosives + _ugl) == 0) exitWith { False };

{
	private _item = _x;
	private _itemParents = [ configFile >> "CfgMagazines" >> _item, true ] call BIS_fnc_returnParents;

	// NOTE: This includes chemlights, IR strobes, and UGL smokes
	if(_signalGrenades > 0 && (
		("SmokeShell" in _itemParents) ||
		("1Rnd_Smoke_Grenade_shell" in _itemParents) ||
		("3Rnd_Smoke_Grenade_shell" in _itemParents) ||
		("B_IR_Grenade" in _itemParents) ||
		("O_IR_Grenade" in _itemParents) ||
		("I_IR_Grenade" in _itemParents) ||
		("I_E_IR_Grenade" in _itemParents) ||
		("O_R_IR_Grenade" in _itemParents))
	) then {
		_unit removeMagazineGlobal _x;
		if(_signalGrenades == 2) then {
			_unit addMagazineGlobal "SmokeShell";
		};
	};

	if(_grenades > 0 && ( ("MiniGrenade" in _itemParents) || ("HandGrenade" in _itemParents) )) then {
		_unit removeMagazineGlobal _x;
		if(_grenades == 2) then {
			_unit addMagazineGlobal "MiniGrenade";
		};
	};

	// This will also remove launcher ammo from assistants etc.
	if(_launchers > 0 && "CA_LauncherMagazine" in _itemParents) then {
		_unit removeMagazineGlobal _x;
	};

	if(_explosives > 0 && (
		("ATMine_Range_Mag" in _itemParents) ||
		("SatchelCharge_Remote_Mag" in _itemParents) ||
		("ACE_SatchelCharge_Remote_Mag_Throwable" in _itemParents) ||
		("ClaymoreDirectionalMine_Remote_Mag" in _itemParents))
	) then {
		_unit removeMagazineGlobal _x;
	};

	// NOTE: This will also remove smoke shells for UGLs, even if _signalGrenades == 0
	if(_ugl > 0 && (
		("1Rnd_HE_Grenade_shell" in _itemParents) ||
		("3Rnd_HE_Grenade_shell" in _itemParents))
	) then {
		_unit removeMagazineGlobal _x;
	};
} forEach magazines _unit;

if(_launchers > 0) then {
	_unit removeWeaponGlobal (secondaryWeapon _unit);
};


if(_ugl > 0) then {

	// Attempt to unload any UGL rounds from equipped weapons
	private "_state";
	private "_mag";
	private "_magParents";
	{
		_state = _unit weaponState _x;
		_mag = _state select 3;
		_magParents = [ configFile >> "CfgMagazines" >> _mag, true ] call BIS_fnc_returnParents;
		if("1Rnd_HE_Grenade_shell" in _magParents || "3Rnd_HE_Grenade_shell" in _magParents) then {
			_unit setAmmo [_x, 0];
		};
	} forEach getArray (configFile >> "cfgWeapons" >> primaryWeapon _unit >> "muzzles");

	{
		_state = _unit weaponState _x;
		_mag = _state select 3;
		_magParents = [ configFile >> "CfgMagazines" >> _mag, true ] call BIS_fnc_returnParents;
		if("1Rnd_HE_Grenade_shell" in _magParents || "3Rnd_HE_Grenade_shell" in _magParents) then {
			_unit setAmmo [_x, 0];
		};
	} forEach getArray (configFile >> "cfgWeapons" >> handgunWeapon _unit >> "muzzles");

	// This will technically leave a grenade that cannot be fired in the weapon which is not ideal,
	// but it works for these purposes. Players may find it odd, if used on them.
};

True