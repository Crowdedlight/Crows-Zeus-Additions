/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_scatterTeleport.sqf
Parameters: center pos in AGL, array of players, distance between players, altitude to teleport to
Return: none

Teleports selected players or vehicles if they are mounted and vehicle is included, but placing them in an outward spiral, with set distance between eachother and at target altitude over ground. 
Useful for TP'ing section into parachute drop. 
OBS. for now, if vehicles are not included and a mounted player is selected for TP, then the player will not be TP'ed.
Could in future add so if player is mounted it "dismount" first then TP.

*///////////////////////////////////////////////
params ["_targetPos", "_players", "_playerOffset", "_targetAltitude"];

// validation of inputs, we need at least some players and none of the paramteres can be null
if ((count _targetPos) > 3) exitWith { diag_log "CrowsZA-ScatterTeleport: position for TP target can not be null"};
if ((count _players) <= 0) exitWith { diag_log "CrowsZA-ScatterTeleport: No units to teleport..."};
if (typename _playerOffset != "SCALAR") exitWith { diag_log "CrowsZA-ScatterTeleport: should always get a player offset which is a scalar, we didn't.... indicates internal script error"};
if (typename _targetAltitude != "SCALAR") exitWith { diag_log "CrowsZA-ScatterTeleport: should always get a altitude which is a scalar, we didn't.... indicates internal script error"};

// get array of TP positions, split into own file for future support of different "shapes"/patterns
private _tpArray = [_targetPos, count _players, _playerOffset, _targetAltitude] call crowsZA_fnc_scatterPatternOutwardSpiral;

//TODO should probably validate that we are not beyond limits with selected position calculations. X, Y and Z are limited to values between -50km and +500km in arma 3. 
//  if we are outside that interval with any position, we should call pattern generation again, but shifted center position away from edge

// now run through each player and tp
{
	//reset velocity 
	_x setvelocity [0,0,0];

	//set position, use setPos or setVehiclePosition depending on type
	if (_x isKindOf "CAManBase") then {
		_x setPos (_tpArray select _forEachIndex);
	} else {
		_x setVehiclePosition [(_tpArray select _forEachIndex), [], 0, "CAN_COLLIDE"];
	};
}
forEach _players;
