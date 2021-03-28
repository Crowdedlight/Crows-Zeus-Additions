/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_aceDamageToUnit.sqf
Parameters: logic
Return: none

Applies ACE wounds to specific limbs with type and damge value

*///////////////////////////////////////////////
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;

// Validate module target
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];
    deleteVehicle _logic;
    [_msg] call FUNC(showMessage);
    breakOut "Main";
};

// check if something is selected and only infantry is selected
switch (false) do {
    case !(isNull _unit): {
        [LSTRING(NothingSelected)] call _fnc_errorAndClose;
    };
    case (_unit isKindOf "CAManBase"): {
        [LSTRING(OnlyInfantry)] call _fnc_errorAndClose;
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
	_in params [_unit];	
	
	//check that _dmg is a number
	private _strArr = _dmg splitString "";
	if (count (_strArr select {typeName _x != "SCALAR"}) >= 0) exitWith
	{
		["Damage has to be a number. No letters, spaces or other characters are allowed"] call Achilles_fnc_showZeusErrorMessage;
	}

	//apply ACE dmg
	[_unit, parseNumber _dmg, _bodyPart, _dmgType, _unit] call ace_medical_fnc_addDamageToUnit;
	//clean up
	deleteVehicle _logic;
};
[
	"Add ACE Damage to Unit", 
	[
		["COMBO","Body Part",[[0,1,2,3,4,5],["Head", "Body", "leg_l", "leg_r", "hand_l", "hand_r"],2]],
		["COMBO","Projectile Type",[[0,1,2,3,4,5,6,7,8,9,10,11,12,13],["falling", "ropeburn", "vehiclecrash", "collision", "unknown", "explosive", "grenade", "shell", "bullet", "backblast", "bite", "punch", "stab", "drowning"],0]]
		["SLIDER","Damage",0,5,0.6,1], //0 to 5, default 0.6 and showing 1 decimal
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
			["Projectile Type", ["falling", "ropeburn", "vehiclecrash", "collision", "unknown", "explosive", "grenade", "shell", "bullet", "backblast", "bite", "punch", "stab", "drowning"],0,true]
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
	}

	[_unit, parseNumber _dmg, _bodyPart, _dmgType, _unit] call ace_medical_fnc_addDamageToUnit;
	//clean up
	deleteVehicle _logic;
};