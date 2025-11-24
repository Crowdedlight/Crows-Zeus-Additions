#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_eventZeusStopRC.sqf
Parameters: unit
Return: 

fires locally when zeus stops RC an unit

*///////////////////////////////////////////////
params ["_unit"];

// always updates array with changes, as the toggle setting check happens in draw handler
private _rcUnits = missionNamespace getVariable[QGVAR(rcUnits), []];
// remove unit
_rcUnits = _rcUnits - [[_unit, name player]];
// remove duplicates by chance
_rcUnits = _rcUnits arrayIntersect _rcUnits;
// push update
missionNamespace setVariable[QGVAR(rcUnits), _rcUnits, true];
