/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: drawBuild.sqf
Parameters: positions, (FUTURE: what object to use for building)
Return: none

builds objects along the drawn line 

*///////////////////////////////////////////////
// both pos comes as ASL
params ["_startPos", "_endPos", "_objectName", "_enableSim", "_enableDmg"];

// todo make dialog where you choose what to build... 
// private _objectName = "Land_HBarrier_3_F";

// get placement and direction offset (We want to place it from edge to edge)
private _spawnObjectLength = 0;
private _spawnObjectLengthOffset = 0;
private _spawnDirOffset = 0;
private "_spawnObjectHeight";

switch(_objectName) do {
	// smaller hesco
	case "Land_HBarrier_3_F":
	{
		_spawnObjectLength = 3.45376;
		_spawnObjectLengthOffset = 1.7;
		_spawnDirOffset = 90; //90deg offset
	};
	// large hesco
	case "Land_HBarrier_Big_F":
	{
		_spawnObjectLength = 8.5;
		_spawnObjectLengthOffset = 4.25;
		_spawnDirOffset = 90; //90deg offset
	};		
	// sandbags
	case "Land_BagFence_Short_F":
	{
		_spawnObjectLength = 1.6;
		_spawnObjectLengthOffset = 0.7;
		_spawnDirOffset = 90; //90deg offset
	};
	// tall sandbags
	case "Land_SandbagBarricade_01_F":
	{
		_spawnObjectLength = 1.7;
		_spawnObjectLengthOffset = 1.7;
		_spawnDirOffset = 90; //90deg offset
	};
	// trench
	case "fort_envelopebig": //only exists if grad trenches is on the server
	{
		_spawnObjectLength = 6;
		_spawnObjectLengthOffset = 3;
		_spawnDirOffset = 270;
	};
	// concrete wall
	case "Land_ConcreteWall_01_m_4m_F":
	{
		_spawnObjectLength = 4;
		_spawnObjectLengthOffset = 2;
		_spawnDirOffset = 90; //90deg offset
	};
	// smaller hesco - green
	case "Land_HBarrier_01_line_3_green_F":
	{
		_spawnObjectLength = 3.45376;
		_spawnObjectLengthOffset = 1.7;
		_spawnDirOffset = 90; //90deg offset
	};
	// big hesco - green 
	case "Land_HBarrier_01_big_4_green_F":
	{
		_spawnObjectLength = 8.5;
		_spawnObjectLengthOffset = 4.25;
		_spawnDirOffset = 90; //90deg offset
	};
	// sandbag wall - green
	case "Land_BagFence_01_short_green_F":
	{
		_spawnObjectLength = 1.6;
		_spawnObjectLengthOffset = 0.7;
		_spawnDirOffset = 90; //90deg offset
	};
	// military wall big
	case "Land_Mil_WallBig_4m_F":
	{
		_spawnObjectLength = 4;
		_spawnObjectLengthOffset = 2;
		_spawnDirOffset = 90; //90deg offset
	};
	// land fortress wall 5m
	case "Land_Fortress_01_5m_F":
	{
		_spawnObjectLength = 10;
		_spawnObjectLengthOffset = 5;
		_spawnDirOffset = 90; //90deg offset
	};
	// grass hedge
	case "Land_Hedge_01_s_2m_F":
	{
		_spawnObjectLength = 2;
		_spawnObjectLengthOffset = 0.5;
		_spawnDirOffset = 0;
	};
	// net fence
	case "Land_NetFence_02_m_4m_F":
	{
		_spawnObjectLength = 4;
		_spawnObjectLengthOffset = 2;
		_spawnDirOffset = 90; //90deg offset
	};
	// wired fence
	case "Land_New_WiredFence_5m_F":
	{
		_spawnObjectLength = 5.20;
		_spawnObjectLengthOffset = 2.6;
		_spawnDirOffset = 90; //90deg offset
	};
	// razorwire
	case "Land_Razorwire_F":
	{
		_spawnObjectLength = 8.46;
		_spawnObjectLengthOffset = 4.20;
		_spawnDirOffset = 90; //90deg offset
	};
	// tire barrier
	case "Land_TyreBarrier_01_line_x4_F":
	{
		_spawnObjectLength = 2.6;
		_spawnObjectLengthOffset = 1.2;
		_spawnDirOffset = 90; //90deg offset
	};
	//power cables
	case "PowerCable_01_StraightLong_F":
	{
		_spawnObjectLength = 5.02368;
		_spawnObjectLengthOffset = 2.49;
		_spawnDirOffset = 0; //no offset
	};
	//concrete overhead line
	case "Land_PowerLine_03_pole_F":
	{
		_spawnObjectLength = 40;
		_spawnObjectLengthOffset = 20;
		_spawnDirOffset = 0; //no offset
		_spawnObjectHeight = 8.8;
	};
	//wood overhead line
	case "Land_PowerLine_02_pole_small_F":
	{
		_spawnObjectLength = 40;
		_spawnObjectLengthOffset = 20;
		_spawnDirOffset = 0; //no offset
		_spawnObjectHeight = 8.9;
	};
};

