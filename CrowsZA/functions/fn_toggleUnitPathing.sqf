/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_toggleUnitPathing.sqf
Parameters: 
	unit 	- (unit) the unit to act on
	action 	- (int)
		0 - disable pathing
		1 - enable pathing
		2 - toggle pathing
Return: success (bool)

Toggle pathing for the passed unit

*///////////////////////////////////////////////

params ["_unit", "_action"];

if (!local _unit || _action < 0 || _action > 2) exitWith { false };

switch(_action) do {
	case 0: { _unit disableAI "PATH"; };
	case 1: { _unit enableAI "PATH"; };
	default {
		if(_unit checkAIFeature "PATH") then {
			_unit disableAI "PATH";
		} else {
			_unit enableAI "PATH";
		}
	};
};

true