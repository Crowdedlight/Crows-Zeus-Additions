/*/////////////////////////////////////////////////
Author: Crowdedlight + WindWalker
			   
File: fn_scatterPatternLine.sqf
Parameters: center pos in AGL, number of spots to generate, offset in meters between points, altitude
Return: array of positions for TP each player

Generates an list of 3d positions for an line pattern. Used together with scatterTeleport

*///////////////////////////////////////////////
params ["_targetPos", "_amount", "_offset", "_targetAltitude", "_direction"];

// create array of _amount positions to fill with teleport positions, We don't use the first position which is the targetPos, but build around it. 
private _tpPositions = [];

// line with distance of _playerOffset
// direction vector in meters
private _di = 0;
private _dj = 0;

//i is x ,j is y
private _dirConstant = 0;

switch (_direction) do {
	case "north": { _dirConstant = 1};
	case "north_east": { _dirConstant = 5};
	case "north_west": { _dirConstant = 6};
	case "east": { _dirConstant  = 2};
	case "south": { _dirConstant = 3 };
	case "south_east": { _dirConstant = 7};
	case "south_west": { _dirConstant = 8};
	case "west": { _dirConstant  = 4};
	default { _dirConstant  = 1};
};

if (_dirConstant > 4) then {
	_offset = _offset / (sqrt 2);
};

// length of segment, we start with just 1, as we grow outwards
private _segmentLength = 1;

// current position (i, j) and how much of current segment we passed.
// i == west to east, j == north to south. 
private _i = _targetPos select 0;
private _j = _targetPos select 1;
private _targetAltitude = _targetAltitude;

private _segmentPassed = 0;

// loop and build positions
for "_k" from 1 to _amount do { 

	switch (_dirConstant) do {
		case 1: { _dj = _offset }; 	//N
		case 2: { _di = _offset }; 	//E
		case 3: { _dj = -_offset }; //S
		case 4: { _di = -_offset }; //W
		case 5: { _di = _offset; _dj = _offset };	//NE
		case 6: { _di = -_offset; _dj = _offset };	//NW
		case 7: { _di = _offset; _dj = -_offset };	//SE
		case 8: { _di = -_offset; _dj = -_offset };	//SW
		default { _di = _offset };
	};

	// make step, add direction vector (di, dj) to current position (i,j)
	_i = _i + _di;
	_j = _j + _dj;
	_segmentPassed = _segmentPassed + 1;

	// push back on array
	_tpPositions pushBack [_i, _j, _targetAltitude];
};
// return array of positions
_tpPositions