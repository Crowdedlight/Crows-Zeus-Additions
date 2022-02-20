/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_deleteAllDead.sqf
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
			if (_deleteBodies && (_x iskindof "man")) then {
				// don't delete crew in vehicles, as that is part of vehicle removal 
				if (vehicle _x == _x) then {
					deleteVehicle _x; 
					sleep 0.01; 
				};
			};

			// if wrecks is enabled 
			if (_deleteWrecks && !(_x iskindof "man")) then {
				deleteVehicleCrew _x; //Works with game version v2.06. Deletes all crew members
				deleteVehicle _x;
				sleep 0.01;
			};
		} foreach allDead;
	}
};
[
	"Are you sure you want to delete ALL dead?", 
	[
		["TOOLBOX:YESNO", ["Delete Bodies", "Deletes all dead bodies not inside vehicles"], true],
		["TOOLBOX:YESNO", ["Delete Wrecks", "Deletes all wrecks and any crew inside"], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
