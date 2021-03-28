/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_removeTrees.sqf
Parameters: position and radius
Return: none

Removes trees and folliage in the given area 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_radius", 5, [0]]]

// removal based on https://gist.github.com/coldnebo/ec1ff71a42fffa91def88e8aba2b66b2 
// these are the main classes of folliage
{ hideTObjs pushBack _x } foreach (nearestTerrainObjects [_pos,["TREE", "SMALL TREE", "BUSH"],_radius]);

// but there are some other model names (unclassified) that we should clean up too
{ if ((str(_x) find "fallen" >= 0) || 
(str(_x) find "stump" >= 0) || 
(str(_x) find "stone" >= 0)) then 
{ hideTObjs pushBack _x } else {}; } foreach (nearestTerrainObjects [_pos,[],_radius]);

// good, now hide them all
{ _x hideObjectGlobal true } foreach hideTObjs;