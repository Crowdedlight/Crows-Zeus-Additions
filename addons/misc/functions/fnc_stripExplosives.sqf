#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosives.sqf
Parameters:
	unit				- (unit)
	itemType			- (int) 0: signal grenades; 1: explosive grenades; 2: explosives; 3: UGL grenades; 4: launchers
	replaceWith			- (int) 0: nothing; other: context specific
	replaceWithCustom	- (string) A custom magazine type to replace with (ignored if blank, errors if invalid)
	leave				- (int) amount of itemType to leave untouched

Return: bool    		- True if method ran successfully, false if aborted (i.e. bad params were passed)

*///////////////////////////////////////////////

params [
	["_unit", objNull, [objNull]],
	["_itemType", 1, [0]],
	["_replace", 0, [0]],
	["_replaceCustom", "", [""]],
	["_leave", 0, [0]]
];

// If an incorrect argument is passed, fail
// TODO: log as an error?
if(isNull _unit || _itemType < 0 || _itemType > 4) exitWith { false };

// If an unrecognised custom class is provided, simply fail and notify zeus
// TODO: alternatively, default to "normal" behaviour
if(_replaceCustom isNotEqualTo "" && { !isClass(configFile >> "CfgMagazines" >> _replaceCustom) && !isClass(configFile >> "CfgWeapons" >> _replaceCustom) && { "ItemCore" in ([configFile >> "CfgWeapons" >> _replaceCustom, true] call BIS_fnc_returnParents) } }) exitWith {
	hint format ["%2: %1", _replaceCustom, localize "STR_CROWSZA_Misc_strip_explosives_error"];
	false
};


private _smokes = [
	"SmokeShell",
	"1Rnd_Smoke_Grenade_shell",
	"3Rnd_Smoke_Grenade_shell",
	"B_IR_Grenade",
	"O_IR_Grenade",
	"I_IR_Grenade",
	"I_E_IR_Grenade",
	"O_R_IR_Grenade"
];

private _grenades = [
	"MiniGrenade",
	"HandGrenade"
];

private _explosives = [
	"ATMine_Range_Mag",
	"SatchelCharge_Remote_Mag",
	"ACE_SatchelCharge_Remote_Mag_Throwable",
	"ClaymoreDirectionalMine_Remote_Mag",
	"rhsusf_m112_mag",
	"rhssaf_tm100_mag"
];


// We hardcode some exceptions for modded items that don't follow the expected inheritance:
private _grenadeNotSmoke = ["ACE_M14"];
private _smokeNotGrenade = ["rhs_mag_rdg2_white", "rhs_mag_an_m8hc", "rhs_mag_nspd", "rhs_mag_nspn_yellow", "rhs_mag_m18_smoke_base", "rhssaf_mag_brd_m83_yellow", "rhssaf_mag_brd_m83_white", "rhssaf_mag_brd_m83_red", "rhssaf_mag_brd_m83_orange", "rhssaf_mag_brd_m83_green", "rhssaf_mag_brd_m83_blue", "fow_e_nb39b", "fow_e_no77"];


_smokes append _smokeNotGrenade;
_grenades append _grenadeNotSmoke;

