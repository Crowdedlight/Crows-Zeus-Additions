#include "script_component.hpp"

// don't load for HC or server
if (!hasInterface) exitWith {};

// globals to use if certain mods are loaded
GVAR(aceLoaded) = isClass (configFile >> "CfgPatches" >> "ace_main");
GVAR(tfarLoaded) = isClass (configFile >> "CfgPatches" >> "task_force_radio");
GVAR(jshkLoaded) = isClass (configFile >> "CfgPatches" >> "JSHK_contam");
GVAR(amfHelicoptersLoaded) = isClass (configFile >> "CfgPatches" >> "AMF_Heli_Transport_01");
GVAR(rhsLoaded) = isClass (configFile >> "CfgPatches" >> "rhs_main");
GVAR(sogLoaded) = isClass (configFile >> "CfgMods" >> "vn");
GVAR(optreLoaded) = isClass (configFile >> "CfgMods" >> "OPTRE_Core");
GVAR(crowsEWLoaded) = isClass (configFile >> "CfgPatches" >> "crowsEW_main");
GVAR(wsLoaded) = isClass (configFile >> "CfgMods" >> "ws");
GVAR(speLoaded) = isClass (configFile >> "CfgMods" >> "spe");