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

// This code inspired by CQB Interactions By Flex7103
// https://steamcommunity.com/sharedfiles/filedetails/?id=2942202773

*///////////////////////////////////////////////
params [
	["_unit", objNull, [objNull]],
	["_confrontationRadius", 15, [15]],
	["_surrenderChance", 0.33, [0.33]],
	["_holdFire", true, [true]],
	["_hesitation", 0, [0]]
];

if(isNull _unit) exitWith { false };

if(_unit getVariable ["crowsza_surrender_chance_applied", false]) exitWith { ["Surrender chance already applied to this unit"] call crowsZA_fnc_showHint; false };


// TODO: add to CZA draw handler so zeuses can see which units have had this applied (similar to Remote Control)
_unit setVariable ["crowsza_surrender_chance_applied", true, true];


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

private _condition = "
if(!this) exitWith { false };
private _unit = thisTrigger getVariable ""_unit"";
{
	[_unit, {
		missionNamespace setVariable [
			""crowsza_surrender_chance_"" + str _this,
			(toUpperANSI cameraView == ""GUNNER"") && (cursorObject == _this),
			remoteExecutedOwner
		];
	}] remoteExecCall [""call"", _x];

	if((missionNamespace getVariable (""crowsza_surrender_chance_"" + str _unit))) exitWith {true};
} forEach thisList;
(missionNamespace getVariable (""crowsza_surrender_chance_"" + str _unit))
";


private _activation = "
private _unit = thisTrigger getVariable ""_unit"";
private _surrenderChance = _unit getVariable ""_surrenderChance"";
private _hesitation = _unit getVariable ""_hesitation"";

missionNamespace setVariable [(""crowsza_surrender_chance_"" + str _unit), nil];
_unit setVariable [""crowsza_surrender_chance_applied"", nil, true];
deletevehicle thisTrigger;

[_unit, _surrenderChance, _hesitation, thisTrigger] spawn {

	params [""_unit"", ""_surrenderChance"", ""_hesitation""];

	sleep ([random (0.5 + _hesitation), 0.5, _hesitation] call BIS_fnc_clamp);


	if(random 1 < _surrenderChance) then {

		if (crowsZA_common_aceModLoaded) then {
			[""ace_captives_setSurrendered"",[_unit,true]] call CBA_fnc_globalEvent;
		} else {
			_unit action [""surrender"", _unit];
		};
		
		_weapon = currentWeapon _unit;
		_unit removeWeapon (currentWeapon _unit); 
		_weaponHolder = ""WeaponHolderSimulated"" createVehicle [0,0,0]; 
		_weaponHolder addWeaponCargoGlobal [_weapon,1]; 
		_weaponHolder setPos (_unit modelToWorld [0,.2,1.2]); 
		_weaponHolder disableCollisionWith _unit; 
		_dir = random(360); 
		_speed = 1; 
		_weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir),4];
	} else {
		_unit setUnitCombatMode ""RED"";
		_unit setCombatBehaviour ""COMBAT"";
	};
};
";

_trigger setTriggerStatements [
	_condition,
	_activation,
	""
];

_unit addEventHandler ["Deleted", {
	params ["_entity"];
	deleteVehicle (_entity getVariable "_trigger");
}];

_unit addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	deleteVehicle (_unit getVariable "_trigger");
}];


_unit addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];

	_unit setUnitCombatMode "RED";
	_unit setCombatBehaviour "COMBAT";
	deletevehicle (_unit getVariable "_trigger");

}];


true