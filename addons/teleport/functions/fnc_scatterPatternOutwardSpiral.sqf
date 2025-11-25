#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_scatterPatternOutwardSpiral.sqf
Parameters: center pos in AGL, number of spots to generate, offset in meters between points, altitude
Return: array of positions for TP each player

Generates an list of 3d positions for an outward spiral pattern. Used together with scatterTeleport

*///////////////////////////////////////////////
params ["_targetPos", "_amount", "_offset", "_targetAltitude"];

// create array of _amount positions to fill with teleport positions, We don't use the first position which is the targetPos, but build around it. 
private _tpPositions = [];

// outward spiral with distance of _playerOffset - Inspired from stack overflow answers
// direction vector in meters
private _di = _offset;
private _dj = 0;

// length of segment, we start with just 1, as we grow outwards
private _segmentLength = 1;

// current position (i, j) and how much of current segment we passed.
private _i = _targetPos select 0;
private _j = _targetPos select 1;
private _targetAltitude = _targetAltitude;

private _segmentPassed = 0;

// loop and build positions
for "_k" from 1 to _amount do { 
	// make step, add direction vector (di, dj) to current position (i,j)
	_i = _i + _di;
	_j = _j + _dj;
	_segmentPassed = _segmentPassed + 1;

	// push back on array
	_tpPositions pushBack [_i, _j, _targetAltitude];

	//if we are at a turn and new segment, do turn
	if (_segmentPassed == _segmentLength) then {
		// done with current segment
		_segmentPassed = 0;

		// rotate direction
		private _tempBuf = _di;
		_di = -_dj;
		_dj = _tempBuf;

		// increase segment length if nessecary
		if (_dj == 0) then {
			_segmentLength = _segmentLength + 1;
		};
	};
};
// return array of positions
_tpPositions
