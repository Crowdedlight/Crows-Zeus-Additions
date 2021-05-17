/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: drawBuild.sqf
Parameters: positions, (FUTURE: what object to use for building)
Return: none

builds objects along the drawn line 

*///////////////////////////////////////////////
params ["_positions"];

diag_log _positions;

// get hesco name 
// get hesco placement offset (We want to place it from edge to edge)

//look through pos (start at 1)
	//calculate distance between points to know amount of hesco to cover the length - https://community.bistudio.com/wiki/vectorDistance
	//calculate the angle between points, so we can rotate each hesco correctly - https://community.bistudio.com/wiki/vectorCos (Not sure if this is right angle I get? redo vector maths)

	//vector maths for calculations https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors

	// loop over the amount of hesco needed to be placed (distance calculation)
		//spawn hesco - https://community.bistudio.com/wiki/createVehicle
		//rotate it - https://community.bistudio.com/wiki/setVectorDir 
		//add to zeus editable objects
	

{
	
} forEach _positions;