// calculate distance between points to know amount of hesco to cover the length - https://community.bistudio.com/wiki/vectorDistance
private _euclideanDist = _startPos vectorDistance _endPos;
private _iterations = ceil (_euclideanDist / _spawnObjectLength); //always round up. Might place one too many segments, but this is why we try to use smaller segments. 

// calculate the direction between points
private _direction = _startPos getDir _endPos;

// diag_log format["distance: %1, direction: %2", _euclideanDist, _direction];

// save start pos in temp var for iteration
private _tempPos = _startPos;
private _nextPos = [];

// dist to move each iteration
private _distMove = _spawnObjectLength;

// array of spawned objects 
private _allObjects = [];

// loop over the amount of object needed to be placed (distance calculation)
for "_i" from 1 to _iterations do {
	// increment distance - https://community.bistudio.com/wiki/getPos
	// if first position, we only move the offset from clicked position, for the rest we move position and offset.
	// diag_log format["spawnObjectOffset: %1, direction: %2", _spawnObjectLengthOffset, _direction];

	if (_i == 1) then {
		_nextPos = _tempPos getPos [_spawnObjectLengthOffset, _direction];
	} else {
		_nextPos = _tempPos getPos [_distMove, _direction];
	};

	// spawn object - https://community.bistudio.com/wiki/createVehicle
	_object = createVehicle [_objectName, _nextPos, [], 0, "CAN_COLLIDE"];

	// Align to highest surface (via killzone_kid at https://community.bistudio.com/wiki/Position#PositionAGLS)
	_nextPos set [2, worldSize];
	_object setPosASL _nextPos;
	_nextPos set [2, vectorMagnitude (_nextPos vectorDiff getPosVisual _object)];
	_object setPosASL _nextPos;

	// disable simulation if selected
	if (!_enableSim) then {
		_object enableSimulationGlobal false;
	};

	// disable damage if chosen - If we see issues with this in future, consider setting owner to server, before disabling damage as the owner shouldn't change short of server crash... and then it doesnt matter
	if (!_enableDmg) then {
		_object allowDamage false;
	};

	// rotate it - https://community.bistudio.com/wiki/setVectorDir 
	_object setDir _direction + _spawnDirOffset; //is individual offset

	_object setVectorUp surfaceNormal position _object;

	// set same position again to sync rotation across clients (Also snaps it to ground level better after rotation)
	//_object setPos (getPos _object);
	_object setPosWorld getPosWorld _object;


	// Special code for overhead wires
	if(_objectName in ["Land_PowerLine_03_pole_F", "Land_PowerLine_02_pole_small_F"]) then {

		_object setVectorUp [0,0,1];
		// Create an invisible object, that "wires" (ropes) can be attached to
		_dummy = "PortableHelipadLight_01_blue_F" createVehicle [0,0];
		_dummy hideObjectGlobal true;
		_dummy disableCollisionWith _object;
		_dummy setVehiclePosition [_object, [], 0, "CAN_COLLIDE"];
		[_dummy, [0,0,0]] call BIS_fnc_setObjectRotation; //Use this rather than setVectorUp - allows objects to collide

		// if (!_enableSim) then {
		// 	_dummy enableSimulationGlobal false;
		// }; // Wires don't like attaching to static/simple objects
		_dummy allowDamage false;
		
		// Note: attatchTo would be great, so that moving a pole also moved
		// the wires; but the wires don't like static/simple objects
		// (this is especially an issue if the "dummy" object, e.g., rolls down a hill!)
		// and we can't do it the other way around or the pole wouldn't take damage
		_allObjects pushBack _dummy;

		// Create the wires between this pole and the previous "pole"
		if(!isNull crowsZA_drawbuild_lastPole) then {
			_distance = (_dummy distance crowsZA_drawbuild_lastPole);
			_rope = ropeCreate [_dummy, [0, 0, _spawnObjectHeight], crowsZA_drawbuild_lastPole, [0, 0, _spawnObjectHeight], _distance];
			_rope enableSimulationGlobal false;
			_allObjects pushBack _rope;
		};
		crowsZA_drawbuild_lastPole = _dummy;

		_object setVariable ["_dummy", _dummy];
		_object addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			deleteVehicle (_unit getVariable "_dummy");
		}];
	};

	// add to array to make zeus editable. Doing like so to only send one server event and not one per spawned element, more efficient. 	
	_allObjects pushBack _object;

	// update temp position 
	_tempPos = _nextPos;
};

// add all spawned objects to zeus editable objects	
["zen_common_updateEditableObjects", [_allObjects]] call CBA_fnc_serverEvent;


// find length of objects for spacing
// _bbr = boundingBoxReal _this;
// _p1 = _bbr select 0;
// _p2 = _bbr select 1;
// _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
// _maxLength = abs ((_p2 select 1) - (_p1 select 1));
// _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
// diag_log _maxWidth;
// diag_log _maxLength;