#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_removeOnDeathZeus.sqf
Parameters: pos, unit
Return: none

Removes Zeus-applied 'Killed' EHs from the passed unit (or object)

*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if(isNull _unit) exitWith { hint "Must be placed on a unit or object"; };

private _ehIndex = _unit getVariable ["crowza_onKilledEHIndex", nil];

if(isNil "_ehIndex") exitWith { hint "No on-Killed events to remove!"};

_unit removeMPEventHandler ["MPKilled", _ehIndex];

private _unitList = missionNamespace getVariable["crowza_onKilledEHUnits", []];
missionNamespace setVariable["crowza_onKilledEHUnits", _unitList-[_unit], true];
