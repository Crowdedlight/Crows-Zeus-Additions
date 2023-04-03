/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_togglePathing.sqf
Parameters: 
	units 	- [unit] the units to act on
	action 	- int
		0 - disable pathing
		1 - enable pathing
		2 - toggle pathing
Return: success (bool)

Toggle pathing for the passed units

*///////////////////////////////////////////////

params [["_units",[],[[objNull]],[]], ["_action", 0, [0]]];

if(count _units == 0 || _action < 0 || _action > 2) exitWith { false };

{
	if(isPlayer _x) then { continue };
	[_x, _action] remoteExec ["crowsZA_fnc_toggleUnitPathing", _x];
} forEach _units;


true