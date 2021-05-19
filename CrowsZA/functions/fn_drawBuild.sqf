/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: drawBuild.sqf
Parameters: positions, (FUTURE: what object to use for building)
Return: none

builds objects along the drawn line 

*///////////////////////////////////////////////
// both pos comes as ASL
params ["_startPos", "_endPos"];

// todo make dialog where you choose what to build... 
private _objectName = "Land_HBarrier_3_F";

// get placement and direction offset (We want to place it from edge to edge)
private _spawnObjectLength = 0;
switch(_objectName) do {
	// smaller hesco
	case "Land_HBarrier_3_F":
	{
		_spawnObjectLength = 3.55376;
		_spawnObjectLengthOffset = _spawnObjectLength*0.5;
		_spawnDirOffset = 90; //90deg offset
	};
	// large hesco
	case "Land_HBarrier_Big_F":
	{
		_spawnObjectLength = 9.02888;
		_spawnDirOffset = 90; //90deg offset
	};		
	// sandbags
	case "Land_BagFence_Short_F":
	{
		_spawnObjectLength = 1.98357;
		_spawnDirOffset = 90; //90deg offset
	};
};

// calculate distance between points to know amount of hesco to cover the length - https://community.bistudio.com/wiki/vectorDistance
private _euclideanDist = _startPos vectorDistance _endPos;
private _iterations = ceil (_euclideanDist / _spawnObjectLength); //always round up. Might place one too many segments, but this is why we try to use smaller segments. 

// calculate the direction between points
private _direction = _startPos getDir _endPos;

diag_log format["distance: %1, direction: %2", _euclideanDist, _direction];

// save start pos in temp var for iteration
private _tempPos = _startPos;
private _nextPos = [];

// dist to move each iteration
private _distMove = _spawnObjectLength + _spawnObjectLengthOffset;

// array of spawned objects 
private _allObjects = [];

// loop over the amount of hesco needed to be placed (distance calculation)
for "_i" from 1 to _iterations do {
	// increment distance - https://community.bistudio.com/wiki/getPos
	// if first position, we only move the offset from clicked position, for the rest we move position and offset.
	if (_i == 1) then {
		_nextPos = _tempPos getPos [_spawnObjectLengthOffset, _direction];
	} else {
		_nextPos = _tempPos getPos [_distMove, _direction]; 	
	};

	// spawn hesco - https://community.bistudio.com/wiki/createVehicle
	_object = createVehicle [_objectName, _nextPos, [], 0, "CAN_COLLIDE"];

	// disable simulation on it - Executed on server
	[_object, false] remoteExec ["enableSimulationGlobal", 2];

	// rotate it - https://community.bistudio.com/wiki/setVectorDir 
	_object setDir 34.3194 + _spawnDirOffset; //is individual offset

	// set same position again to sync rotation across clients (Also snaps it to ground level better after rotation)
	_object setPos (getPos _object);

	// add to array to make zeus editable. Doing like so to only send one server event and not one per spawned element, more effecient. 	
	_allObjects pushBack _object;

	// update temp position 
	_tempPos = _nextPos;
};

// add all spawned objects to zeus editable objects	
["zen_common_addObjects", [_allObjects, objNull]] call CBA_fnc_serverEvent;














//testing notes
// 	22:50:31 [10531.5,6882.86,76.5975]
// 22:50:31 [10537.9,6891.64,75.4359]

// box1: [10531.8,6882.61,0.003479] -> Dir:  [-0.768267,0.640129,0]
// box2: [10537.5,6890.96,0.002578] -> Dir:  [-0.766267,0.642531,0]
// box3: dir-> [0,1,0]

// box1 vectorcos box2: 

// [10531.8,6882.61,0.003479] vectorDistance[10537.5,6890.96,0.002578]
// [0.563806,0.825907,-8.91178e-005]

// [10531.8,6882.61,0.003479] getDir [10537.5,6890.96,0.002578]
// 34.3194 deg

// private _startPos = [10531.8,6882.61,0.003479];
// private _obj = createVehicle ["Land_HBarrier_3_F", ASLToAGL _startPos modelToWorld [-1.77688,0,0], [], 0, "CAN_COLLIDE"];

// sandbag: Land_BagFence_Short_F
// hesco_small: Land_HBarrier_3_F -> length: 1.76125, middle: 0,880625


// find length of objects for spacing
// _bbr = boundingBoxReal _this;
// _p1 = _bbr select 0;
// _p2 = _bbr select 1;
// _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
// _maxLength = abs ((_p2 select 1) - (_p1 select 1));
// _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
// diag_log _maxWidth;
// diag_log _maxLength;