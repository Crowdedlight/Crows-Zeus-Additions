#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "zen_main", "zen_context_menu", "zen_custom_modules", "zen_attributes"};
        author = "Crowdedlight";
        authorUrl = "https://forums.bohemia.net/profile/1173289-crowdedlight/";
        VERSION_CONFIG;
    };
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class CrowsZA_cat: NO_CATEGORY
	{
		displayName = "Crows Zeus Additions";
	};
};

PRELOAD_ADDONS;

#include "CfgEventhandlers.hpp"
