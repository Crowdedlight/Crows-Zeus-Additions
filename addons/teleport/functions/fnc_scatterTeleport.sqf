#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_scatterTeleport.sqf
Parameters: center pos in AGL, array of players, distance between players, altitude to teleport to
Return: none

Teleports selected players or vehicles if they are mounted and vehicle is included, but placing them in an outward spiral, with set distance between eachother and at target altitude over ground. 
Useful for TP'ing section into parachute drop. 
OBS. for now, if vehicles are not included and a mounted player is selected for TP, then the player will not be TP'ed.
Could in future add so if player is mounted it "dismount" first then TP.

*///////////////////////////////////////////////
params ["_targetPos", "_players", "_playerOffset", "_targetAltitude", "_tpPattern", "_tpDirection"];

// validation of inputs, we need at least some players and none of the paramteres can be null
if ((count _targetPos) > 3) exitWith { diag_log "CrowsZA-ScatterTeleport: position for TP target can not be null"};
if ((count _players) <= 0) exitWith { diag_log "CrowsZA-ScatterTeleport: No units to teleport..."};
if (typeName _playerOffset != "SCALAR") exitWith { diag_log "CrowsZA-ScatterTeleport: should always get a player offset which is a scalar, we didn't.... indicates internal script error"};
if (typeName _targetAltitude != "SCALAR") exitWith { diag_log "CrowsZA-ScatterTeleport: should always get a altitude which is a scalar, we didn't.... indicates internal script error"};

// get array of TP positions, split into own file for future support of different "shapes"/patterns
private _tpArray = [];
switch (_tpPattern) do 
{
	case "odd":
	{
		//calculate spots with outward spiral
		_tpArray = [_targetPos, count _players, _playerOffset, _targetAltitude] call FUNC(scatterPatternOddPattern);
	};
	case "outward_spiral":
	{
		//calculate spots with outward spiral
		_tpArray = [_targetPos, count _players, _playerOffset, _targetAltitude] call FUNC(scatterPatternOutwardSpiral);
	};
	case "line":
	{
		//calculate with line
		_tpArray = [_targetPos, count _players, _playerOffset, _targetAltitude, _tpDirection] call FUNC(scatterPatternLine);
	};
	default 
	{
		//no argument found, so we failed... log and stop execution
		diag_log "CrowsZA-ScatterTeleport: No valid pattern was given for teleport";
		exit;
	};
};

//TODO should probably validate that we are not beyond limits with selected position calculations. X, Y and Z are limited to values between -50km and +500km in arma 3. 
//  if we are outside that interval with any position, we should call pattern generation again, but shifted center position away from edge
private _playerEffect = {
	if (!hasInterface) exitWith {};
	private _spawn = [] spawn {
		titleCut ["", "BLACK OUT", 1];
		sleep 1.5;
		titleCut ["", "BLACK IN", 1];
	};
};

// now run through each player and tp
{
	// fade to black if target is player
	if (isPlayer _x) then {
		[[], _playerEffect] remoteExec ["call", _x];
	};
	
	// reset velocity 
	_x setVelocity [0,0,0];

	// set position, use setPos for vics too as setVehiclePosition doesn't allow altitude setting
	_x setPos (_tpArray select _forEachIndex);
}
forEach _players;
