class CrowsZA_addon
{
	tag = "crowsZA";
	class CrowsZeusAdditions
	{
		file = "\CrowsZA\functions";
		class registerSettingsCBA { preInit = 1; };
		class zeusRegister { postInit = 1; };

		class showHint {};

		class aceDamageToUnit {};

		class removeTreesZeus {};
		class removeTrees {};

		class restoreTreesZeus {};
		class restoreTrees {};

		class animalFollowZeus {};
		class animalFollow {};
		class deleteAllAnimalFollow {};

		class scatterTeleportZeus {};
		class scatterTeleport {};

		class scatterPatternOutwardSpiral {};
		class scatterPatternLine {};
		class scatterPatternOddPattern {};

		class teleportToSquadMember {};

		// class scatterTeleportWithParachute {};

		class setNumberplate {};

		class deleteAllDead {};

		class centerZeusViewUnit {};

		class massSurrender {};
		
		class massUnconscious {};
		
		class capturePlayer {}; 

		class spawnArsenal {};

		class setColour {};

		class contextPasteLoadout {};
		
		class loadoutViewer {};
		class loadoutRefresh {};

		class radiusHeal {};
		class radiusHealDialog {};

		class setSupplyVehicle {};
		
		class fireSupport {};

		class resupplyPlayerLoadouts {};
		class spawnSupplyDrop {};

		// draw building and helper functions
		class getPosFromMouse {};
		class drawBuildSelectPosition {};
		class drawBuildZeus {};
		class drawBuild {};

		// TFAR related 
		class tfarSetVehicleSide {};

		// jshk heal for ACE while its broken
		class jshkHeal {};
		class isAliveManUnit {};

		// PINGBOX 
		class enablePingBoxHUD {};
		class disablePingBoxHUD {};
		class refreshPingBoxHUD {};
		class addEntryPingBoxHUD {};

		// Remove Radio/Bino
		class removeRadioBino {};
	};
};