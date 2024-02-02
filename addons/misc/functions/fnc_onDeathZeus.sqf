#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_onDeathZeus.sqf
Parameters: pos, unit
Return: none

Activates one or more configurable effects when the passed unit (or object) dies

*///////////////////////////////////////////////



params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if(isNull _unit) exitWith { hint "Must be placed on a unit or object"; };

private _onConfirm =
{
	params ["_dialogResult","_in"];

	private _expectedParams = [
		"_hint_killer",
		"_hint_all",
		"_hint_zeus",
		"_deleteRemains",
		"_explosion",
		"_customCode",
		"_codeTarget"
	];

	if (isClass(configFile >> "CfgPatches" >> "crowsEW_main")) then {
		_expectedParams insert [5, ["_emp", "_sound_killer", "_sound_all"]];
	};

	_dialogResult params _expectedParams;
	_in params ["_pos", ["_unit",objNull,[objNull]]];

	if(isNull _unit) exitWith { hint "Something has gone wrong!"; diag_log "CrowsZA-onDeathZeus: unit became invalid after selection";};

	if(
		_hint_killer isEqualTo "" &&
		{_hint_all isEqualTo "" &&
		{_hint_zeus isEqualTo "" &&
		{!_deleteRemains &&
		{_explosion == 0 &&
		{_customCode isEqualTo "" &&
		{isNil "_emp" || {!_emp}} &&
		{isNil "_sound_killer" || {_sound_killer isEqualTo ""}} &&
		{isNil "_sound_all" || {_sound_all isEqualTo ""}}}}}}}
	) exitWith { hint "Nothing set - no action taken!" };


	private _unitList = missionNamespace getVariable ["crowza_onKilledEHUnits", []];
	_unitList pushBackUnique _unit;
	missionNamespace setVariable ["crowza_onKilledEHUnits", _unitList, true];

	_unit setVariable [QGVAR(onDeath_hintKiller), _hint_killer];
	_unit setVariable [QGVAR(onDeath_hintAll), _hint_all];
	_unit setVariable [QGVAR(onDeath_hintZeus), _hint_zeus];
	_unit setVariable [QGVAR(onDeath_deleteRemains), _deleteRemains];
	_unit setVariable [QGVAR(onDeath_explosion), _explosion];
	_unit setVariable [QGVAR(onDeath_emp), _emp];
	_unit setVariable [QGVAR(onDeath_soundKiller), _sound_killer];
	_unit setVariable [QGVAR(onDeath_soundAll), _sound_all];
	_unit setVariable [QGVAR(onDeath_customCode), _customCode];
	_unit setVariable [QGVAR(onDeath_codeTarget), _codeTarget];

	// If the EH is being overwritten (i.e. the module has been applied already), remove the old one first
	private _ehIndex = _unit getVariable ["crowza_onKilledEHIndex", nil];
	if(!isNil "_ehIndex") then {
		_unit removeMPEventHandler ["MPKilled", _ehIndex];
	};

	_ehIndex = _unit addMPEventHandler ["MPKilled", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];

		private _hint_killer = _unit getVariable [QGVAR(onDeath_hintKiller), ""];
		if(_hint_killer isNotEqualTo "" and player isEqualTo _killer) then {
			hint _hint_killer;
		};

		private _hint_all = _unit getVariable [QGVAR(onDeath_hintAll), ""];
		if(_hint_all isNotEqualTo "") then {
			hint _hint_all;
		};

		private _hint_zeus = _unit getVariable [QGVAR(onDeath_hintZeus), ""];
		if(_hint_zeus isNotEqualTo "" and !isNull (getAssignedCuratorLogic player)) then {
			hint _hint_zeus;
		};

		// TODO: worth investigating what happens if crowsEW is present ONLY on this client
		// (It shouldn't be - but not everyone uses a mod whitelist afterall)
		if (isClass(configFile >> "CfgPatches" >> "crowsEW_main")) then {
			private _sound = (_unit getVariable [QGVAR(onDeath_soundKiller), ""]);
			if(_sound isNotEqualTo "" and player isEqualTo _killer) then {
				[getPosASL _unit, 100, _sound, 1, true] call crowsEW_sounds_fnc_playSoundPos;
			};
		};

		private _customCode = _unit getVariable [QGVAR(onDeath_customCode), ""];
		if(_customCode isNotEqualTo "") then {
			private _codeTarget = _unit getVariable [QGVAR(onDeath_codeTarget), 0];

			if((_codeTarget == 0 and hasInterface) || {
				(_codeTarget == 1 and isServer) || {
				(_codeTarget == 2)}}
			) then {
				[_unit, _killer, _instigator, _useEffects] call (compile _customCode);
			};
		};

		if(isServer) then {
			private _unitList = missionNamespace getVariable["crowza_onKilledEHUnits", []];
			missionNamespace setVariable["crowza_onKilledEHUnits", _unitList-[_unit], true];

			switch(_unit getVariable [QGVAR(onDeath_explosion), 0]) do {
				case 1: { private _ied = createVehicle ["ModuleExplosive_IEDUrbanSmall_F", getPosATL _unit, [], 0, "CAN_COLLIDE"]; _ied setDamage 1; };
				case 2: { private _ied = createVehicle ["ModuleExplosive_IEDUrbanBig_F", getPosATL _unit, [], 0, "CAN_COLLIDE"]; _ied setDamage 1; };
				case 3: { ["zen_modules_moduleNuke", [ASLToAGL(getPosASL _unit), 200, 300, false]] call CBA_fnc_globalEvent; };
				default {};
			};

			if (isClass(configFile >> "CfgPatches" >> "crowsEW_main")) then {

				if(_unit getVariable [QGVAR(onDeath_emp), false]) then {
					[getPos _unit, _unit, 500, false, 1, 1] call crowsEW_emp_fnc_fireEMP;
				};

				private _sound = (_unit getVariable [QGVAR(onDeath_soundAll), ""]);
				if(_sound isNotEqualTo "") then {
					[getPosASL _unit, 100, _sound, 2] call crowsEW_sounds_fnc_playSoundPos;
				};
			};

			if(_unit getVariable [QGVAR(onDeath_deleteRemains), false]) then {
				deleteVehicle _unit;
			};
		};
	}];

	_unit setVariable ["crowza_onKilledEHIndex", _ehIndex, true];
};



