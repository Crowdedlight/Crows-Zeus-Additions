/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_setRearmVehicle.sqf
Parameters: pos
Return: none

Sets the object as a rearm vehicle for ACE rearm

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//if unit is empty/null, exit. Also don't allow to set it on infantry or players
if (isNull _unit || _unit isKindOf "CAManBase") exitWith { 
	diag_log "CrowsZA-setRearmVehicle: invalid or no object selected";
};

//make it source
[_unit] remoteExec ["ace_rearm_fnc_makeSource", 2];
