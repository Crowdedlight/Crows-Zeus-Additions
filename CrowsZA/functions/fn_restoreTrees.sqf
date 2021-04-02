/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_restoreTrees.sqf
Parameters: position and radius
Return: none

Restores trees in that area

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_radius", 5, [0]]];

//pos change to AGL for nearestTerrainObjects function
_posAGL = ASLToAGL _pos;

private _hideTObjs = [];

// these are the main classes of folliage
{ _hideTObjs pushBack _x } foreach (nearestTerrainObjects [_posAGL,["TREE", "SMALL TREE", "BUSH"],_radius]);

// but there are some other model names (unclassified) that we should clean up too
{ 
	if ((str(_x) find "fallen" >= 0) || (str(_x) find "stump" >= 0) || (str(_x) find "stone" >= 0)) then 
	{ 
		_hideTObjs pushBack _x;
	} else {}; 
} foreach (nearestTerrainObjects [_posAGL,[],_radius]);

//log
diag_log format["crowsZA-restoreTrees: showing %1 objects", count _hideTObjs];

// remote exec on server side, has to be with [argument, code] and "spawn" otherwise it doesn't work properly...
[_hideTObjs,{{_x hideObjectGlobal false} foreach _this}] remoteExec ["spawn",2]; 