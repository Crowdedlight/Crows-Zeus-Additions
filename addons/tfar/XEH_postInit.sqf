#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// only load if ACE is loaded!
if (!EGVAR(main,tfarLoaded)) exitWith {};

// zeus modules
private _moduleList = [
	[localize "STR_CROWSZA_tfar_radio_side",{_this call FUNC(tfarSetVehicleSide)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
];

{
    [
        "Crows Zeus Modules", 
		(_x select 0), 
		(_x select 1), 
		(_x select 2)
    ] call zen_custom_modules_fnc_register;
} forEach _moduleList;
