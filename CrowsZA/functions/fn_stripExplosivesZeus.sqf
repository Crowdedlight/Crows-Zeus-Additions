/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_stripExplosivesZeus.sqf
Parameters: pos, unit
Return: none

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _sideOrGroup = if(isNull _unit) then { east } else { true };

[_unit, [_sideOrGroup, true, 1, 0, "", 0], true] call crowsZA_fnc_constructstripExplosivesDialog;