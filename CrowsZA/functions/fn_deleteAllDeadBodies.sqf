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

	//log 
	diag_log "crowsZA-deleteAllDeadBodies: Deleting all dead bodies";
	
	// deleting local, as delete is JIP friendly and should sync automatically
	// spawn in scheduled enviroment so sleep is allowed.
	_null = [] spawn {
		{
			//only delete if not inside vic. As deleteVehicle cause issues if deleting units inside an vic. 
			if (vehicle player == player) then {
				deleteVehicle _x; 
				sleep 0.01; 
			};
			//todo future, if we want.
			//clean up vehicle crews first, if we include wrecks 
			// private _vic = _x;
			// { _vic deleteVehicleCrew _x } forEach crew _vic;
			// deleteVehicle _vic;
		} foreach allDeadMen;
	}
};
[
	"Are you sure you want to delete ALL dead bodies?", 
	[],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
