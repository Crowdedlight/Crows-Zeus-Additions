#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_deleteAllDead.sqf
Parameters: pos, _unit
Return: none

Deletes all dead bodies and wrecks for cleanup

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog,
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_deleteBodies",
		"_deleteWrecks"
	];

	//log 
	diag_log "crowsZA-deleteAllDead: Deleting all dead bodies/wrecks";
	
	// deleting local, as delete is JIP friendly and should sync automatically
	// spawn in scheduled enviroment so sleep is allowed.
	_null = [_deleteBodies, _deleteWrecks] spawn {
		{
			params["_deleteBodies", "_deleteWrecks"];

			// if bodies is enabled
			if (_deleteBodies && (_x isKindOf "man")) then {
				// don't delete crew in vehicles, as that is part of vehicle removal 
				if (isNull objectParent _x) then {
					deleteVehicle _x; 
					sleep 0.01; 
				};
			};

			// if wrecks is enabled 
			if (_deleteWrecks && !(_x isKindOf "man")) then {
				deleteVehicleCrew _x; //Works with game version v2.06. Deletes all crew members
				deleteVehicle _x;
				sleep 0.01;
			};
		} forEach allDead;
	}
};
[
	localize "STR_CROWSZA_Misc_delete_dead", 
	[
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_delete_bodies", localize "STR_CROWSZA_Misc_delete_bodies_tooltip"], true],
		["TOOLBOX:YESNO", [localize "STR_CROWSZA_Misc_delete_wrecks", localize "STR_CROWSZA_Misc_delete_wrecks_tooltip"], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
