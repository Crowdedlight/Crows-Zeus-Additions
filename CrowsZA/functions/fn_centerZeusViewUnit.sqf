/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_centerZeusViewUnit.sqf
Parameters: Hovered Entity
Return: none

Set zeus view to follow unit until deselected

*///////////////////////////////////////////////
params ["_entity"];

//local execution, deselecting the unit makes it stop following. wasd can be used to change heights etc while following. 
curatorCamera camSetTarget _entity; 
curatorCamera camSetRelPos [0,-13,0]; 
curatorCamera camCommit 0;

//todo might be enough to just add eventhandler that updates the relative point of the cam, test it out. 
