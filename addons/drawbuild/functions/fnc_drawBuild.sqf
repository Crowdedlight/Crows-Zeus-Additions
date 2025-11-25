#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_drawBuild.sqf
Parameters: startPos - Array: position (ASL) to draw from
			endPos - Array: position (ASL) to draw to
			objectName - String: classname of the object(s) to create
			enableSim - Boolean: whether the created objects should be simulation-enabled
			enableDmg - Boolean: whether the created objects should be damage-enabled

Return: none

Builds objects along the drawn line 

*///////////////////////////////////////////////

params ["_startPos", "_endPos", "_objectName", "_customOffset", "_enableSim", "_enableDmg"];

// get placement and direction offset (We want to place it from edge to edge)
private "_spawnObjectLength";
private "_spawnObjectLengthOffset";
private "_spawnDirOffset";

private _objectParams = GVAR(drawBuildPresets) getOrDefault [_objectName, objNull];
if(_objectParams isEqualTo objNull) then {
	private _obj = createVehicle [_objectName, [0,0,0]];
	(boundingBoxReal _obj) params ["_min", "_max"];
	private _width = abs(_max#0-_min#0);
	private _length = abs(_max#1-_min#1);
	if(_width > _length) then {
		_length = _width;
		_spawnDirOffset = 90;
	} else {
		_spawnDirOffset = 0;
	};
	_spawnObjectLength = _length;
	_spawnObjectLengthOffset = _spawnObjectLength/2;
	deleteVehicle _obj;
} else {
	_spawnObjectLength = _objectParams#0;
	_spawnObjectLengthOffset = _objectParams#1;
	_spawnDirOffset = _objectParams#2;
};

private _parsedOffset = [_customOffset] call BIS_fnc_parseNumber;
if(_parsedOffset isNotEqualTo -1) then {
	_spawnObjectLength = _parsedOffset;
	_spawnObjectLengthOffset = _spawnObjectLength/2;
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


	if("Module" in _objectName) then {
		private _moduleGroup = createGroup sideLogic;
		_object = _objectName createUnit [
			_nextPos,
			_moduleGroup,
			QUOTE(this setVariable [ARR_3('BIS_fnc_initModules_disableAutoActivation',false,true)];)
		];
		_tempPos = _nextPos;
		continue;
	};

	// add some randomness to blood trails
	private _blood = ["BloodTrail_01_New_F","BloodSplatter_01_Small_New_F","BloodSplatter_01_Medium_New_F","BloodPool_01_Medium_New_F"];
	if(_objectName in _blood) then {
		_objectName = selectRandom _blood;
	};

	_object = createVehicle [_objectName, _nextPos, [], 0, "CAN_COLLIDE"];

	// Align to highest surface (via killzone_kid at https://community.bistudio.com/wiki/Position#PositionAGLS)
	// Mainly used to enable laying of sandbags on top of a building - easiest to do when looking directly down
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
