#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fnc_suitcaseNukeZeus.sqf
Parameters: pos
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3]];

private _onConfirm =
{
    params ["_dialogResult","_in"];
    _in params [["_pos",[0,0,0],[[]],3]];
    _dialogResult params [
        "_countdownLength",
        "_effect",
        "_defuser",
        "_defuseTime",
        ["_code", "", [""]],
        ["_target", 0, [0]]
    ];

    private _device = "Land_MultiScreenComputer_01_black_F" createVehicle _pos;
    ["zen_common_updateEditableObjects", [[_device]]] call CBA_fnc_serverEvent;
    _device setVariable [QGVAR(suitcaseNuke_isArmed), true, true];


    // Timer code
    // TODO: move to server to avoid problems if zeus crashes?
    [_device, _countdownLength] spawn { 

        params ["_device","_countdownLength"]; 

        private "_activateTime";
        private "_countdownRemaining";
        // Not strictly needed, but makes it possible to test in SP!
        if(isMultiplayer) then {
            _activateTime = serverTime + _countdownLength;
            _countdownRemaining = _activateTime - serverTime;
        } else {
            _activateTime = time + _countdownLength;
            _countdownRemaining = _activateTime - time;
        };

        private "_countdownRemainingText";
        private _isArmed = true;
        while {alive _device and {_isArmed and {_countdownRemaining > 0}}} do { 
            
            _countdownRemainingText = [_countdownRemaining, "MM:SS"] call BIS_fnc_secondsToString; 
            { 
                _device setObjectTextureGlobal[_x, 
                    format ['#(rgb,512,512,3)text(0,1,"LCD14",0.3,"#171717","#eb4034","\n%1")', _countdownRemainingText]
                ]; 
            } forEach [1,2,3];

            if(isMultiplayer) then {
                _countdownRemaining = _activateTime - serverTime;
            } else {
                _countdownRemaining = _activateTime - time;
            };
            if(_countdownRemaining < 0) then { _countdownRemaining = 0; };

            _isArmed = _device getVariable [QGVAR(suitcaseNuke_isArmed), false];

            sleep 0.3; 
        };

        if(_isArmed) then {
            _device setDamage 1;
        };

        while {not isNull _device} do {
            // if(_countdownRemaining > 0) then {
                { 
                    _device setObjectTextureGlobal[_x, 
                        format ['#(rgb,512,512,3)text(0,1,"LCD14",0.3,"#171717","#eb4034","\n%1")', _countdownRemainingText]
                    ]; 
                } forEach [1,2,3];
            // } else {
            //     // TODO: make this customisable, or remove
            //     { 
            //         _device setObjectTextureGlobal[_x, 
            //             format ['#(rgb,512,512,3)text(0,1,"LucidaConsoleB",0.1,"#171717","#eb4034","\n\n\nGoodbye!!!")']
            //         ]; 
            //     } forEach [1,2,3];
            // };
            sleep 0.8;
            { 
                _device setObjectTextureGlobal[_x, 
                    '#(rgb,512,512,3)text(0,1,"LCD14",0.3,"#171717","#eb4034","")'
                ]; 
            } forEach [1,2,3];
            sleep 0.4;
        };
    };

    // Activation Code
    _device setVariable [QGVAR(suitcaseNuke_activate), _effect];
    _device setVariable [QGVAR(suitcaseNuke_code), _customCode];
    _device setVariable [QGVAR(suitcaseNuke_codeTarget), _target];
    _device addMPEventHandler ["MPKilled", {
        params ["_device"];
        if(isServer) then {
            switch(_device getVariable QGVAR(suitcaseNuke_activate)) do {
                case "explosive_small": {
                    private _explosive = createVehicle ["DemoCharge_Remote_Ammo_Scripted", getPosATL _device, [], 0, "CAN_COLLIDE"];
                    _explosive setDamage 1;
                    deleteVehicle _device;
                };
                case "explosive_large": {
                    private _explosive = createVehicle ["Bo_GBU12_LGB", getPosATL _device, [], 0, "CAN_COLLIDE"];
                    _explosive setDamage 1;
                    deleteVehicle _device;
                };
                case "explosive_nuke": {
                    ["zen_modules_moduleNuke", [ASLToAGL(getPosASL _unit), 200, 300, false]] call CBA_fnc_globalEvent;
                    deleteVehicle _device;
                };
                case "smoke_yellow": {
                    private _smoke = createVehicle ["SmokeShellYellow_Infinite", getPosATL _device, [], 0, "CAN_COLLIDE"];
                    hideObjectGlobal _smoke;
                    _device setVariable [QGVAR(suitcaseNuke_smoke), _smoke];
                    _smoke attachTo [_device];
                    _device addEventHandler ["Deleted", {
                        params ["_device"];
                        deleteVehicle (_device getVariable [QGVAR(suitcaseNuke_smoke), objNull]);
                    }];
                };
                default {};
            };
        };

        // private _customCode = _device getVariable [QGVAR(suitcaseNuke_code), ""];
        // if(_customCode isNotEqualTo "") then {
        //     private _codeTarget = _unit getVariable [QGVAR(suitcaseNuke_codeTarget), 0];

        //     if((_codeTarget == 0 and hasInterface) || {
        //         (_codeTarget == 1 and isServer) || {
        //         (_codeTarget == 2)}}
        //     ) then {
        //         [_device] call (compile _customCode);
        //     };
        // };
    }];


    // Defusal Code
    if(_defuser > 0) then {

        // TODO: with ace, also (optionally) require DefusalKit item
        private _ace = (isClass(configFile >> "CfgPatches" >> "ace_main"));
        private _condition = switch(true) do {
            case (_defuser == 1 and _ace) : { " and ([player] call ace_common_fnc_isEOD)" }; // EOD
            case (_defuser == 1 and !_ace) : { " and (player getUnitTrait ""ExplosiveSpecialist"")" }; // EOD
            case (_defuser == 2 and _ace) : { " and (([player] call ace_common_fnc_isEngineer) or ([player] call ace_common_fnc_isEOD)" }; // Engineer
            case (_defuser == 2 and !_ace) : { " and ((player getUnitTrait ""Engineer"") or (player getUnitTrait ""ExplosiveSpecialist""))" }; // Engineer
            default { "" }; // Anyone
        };


        [
            _device,
            "Defuse Device",
            "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
            "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
            format ["(_this distance _target < 3) and (alive _target) and _target getVariable [""crowsza_misc_suitcaseNuke_isArmed"", false]%1", _condition],
            "_caller distance _target < 3 and (alive _target) and _target getVariable [""crowsza_misc_suitcaseNuke_isArmed"", false]",
            {},
            {},
            {
                _target setVariable [QGVAR(suitcaseNuke_isArmed), false, true];
                if (isClass(configFile >> "CfgPatches" >> "crowsEW_sounds")) then {
                    [getPos _target, 200, "device_disarmed", 2] call crowsEW_sounds_fnc_playSoundPos;
                    [getPos _target, 200, "futuristic_machine_turn_off", 2] call crowsEW_sounds_fnc_playSoundPos;
                };
            },
            {},
            [],
            _defuseTime
        ] remoteExec ["BIS_fnc_holdActionAdd", [0, -2] select isDedicated, _device];
    };
};

