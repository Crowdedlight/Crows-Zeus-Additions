#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric

File: fnc_onDeathZeus.sqf
Parameters: pos, unit
Return: none

Activates one or more configurable effects when the passed unit (or object) dies

*///////////////////////////////////////////////



params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if(isNull _unit) exitWith { hint (localize "STR_CROWSZA_Misc_onkilled_error_unit"); };

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

    if (EGVAR(main,crowsEWLoaded)) then {
        _expectedParams insert [5, ["_emp", "_sound_killer", "_sound_all"]];
    };

    _dialogResult params _expectedParams;
    _in params ["_pos", ["_unit",objNull,[objNull]]];

    if(isNull _unit) exitWith {
        hint (localize "STR_CROWSZA_Misc_onkilled_error_hint");
        diag_log "CrowsZA-onDeathZeus: unit became null after selection somehow";
    };

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
    ) exitWith { hint (localize "STR_CROWSZA_Misc_onkilled_error_null") };


    private _unitList = GETMVAR(GVAR(OnKilledModuleUnits),[]);
    _unitList pushBackUnique _unit;
    SETMVAR(GVAR(OnKilledModuleUnits),_unitList);

    _unit setVariable [QGVAR(onDeath_hintKiller), _hint_killer, true];
    _unit setVariable [QGVAR(onDeath_hintAll), _hint_all, true];
    _unit setVariable [QGVAR(onDeath_hintZeus), _hint_zeus, true];
    _unit setVariable [QGVAR(onDeath_deleteRemains), _deleteRemains, true];
    _unit setVariable [QGVAR(onDeath_explosion), _explosion, true];
    _unit setVariable [QGVAR(onDeath_emp), _emp, true];
    _unit setVariable [QGVAR(onDeath_soundKiller), _sound_killer, true];
    _unit setVariable [QGVAR(onDeath_soundAll), _sound_all, true];
    _unit setVariable [QGVAR(onDeath_customCode), _customCode, true];
    _unit setVariable [QGVAR(onDeath_codeTarget), _codeTarget, true];

    // If the EH is being overwritten (i.e. the module has been applied already), remove the old one first
    private _ehIndex = _unit getVariable [QGVAR(OnKilledModuleEHIndex), nil];
    if(!isNil "_ehIndex") then {
        _unit removeMPEventHandler ["MPKilled", _ehIndex];
    };

    _ehIndex = _unit addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer", "_instigator", "_useEffects"];

        private _crowsEWLoaded = isClass (configFile >> "CfgPatches" >> "crowsEW_main");

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

        if (_crowsEWLoaded) then {
            private _sound = (_unit getVariable [QGVAR(onDeath_soundKiller), ""]);
            if(_sound isNotEqualTo "" and player isEqualTo _killer) then {
                [getPosASL _unit, 100, _sound, 1, true] call EMFUNC(crowsEW,sounds,playSoundPos);
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

            private _unitList = GETMVAR(GVAR(OnKilledModuleUnits),[]);
            SETMVAR(GVAR(OnKilledModuleUnits),_unitList-[_unit]);

            switch(_unit getVariable [QGVAR(onDeath_explosion), 0]) do {
                case 1: { private _ied = createVehicle ["DemoCharge_Remote_Ammo_Scripted", getPosATL _unit, [], 0, "CAN_COLLIDE"]; _ied setDamage 1; };
                case 2: { private _ied = createVehicle ["Bo_GBU12_LGB", getPosATL _unit, [], 0, "CAN_COLLIDE"]; _ied setDamage 1; };
                case 3: { ["zen_modules_moduleNuke", [ASLToAGL(getPosASL _unit), 200, 300, false]] call CBA_fnc_globalEvent; };
                default {};
            };

            if (_crowsEWLoaded) then {

                if(_unit getVariable [QGVAR(onDeath_emp), false]) then {
                    [QUOTE(crowsew_emp_eventFireEMP), [getPosASL _unit, _unit, 500, false, 1, 1]] call CBA_fnc_serverEvent;
                };

                private _sound = (_unit getVariable [QGVAR(onDeath_soundAll), ""]);
                if(_sound isNotEqualTo "") then {
                    [getPosASL _unit, 100, _sound, 2] call EMFUNC(crowsEW,sounds,playSoundPos);
                };
            };

            if(_unit getVariable [QGVAR(onDeath_deleteRemains), false]) then {
                deleteVehicle _unit;
            };
        };
    }];

    _unit setVariable [QGVAR(OnKilledModuleEHIndex), _ehIndex, true];


    // Clean up the global array if the unit is deleted without being killed
    [_unit, ["Deleted", {
        params ["_unit"];
        private _unitList = GETMVAR(GVAR(OnKilledModuleUnits),[]);
        SETMVAR(GVAR(OnKilledModuleUnits),_unitList-[_unit]);
    }]] remoteExec ["addEventHandler", 2];
};



