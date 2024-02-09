#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fnc_modifySuitcaseNuke.sqf
Parameters: pos
Return: none

*///////////////////////////////////////////////
params [["_device", objNull, [objNull]]];

private _onConfirm = {
    params ["_dialogResult","_in"];
    _in params [["_device", objNull, [objNull]]];
    _dialogResult params [
        "_countdownLength",
        "_effect",
        "_armed"
    ];
    _countdownLength = round(_countdownLength) * 10;

    _device setVariable [QGVAR(suitcaseNuke_newCountdown), _countdownLength, true];
    _device setVariable [QGVAR(suitcaseNuke_activate), _effect, true];
    _device setVariable [QGVAR(suitcaseNuke_isArmed), _armed, true];
};


private _effects = [
    ["nothing", "explosive_small", "explosive_large", "explosive_nuke", "smoke_red", "smoke_yellow"],
    ["Nothing", "Explosion (Small)", "Explosion (Large)", "Explosion (Nuclear)", "Smoke (Red)", "Smoke (Yellow)"],
    2
];

if (EGVAR(main,crowsEWLoaded)) then {
    _effects#0 insert [1, ["emp"]];
    _effects#1 insert [1, ["EMP"]];
    _effects set [2,3];
};


_effects set [2, ((_effects#0) find (_device getVariable [QGVAR(suitcaseNuke_activate), 3]))];
// This will be inaccurate if there's a mismatch in who has crowsEW loaded


private _currentTimer = _device getVariable [QGVAR(suitcaseNuke_countdown), (5*60)];

private _controls = [
    // TODO: size of slider makes it very difficult to be precise - replace with (parsed) text?
    ["SLIDER", ["Timer", "How long until the device activates in MM:SS"], [1, (30*60)/10, _currentTimer/10, {[round(_this)*10, "MM:SS"] call BIS_fnc_secondsToString}]],
    ["COMBO", ["Effect", "What happens when the device activates"], _effects],
    ["TOOLBOX:YESNO",["Armed", "Is the device able to detonate"+endl+"(Pauses countdown)"],_device getVariable [QGVAR(suitcaseNuke_isArmed), true]]
];


[
    "Edit Suitcase Device",
    _controls,
    _onConfirm,
    {},
    _this
] call zen_dialog_fnc_create;
