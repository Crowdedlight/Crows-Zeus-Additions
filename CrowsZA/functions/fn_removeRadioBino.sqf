/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_removeRadioBino.sqf
Parameters: position ASL and unit clicked
Return: none

Removes radio and/or bino from given unit or group

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith { };

// open dialog
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_radio",
		"_bino",
		"_group"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	if (isNull _unit) exitWith { };

	private _units = [_unit];
	// check if group then get all units 
	if (_group) then {
		_units = units _unit;
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
			"Zeus has removed your radio and/or binoculars" remoteExec ["hint", _x];
		};
	} forEach _units;

};
[
	"Remove Equipment", 
	[
		["TOOLBOX:YESNO", ["Remove Radio", "Removes radios from units radio slot"], true],
		["TOOLBOX:YESNO", ["Remove Binoculars", "Removes binoculars from units binocular slot"], true],
		["TOOLBOX:YESNO", ["Entire Group", "Applies to entire group, or only unit selected"], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
