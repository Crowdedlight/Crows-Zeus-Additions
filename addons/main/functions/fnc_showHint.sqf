#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_showHint.sqf
Parameters: message, silent
Return: none

show hint for the zeus

*///////////////////////////////////////////////
params ["_msg", "_silent"];

if (_silent) then {
	hintSilent (_msg call BIS_fnc_localize);
} else {
	hint (_msg call BIS_fnc_localize);
};
