#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_aceDamageToUnit.sqf
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
        ["CrowsZA-AceDamage: Nothing Selected for ACE Damage"] call _fnc_errorAndClose;
    };
    case (_unit isKindOf "CAManBase"): {
        ["CrowsZA-AceDamage: Only allowed to pick infantry for ACE Damage"] call _fnc_errorAndClose;
    };
};

// open dialog
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

	//log it
	diag_log format ["CrowsZA-AceDamage: Zeus applying %1 dmg to %2 limb with type %3 on unit %4", _dmg, _bodypart, _dmgType, name _unit];

	//force to be in this limb, even if non-specific damage type
	// represents all incoming damage for selecting a non-selection Specific wound location, (used for selectRandomWeighted [value1,weight1,value2....])
	// #define HITPOINT_INDEX_HEAD 0
	// #define HITPOINT_INDEX_BODY 1
	// #define HITPOINT_INDEX_LARM 2
	// #define HITPOINT_INDEX_RARM 3
	// #define HITPOINT_INDEX_LLEG 4
	// #define HITPOINT_INDEX_RLEG 5
	// 	HITPOINT_INDEX_HEAD, 0, HITPOINT_INDEX_BODY, 0, HITPOINT_INDEX_LARM, 0, 
    //	HITPOINT_INDEX_RARM, 0, HITPOINT_INDEX_LLEG, 0, HITPOINT_INDEX_RLEG, 0
	private _damageSelectionArray = [
        0, 0, 1, 0, 2, 0, 
        3, 0, 4, 0, 5, 0
    ];

	// set true for the selected limb based on case
	switch (_bodyPart) do {
		case "head": {
			_damageSelectionArray set [1, 1];
		};
		case "body": {
			_damageSelectionArray set [3, 1];
		};
		case "hand_l": {
			_damageSelectionArray set [5, 1];
		};
		case "hand_r": {
			_damageSelectionArray set [7, 1];
		};
		case "leg_l": {
			_damageSelectionArray set [9, 1];
		};
		case "leg_r": {
			_damageSelectionArray set [11, 1];
		};
	};

	//apply ACE dmg as ZEN SLider is a number. Using remoteExec as it needs to be run where the unit is local
	[_unit, _dmg, _bodyPart, _dmgType, _unit, _damageSelectionArray] remoteExec ["ace_medical_fnc_addDamageToUnit", _unit];
};
[
	localize "STR_CROWSZA_ACE_adddamage_name", 
	[
		["COMBO",localize "STR_CROWSZA_ACE_adddamage_bodypart",[["head", "body", "leg_l", "leg_r", "hand_l", "hand_r"], [localize "STR_CROWSZA_ACE_adddamage_bodypart_head", localize "STR_CROWSZA_ACE_adddamage_bodypart_body", localize "STR_CROWSZA_ACE_adddamage_bodypart_leg_l", localize "STR_CROWSZA_ACE_adddamage_bodypart_leg_r", localize "STR_CROWSZA_ACE_adddamage_bodypart_hand_l", localize "STR_CROWSZA_ACE_adddamage_bodypart_hand_r"],2]],
		["COMBO","Projectile Type",[["falling", "ropeburn", "vehiclecrash", "collision", "unknown", "explosive", "grenade", "shell", "bullet", "backblast", "bite", "punch", "stab", "drowning", "burn"],[localize "STR_CROWSZA_ACE_adddamage_falling", localize "STR_CROWSZA_ACE_adddamage_ropeburn", localize "STR_CROWSZA_ACE_adddamage_vehiclecrash", localize "STR_CROWSZA_ACE_adddamage_collision", localize "STR_CROWSZA_ACE_adddamage_unknown", localize "STR_CROWSZA_ACE_adddamage_explosive", localize "STR_CROWSZA_ACE_adddamage_grenade", localize "STR_CROWSZA_ACE_adddamage_shell", localize "STR_CROWSZA_ACE_adddamage_bullet", localize "STR_CROWSZA_ACE_adddamage_backblast", localize "STR_CROWSZA_ACE_adddamage_bite", localize "STR_CROWSZA_ACE_adddamage_punch", localize "STR_CROWSZA_ACE_adddamage_stab", localize "STR_CROWSZA_ACE_adddamage_drowning", localize "STR_CROWSZA_ACE_adddamage_burn"],0]],
		["SLIDER",localize "STR_CROWSZA_ACE_adddamage_damage",[0,5,0.6,1]] //0 to 5, default 0.6 and showing 1 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
