/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_drawBuildZeus.sqf
Parameters:
Return: none

Starts the selection handler to select multiple points for you to draw

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// todo future, have dialog of build settings etc. 

//no return function as we build in segments with selectPosition 
[_pos, {}] call crowsZA_fnc_drawBuildSelectPosition;
