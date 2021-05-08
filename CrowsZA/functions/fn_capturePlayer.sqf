/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_capturePlayer.sqf
Parameters: pos, _unit (We don't use unit or pos)
Return: none

Sets unit captive, full heals, removes weapons and radio

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//if unit is empty/null, exit
if (isNull _unit || !(_unit isKindOf "CAManBase")) exitWith { 
	diag_log "CrowsZA-capturePlayer: Tried to capture a null or invalid unit";
};

//log it
diag_log format ["CrowsZA-capturePlayer: Zeus is capturing unit %1. They have been set captive, healed and their weapons and radio is placed into the box next to them", name _unit];

//full heal
["ace_medical_treatment_fullHealLocal", [_unit], _unit] call CBA_fnc_targetEvent;

//toggle captive
["ace_captives_setHandcuffed", [_unit, true], _unit] call CBA_fnc_targetEvent;

//spawn container to store weapons removed from captive, and clean it
private _crate = "VirtualReammoBox_small_F" createVehicle (position _unit);

//make zeus editable
["zen_common_addObjects", [[_crate], objNull]] call CBA_fnc_serverEvent;

//remove weapons - We do not use "removeAllWeapons" as that also removes magazines, and we just want to remove the main guns
private _loadoutArr = getUnitLoadout _unit;
private _weapons = (_loadoutArr select [0, 3]);
private _items = _loadoutArr select 9;
{
	//check if weapon exists
	if (isNil "_x" || count _x < 1) then {continue};
	private _wep = _x select 0;
	_unit removeWeaponGlobal _wep; 

	//add it to container
	_crate addItemCargoGlobal [_wep, 1];
} forEach _weapons;

//remove radio - check for "Radio" or "TFAR"
{
	//if radio, remove it
	private _tfarRadio = ["TFAR", _x] call BIS_fnc_inString;
	private _baseRadio = ["radio", _x] call BIS_fnc_inString;
	if (!_tfarRadio && !_baseRadio) then {continue};
	_unit unlinkItem _x;

	//add to crate
	_crate addItemCargoGlobal [_x, 1];
} forEach _items;
