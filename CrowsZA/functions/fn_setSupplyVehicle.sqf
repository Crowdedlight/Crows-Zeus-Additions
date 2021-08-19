/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_setRearmVehicle.sqf
Parameters: pos
Return: none

Sets the object as a rearm vehicle for ACE rearm

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_rearm",
		"_repair",
		"_refuel",
		"_refuelAmount"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	//if unit is empty/null/dead, exit. Also don't allow to set it on infantry, buildings or players
	if (isNull _unit || _unit isKindOf "CAManBase" || _unit isKindOf "Building" || !alive _unit) exitWith { 
		diag_log "CrowsZA-setRearmVehicle: invalid or no object selected";
	};

	if (_rearm) then {
		//rearm - only run on server 
		[_unit] remoteExec ["ace_rearm_fnc_makeSource", 2];
	};

	if (_refuel) then {
		//refuel - only run on server 
		[_unit, _refuelAmount] remoteExec ["ace_refuel_fnc_makeSource", 2];
	};

	if (_repair) then {
		//repair - only run on server 
		_unit setVariable ["ACE_isRepairVehicle", 1, true];
	};
};
[
	"Set vehicle as...", 
	[
		["CHECKBOX",["Rearm", "Set vehicle as rearm vehicle"],[false]],
		["CHECKBOX",["Repair", "Set vehicle as repair vehicle"],[false]],
		["CHECKBOX",["Refuel", "Set vehicle as refuel vehicle"],[false]],
		["SLIDER","Refuel Amount [liters]",[0,10000,2000,0]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;


