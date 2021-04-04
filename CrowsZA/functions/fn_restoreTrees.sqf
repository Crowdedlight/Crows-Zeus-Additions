/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_restoreTrees.sqf
Parameters: position and radius
Return: none

Restores trees in that area

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_radius", 5, [0]], "_treeRemoval", "_bushRemoval", "_stoneRemoval"];

//pos change to AGL for nearestTerrainObjects function
_posAGL = ASLToAGL _pos;

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

// these are the main classes of objects
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
diag_log format["crowsZA-restoreTrees: showing %1 objects", count _hideTObjs];

// remote exec on server side, has to be with [argument, code] and "spawn" otherwise it doesn't work properly...
[_hideTObjs,{{_x hideObjectGlobal false} foreach _this}] remoteExec ["spawn",2]; 