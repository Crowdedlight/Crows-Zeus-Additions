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

// using false to restore objects. RemoteExec to run on server, as the command is designed to automatically add to JIP and for all connected clients
[{ _x hideObjectGlobal false } foreach (nearestTerrainObjects [_posAGL,["TREE", "SMALL TREE", "BUSH"],_radius])] remoteExec ["spawn", 2, false];