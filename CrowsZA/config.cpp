//imports & defines
#include "functions\common_defines.hpp"
//loadout gui include
#include "ui\loadoutGui.hpp"

class CfgPatches
{
	class CrowsZA
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = { 
			"ace_medical_engine",
			"zen_context_menu",
			"zen_attributes"
		 };
		author = "Crowdedlight";
		authorUrl = "https://forums.bohemia.net/profile/1173289-crowdedlight/";
		version = 1.2.0;
		versionStr = "1.2.0";
		versionAr[] = {1,2,0};
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
class CfgFunctions
{
	#include "\CrowsZA\cfgFunctions.hpp"
};