#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric + (minor edits) Crowdedlight
			   
File: fnc_constructStripExplosivesDialog.sqf
Parameters:
	unit 			- (unit) unit that module was applied to, or objNull
	controlValues	- (Array) values to set the UI to
	default 		- (bool) whether to force default UI values
Return: none

*///////////////////////////////////////////////

params ["_unit", "_controlValues", ["_default", false]];

GVAR(strip_explosives_unit) = _unit;

private _onConfirm = {
	params ["_dialogResult","_in"];
	
	_dialogResult params [
		["_sideOrGroup", east, [east, true]],
		["_ignorePlayers", true, [true]],
		["_itemType", 1, [0]],
		["_replace", 0, [0]],
		["_replaceCustom", "", [""]],
		["_leave", 0, [0]]
	];
	_in params ["_unit"];

	_leave = [_leave, 0] call BIS_fnc_cutDecimals;

	private _units = if(_sideOrGroup in [west, east, independent, civilian]) then {
		units _sideOrGroup
	} else {
		if(_sideOrGroup) then {
			units _unit
		} else {
			[_unit]
		}
	};

	// Logging
	private _logItem = switch(_itemType) do {
		case 0: { "signal grenades" };
		case 1: { "explosive grenades" };
		case 2: { "explosives" };
		case 3: { "UGL grenades" };
		case 4: { "launchers" };
	};
	private _logSide = if(_u in [west, east, independent, civilian]) then {
		format ["%1 %2", _u, localize "STR_CROWSZA_Misc_side"]
	} else {
		if(_group) then {
			format ["%2 %1", group _u, localize "STR_CROWSZA_Misc_group"]
		} else {
			format ["%2 %1", _u, localize "STR_CROWSZA_Misc_unit"]
		}
	};
	private _logPlayers = switch(_ignorePlayers) do {
		case true: { "(ignoring players)" };
		case false: { "(INCLUDING players)" };
	};
	diag_log format ["crowsZA-stripExplosives: Stripping %1 from %2 %3", _logItem, _logSide, _logPlayers];


	[_units, _ignorePlayers, _itemType, _replace, _replaceCustom, _leave, _logItem] spawn {
		params["_units", "_ignorePlayers", "_itemType", "_replace",  "_replaceCustom", "_leave", "_logItem"];
		{
			if(!(isPlayer _x) || {!_ignorePlayers}) then {
				[_x, _itemType, _replace, _replaceCustom, _leave] call FUNC(stripExplosives);
				if (isPlayer _x) then {
					private _logAction = ["removed", "replaced"] select (_replace);
				    (format [localize "STR_CROWSZA_Misc_strip_explosives_zeus_has_removed", _logAction, _logItem]) remoteExec ["hint", _x];
				};
				sleep 0.01;
			};
		} forEach _units;
	};
};


private _controls = [];

if((_controlValues select 0) in [west, east, independent, civilian]) then {
	_controls pushBack ["SIDES", localize "STR_CROWSZA_Misc_remove_radio_bino_side", _controlValues select 0, _default];
}
else {
	_controls pushBack ["CHECKBOX", [localize "STR_CROWSZA_Misc_strip_explosives_whole_group", localize "STR_CROWSZA_Misc_strip_explosives_whole_group_tooltip"], _controlValues select 0, _default];
};
_controls pushBack ["CHECKBOX", localize "STR_CROWSZA_Misc_strip_explosives_ignore_players", _controlValues select 1, _default];
_controls pushBack ["TOOLBOX", [localize "STR_CROWSZA_Misc_strip_explosives_item_type", (localize "STR_CROWSZA_Misc_strip_explosives_item_type_tooltip") regexReplace ["<br/>",endl]], [_controlValues select 2, 1, 5, [localize "STR_CROWSZA_Misc_strip_explosives_signals", localize "STR_CROWSZA_Misc_strip_explosives_grenades", localize "STR_CROWSZA_Misc_strip_explosives_explosives", localize "STR_CROWSZA_Misc_strip_explosives_ugl", localize "STR_CROWSZA_Misc_strip_explosives_launchers"]], _default];
private _replace = ["Nothing"];


switch (_controlValues select 2) do {
	// Signal grenades
	case 0 : {  _replace append ["White smoke", "Blue smoke", "Green smoke", "Red smoke"]; }; 
	
	// Grenades
	case 1 : {
		_replace append ["M67 (Fragmentation)"];

		if(isClass (configFile >> "CfgMagazines" >> "ACE_M84")) then {
			_replace append ["M84 (Stun)"];
		};

		if(isClass (configFile >> "CfgMagazines" >> "rhs_mag_m69" )) then {
			_replace append ["M69 (Practice)"];
		} else{
			if(isClass (configFile >> "CfgMagazines" >> "BAF_HandGrenade_Blank" )) then {
				_replace append ["L111A1 (Practice)"];
			};
		};
	}; 
	
	// Explosives
	case 2 : {  _replace append ["M112 Demo Block"]; }; 
	
	// UGL Grenade Launchers
	case 3 : {
		_replace append ["Smoke (white)", "40mm HE"];
		if(isClass (configFile >> "CfgMagazines" >> "rhs_mag_m4009" ) || {isClass (configFile >> "CfgMagazines" >> "rhs_VG40SZ" )}) then {
			_replace pushBack "Stun";
		};
		if(isClass (configFile >> "CfgMagazines" >> "rhs_mag_M781_Practice" )) then {
			_replace pushBack "Practice";
		};
	};
	
	// Shoulder launchers
	case 4 : {  };
};

if((_controlValues select 2) < 4) then {
	_controls pushBack ["TOOLBOX", localize "STR_CROWSZA_Misc_strip_explosives_replace_with", [_controlValues select 3, 1, count _replace, _replace], _default];

	private _replaceCustom = if(count _controlValues >= 6) then { _controlValues select 4 } else { "" }; // TODO: could store the previous value as a (global) variable rather than clearing if not set
	_controls pushBack ["EDIT", [localize "STR_CROWSZA_Misc_strip_explosives_replace_with_custom", (localize "STR_CROWSZA_Misc_strip_explosives_replace_with_custom_tooltip") regexReplace ["<br/>",endl]], [_replaceCustom], _default];

	private _leave = if(count _controlValues >= 6) then { _controlValues select 5 } else { 0 };
	_controls pushBack ["SLIDER", [localize "STR_CROWSZA_Misc_strip_explosives_leave_untouched", (localize "STR_CROWSZA_Misc_strip_explosives_leave_untouched_tooltip") regexReplace ["<br/>",endl]], [0, 10, _leave, 0], _default];
};

GVAR(strip_explosives_previousValues) = _controlValues;

[
	localize "STR_CROWSZA_Misc_strip_explosives_dialog",
	_controls,
	_onConfirm,
	{},
	[_unit]
] call zen_dialog_fnc_create;

(uiNamespace getVariable "zen_common_display") displayAddEventHandler ["MouseButtonUp", {

	params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

	// Get the values of all content controls
	(_display getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
	private _values = _controls apply {
	    _x params ["_controlsGroup", "_settings"];

	    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
	};

	// If any controls that would affect the layout changed since the last check, recreate the display
	if((GVAR(strip_explosives_previousValues) select 2) != (_values select 2)) then {
		GVAR(strip_explosives_previousValues) = _values;
		closeDialog 2;
		[GVAR(strip_explosives_unit), _values] call FUNC(constructstripExplosivesDialog);
	};
}];
