/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosives.sqf
Parameters:
	unit			- (unit)
	signalGrenades	- (int) 0: ignore, 1: remove, 2: replace
	grenades		- (int) 0: ignore, 1: remove, 2: replace
	launchers		- (int) 0: ignore, 1: remove
	explosives		- (int) 0: ignore, 1: remove

Return: none

*///////////////////////////////////////////////
params ["_unit", "_signalGrenades", "_grenades", "_launchers", "_explosives"];

{
	private _item = _x;
	private _itemParents = [ configFile >> "CfgMagazines" >> _item, true ] call BIS_fnc_returnParents;

	// NOTE: This includes chemlights and IR strobes
	if(_signalGrenades > 0 && (
		("SmokeShell" in _itemParents) ||
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

	if(_explosives > 0 && (
		("ATMine_Range_Mag" in _itemParents) ||
		("SatchelCharge_Remote_Mag" in _itemParents) ||
		("ACE_SatchelCharge_Remote_Mag_Throwable" in _itemParents) ||
		("ClaymoreDirectionalMine_Remote_Mag" in _itemParents))
	) then {
		_unit removeMagazineGlobal _x;
	};

} forEach magazines _unit;

if(_launchers > 0) then {
	_unit removeWeaponGlobal (secondaryWeapon _unit);

	// TODO: also remove launcher ammo?
	// (even if the unit doesn't have a launcher, e.g. AT Assistants)
};