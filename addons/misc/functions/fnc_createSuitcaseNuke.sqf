#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fnc_createSuitcaseNuke.sqf
Parameters: pos
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3]];

private _onConfirm = {
    params ["_dialogResult","_in"];
    _in params [["_pos",[0,0,0],[[]],3]];
    _dialogResult params [
        "_countdownLength",
        "_effect",
        "_defuser",
        "_defuseTime"
    ];
    _countdownLength = round(_countdownLength) * 10;

    //TODO: make device customisable
    private _device = "Land_MultiScreenComputer_01_black_F" createVehicle _pos;
    ["zen_common_updateEditableObjects", [[_device]]] call CBA_fnc_serverEvent;
    _device setVariable [QGVAR(suitcaseNuke_isArmed), true, true];
    _device setVariable [QGVAR(suitcaseNuke_countdown), _countdownLength, true];

    // Countdown code
    [{
        params ["_args", "_handle"];
        _args params ["_device"];

        private _isArmed = _device getVariable [QGVAR(suitcaseNuke_isArmed), false];

        // If the device is active - i.e. armed and not triggered yet,
        // manage the countdown timer
        private _countdownRemaining = _device getVariable [QGVAR(suitcaseNuke_countdown), nil];
        if(isNil "_countdownRemaining") exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
            diag_log "CrowsZA-suitcaseNuke: device has no set countdown";
        };


        // Check if the countdown has been MODIFIED since last frame
        private _newCountdown = _device getVariable [QGVAR(suitcaseNuke_newCountdown), nil];
        if(!isNil "_newCountdown") then {
            _countdownRemaining = _newCountdown;
            _device setVariable [QGVAR(suitcaseNuke_newCountdown), nil, true];
            _device setVariable [QGVAR(suitcaseNuke_countdown), _countdownRemaining, true];
        };

        if(alive _device and _isArmed) then {

            // Not strictly needed, but makes it possible to test in singleplayer
            private _time = [{time}, {serverTime}] select isMultiplayer;

            // If this code is 'locked' to the zeus's client, serverTime isn't needed
            // But if other zeuses can modify the device, best to sync with serverTime
            private _deltaTime = (call _time) - (_device getVariable [QGVAR(suitcaseNuke_time), (call _time)]);
            _device setVariable [QGVAR(suitcaseNuke_time), (call _time), true];

            _countdownRemaining = _countdownRemaining - _deltaTime;
            if(_countdownRemaining < 0) then { _countdownRemaining = 0; };
            _device setVariable [QGVAR(suitcaseNuke_countdown), _countdownRemaining, true];

            // If the timer hits 0, trigger the device
            if(_countdownRemaining <= 0) then {
                _device setDamage 1;
            };
        };

        // Add a flipflop to add some syncopation to the flashing message
        private _flipFlop = (_device getVariable [QGVAR(suitcaseNuke_countdownFlipFlop), 0]);
        private _deviceText = " ";
        if(_flipFlop < 3) then {
            if(_countdownRemaining >= (60*60)) then {
                _deviceText = [_countdownRemaining, "HH:MM:SS"] call BIS_fnc_secondsToString;
            } else {
                _deviceText = [_countdownRemaining, "MM:SS"] call BIS_fnc_secondsToString;
            };
        };

        // Set texture of each screen
        { 
            _device setObjectTextureGlobal[_x, 
                format ['#(rgb,512,512,3)text(0,1,"LCD14",0.3,"#171717","#eb4034","\n%1")', _deviceText]
            ]; 
        } forEach [1,2,3];
        
        // If the device has been disarmed (or triggered), flash the countdown on and off
        if(!alive _device || !_isArmed) then {
            _device setVariable [QGVAR(suitcaseNuke_countdownFlipFlop), (_flipFlop+1)%4, true];
        } else {
            // In case device is re-armed while flipFlop=3
            _device setVariable [QGVAR(suitcaseNuke_countdownFlipFlop), 0, true];
        };
        

        // If the device is deleted, remove this EH
        if(isNull _device) then {
            _handle call CBA_fnc_removePerFrameHandler;
        };

    }, 0.3, [_device]] call CBA_fnc_addPerFrameHandler;


    // Activation Code
    _device setVariable [QGVAR(suitcaseNuke_activate), _effect, true];
    _device addMPEventHandler ["MPKilled", {
        params ["_device"];
        if(isServer) then {
            switch(_device getVariable QGVAR(suitcaseNuke_activate)) do {
                case "emp": {
                    if (isClass (configFile >> "CfgPatches" >> "crowsEW_main")) then {
                        [getPos _device, _device, 500, false, 1, 1] call EMFUNC(crowsEW,emp,fireEMP);
                    } else {
                        diag_log "CrowsZA-suitcaseNuke: Zeus has CrowsEW loaded, but the server does not!";
                    };
                };
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
                    ["zen_modules_moduleNuke", [ASLToAGL(getPosASL _device), 200, 300, false]] call CBA_fnc_globalEvent;
                    deleteVehicle _device;
                };
                case "smoke_red": {
                    private _smoke = createVehicle ["SmokeShellRed_Infinite", getPosATL _device, [], 0, "CAN_COLLIDE"];
                    hideObjectGlobal _smoke;
                    _device setVariable [QGVAR(suitcaseNuke_smoke), _smoke, true];
                    _smoke attachTo [_device];
                    _device addEventHandler ["Deleted", {
                        params ["_device"];
                        deleteVehicle (_device getVariable [QGVAR(suitcaseNuke_smoke), objNull]);
                    }];
                };
                case "smoke_yellow": {
                    private _smoke = createVehicle ["SmokeShellYellow_Infinite", getPosATL _device, [], 0, "CAN_COLLIDE"];
                    hideObjectGlobal _smoke;
                    _device setVariable [QGVAR(suitcaseNuke_smoke), _smoke, true];
                    _smoke attachTo [_device];
                    _device addEventHandler ["Deleted", {
                        params ["_device"];
                        deleteVehicle (_device getVariable [QGVAR(suitcaseNuke_smoke), objNull]);
                    }];
                };
                default {};
            };
        };
    }];


    // Defusal Code
    if(_defuser > 0) then {

        // TODO: with ace, also (optionally) require DefusalKit item
        private _ace = EGVAR(main,aceLoaded);
        private _defuserCondition = switch(true) do {
            case (_defuser == 1 and _ace) : { QUOTE(([player] call EMFUNC(ace,common,isEOD))) }; // ace EOD
            case (_defuser == 1 and !_ace) : { QUOTE((player getUnitTrait QQUOTE(ExplosiveSpecialist))) }; // EOD
            case (_defuser == 2 and _ace) : { QUOTE((([player] call EMFUNC(ace,common,isEngineer)) or ([player] call EMFUNC(ace,common,isEOD)))) }; // ace Engineer
            case (_defuser == 2 and !_ace) : { QUOTE(((player getUnitTrait QQUOTE(Engineer)) or (player getUnitTrait QQUOTE(ExplosiveSpecialist)))) }; // Engineer
            default { QUOTE(true) }; // Anyone
        };


        [
            _device,
            localize "STR_CROWSZA_Misc_suitcaseNuke_defuse",
            "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
            "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
            format ["%1 and %2", QUOTE(ARR_2((_this distance _target < 3) and (alive _target) and (_target getVariable [QQGVAR(suitcaseNuke_isArmed),false]))), _defuserCondition],
            QUOTE(ARR_2(_caller distance _target < 3 and (alive _target) and (_target getVariable [QQGVAR(suitcaseNuke_isArmed),false]))),
            {},
            {},
            {
                _target setVariable [QGVAR(suitcaseNuke_isArmed), false, true];
                if (isClass (configFile >> "CfgPatches" >> "crowsEW_main")) then {
                    [getPosASL _target, 200, "device_disarmed", 2] call EMFUNC(crowsEW,sounds,playSoundPos);
                    [getPosASL _target, 200, "futuristic_machine_turn_off", 2] call EMFUNC(crowsEW,sounds,playSoundPos);
                };
            },
            {},
            [],
            _defuseTime
        ] remoteExec ["BIS_fnc_holdActionAdd", [0, -2] select isDedicated, _device];
    };
};


