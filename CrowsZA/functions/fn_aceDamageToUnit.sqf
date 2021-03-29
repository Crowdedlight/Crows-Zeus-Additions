/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_aceDamageToUnit.sqf
Parameters: logic
Return: none

Applies ACE wounds to specific limbs with type and damge value

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// Validate module target
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];
    diag_log _msg;
    breakOut "Main";
};

// check if something is selected and only infantry is selected
switch (false) do {
    case !(isNull _unit): {
        ["Nothing Selected for ACE Damage"] call _fnc_errorAndClose;
    };
    case (_unit isKindOf "CAManBase"): {
        ["Only allowed to pick infantry for ACE Damage"] call _fnc_errorAndClose;
    };
};

// open dialog
//either Ares or ZEN
if (crowZA_zen) then 
{
	//ZEN
	private _onConfirm =
	{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_bodyPart",
		"_dmgType",
		"_dmg"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	if (isNull _unit) exitWith { _return; };

	//debug 
	//diag_log _unit;

	//private _debug = missionNamespace getVariable [_unit , objNull];

	//diag_log _debug;
	
	//apply ACE dmg as ZEN SLider is a number
	[_unit, _dmg, _bodyPart, _dmgType, _unit] call ace_medical_fnc_addDamageToUnit;
};
[
	"Add ACE Damage to Unit", 
	[
		["COMBO","Body Part",[["head", "body", "leg_l", "leg_r", "hand_l", "hand_r"], ["Head", "Body", "Left Leg", "Right Leg", "Left Hand", "Right Hand"],2]],
		["COMBO","Projectile Type",[["falling", "ropeburn", "vehiclecrash", "collision", "unknown", "explosive", "grenade", "shell", "bullet", "backblast", "bite", "punch", "stab", "drowning"],["Falling", "Ropeburn", "Vehiclecrash", "Collision", "Unknown", "Explosive", "Grenade", "Shell", "Bullet", "Backblast", "Bite", "Punch", "Stab", "Drowning"],0]],
		["SLIDER","Damage",[0,5,0.6,1]] //0 to 5, default 0.6 and showing 1 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

} else 
{
	//ARES 
	private _dialogResult =
	[
		"Add ACE Damage to Unit",
		[
			["Body Part", ["Head", "Body", "leg_l", "leg_r", "hand_l", "hand_r"],3,true],
			["Projectile Type", ["falling", "ropeburn", "vehiclecrash", "collision", "unknown", "explosive", "grenade", "shell", "bullet", "backblast", "bite", "punch", "stab", "drowning"],0,true],
			["Damage", "", "0.6"]
		]
	] call Ares_fnc_showChooseDialog;

	if (_dialogResult isEqualTo []) exitWith{};

	_dialogResult params 
	[
		"_bodyPart",
		"_dmgType",
		"_dmg"
	];

	//check that _dmg is a number
	private _strArr = _dmg splitString "";
	if (count (_strArr select {typeName _x != "SCALAR"}) >= 0) exitWith
	{
		["Damage has to be a number. No letters, spaces or other characters are allowed"] call Achilles_fnc_showZeusErrorMessage;
	};

	//log it
	diag_log format ["Zeus applying %1 dmg to %2 limb with type %3 on unit %4", _dmg, _bodypart, _dmgType, _unit];

	[_unit, parseNumber _dmg, _bodyPart, _dmgType, _unit] call ace_medical_fnc_addDamageToUnit;
};