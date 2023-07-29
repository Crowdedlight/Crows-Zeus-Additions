#include "script_component.hpp"

GVAR(ace_loaded) = isClass (configFile >> "CfgPatches" >> "ace_main");

// only load if ACE is loaded!
if (!ace_loaded) exitWith {};

// zeus modules
private _moduleList = [
        ["ACE Add Damage to Unit",{_this call FUNC(aceDamageToUnit)}, QPATHTOF(data\sword.paa)],
        ["Mass-Unconscious Toggle",{_this call FUNC(massUnconscious)}, "\z\ace\addons\zeus\UI\Icon_Module_Zeus_Unconscious_ca.paa"],
        ["Capture Player",{_this call FUNC(capturePlayer)}, "\z\ace\addons\captives\UI\captive_ca.paa"],
        ["Mass-Surrender Toggle",{_this call FUNC(massSurrender)}, "\z\ace\addons\captives\UI\Surrender_ca.paa"],
        ["Set Supply Vehicle",{_this call FUNC(setSupplyVehicle)}, QPATHTOF(data\rearmvehicle.paa)]
];

{
    [
        "Crows Zeus Modules", 
		(_x select 0), 
		(_x select 1), 
		(_x select 2)
    ] call zen_custom_modules_fnc_register;
} forEach _moduleList;