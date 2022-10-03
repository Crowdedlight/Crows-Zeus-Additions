/*/////////////////////////////////////////////////
Author: Crowdedlight

File: fn_isAliveManUnit.sqf
Parameters: _unit
Return: none

Checks if unit object, is not null and is alive. Required to filter away if right-clicked on group as the other if-checks dont work with group

*///////////////////////////////////////////////
params ["_unit"];

_unit isEqualType objNull && {alive _unit} && {_unit isKindOf "CAManBase"}
