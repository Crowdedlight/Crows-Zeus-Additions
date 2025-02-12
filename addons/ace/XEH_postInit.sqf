#include "script_component.hpp"

// don't load for HC or server
if (!hasInterface) exitWith {};

// only load if ACE is loaded!
if (!EGVAR(main,aceLoaded)) exitWith {};

// zeus modules
private _moduleList = [
        [localize "STR_CROWSZA_ACE_module_add_damage",{_this call FUNC(aceDamageToUnit)}, QPATHTOF(data\sword.paa)],
        [localize "STR_CROWSZA_ACE_module_unconscious_toggle",{_this call FUNC(massUnconscious)}, "\z\ace\addons\zeus\UI\Icon_Module_Zeus_Unconscious_ca.paa"],
        [localize "STR_CROWSZA_ACE_module_capture_player",{_this call FUNC(capturePlayer)}, "\z\ace\addons\captives\UI\captive_ca.paa"],
        [localize "STR_CROWSZA_ACE_module_mass_surrender",{_this call FUNC(massSurrender)}, "\z\ace\addons\captives\UI\Surrender_ca.paa"],
        [localize "STR_CROWSZA_ACE_module_supply_vic",{_this call FUNC(setSupplyVehicle)}, QPATHTOF(data\rearmvehicle.paa)]
];

{
    [
        "Crows Zeus Modules", 
		(_x select 0), 
		(_x select 1), 
		(_x select 2)
    ] call zen_custom_modules_fnc_register;
} forEach _moduleList;

// register context actions
private _contextActionList = [
    // Action name, Display name, Icon and Icon colour, code, Condition to show, arguments, dynamic children, modifier functions
    [
        ["jshk_heal",localize "STR_CROWSZA_ACE_module_jshk","\z\ace\addons\medical_gui\ui\cross.paa", 
		{_hoveredEntity call FUNC(jshkHeal)}, 
		{_hoveredEntity isEqualType {} && {[_hoveredEntity] call EFUNC(main,isAliveManUnit) && EGVAR(main,aceLoaded) && EGVAR(main,jshkLoaded) && (_hoveredEntity getVariable ["ACE_isUnconscious", false]) == true}}] call zen_context_menu_fnc_createAction,
        ["HealUnits"],
        0
    ]
];
{
    [
        // action, parent path, priority
        (_x select 0), (_x select 1), (_x select 2)
    ] call zen_context_menu_fnc_addAction;
} forEach _contextActionList;