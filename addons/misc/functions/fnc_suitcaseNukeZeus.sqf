#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fnc_suitcaseNukeZeus.sqf
Parameters: pos
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_device", objNull, [objNull]]];

if(isNull _device) then {
    [_pos] call FUNC(createSuitcaseNuke);
} else {
    private _isDevice = _device getVariable [QGVAR(suitcaseNuke_isArmed), nil];
    if(alive _device and !isNil "_isDevice") then {
        [_device] call FUNC(modifySuitcaseNuke);
    } else {
        hint localize "STR_CROWSZA_Misc_suitcaseNuke_error_zeusPlacement";
    };
};
