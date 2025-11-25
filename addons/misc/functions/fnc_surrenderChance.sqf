#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_surrenderChance.sqf
Parameters:
	unit					- (unit)
	confrontationRadius		- (float) radius within which pointing a weapon at the unit will trigger a response
	surrenderChance			- (float) min: 0 max: 1
	holdFire				- (bool) will unit hold fire until confronted
	hesitation				- (float) maximum time unit will stall before acting once confronted

Return: bool        		- True if method ran successfully, false if aborted (e.g. bad params were passed)

This code inspired by CQB Interactions By Flex7103
https://steamcommunity.com/sharedfiles/filedetails/?id=2942202773

Additional input from Blueduckraider50 on Github
https://github.com/Crowdedlight/Crows-Zeus-Additions/issues/88

*///////////////////////////////////////////////
params [
	["_unit", objNull, [objNull]],
	["_confrontationRadius", 15, [15]],
	["_surrenderChance", 0.33, [0.33]],
	["_holdFire", true, [true]],
	["_hesitation", 0, [0]]
];

// Remove unit from list of units with the module applied, and associated variables
GVAR(clearSurrender) = {
	params ["_unit"];
	deleteVehicle (_unit getVariable "_trigger");
	_unit removeEventHandler ["HandleDamage", _unit getVariable "crowsza_surrChance_ehDamaged"];
	_unit setVariable ["crowsza_surrender_chance_applied", nil, true];
	private _surrenderUnits = missionNamespace getVariable["crowsZA_surrenderUnits", []];
	_surrenderUnits = _surrenderUnits - [_unit];
	_surrenderUnits = _surrenderUnits arrayIntersect _surrenderUnits;
	missionNamespace setVariable["crowsZA_surrenderUnits", _surrenderUnits, true];
};


if(isNull _unit) exitWith { false };

if(_unit getVariable ["crowsza_surrender_chance_applied", false]) exitWith { ["STR_CROWSZA_Misc_surrender_chance_error"] call EFUNC(main,showHint); false };

// Tag this unit so that this function isn't applied twice
_unit setVariable ["crowsza_surrender_chance_applied", true, true];


// Add this unit to the list of units with this module applied, for drawing icons
private _surrenderUnits = missionNamespace getVariable["crowsZA_surrenderUnits", []];
_surrenderUnits pushBack _unit;
_surrenderUnits = _surrenderUnits arrayIntersect _surrenderUnits;
missionNamespace setVariable["crowsZA_surrenderUnits", _surrenderUnits, true];


if(_holdFire) then {
	// Set the combat mode of the whole group, to avoid the entire group
	// opening fire when one "snaps"
	_unit setCombatMode "BLUE";
};


private _trigger = createTrigger ["EmptyDetector", getPos _unit, false];
_trigger setTriggerArea [_confrontationRadius, _confrontationRadius, 0, false];
_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];

_trigger setVariable ["_unit", _unit];
_unit setVariable ["_trigger", _trigger];
_unit setVariable ["_hesitation", _hesitation];
_unit setVariable ["_surrenderChance", _surrenderChance];

_trigger attachTo [_unit];


// TODO: Optionally ensure that the player pointing a weapon is considered HOSTILE to the units side
// (don't mandate - could be useful to encourage friendly units, e.g. CIVs, to surrender too)

private _condition = toString {
	if(!this) exitWith { false };
	private _unit = thisTrigger getVariable "_unit";
	_weaponsOnTarget = {
		if(!isPlayer _x || {weaponLowered _x}) exitWith { 0 };
		_player = _x;
		_weaponDir = _player weaponDirection (currentWeapon _player);
		_lineStart = eyePos _player;
		_lineEnd = _lineStart vectorAdd (_player weaponDirection currentWeapon _player vectorMultiply (100));
		_units = lineIntersectsSurfaces [_lineStart, _lineEnd, _player];
		(count _units > 0 && {(_units select 0) select 2 == _unit || (_units select 0) select 3 == _unit})
	} count thisList;

	_weaponsOnTarget > 0
};

private _activation = toString {
	private _unit = thisTrigger getVariable "_unit";
	private _surrenderChance = _unit getVariable "_surrenderChance";
	private _hesitation = _unit getVariable "_hesitation";

	[_unit] call GVAR(clearSurrender);

	[_unit, _surrenderChance, _hesitation, thisTrigger] spawn {

		params ["_unit", "_surrenderChance", "_hesitation"];

		sleep ([random (0.5 + _hesitation), 0.5, _hesitation] call BIS_fnc_clamp);

		if(random 1 < _surrenderChance) then {
			[_unit] call FUNC(surrender);
		} else {
			_unit setUnitCombatMode "RED";
			_unit setCombatBehaviour "COMBAT";
		};
	};
};

_trigger setTriggerStatements [
	_condition,
	_activation,
	""
];


private _eh = _unit addEventHandler ["HandleDamage", {
	[{
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];

		private _unitDamage = if (EGVAR(main,aceLoaded)) then {
			// TODO: alternatively use BIS_fnc_arithmeticMean
			//((_unit getVariable ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]]) call BIS_fnc_arithmeticMean)
			private _sum = 0;
			{ _sum = _sum + _x; } forEach (_unit getVariable ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]]);
			_sum
		} else {
			damage _unit
		};

		private _surrenderChance = _unit getVariable "_surrenderChance";

		if(_unitDamage > _surrenderChance || {(random 1) < (_surrenderChance*0.2)}) then {

			if(_unitDamage > _surrenderChance) then {
				_unit setUnitCombatMode "RED";
				_unit setCombatBehaviour "COMBAT";
			} else {
				[_unit] call FUNC(surrender);
			};

			[_unit] call GVAR(clearSurrender);
		};
	}, _this] call CBA_fnc_execNextFrame;
}];
_unit setVariable ["crowsza_surrChance_ehDamaged", _eh];



_unit addEventHandler ["Deleted", {
	params ["_entity"];
	[_entity] call GVAR(clearSurrender);
}];

_unit addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	[_unit] call GVAR(clearSurrender);
}];



true