private _options = [];
_options append [
    ["EDIT",[localize "STR_CROWSZA_Misc_onkilled_hint_killer",localize "STR_CROWSZA_Misc_onkilled_hint_killer_tooltip"],["", {}, 1]],
    ["EDIT",[localize "STR_CROWSZA_Misc_onkilled_hint_all",localize "STR_CROWSZA_Misc_onkilled_hint_all_tooltip"],["", {}, 1]],
    ["EDIT",[localize "STR_CROWSZA_Misc_onkilled_hint_zeus",localize "STR_CROWSZA_Misc_onkilled_hint_zeus_tooltip"],["", {}, 1]],
    ["CHECKBOX",[localize "STR_CROWSZA_Misc_onkilled_delete_remains",localize "STR_CROWSZA_Misc_onkilled_hint_delete_remains_tooltip"],[false]],
    ["COMBO",[localize "STR_CROWSZA_Misc_onkilled_explosion",localize "STR_CROWSZA_Misc_onkilled_hint_explosion_tooltip"],[[0, 1, 2, 3],[
        localize "STR_CROWSZA_Misc_onkilled_explosion_none",
        localize "STR_CROWSZA_Misc_onkilled_explosion_small",
        localize "STR_CROWSZA_Misc_onkilled_explosion_large",
        localize "STR_CROWSZA_Misc_onkilled_explosion_nuclear"
    ], 0]]
];

if (EGVAR(main,crowsEWLoaded)) then {
    private _sounds = [""];
    private _soundNames = ["None"];
    {
        _sounds pushBack _x;
        _soundNames pushBack (EMGVAR(crowsEW,sounds,soundAttributes) get _x)#2;
    } forEach ([(keys EMGVAR(crowsEW,sounds,soundAttributes)), [], { (EMGVAR(crowsEW,sounds,soundAttributes) get _x)#2 }] call BIS_fnc_sortBy);

    _options append [
        ["CHECKBOX",[localize "STR_CROWSZA_Misc_onkilled_emp",(localize "STR_CROWSZA_Misc_onkilled_emp_tooltip") regexReplace ["<br/>",endl]],[false]],
        ["COMBO",[localize "STR_CROWSZA_Misc_onkilled_sound_killer",localize "STR_CROWSZA_Misc_onkilled_sound_killer_tooltip"],[_sounds, _soundNames, 0]],
        ["COMBO",[localize "STR_CROWSZA_Misc_onkilled_sound_all",localize "STR_CROWSZA_Misc_onkilled_sound_all_tooltip"],[_sounds, _soundNames, 0]]
    ];
};

_options append [
    ["EDIT:CODE",[localize "STR_CROWSZA_Misc_onkilled_customcode",(localize "STR_CROWSZA_Misc_onkilled_customcode_tooltip") regexReplace ["<br/>",endl]],["", {}, 5]],
    ["TOOLBOX",[localize "STR_CROWSZA_Misc_onkilled_codetarget",localize "STR_CROWSZA_Misc_onkilled_codetarget_tooltip"],[0, 1, 3, [
        localize "STR_CROWSZA_Misc_onkilled_codetarget_client",
        localize "STR_CROWSZA_Misc_onkilled_codetarget_server",
        localize "STR_CROWSZA_Misc_onkilled_codetarget_clientserver"
    ]]]
];

[
    localize "STR_CROWSZA_Misc_onkilled", 
    _options,
    _onConfirm,
    {},
    _this
] call zen_dialog_fnc_create;
