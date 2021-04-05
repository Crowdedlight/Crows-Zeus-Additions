/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_zeusRegister.sqf
Parameters: none
Return: none

Using the same setup method as JShock in JSHK contamination mod. 

*///////////////////////////////////////////////

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

//spawn script to register zen modules
private _wait = [player] spawn
{
	params ["_unit"];
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
	
	private _moduleList = 
	[
		["ACE Add Damage to Unit",{_this call crowsZA_fnc_aceDamageToUnit}, "\CrowsZA\data\sword.paa"],
		["Remove Trees",{_this call crowsZA_fnc_removeTreesZeus}, "\CrowsZA\data\axe.paa"],
		["Restore Trees",{_this call crowsZA_fnc_restoreTreesZeus}, "\CrowsZA\data\tree.paa"],
		["Follow Unit With Animal",{_this call crowsZA_fnc_animalFollowZeus}, "\CrowsZA\data\sheep.paa"],
		["Delete All Follow Animals",{_this call crowsZA_fnc_deleteAllAnimalFollow}, "\CrowsZA\data\sheep.paa"],
		["Scatter Teleport",{_this call crowsZA_fnc_scatterTeleportZeus}, "\CrowsZA\data\tp.paa"],
		// ["Scatter Teleport With Parachute",{_this call crowsZA_fnc_scatterTeleportWithParachuteZeus}, "\CrowsZA\data\tp_chute.paa"],
		["Set Numberplate",{_this call crowsZA_fnc_setNumberplate}, "\CrowsZA\data\numberplate.paa"],
		["Delete ALL dead bodies",{_this call crowsZA_fnc_deleteAllDeadBodies}, "\CrowsZA\data\cleanup.paa"]
	];

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
		["camera_center_unit","Camera Center Unit","\CrowsZA\data\camera.paa", {_hoveredEntity call crowsZA_fnc_centerZeusViewUnit}, {!isNull _hoveredEntity}] call zen_context_menu_fnc_createAction
	];

	//register context actions
	{
		private _reg = [
			//action, parent path, priority
			_x, [], 0
		] call zen_context_menu_fnc_addAction;
	} forEach _contextActionList;

};
diag_log format ["CrowZA:fn_zeusRegister: Zeus initialization complete. Zeus Enhanced Detected: %2",_hasZen];
