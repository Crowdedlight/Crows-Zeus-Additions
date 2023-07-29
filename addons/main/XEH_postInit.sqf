#include "script_component.hpp"

class zeusRegister { postInit = 1; };
// check how we did in ewar and adopt similar?


crowsZA_common_aceModLoaded = isClass (configFile >> "CfgPatches" >> "ace_main");
crowsZA_common_jshkModLoaded = isClass (configFile >> "CfgPatches" >> "JSHK_contam");
crowsZA_common_amfHelicoptersLoaded = isClass (configfile >> "CfgPatches" >> "AMF_Heli_Transport_01");
crowsZA_common_rhsLoaded = isClass (configfile >> "CfgPatches" >> "rhs_main");
crowsZA_common_sogLoaded = isClass (configfile >> "CfgMods" >> "vn");