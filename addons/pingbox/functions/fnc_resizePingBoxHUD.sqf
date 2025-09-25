#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Dive
			   
File: fnc_resizePingBoxHUD.sqf
Parameters: 
	0 - number of rows/pings the hud should be able to display
Return: none

Resizes the pingbox HUD according to the current CBA settings

[5] call crowsza_fnc_resizePingBoxHUD

*///////////////////////////////////////////////

params ["_numRows"];

//get display
private _display = uiNamespace getVariable "crowsza_pingbox_hud";

private _size = GVAR(CBA_Setting_Pingbox_Size); // from CBA setting
private _newHeight = (_size / 3) * (0.066 * safezoneH);

// update list + background height
{
	private _ctrl = _display displayCtrl _x;
	if (!isNull _ctrl) then {
		private _pos = ctrlPosition _ctrl;
		if !((_pos select 3) isEqualTo _newHeight) then { // only update if different
			_pos set [3, _newHeight];
			_ctrl ctrlSetPosition _pos;
			_ctrl ctrlCommit 0;
		};
	};
} foreach [IDC_PINGBOX_LIST, IDC_PINGBOX_BACKGROUND];

GVAR(currentSize) = _numRows;