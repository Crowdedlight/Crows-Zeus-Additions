/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_constructStripExplosivesDialog.sqf
Parameters:
	unit 			- (unit) unit that module was applied to, or objNull
	controlValues	- (Array) values to set the UI to
	default 		- (bool) whether to force default UI values
Return: none

*///////////////////////////////////////////////

params ["_unit", "_controlValues", ["_default", false]];

crowsza_strip_explosives_unit = _unit;

private _onConfirm = {
	params ["_dialogResult","_in"];
	
	_dialogResult params [
		["_sideOrGroup", east, [east, true]],
		["_ignorePlayers", true, [true]],
		["_itemType", 1, [0]],
		["_replace", 0, [0]],
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
		format ["%1 side", _u]
	} else {
		if(_group) then {
			format ["group %1", group _u]
		} else {
			format ["unit %1", _u]
		}
	};
	private _logPlayers = switch(_ignorePlayers) do {
		case true: { "(ignoring players)" };
		case false: { "(INCLUDING players)" };
	};
	diag_log format ["crowsZA-stripExplosives: Stripping %1 from %2 %3", _logItem, _logSide, _logPlayers];


	[_units, _ignorePlayers, _itemType, _replace, _leave, _logItem] spawn {
		params["_units", "_ignorePlayers", "_itemType", "_replace", "_leave", "_logItem"];
		{
			if(!(isPlayer _x) || {!_ignorePlayers}) then {
				[_x, _itemType, _replace, _leave] call crowsZA_fnc_stripExplosives;
				if (isPlayer _x) then {
					private _removed = if(_replace == 0) then { "removed" } else { "replaced" };
				    (format ["Zeus has %1 your %2", _removed, _logItem]) remoteExec ["hint", _x];
				};
				sleep 0.01;
			};
		} foreach _units;
	};
};


private _controls = [];

if((_controlValues select 0) in [west, east, independent, civilian]) then {
	_controls pushBack ["SIDES", "Side", _controlValues select 0, _default];
}
else {
	_controls pushBack ["CHECKBOX", ["Whole Group", "Remove items from this unit's group"], _controlValues select 0, _default];
};
_controls pushBack ["CHECKBOX", "Ignore players", _controlValues select 1, _default];
_controls pushBack ["TOOLBOX", "Item Type", [_controlValues select 2, 1, 5, ["Signal Grenades", "Grenades", "Explosives", "UGL Grenades", "Launchers"]], _default];
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
	_controls pushBack ["TOOLBOX", "Replace with", [_controlValues select 3, 1, count _replace, _replace], _default];

	private _leave = if(count _controlValues >= 5) then { _controlValues select 4 } else { 0 };
	_controls pushBack ["SLIDER", ["Leave untouched", "Amount of unit's inventory to leave unchanged. Does not guarantee which type is preserved if the unit has, e.g. multiple colours of smoke."], [0, 10, _leave, 0], _default];
};

crowsza_strip_explosives_previousValues = _controlValues;

[
	"Remove Explosives",
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
	if((crowsza_strip_explosives_previousValues select 2) != (_values select 2)) then {
		crowsza_strip_explosives_previousValues = _values;
		closeDialog 2;
		[crowsza_strip_explosives_unit, _values] call crowsZA_fnc_constructstripExplosivesDialog;
	};
}];