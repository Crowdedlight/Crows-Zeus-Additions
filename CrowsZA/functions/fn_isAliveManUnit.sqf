/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_isAliveManUnit.sqf
Parameters: _unit
Return: none

Checks if unit object, is not null and is alive. Required to filter away if right-clicked on group as the other if-checks dont work with group

*///////////////////////////////////////////////
params ["_unit"];

// check if object and not group
private _result = false;

// check if not group, before 
if (typeName _unit != "OBJECT") exitWith { _result = false; _result;};

if (!isNull _unit && alive _unit && _unit isKindOf "CAManBase") then {
	_result = true;
};
_result;