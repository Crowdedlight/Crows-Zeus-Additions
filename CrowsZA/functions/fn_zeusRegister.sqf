/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_zeusRegister.sqf
Parameters: none
Return: none

Using the same setup method as JShock in JSHK contamination mod. 

*///////////////////////////////////////////////

// check for zen 
private _hasZen = isClass (configFile >> "CfgPatches" >> "zen_custom_modules");
if !(_hasZen) exitWith
{
	diag_log "******CBA and/or ZEN not detected. They are required for Crows Zeus Additions.";
};

//only load for zeus
if (!hasInterface) exitWith {};

//private global var
crowsZA_animalFollowList = [];
publicVariable "crowsZA_animalFollowList";
crowsZA_common_selectPositionActive = false;

private _loadedMods = getLoadedModsInfo;
//spawn script to register zen modules
private _wait = [player,_loadedMods] spawn
{
	params ["_unit","_loadedMods"];
	private _timeout = 0;
	waitUntil 
	{
		if (_timeout >= 10) exitWith 
		{
			diag_log "CrowZA:fn_zeusRegister: Timed out!!!";
			true;
		};
		sleep 1;
		_timeout = _timeout + 1;
		if (count allCurators == 0 || {!isNull (getAssignedCuratorLogic _unit)}) exitWith {true};
		false;
	};
	 
	// save ace loaded variable as public var. So context menu check just needs to check var
	crowsZA_common_aceModLoaded = isClass (configFile >> "CfgPatches" >> "ace_main");
	crowsZA_common_jshkModLoaded = isClass (configFile >> "CfgPatches" >> "JSHK_contam");
	crowsZA_common_sogLoaded = isClass (configfile >> "CfgMods" >> "vn");

	// check if tfar is loaded 
	private _hasTFAR = isClass (configFile >> "CfgPatches" >> "task_force_radio");

	private _moduleList = [crowsZA_common_aceModLoaded, _hasTFAR] call {
		params ["_isAceLoaded", "_isTFARLoaded"];
		private _aceDependentModules = [
			["ACE Add Damage to Unit",{_this call crowsZA_fnc_aceDamageToUnit}, "\CrowsZA\data\sword.paa"],
			["Mass-Unconscious Toggle",{_this call crowsZA_fnc_massUnconscious}, "\z\ace\addons\zeus\UI\Icon_Module_Zeus_Unconscious_ca.paa"],
			["Capture Player",{_this call crowsZA_fnc_capturePlayer}, "\z\ace\addons\captives\UI\captive_ca.paa"],
			["Mass-Surrender Toggle",{_this call crowsZA_fnc_massSurrender}, "\z\ace\addons\captives\UI\Surrender_ca.paa"],
			["Set Supply Vehicle",{_this call crowsZA_fnc_setSupplyVehicle}, "\CrowsZA\data\rearmvehicle.paa"]			
		];
		private _otherModules = [
			["Remove Trees",{_this call crowsZA_fnc_removeTreesZeus}, "\CrowsZA\data\axe.paa"],
			["Restore Trees",{_this call crowsZA_fnc_restoreTreesZeus}, "\CrowsZA\data\tree.paa"],
			["Follow Unit With Animal",{_this call crowsZA_fnc_animalFollowZeus}, "\CrowsZA\data\sheep.paa"],
			["Delete All Follow Animals",{_this call crowsZA_fnc_deleteAllAnimalFollow}, "\CrowsZA\data\sheep.paa"],
			["Scatter Teleport",{_this call crowsZA_fnc_scatterTeleportZeus}, "\CrowsZA\data\tp.paa"],
			["Spawn Arsenal",{_this call crowsZA_fnc_spawnArsenal}, "\a3\ui_f\data\logos\a_64_ca.paa"],
			["Set Numberplate",{_this call crowsZA_fnc_setNumberplate}, "\CrowsZA\data\numberplate.paa"],
			["Delete ALL dead",{_this call crowsZA_fnc_deleteAllDead}, "\CrowsZA\data\cleanup.paa"],
			["Set Colour",{_this call crowsZA_fnc_setColour}, "\CrowsZA\data\paint.paa"],
			["Teleport To Squadmember",{_this call crowsZA_fnc_teleportToSquadMember}, "\CrowsZA\data\tpToSquad.paa"], 
			["DrawBuild",{_this call crowsZA_fnc_drawBuildZeus}, "\CrowsZA\data\drawbuild.paa"],
			["Fire Support",{_this call crowsZA_fnc_fireSupport}, "\x\zen\addons\modules\ui\target_ca.paa"],
			["Resupply Player Loadouts",{_this call crowsZA_fnc_resupplyPlayerLoadouts}, "\CrowsZA\data\resupplyplayerloadout.paa"],
			["Remove Radio/Bino",{_this call crowsZA_fnc_removeRadioBino}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
		];
		private _tfarModules = [
			["Set TFAR Vehicle Radio Side",{_this call crowsZA_fnc_tfarSetVehicleSide}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]
		];

		// return the ones to load
		private _combinedArr = _otherModules;
		
		if (_isAceLoaded) then {
			_combinedArr = _combinedArr + _aceDependentModules;
		};
		
		if (_isTFARLoaded) then {
			_combinedArr = _combinedArr + _tfarModules;
		};
		_combinedArr;
	};	

	//registering ZEN custom modules
	{
		private _reg = 
		[
			"Crows Zeus Modules", 
			(_x select 0), 
			(_x select 1),
			(_x select 2)
		] call zen_custom_modules_fnc_register;
	} forEach _moduleList;

	private _contextActionList = 
	[	//Action name, Display name, Icon and Icon colour, code, Condition to show, arguments, dynamic children, modifier functions
		[["camera_center_unit","Camera Center Unit","\CrowsZA\data\camera.paa", {_hoveredEntity call crowsZA_fnc_centerZeusViewUnit}, {!isNull _hoveredEntity}] call zen_context_menu_fnc_createAction,
		 [], 
		 0],
		[["teleport_to_squadmate","Teleport To Squadmate","\CrowsZA\data\tpToSquad.paa", {[[],_hoveredEntity] call crowsZA_fnc_teleportToSquadMember}, {!isNull _hoveredEntity && [_hoveredEntity] call crowsZA_fnc_isAliveManUnit && (count units group leader _hoveredEntity) > 1}] call zen_context_menu_fnc_createAction,
		 [], 
		 6],
		[["paste_loadout_to_inventory","Paste Loadout","\CrowsZA\data\paste.paa", {_hoveredEntity call crowsZA_fnc_contextPasteLoadout}, {!isNil "zen_context_actions_loadout" && !isNull _hoveredEntity}] call zen_context_menu_fnc_createAction,
		 ["Inventory"], 
		 0],
		[["loadout_viewer","View","\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_0_ca.paa", {_hoveredEntity call crowsZA_fnc_loadoutViewer}, {[_hoveredEntity] call crowsZA_fnc_isAliveManUnit}] call zen_context_menu_fnc_createAction,
		 ["Loadout"], 
		 0],
		 [["radius_heal","Radius Heal","\CrowsZA\data\radiusheal.paa", {[_position] call crowsZA_fnc_radiusHealDialog}, {true}, [], {[
			 [["radius_heal_10","10m","\CrowsZA\data\radiusheal.paa", {[_position, 10] call crowsZA_fnc_radiusHeal}] call zen_context_menu_fnc_createAction, [], 10],
			 [["radius_heal_50","50m","\CrowsZA\data\radiusheal.paa", {[_position, 50] call crowsZA_fnc_radiusHeal}] call zen_context_menu_fnc_createAction, [], 10],
			 [["radius_heal_100","100m","\CrowsZA\data\radiusheal.paa", {[_position, 100] call crowsZA_fnc_radiusHeal}] call zen_context_menu_fnc_createAction, [], 10],
			 [["radius_heal_150","150m","\CrowsZA\data\radiusheal.paa", {[_position, 150] call crowsZA_fnc_radiusHeal}] call zen_context_menu_fnc_createAction, [], 10]
		 ]}] call zen_context_menu_fnc_createAction,
		 ["HealUnits"], 
		 0],
		[["jshk_heal","JSHK Heal","\z\ace\addons\medical_gui\ui\cross.paa", {_hoveredEntity call crowsZA_fnc_jshkHeal}, {[_hoveredEntity] call crowsZA_fnc_isAliveManUnit && crowsZA_common_aceModLoaded && crowsZA_common_jshkModLoaded && (_hoveredEntity getVariable ["ACE_isUnconscious", false]) == true}] call zen_context_menu_fnc_createAction,
		 ["HealUnits"], 
		 0]//,
		// [["ace_medical_menu","Medical Menu","\z\ace\addons\medical_gui\ui\cross.paa", {_hoveredEntity call crowsZA_fnc_medicalStatus}, {!isNull _hoveredEntity && alive _hoveredEntity && _hoveredEntity isKindOf "CAManBase" && crowsZA_common_aceModLoaded}] call zen_context_menu_fnc_createAction,
		//  ["HealUnits"], 
		//  0]
	];

	//register context actions
	{
		private _reg = [
			//action, parent path, priority
			(_x select 0), (_x select 1), (_x select 2)
		] call zen_context_menu_fnc_addAction;
	} forEach _contextActionList;

	// sometimes the function gets executed before its registered we are zeus, thus the function exits instead of loading the pingbox, as we are not zeus... So call it again here where we know we are zeus
	call crowsZA_fnc_enablePingBoxHUD;
};
diag_log format ["CrowZA:fn_zeusRegister: Zeus initialization complete. Zeus Enhanced Detected: %2",_hasZen];