private _controls = [
    // TODO: size of slider makes it very difficult to be precise - replace with (parsed) text?
    ["SLIDER", ["Timer", "How long until the device activates in MM:SS"], [1, 30*60, 5*60, {[_this, "MM:SS"] call BIS_fnc_secondsToString}]],
    ["COMBO", ["Effect", "What happens when the device activates"], [
        ["nothing", "explosive_small", "explosive_large", "explosive_nuke", "smoke_yellow"],
        ["Nothing", "Explosion (small)", "Explosion (large)", "Explosion (Nuclear)", "Smoke (Yellow)"],
        3
    ]],
    ["TOOLBOX",["Defusable", "Who can attempt to defuse the device"],[3, 1, 4, ["No-one", "Explosive Specialist", "Engineer", "Anyone"]]],
    ["SLIDER", ["Defuse Time", "How long does it take to defuse the device in MM:SS"], [1, 60, 10, {[_this, "MM:SS"] call BIS_fnc_secondsToString}]]

    // TODO: could remove the below and rely on a combination of this module + the OnDeath module
    // ["EDIT:CODE",["Custom Code", "Custom code to execute on unit's death"+endl+"Written at your own risk - if unsure, leave blank!"],["", {}, 5]],
    // ["TOOLBOX",["Code Target", "Which machine to run the custom code on"],[0, 1, 3, ["Clients", "Server", "Clients + Server"]]]
];


[
    "Suitcase Device",
    _controls,
    _onConfirm,
    {},
    _this
] call zen_dialog_fnc_create;