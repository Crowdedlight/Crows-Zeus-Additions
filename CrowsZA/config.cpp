//imports & defines
#include "functions\common_defines.hpp"
//loadout gui include
#include "ui\loadoutGui.hpp"
#include "ui\drawbuildGui.hpp"

class CfgPatches
{
	class CrowsZA
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {
			"zen_context_menu",
			"zen_attributes"
		 };
		author = "Crowdedlight";
		authorUrl = "https://forums.bohemia.net/profile/1173289-crowdedlight/";
		version = 1.6.0;
		versionStr = "1.6.0";
		versionAr[] = {1,6,0};
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