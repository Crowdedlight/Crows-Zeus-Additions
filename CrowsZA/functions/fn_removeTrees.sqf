/*/////////////////////////////////////////////////
Author: Crowdedlight + Windwalker
			   
File: fn_removeTrees.sqf
Parameters: position and radius
Return: none

Removes trees and folliage in the given area for all players and add it to the JIP queue to also work for "join-in-progress" players
JIP queue is cleaned on mission restarts

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_radius", 5, [0]], "_treeRemoval", "_bushRemoval", "_stoneRemoval"];

//pos change to AGL for nearestTerrainObjects function
_posAGL = ASLToAGL _pos;

//array to remove
private _hideTObjs = [];

//make list of main type to remove
private _hideMainTypes = [];
private _hideSubTypes = [];

//TREES
if (_treeRemoval) then {
	_hideMainTypes append ["TREE", "SMALL TREE"];
	_hideSubTypes append ["stump", "fallen"];
};
//BUSHES
if (_bushRemoval) then {
	_hideMainTypes append ["BUSH"];
};
//STONES
if (_stoneRemoval) then {
	_hideSubTypes append ["stone", "boulder"];
};

// these are the main classes of objects, only run if we have at least one selected, as it otherwise removes everything
if (count _hideMainTypes > 0) then {
	{ _hideTObjs pushBack _x } foreach (nearestTerrainObjects [_posAGL,_hideMainTypes,_radius]);
};

// but there are some other model names (unclassified) that we should clean up too
{ 
	private _tempValue = str(_x);
	//checks if any element on the _hideSubTypes array can be found in the object name for this iterations object. 
	if (_hideSubTypes findIf { (_tempValue find _x >= 0) } > -1) then {
		_hideTObjs pushBack _x;
	};

} foreach (nearestTerrainObjects [_posAGL,[],_radius]);

//log
diag_log format["crowsZA-removeTrees: Hiding %1 objects", count _hideTObjs];

// remote exec on server side, has to be with [argument, code] and "spawn" otherwise it doesn't work properly...
[_hideTObjs,{{_x hideObjectGlobal true} foreach _this}] remoteExec ["spawn",2]; 
