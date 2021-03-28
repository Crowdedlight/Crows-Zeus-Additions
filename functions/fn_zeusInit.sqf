/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_zeusInit.sqf
Parameters: none
Return: none

*///////////////////////////////////////////////

private _hasAch = isClass (configFile >> "CfgPatches" >> "achilles_modules_f_achilles");
private _hasZen = isClass (configFile >> "CfgPatches" >> "zen_custom_modules");
if !(_hasAch || _hasZen) exitWith
{
	private _msg = "******CBA and/or Achilles or ZEN not detected. They are required for Crows Zeus Additions.";
	diag_log _msg;
};

//global var for zen
crowZA_zen = _hasZen;

if (!hasInterface) exitWith {};

private _wait = [player] spawn
{
	params ["_unit"];
	private _timeout = 0;
	waitUntil 
	{
		if (_timeout >= 10) exitWith 
		{
			diag_log "fn_zeusInit: Timed out!!!";
			true;
		};
		sleep 1;
		_timeout = _timeout + 1;
		if (count allCurators == 0 || {!isNull (getAssignedCuratorLogic _unit)}) exitWith {true};
		false;
	};
	
	private _moduleList = 
	[
		["ACE Add Damage to Unit",{_this call crowsZA_fnc_aceDamageToUnit}],
	];

	if !(_hasZen) then 
	{
		{
			[
				"Crows Zeus Modules", 
				(_x select 0), 
				(_x select 1)
			] call Ares_fnc_RegisterCustomModule;
		} forEach _moduleList;
	} else {
		{
			private _reg = 
			[
				"Crows Zeus Modules", 
				(_x select 0), 
				(_x select 1),
				"\Crows_Zeus_Additions\data\icon.paa"
			] call zen_custom_modules_fnc_register;
		} forEach _moduleList;
	};
};
//waitUntil {scriptDone _wait};
diag_log format ["fn_zeusInit: Zeus initialization complete. Achilles Detected: %1 -- Zeus Enhanced Detected: %2",_hasAch,_hasZen];
