#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_eventZeusStartRC.sqf
Parameters: unit
Return: 

fires when zeus start to RC an unit.

*///////////////////////////////////////////////
params ["_unit"];

// always updates array with changes, as the toggle setting check happens in draw handler
private _rcUnits = missionNamespace getVariable["crowsZA_rcUnits", []];
_rcUnits pushBack _unit;
// remove duplicates by chance
_rcUnits = _rcUnits arrayIntersect _rcUnits;
// push update
missionNamespace setVariable["crowsZA_rcUnits", _rcUnits, true];
