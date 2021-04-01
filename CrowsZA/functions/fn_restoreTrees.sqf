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

//run on remoteExec for server as globalhide command is designed to clear it for all clients and JIP. 
[{ _x hideObjectGlobal false } foreach _hideTObjs] remoteExec ["spawn", 2, false];