{
	private _item = _x;
	private _itemAndParents = [configFile >> "CfgMagazines" >> _item, true] call BIS_fnc_returnParents;
	_itemAndParents pushBackUnique _item;

	// NOTE: This includes chemlights, IR strobes, and UGL smokes
	if(_itemType == 0 &&
		// Check that the item is of the specified type (or inherits from something that is)
		{ count (_smokes arrayIntersect _itemAndParents) > 0 } &&
		// Check there are no exceptions for this item (and that it doesn't inherit from something with an exception)
		{ count ( _grenadeNotSmoke arrayIntersect _itemAndParents) == 0 }
	)
	then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _item;

			if(_replaceCustom isNotEqualTo "") then {
				if(isClass(configFile >> "CfgMagazines" >> _replaceCustom)) then {
					_unit addMagazineGlobal _replaceCustom;
				} else {
					_unit addItem _replaceCustom;
				};
			} else {
				switch(_replace) do {
					case 1 : { _unit addMagazineGlobal "SmokeShell"; };
					case 2 : { _unit addMagazineGlobal "SmokeShellBlue"; };
					case 3 : { _unit addMagazineGlobal "SmokeShellGreen"; };
					case 4 : { _unit addMagazineGlobal "SmokeShellRed"; };
				};
			};
		} else{
			_leave = _leave - 1;
		};
	};


	if(_itemType == 1 &&
		// Check that the item is of the specified type (or inherits from something that is)
		{ count (_grenades arrayIntersect _itemAndParents) > 0 } &&
		// Check there are no exceptions for this item (and that it doesn't inherit from something with an exception)
		{!("SmokeShell" in _itemAndParents) || count (_grenadeNotSmoke arrayIntersect _itemAndParents) > 0 } &&
		{ count ( _smokeNotGrenade arrayIntersect _itemAndParents) == 0 }
	) then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _item;

			if(_replaceCustom isNotEqualTo "") then {
				if(isClass(configFile >> "CfgMagazines" >> _replaceCustom)) then {
					_unit addMagazineGlobal _replaceCustom;
				} else {
					_unit addItem _replaceCustom;
				};
			} else {
				switch (_replace) do {
					case 1 : { _unit addMagazineGlobal "MiniGrenade"; };
					case 2 : {
						if(isClass (configFile >> "CfgMagazines" >> "ACE_M84")) then {
							_unit addMagazineGlobal "ACE_M84";
						} else {
							if(isClass (configFile >> "CfgMagazines" >> "rhs_mag_m69" )) then {
								_unit addMagazineGlobal "rhs_mag_m69";
							} else{
								if(isClass (configFile >> "CfgMagazines" >> "BAF_HandGrenade_Blank" )) then {
									_unit addMagazineGlobal "BAF_HandGrenade_Blank";
								};
							};
						};
					};
					case 3 : {
						if(isClass (configFile >> "CfgMagazines" >> "rhs_mag_m69" )) then {
							_unit addMagazineGlobal "rhs_mag_m69";
						} else{
							if(isClass (configFile >> "CfgMagazines" >> "BAF_HandGrenade_Blank" )) then {
								_unit addMagazineGlobal "BAF_HandGrenade_Blank";
							};
						};
					};
				};
			};
		} else{
			_leave = _leave - 1;
		};
		
	};

	if(_itemType == 2 && { count (_explosives arrayIntersect _itemAndParents) > 0 }) then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _item;
			if(_replaceCustom isNotEqualTo "") then {
				if(isClass(configFile >> "CfgMagazines" >> _replaceCustom)) then {
					_unit addMagazineGlobal _replaceCustom;
				} else {
					_unit addItem _replaceCustom;
				};
			} else {
				switch(_replace) do {
					case 1 : { _unit addMagazineGlobal "DemoCharge_Remote_Mag"; };
				};
			};
		} else{
			_leave = _leave - 1;
		};
	};


	if(_itemType == 3 && {!("SmokeShell" in _itemAndParents)} && {
		("1Rnd_HE_Grenade_shell" in _itemAndParents) ||
		("3Rnd_HE_Grenade_shell" in _itemAndParents) ||
		("LIB_BaseRifleGrenade" in _itemAndParents)
	}) then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _item;

			if(_replaceCustom isNotEqualTo "") then {
				_unit addMagazineGlobal _replaceCustom;
			} else {
				private _compatible = (compatibleMagazines (primaryWeapon _unit)) + (compatibleMagazines (handgunWeapon _unit));
				switch(_replace) do {
					case 1 : {
						if("1Rnd_Smoke_Grenade_shell" in _compatible) then {
							_unit addMagazineGlobal "1Rnd_Smoke_Grenade_shell";
						} else {
							if("rhs_GRD40_white" in _compatible) then {
								_unit addMagazineGlobal "rhs_GRD40_white";
							};
						};
					};
					case 2 : {
						if("1Rnd_HE_Grenade_shell" in _compatible) then {
							_unit addMagazineGlobal "1Rnd_HE_Grenade_shell";
						} else {
							if("rhs_VOG25" in _compatible) then {
								_unit addMagazineGlobal "rhs_VOG25";
							};
						};
					};
					case 3 : {
						if("rhs_mag_m4009" in _compatible) then {
							_unit addMagazineGlobal "rhs_mag_m4009";
						} else {
							if("rhs_VG40SZ" in _compatible) then {
								_unit addMagazineGlobal "rhs_VG40SZ";
							};
						};
					};
					case 4 : {
						if("rhs_mag_M781_Practice" in _compatible) then {
							_unit addMagazineGlobal "rhs_mag_M781_Practice";
						} else {
							if("rhs_VG40MD" in _compatible) then {
								_unit addMagazineGlobal "rhs_VG40MD";
							};
						};
					};
				};
			};
		} else {
			_leave = _leave - 1;
		};
	};


	// This will also remove launcher ammo from assistants etc.
	if(_itemType == 4 && {"CA_LauncherMagazine" in _itemAndParents}) then {
		_unit removeMagazineGlobal _item;
	};
} forEach magazines _unit;



if(_itemType == 3) then {

	// Unload any UGL rounds from equipped weapons
	private "_magParents";
	{
		private _magazine = _x;
		_magParents = [ configFile >> "CfgMagazines" >> _magazine, true ] call BIS_fnc_returnParents;
		if(_leave <= 0 && {"1Rnd_HE_Grenade_shell" in _magParents || "3Rnd_HE_Grenade_shell" in _magParents || "LIB_BaseRifleGrenade" in _magParents} && {!("SmokeShell" in _magParents)}) then {
			_unit removePrimaryWeaponItem _magazine;

			if(_replaceCustom isNotEqualTo "") then {
				_unit addMagazineGlobal _replaceCustom;
			} else {
				switch(_replace) do {
					case 1 : { if(!(_unit addPrimaryWeaponItem "1Rnd_Smoke_Grenade_shell")) then {_unit addPrimaryWeaponItem "rhs_GRD40_white"}; };
					case 2 : { if(!(_unit addPrimaryWeaponItem "1Rnd_HE_Grenade_shell")) then {_unit addPrimaryWeaponItem "rhs_VOG25"}; };
					case 3 : { if(!(_unit addPrimaryWeaponItem "rhs_mag_m4009")) then {_unit addPrimaryWeaponItem "rhs_VG40SZ"}; };
					case 4 : { if(!(_unit addPrimaryWeaponItem "rhs_mag_M781_Practice")) then {_unit addPrimaryWeaponItem "rhs_VG40MD"}; };
				};
			};
		} else {
			_leave = _leave - 1;
		};
	} forEach primaryWeaponMagazine _unit;

	{
		private _magazine = _x;
		_magParents = [ configFile >> "CfgMagazines" >> _magazine, true ] call BIS_fnc_returnParents;
		if(_leave <= 0 && {"1Rnd_HE_Grenade_shell" in _magParents || "3Rnd_HE_Grenade_shell" in _magParents || "LIB_BaseRifleGrenade" in _magParents} && {!("SmokeShell" in _magParents)}) then {
			_unit removeHandgunItem _magazine;
			// TODO: set up replace for any common (modded) handgun-slot GL's
		} else {
			_leave = _leave - 1;
		};
	} forEach handgunMagazine _unit;
};


if(_itemType == 4) then {
	_unit removeWeaponGlobal (secondaryWeapon _unit);
};

true