#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_removeRadioBino.sqf
Parameters: position ASL and unit clicked
Return: none

Removes radio and/or bino from given unit or group

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// open dialog
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_group",
		"_radio",
		"_bino"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	private _units = [];

	// check if group == side type, then we get all units on that side. Otherwise we are looking at an unit and true/false for group apply 
	if (typeName _group == "SIDE") then {
		_units = units _group;
	} else {
		// safety for if unit died or was deleted before we applied
		if (isNull _unit) exitWith {};
		// check if we do group or single unit
		if (_group) then {
			_units = units _unit;
		} else {
			_units pushBack _unit;
		};
	};

	// loop units and remove radio and bino
	{
		private _loadout = getUnitLoadout _x;
		
		if (_radio) then {
			private _radioItem = (_loadout#9) select 2;
			_x unlinkItem _radioItem;
			_x removeItems _radioItem;
		};

		if (_bino) then {
			private _itemsBino = _loadout#8;
			_x removeWeaponGlobal (_itemsBino#0);
			_x removeItems (_itemsBino#0);
		};

		// if player, notify player with hint
		if (isPlayer _x) then {
			localize "STR_CROWSZA_Misc_remove_radio_bino_error" remoteExec ["hint", _x];
		};
	} forEach _units;

};

private _options = [];
// if unit is null, give side selection, otherwise unit selection
if (isNull _unit) then {
	_options = [
		["SIDES", localize "STR_CROWSZA_Misc_remove_radio_bino_side", east],
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_remove_radio_bino_remove_radio", localize "STR_CROWSZA_Misc_remove_radio_bino_remove_radio_tooltip"], true],
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_remove_radio_bino_remove_bino", localize "STR_CROWSZA_Misc_remove_radio_bino_remove_bino_tooltip"], true]
	];
} else {
	_options = [
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_remove_radio_bino_group", localize "STR_CROWSZA_Misc_remove_radio_bino_group_tooltip"], true],
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_remove_radio_bino_remove_radio", localize "STR_CROWSZA_Misc_remove_radio_bino_remove_radio_tooltip"], true],
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_remove_radio_bino_remove_bino", localize "STR_CROWSZA_Misc_remove_radio_bino_remove_bino_tooltip"], true]
	];
};

[
	localize "STR_CROWSZA_Misc_remove_radio_bino", 
	_options,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