private _effects = [
    ["nothing", "explosive_small", "explosive_large", "explosive_nuke", "smoke_red", "smoke_yellow"],
    [
        localize "STR_CROWSZA_Misc_suitcaseNuke_effect_none",
        localize "STR_CROWSZA_Misc_suitcaseNuke_effect_explosion_small",
        localize "STR_CROWSZA_Misc_suitcaseNuke_effect_explosion_large",
        localize "STR_CROWSZA_Misc_suitcaseNuke_effect_explosion_nuclear",
        localize "STR_CROWSZA_Misc_suitcaseNuke_effect_smoke_red",
        localize "STR_CROWSZA_Misc_suitcaseNuke_effect_smoke_yellow"
    ],
    2
];

if (EGVAR(main,crowsEWLoaded)) then {
    _effects#0 insert [1, ["emp"]];
    _effects#1 insert [1, [localize "STR_CROWSZA_Misc_suitcaseNuke_effect_emp"]];
    _effects set [2,3];
};

private _controls = [
    // TODO: replace slider with editbox?
    ["SLIDER", [localize "STR_CROWSZA_Misc_suitcaseNuke_timer", localize "STR_CROWSZA_Misc_suitcaseNuke_timer_tooltip"], [1, (30*60)/10, (5*60)/10, {[round(_this)*10, "MM:SS"] call BIS_fnc_secondsToString}]],
    ["COMBO", [localize "STR_CROWSZA_Misc_suitcaseNuke_effect", localize "STR_CROWSZA_Misc_suitcaseNuke_effect_tooltip"], _effects],
    ["TOOLBOX",[localize "STR_CROWSZA_Misc_suitcaseNuke_defuseable", localize "STR_CROWSZA_Misc_suitcaseNuke_defuseable_tooltip"],[3, 1, 4, 
        [
            localize "STR_CROWSZA_Misc_suitcaseNuke_defuseable_noone",
            localize "STR_CROWSZA_Misc_suitcaseNuke_defuseable_specialist",
            localize "STR_CROWSZA_Misc_suitcaseNuke_defuseable_engineer",
            localize "STR_CROWSZA_Misc_suitcaseNuke_defuseable_any"
        ]]],
    ["SLIDER", [localize "STR_CROWSZA_Misc_suitcaseNuke_defusetimer", localize "STR_CROWSZA_Misc_suitcaseNuke_defusetimer_tooltip"], [1, 60, 10, {[_this, "MM:SS"] call BIS_fnc_secondsToString}]]
];


[
    localize "STR_CROWSZA_Misc_suitcaseNuke_defuse",
    _controls,
    _onConfirm,
    {},
    _this
] call zen_dialog_fnc_create;
