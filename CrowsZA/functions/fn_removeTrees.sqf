/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_removeTrees.sqf
Parameters: position and radius
Return: none

Removes trees and folliage in the given area for all players and add it to the JIP queue to also work for "join-in-progress" players
JIP queue is cleaned on mission restarts

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_radius", 5, [0]]];

//pos change to AGL for nearestTerrainObjects function
_posAGL = ASLToAGL _pos;

//array to remove
private _hideTObjs = [];

// removal based on https://gist.github.com/coldnebo/ec1ff71a42fffa91def88e8aba2b66b2 
// these are the main classes of trees
{ _hideTObjs pushBack _x } foreach (nearestTerrainObjects [_posAGL,["TREE", "SMALL TREE", "BUSH"],_radius]);

// but there are some other model names (unclassified) that we should clean up too
{ 
	if ((str(_x) find "fallen" >= 0) || (str(_x) find "stump" >= 0) || (str(_x) find "stone" >= 0)) then 
	{ 
		_hideTObjs pushBack _x;
	};
} foreach (nearestTerrainObjects [_posAGL,[],_radius]);

//log
diag_log format["crowsZA-removeTrees: Hiding %1 objects", count _hideTObjs];

// remote exec on server side, has to be with [argument, code] and "spawn" otherwise it doesn't work properly...
[_hideTObjs,{{_x hideObjectGlobal true} foreach _this}] remoteExec ["spawn",2]; 