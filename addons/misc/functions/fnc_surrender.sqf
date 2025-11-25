#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_surrender.sqf
Parameters:
	unit - (unit) unit to surrender

Return: bool - success

This code inspired by CQB Interactions By Flex7103
https://steamcommunity.com/sharedfiles/filedetails/?id=2942202773

*///////////////////////////////////////////////

params [["_unit", objNull, [objNull]]];

if(isNull _unit || {!alive _unit}) exitWith { false };

if (EGVAR(main,aceLoaded)) then {
	["ace_captives_setSurrendered",[_unit,true], _unit] call CBA_fnc_targetEvent;
} else {
	_unit action ["surrender", _unit];
};

_weapon = currentWeapon _unit;
if(_weapon isEqualTo "") exitWith { false };
_unit removeWeapon (currentWeapon _unit); 
_weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0]; 
_weaponHolder addWeaponCargoGlobal [_weapon,1]; 
_weaponHolder setPos (_unit modelToWorld [0,.2,1.2]); 
_weaponHolder disableCollisionWith _unit; 
_dir = random(360); 
_speed = 1; 
_weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir),4];

true
