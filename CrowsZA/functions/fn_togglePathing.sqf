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

	switch(_action) do {
		case 0: { _x disableAI "PATH"; };
		case 1: { _x enableAI "PATH"; };
		default {
			if(_x checkAIFeature "PATH") then {
				_x disableAI "PATH";
			} else {
				_x enableAI "PATH";
			}
		};
	};	
} forEach _units;


true