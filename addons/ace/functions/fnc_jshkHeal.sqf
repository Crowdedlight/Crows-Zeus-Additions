#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_jshkHeal.sqf
Parameters: pos
Return: none

heals all players in a radius around the spot clicked

*///////////////////////////////////////////////
params ["_unit"];

[_unit, false] call ace_medical_status_fnc_setUnconsciousState;
[_unit, false] call ace_medical_status_fnc_setCardiacArrestState;