private _options = [];
_options append [
	["EDIT",["Hint (Killer)", "Display a hint to the player that killed the unit"],["", {}, 1]],
	["EDIT",["Hint (All)", "Display a hint to all players"],["", {}, 1]],
	["EDIT",["Hint (Zeus)", "Display a hint to (all) Zeus players"],["", {}, 1]],
	["CHECKBOX",["Delete Remains", "Delete the 'dead' object or unit"],[false]],
	["COMBO",["Explosion", "Detonate an explosive on the position of the killed unit"],[[0, 1, 2, 3], ["None", "Small", "Large", "Nuclear"], 0]]
];

if (isClass(configFile >> "CfgPatches" >> "crowsEW_main")) then {
	private _sounds = [""];
	private _soundNames = ["None"];
	{
		_sounds pushback _x;
		_soundNames pushback (crowsEW_sounds_soundAttributes get _x)#2;
	} forEach ([(keys crowsEW_sounds_soundAttributes), [], { (crowsEW_sounds_soundAttributes get _x)#2 }] call BIS_fnc_sortBy);

	_options append [
		["CHECKBOX",["EMP", "Detonate an EMP that affects lights, radios, unprotected vehicles,"+endl+"and other electronic equipment within 500m"],[false]],
		["COMBO",["Sound (Killer)", "Play a sound to the player that killed the unit"],[_sounds, _soundNames, 0]],
		["COMBO",["Sound (All)", "Play a sound to the player that killed the unit"],[_sounds, _soundNames, 0]]
	];
};

_options append [
	["EDIT:CODE",["Custom Code", "Custom code to execute on unit's death"+endl+"Arguments: _unit, _killer, _instigator, _useEffects"+endl+"Written at your own risk - if unsure, leave blank!"],["", {}, 5]],
	["TOOLBOX",["Code Target", "Which machine to run the custom code on"],[0, 1, 3, ["Clients", "Server", "Clients + Server"]]]
];

[
	"Action On Death", 
	_options,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
