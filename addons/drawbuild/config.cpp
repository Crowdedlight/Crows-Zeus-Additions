#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"crowsza_main"};
        author = "Crowdedlight";
        VERSION_CONFIG;
    };
};

#include "CfgEventhandlers.hpp"
