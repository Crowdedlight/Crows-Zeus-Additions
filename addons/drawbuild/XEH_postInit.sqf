#include "script_component.hpp"

// don't load for HC or server
if (!hasInterface) exitWith {};

// register zeus module
private _moduleList = [
        [localize "STR_CROWSZA_Drawbuild_module_name",{_this call FUNC(drawBuildZeus)}, QPATHTOF(data\drawbuild.paa)]
];

{
    [
        "Crows Zeus Modules", 
		(_x select 0), 
		(_x select 1), 
		(_x select 2)
    ] call zen_custom_modules_fnc_register;
} forEach _moduleList;


// Format - classname : [length, offset, rotation]
// TODO: include vertical offset (e.g., for trenches)
GVAR(drawBuildPresets) = createHashMapFromArray [
    ["Land_HBarrier_3_F", [3.45376, 1.7, 90]],                  // smaller hesco
    ["Land_HBarrier_Big_F", [8.5, 4.25, 90]],                   // large hesco 
    ["Land_BagFence_Short_F", [1.6, 0.7, 90]],                  // sandbags
    ["Land_SandbagBarricade_01_F", [1.7, 1.7, 90]],             // tall sandbags
    ["Land_ConcreteWall_01_m_4m_F", [4, 2, 90]],                // concrete wall
    ["Land_HBarrier_01_line_3_green_F", [3.45376, 1.7, 90]],    // smaller hesco - green
    ["Land_HBarrier_01_big_4_green_F", [8.5, 4.25, 90]],        // big hesco - green 
    ["Land_BagFence_01_short_green_F", [1.6, 0.7, 90]],         // sandbag wall - green
    ["Land_Mil_WallBig_4m_F", [4, 2, 90]],                      // military wall big
    ["Land_Fortress_01_5m_F", [10, 5, 90]],                     // land fortress wall 5m
    ["Land_Hedge_01_s_2m_F", [2, 0.5, 0]],                      // grass hedge
    ["Land_NetFence_02_m_4m_F", [4, 2, 90]],                    // net fence
    ["Land_New_WiredFence_5m_F", [5.20, 2.6, 90]],              // wired fence
    ["Land_Razorwire_F", [8.46, 4.20, 90]],                     // razorwire
    ["Land_TyreBarrier_01_line_x4_F", [2.6, 1.2, 90]],          // tire barrier
    ["PowerCable_01_StraightLong_F", [5.02368, 2.49, 0]],       // power cables
    ["BloodTrail_01_New_F", [12, 6, 0]],                        // blood trail
    ["Land_Sign_MinesDanger_Greek_F", [50, 25, 90]]             // minefield sign
];

if(isClass (configFile >> "CfgPatches" >> "UK3CB_BAF_Weapons")) then {
    GVAR(drawBuildPresets) set ["UK3CB_ModuleWPSmokeWhite81_F", [40, 20, 0]];
} else {
    GVAR(drawBuildPresets) set ["ModuleSmokeWhite_F", [15, 7.5, 0]];
};


if(isClass (configFile >> "CfgPatches" >> "grad_trenches_main")) then {
    GVAR(drawBuildPresets) set ["fort_envelopebig", [6, 3, 270]]; // trench
};
