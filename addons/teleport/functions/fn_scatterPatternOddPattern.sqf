/*/////////////////////////////////////////////////
Author: Crowdedlight+WindWalker
			   
File: fn_scatterPatternOddPattern.sqf
Parameters: center pos in AGL, number of spots to generate, offset in meters between points, altitude
Return: array of positions for TP each player

Generates an list of 3d positions for an uniqe tp pattern. Used together with scatterTeleport

*///////////////////////////////////////////////
params ["_targetPos", "_amount", "_offset", "_targetAltitude"];

// create array of _amount positions to fill with teleport positions, We don't use the first position which is the targetPos, but build around it. 
private _tpPositions = [];

// length of segment, we start with just 1, as we grow outwards
private _segmentLength = 1;

// current position (i, j) and how much of current segment we passed.
private _i = _targetPos select 0;
private _j = _targetPos select 1;
private _targetAltitude = _targetAltitude;

private _segmentPassed = 0;

private _row = 0;
private _tick = 0;

// loop and build positions
for "_k" from 1 to _amount do { 
	
	private _tmpI = 0;
	private _tmpJ = 0;
	
	switch (_tick) do {
		case 0:  { _tmpI = _i + 0  	 + 0 	  ;			_tmpJ = _j + 0 	+					(10 * _row)};
		case 1:  { _tmpI = _i + 2    + _offset; 		_tmpJ = _j + 2 	+  _offset 	   	+	(10 * _row)};
		case 2:  { _tmpI = _i + 4    + _offset * 2; 	_tmpJ = _j + 13 +  _offset * 2 	+	(10 * _row)};
		case 3:  { _tmpI = _i + 6    + _offset * 3; 	_tmpJ = _j + 2	+  _offset     	+	(10 * _row)};
		case 4:  { _tmpI = _i + 8    + _offset * 4; 	_tmpJ = _j + 0 	+					(10 * _row)};
		case 5:  { _tmpI = _i + 10    + _offset * 4.2; 	_tmpJ = _j + 13 +  _offset * 2 	+	(10 * _row)};
		case 6:  { _tmpI = _i + 10.2  + _offset * 4.4; 	_tmpJ = _j + 18 +  _offset * 3 	+	(10 * _row)};
		case 7:  { _tmpI = _i + 10.6  + _offset * 4.6; 	_tmpJ = _j + 22 +  _offset * 4 	+	(10 * _row)};
		case 8:  { _tmpI = _i + 11.2  + _offset * 4.8; 	_tmpJ = _j + 28 +  _offset * 5 	+	(10 * _row)};
		case 9:  { _tmpI = _i + 12    + _offset * 5;	_tmpJ = _j + 32 +  _offset * 6 	+	(10 * _row)};
		case 10: { _tmpI = _i + 13.3  + _offset * 5.2; 	_tmpJ = _j + 35 +  _offset * 7 	+	(10 * _row)};
		case 11: { _tmpI = _i + 14.8  + _offset * 5.4; 	_tmpJ = _j + 32 +  _offset * 6 	+	(10 * _row)};
		case 12: { _tmpI = _i + 15.6  + _offset * 5.6; 	_tmpJ = _j + 28 +  _offset * 5 	+	(10 * _row)};
		case 13: { _tmpI = _i + 16.2  + _offset * 5.8; 	_tmpJ = _j + 22 +  _offset * 4 	+	(10 * _row)};
		case 14: { _tmpI = _i + 16.6  + _offset * 6; 	_tmpJ = _j + 18 +  _offset * 3 	+	(10 * _row)};
		case 15: { _tmpI = _i + 16.8  + _offset * 6.2; 	_tmpJ = _j + 13 +  _offset * 2 	+	(10 * _row)};
		case 16: { _tmpI = _i + 18.8  + _offset * 6.4; 	_tmpJ = _j + 0 	+					(10 * _row)};
		case 17: { _tmpI = _i + 20.8 + _offset * 7.4; 	_tmpJ = _j + 2 	+  _offset  	+	(10 * _row)};
		case 18: { _tmpI = _i + 22.8 + _offset * 8.4; 	_tmpJ = _j + 13 +  _offset * 2 	+	(10 * _row)};
		case 19: { _tmpI = _i + 24.8 + _offset * 9.4; 	_tmpJ = _j + 2 	+  _offset  	+	(10 * _row)};
		case 20: { _tmpI = _i + 26.8 + _offset * 10.4; 	_tmpJ = _j + 0 	+   				(10 * _row);  _row = _row + 1 };
		default {  };
	};
	
	
	
	if (_tick == 20) then { _tick = -1};
	
	_tick = _tick + 1;
	
	_segmentPassed = _segmentPassed + 1;

	// push back on array
	_tpPositions pushBack [_tmpI, _tmpJ, _targetAltitude];

};
// return array of positions
_tpPositions