/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosives.sqf
Parameters:
	unit		- (unit)
	itemType	- (int) 0: signal grenades; 1: explosive grenades; 2: explosives; 3: UGL grenades; 4: launchers
	replaceWith	- (int) 0: nothing; other: context specific
	leave		- (int) amount of itemType to leave untouched

Return: bool    - True if method ran successfully, false if aborted (i.e. bad params were passed)

*///////////////////////////////////////////////

params [
	["_unit", objNull, [objNull]],
	["_itemType", 1, [0]],
	["_replace", 0, [0]],
	["_leave", 0, [0]]
];

if(isNull _unit || _itemType < 0 || _itemType > 4) exitWith { false };

// We hardcode some exceptions for modded items that don't follow the expected inheritance:
private _grenadeNotSmoke = ["ACE_M14"];
private _smokeNotGrenade = ["rhs_mag_rdg2_white", "rhs_mag_an_m8hc", "rhs_mag_nspd", "rhs_mag_nspn_yellow", "rhs_mag_m18_smoke_base", "rhssaf_mag_brd_m83_yellow", "rhssaf_mag_brd_m83_white", "rhssaf_mag_brd_m83_red", "rhssaf_mag_brd_m83_orange", "rhssaf_mag_brd_m83_green", "rhssaf_mag_brd_m83_blue", "fow_e_nb39b", "fow_e_no77"];


{
	private _item = _x;
	private _itemParents = [configFile >> "CfgMagazines" >> _item, true] call BIS_fnc_returnParents;

	// NOTE: This includes chemlights, IR strobes, and UGL smokes
	if(_itemType == 0 && { !(_item in _grenadeNotSmoke) && count (_itemParents arrayIntersect _grenadeNotSmoke) == 0 } && {
		_item in _smokeNotGrenade || count (_itemParents arrayIntersect _smokeNotGrenade) > 0 ||
		count ([
			"SmokeShell",
			"1Rnd_Smoke_Grenade_shell",
			"3Rnd_Smoke_Grenade_shell",
			"B_IR_Grenade",
			"O_IR_Grenade",
			"I_IR_Grenade",
			"I_E_IR_Grenade",
			"O_R_IR_Grenade"
		] arrayIntersect _itemParents) > 0
	})
	then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _x;
			switch(_replace) do {
				case 1 : { _unit addMagazineGlobal "SmokeShell"; };
				case 2 : { _unit addMagazineGlobal "SmokeShellBlue"; };
				case 3 : { _unit addMagazineGlobal "SmokeShellGreen"; };
				case 4 : { _unit addMagazineGlobal "SmokeShellRed"; };
			};
		} else{
			_leave = _leave - 1;
		};
	};


	if(_itemType == 1 && { !(_item in _smokeNotGrenade) && count (_itemParents arrayIntersect _smokeNotGrenade) == 0 } &&
		{!("SmokeShell" in _itemParents) || _item in _grenadeNotSmoke || count (_itemParents arrayIntersect _grenadeNotSmoke) > 0 } && {
		_item in _grenadeNotSmoke ||
		count (_itemParents arrayIntersect _grenadeNotSmoke) > 0 ||
		("MiniGrenade" in _itemParents) ||
		("HandGrenade" in _itemParents)
	}) then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _x;

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
		} else{
			_leave = _leave - 1;
		};
		
	};

	if(_itemType == 2 && {
		("ATMine_Range_Mag" in _itemParents) ||
		("SatchelCharge_Remote_Mag" in _itemParents) ||
		("ACE_SatchelCharge_Remote_Mag_Throwable" in _itemParents) ||
		("ClaymoreDirectionalMine_Remote_Mag" in _itemParents)
	}) then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _x;
			switch(_replace) do {
				case 1 : { _unit addMagazineGlobal "DemoCharge_Remote_Mag"; };
			};
		} else{
			_leave = _leave - 1;
		};
	};


	if(_itemType == 3 && {!("SmokeShell" in _itemParents)} && {
		("1Rnd_HE_Grenade_shell" in _itemParents) ||
		("3Rnd_HE_Grenade_shell" in _itemParents) ||
		("LIB_BaseRifleGrenade" in _itemParents)
	}) then {
		if(_leave <= 0) then {
			_unit removeMagazineGlobal _x;

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
		} else {
			_leave = _leave - 1;
		};
	};


	// This will also remove launcher ammo from assistants etc.
	if(_itemType == 4 && {"CA_LauncherMagazine" in _itemParents}) then {
		_unit removeMagazineGlobal _x;
	};
} forEach magazines _unit;



if(_itemType == 3) then {

	// Unload any UGL rounds from equipped weapons
	private "_magParents";
	{
		_magParents = [ configFile >> "CfgMagazines" >> _x, true ] call BIS_fnc_returnParents;
		if(_leave <= 0 && {"1Rnd_HE_Grenade_shell" in _magParents || "3Rnd_HE_Grenade_shell" in _magParents || "LIB_BaseRifleGrenade" in _magParents} && {!("SmokeShell" in _magParents)}) then {
			_unit removePrimaryWeaponItem _x;

			switch(_replace) do {
				case 1 : { if(!(_unit addPrimaryWeaponItem "1Rnd_Smoke_Grenade_shell")) then {_unit addPrimaryWeaponItem "rhs_GRD40_white"}; };
				case 2 : { if(!(_unit addPrimaryWeaponItem "1Rnd_HE_Grenade_shell")) then {_unit addPrimaryWeaponItem "rhs_VOG25"}; };
				case 3 : { if(!(_unit addPrimaryWeaponItem "rhs_mag_m4009")) then {_unit addPrimaryWeaponItem "rhs_VG40SZ"}; };
				case 4 : { if(!(_unit addPrimaryWeaponItem "rhs_mag_M781_Practice")) then {_unit addPrimaryWeaponItem "rhs_VG40MD"}; };
			};
		} else {
			_leave = _leave - 1;
		};
	} forEach primaryWeaponMagazine _unit;

	{
		_magParents = [ configFile >> "CfgMagazines" >> _x, true ] call BIS_fnc_returnParents;
		if(_leave <= 0 && {"1Rnd_HE_Grenade_shell" in _magParents || "3Rnd_HE_Grenade_shell" in _magParents || "LIB_BaseRifleGrenade" in _magParents} && {!("SmokeShell" in _magParents)}) then {
			_unit removeHandgunItem _x;
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