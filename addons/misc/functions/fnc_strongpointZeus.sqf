#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fn_strongpointZeus.sqf
Parameters: pos, unit
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if(isNull _unit) exitWith { hint parseText (localize "STR_CROWSZA_Misc_strongpoint_error_no_unit"); }; //TODO: alternatively, add dropdown(s) with all compositions


private _controls = [];

// _controls append [
//     ["COMBO", "Side", [["west"], [["BLUFOR", "", "\A3\ui_f\data\map\markers\nato\b_unknown.paa"]], 0]],
//     ["COMBO", "Faction", [["1"], [["Gendarmerie"]], 0]],
//     ["COMBO", "Composition", [["1"], [["Gendarmerie Patrol", "", "\A3\ui_f\data\map\markers\nato\b_inf.paa"]], 0]]
// ];

_controls append [
    ["SLIDER:RADIUS", localize "STR_CROWSZA_Misc_strongpoint_radius", [20, 500, 200, 0, ASLtoAGL _pos, [1, 0, 0, 0.7]]],
    ["SLIDER", [localize "STR_CROWSZA_Misc_strongpoint_ui_strongpoints", localize "STR_CROWSZA_Misc_strongpoint_ui_strongpoints_tooltip"], [1, 20, 6, 0]],
    ["SLIDER:PERCENT", [localize "STR_CROWSZA_Misc_strongpoint_ui_fill", localize "STR_CROWSZA_Misc_strongpoint_ui_fill_tooltip"], [0.1, 1, 0.8, 0]],
    //["SLIDER:PERCENT", [localize "STR_CROWSZA_Misc_strongpoint_ui_dispersion", localize "STR_CROWSZA_Misc_strongpoint_ui_dispersion_tooltip"], [0, 1, 0.8, 0]],
    ["CHECKBOX", [localize "STR_CROWSZA_Misc_strongpoint_ui_sandbags", localize "STR_CROWSZA_Misc_strongpoint_ui_sandbags_tooltip"], true],
    ["SLIDER", [localize "STR_CROWSZA_Misc_strongpoint_ui_patrol", localize "STR_CROWSZA_Misc_strongpoint_ui_patrol_tooltip"], [0, 6, 2, 0]]
];

if(!EGVAR(main,zeiLoaded)) then {
    _controls deleteAt 3;
};


[
    localize "STR_CROWSZA_Misc_strongpoint",
    _controls,
    FUNC(strongpoint),
    {},
    _this
] call zen_dialog_fnc_create;