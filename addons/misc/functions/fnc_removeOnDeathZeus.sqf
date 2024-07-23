#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fnc_removeOnDeathZeus.sqf
Parameters: pos, unit
Return: none

Removes Zeus-applied 'Killed' EHs from the passed unit (or object)

*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if(isNull _unit) exitWith { hint (localize "STR_CROWSZA_Misc_onkilled_error_unit"); };

private _ehIndex = _unit getVariable [QGVAR(OnKilledModuleEHIndex), nil];

if(isNil "_ehIndex") exitWith { hint (localize "STR_CROWSZA_Misc_onkilled_error_empty"); };

_unit removeMPEventHandler ["MPKilled", _ehIndex];

private _unitList = GETMVAR(GVAR(OnKilledModuleUnits),[]);
SETMVAR(GVAR(OnKilledModuleUnits),_unitList-[_unit]);
