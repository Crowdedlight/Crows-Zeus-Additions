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