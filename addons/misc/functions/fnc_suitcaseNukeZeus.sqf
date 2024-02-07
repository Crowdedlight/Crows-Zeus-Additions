#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fnc_suitcaseNukeZeus.sqf
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
        "_defuseTime",
        ["_code", "", [""]],
        ["_target", 0, [0]]
    ];
    _countdownLength = round(_countdownLength) * 10;

    private _device = "Land_MultiScreenComputer_01_black_F" createVehicle _pos;
    ["zen_common_updateEditableObjects", [[_device]]] call CBA_fnc_serverEvent;
    _device setVariable [QGVAR(suitcaseNuke_isArmed), true];


    // Countdown code
    [{
        params ["_args", "_handle"];
        _args params ["_device", "_activateTime"];

        private _isArmed = _device getVariable [QGVAR(suitcaseNuke_isArmed), false];

        // If the device is active - i.e. armed and not triggered yet,
        // manage the countdown timer
        if(alive _device and _isArmed) then {

            // If this code is 'locked' to the zeus's client, serverTime isn't needed
            private _countdownRemaining = _activateTime - time;
            if(_countdownRemaining < 0) then { _countdownRemaining = 0; };

            // Store the countdown clock so we can continue to display it if disarmed
            if(_countdownRemaining >= (60*60)) then {
                _device setVariable [QGVAR(suitcaseNuke_timer), ([_countdownRemaining, "HH:MM:SS"] call BIS_fnc_secondsToString)];
            } else {
                _device setVariable [QGVAR(suitcaseNuke_timer), ([_countdownRemaining, "MM:SS"] call BIS_fnc_secondsToString)];
            };

            // If the timer hits 0, trigger the device
            if(_countdownRemaining <= 0) then {
                _device setDamage 1;
            };
        };

        // Add a flipflop to add some syncopation to the flashing message
        private _flipFlop = (_device getVariable [QGVAR(suitcaseNuke_timerFlipFlop), 0]);
        private _deviceText = "";
        if(_flipFlop < 3) then {
            _deviceText = _device getVariable QGVAR(suitcaseNuke_timer)
        };

        // Set texture of each screen
        { 
            _device setObjectTextureGlobal[_x, 
                format ['#(rgb,512,512,3)text(0,1,"LCD14",0.3,"#171717","#eb4034","\n%1")', _deviceText]
            ]; 
        } forEach [1,2,3];
        
        // If the device has been disarmed (or triggered), flash the countdown on and off
        if(!alive _device || !_isArmed) then {
            _device setVariable [QGVAR(suitcaseNuke_timerFlipFlop), (_flipFlop+1)%4];
        };
        

        // If the device is deleted, remove this EH
        if(isNull _device) then {
            _handle call CBA_fnc_removePerFrameHandler;
        };

    }, 0.3, [_device, time + _countdownLength]] call CBA_fnc_addPerFrameHandler;


    // Activation Code
    _device setVariable [QGVAR(suitcaseNuke_activate), _effect];
    _device setVariable [QGVAR(suitcaseNuke_code), _customCode];
    _device setVariable [QGVAR(suitcaseNuke_codeTarget), _target];
    _device addMPEventHandler ["MPKilled", {
        params ["_device"];
        if(isServer) then {
            switch(_device getVariable QGVAR(suitcaseNuke_activate)) do {
                case "emp": {
                    if (EGVAR(main,crowsEWLoaded)) then {
                        [getPos _device, _device, 500, false, 1, 1] call EMFUNC(crowsEW,emp,fireEMP);
                    } else {
                        diag_log "CrowsZA-suitcaseNuke: zeus has crowsEW installed but the server does not";
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
                    _device setVariable [QGVAR(suitcaseNuke_smoke), _smoke];
                    _smoke attachTo [_device];
                    _device addEventHandler ["Deleted", {
                        params ["_device"];
                        deleteVehicle (_device getVariable [QGVAR(suitcaseNuke_smoke), objNull]);
                    }];
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
    }];


    // Defusal Code
    if(_defuser > 0) then {

        // TODO: with ace, also (optionally) require DefusalKit item
        private _ace = EGVAR(main,aceLoaded);
        private _defuserCondition = switch(true) do {
            case (_defuser == 1 and _ace) : { QUOTE( ([player] call EMFUNC(ace,common,isEOD))) }; // ace EOD
            case (_defuser == 1 and !_ace) : { QUOTE( (player getUnitTrait QQUOTE(ExplosiveSpecialist))) }; // EOD
            case (_defuser == 2 and _ace) : { QUOTE( (([player] call EMFUNC(ace,common,isEngineer)) or ([player] call EMFUNC(ace,common,isEOD)))) }; // ace Engineer
            case (_defuser == 2 and !_ace) : { QUOTE( ((player getUnitTrait QQUOTE(Engineer)) or (player getUnitTrait QQUOTE(ExplosiveSpecialist)))) }; // Engineer
            default { QUOTE(true) }; // Anyone
        };


        [
            _device,
            "Defuse Device",
            "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
            "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
            format ["%1 and %2", QUOTE((_this distance _target < 3) and (alive _target) and (_target getVariable [QQGVAR(suitcaseNuke_isArmed) COMMA false])), _defuserCondition],
            QUOTE(_caller distance _target < 3 and (alive _target) and (_target getVariable [QQGVAR(suitcaseNuke_isArmed) COMMA false])),
            {},
            {},
            {
                _target setVariable [QGVAR(suitcaseNuke_isArmed), false, true];
                if (EGVAR(main,crowsEWLoaded)) then {
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
    ["Nothing", "Explosion (Small)", "Explosion (Large)", "Explosion (Nuclear)", "Smoke (Red)", "Smoke (Yellow)"],
    3
];

if (EGVAR(main,crowsEWLoaded)) then {
    _effects#0 insert [1, ["emp"]];
    _effects#1 insert [1, ["EMP"]];
};

private _controls = [
    // TODO: size of slider makes it very difficult to be precise - replace with (parsed) text?
    ["SLIDER", ["Timer", "How long until the device activates in MM:SS"], [1, (30*60)/10, (5*60)/10, {[round(_this)*10, "MM:SS"] call BIS_fnc_secondsToString}]],
    ["COMBO", ["Effect", "What happens when the device activates"], _effects],
    ["TOOLBOX",["Defusable", "Who can attempt to defuse the device"],[3, 1, 4, ["No-one", "Explosive Specialists", "Engineers", "Anyone"]]],
    ["SLIDER", ["Defuse Time", "How long does it take to defuse the device in MM:SS"], [1, 60, 10, {[_this, "MM:SS"] call BIS_fnc_secondsToString}]]
];


[
    "Suitcase Device",
    _controls,
    _onConfirm,
    {},
    _this
] call zen_dialog_fnc_create;
