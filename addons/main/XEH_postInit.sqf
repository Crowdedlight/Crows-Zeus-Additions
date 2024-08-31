#include "script_component.hpp"

// don't load for HC or server
if (!hasInterface) exitWith {

    // if HC, register in mission GVAR
    if(!isDedicated) then {
        [
            {
                //Race conditions?
                private _hcRegister = GETMVAR(GVAR(hcRegister),createHashMap);
                _hcRegister set [clientOwner, diag_fps];
                SETMVAR(GVAR(hcRegister),_hcRegister);
            },
            5
        ] call CBA_fnc_addPerFrameHandler;
    };
};

// globals to use if certain mods are loaded
GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(tfarLoaded) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(jshkLoaded) = isClass (configFile >> "CfgPatches" >> "JSHK_contam");
GVAR(amfHelicoptersLoaded) = isClass (configfile >> "CfgPatches" >> "AMF_Heli_Transport_01");
GVAR(rhsLoaded) = isClass (configfile >> "CfgPatches" >> "rhs_main");
GVAR(sogLoaded) = isClass (configfile >> "CfgMods" >> "vn");
GVAR(optreLoaded) = isClass (configfile >> "CfgMods" >> "OPTRE_Core");
GVAR(crowsEWLoaded) = isClass (configFile >> "CfgPatches" >> "crowsEW_main");

GVAR(zeiLoaded) = isClass (configfile >> "CfgPatches" >> "ZEI");
GVAR(lambsLoaded) = isClass (configfile >> "CfgPatches" >> "lambs_danger");
