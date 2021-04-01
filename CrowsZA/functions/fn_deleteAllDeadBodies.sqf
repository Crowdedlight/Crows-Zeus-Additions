/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_deleteAllDeadBodies.sqf
Parameters: pos, _unit
Return: none

Deletes all dead bodies for cleanup

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog,
private _onConfirm =
{
	//only showing dialog to make sure Zeus wants to delete all dead bodies
	crowsZA_fnc_deleteBodies = {
		{ 
			//log 
			diag_log "crowsZA-deleteAllDeadBodies: Deleting all dead bodies";

			//only delete if not inside vic. As deleteVehicle cause issues if deleting units inside an vic. 
			// Arma suggest to use deleteVehicleCrew for this case, however for now we want to clean up vics ourselves
			if (vehicle player == player) then {
				deleteVehicle _x; 
				sleep 0.01; 
			};
		} foreach allDeadMen;
	};

	//Delete all dead bodies, spawn it to run on server with remoteExec
	[] remoteExec ["crowsZA_fnc_deleteBodies", 2, false]; //2 = server, for all players, no JIP
};
[
	"Are you sure you want to delete ALL dead bodies?", 
	[],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;



