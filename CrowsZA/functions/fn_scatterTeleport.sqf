/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_scatterTeleport.sqf
Parameters: center pos in AGL, array of players, distance between players, altitude to teleport to
Return: none

Removes trees in an area around the selected point

*///////////////////////////////////////////////
params ["_targetPos", "_players", "_playerOffset", "_targetAltitude"];

// TODO validation of inputs, we need at least some players and none of the paramteres can be null

// get array of TP positions, split into own file for future support of different "shapes"/patterns
private _tpArray = [_targetPos, count _players, _playerOffset, _targetAltitude] call crowsZA_fnc_scatterPatternOutwardSpiral;

//TODO should validate that we are not beyond limits with selected position calculations. X, Y and Z are limited to values between -50km and +500km in arma 3. 
// if we are outside that interval with any position, we should call pattern generation again, but shifted center position away from edge

// now run through each player and tp
private _i = 0;
{
    _x setPos (_tpArray select _i);
	_i = _i + 1;
}
forEach _players;
