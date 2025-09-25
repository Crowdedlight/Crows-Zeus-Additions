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

params ["_desiredSize"];

private _resizeCtrl = {
	params ["_id", "_pos"];
	private _display = uiNamespace getVariable "crowsza_pingbox_hud";
	private _ctrl = _display displayCtrl _id;
	
	if (!isNull _ctrl) then {
		_ctrl ctrlSetPosition _pos;
		_ctrl ctrlCommit 0;
	};
};

// If the list size is more than 3 we need to move pingbox up a bit
private _extraSize = _desiredSize - PINGBOX_SIZE_DEFAULT;
private _yOffset = _extraSize * PINGBOX_LINE_HEIGHT;

private _posList = [
	PINGBOX_POS_X_DEFAULT * safezoneW + safezoneX,
	(PINGBOX_POS_Y_DEFAULT - _yOffset) * safezoneH + safezoneY,
	PINGBOX_WIDTH_DEFAULT * safezoneW,
	PINGBOX_LINE_HEIGHT * _desiredSize * safezoneH
];

[IDC_PINGBOX_LIST, _posList] call _resizeCtrl;
[IDC_PINGBOX_BACKGROUND, _posList] call _resizeCtrl;

private _posTitle = [
	PINGBOX_POS_X_DEFAULT * safezoneW + safezoneX,
	(PINGBOX_POS_Y_DEFAULT - _yOffset - PINGBOX_LINE_HEIGHT) * safezoneH + safezoneY,
	PINGBOX_WIDTH_DEFAULT * safezoneW,
	PINGBOX_LINE_HEIGHT * safezoneH
];

[IDC_PINGBOX_TITLE, _posTitle] call _resizeCtrl;

GVAR(currentSize) = _desiredSize;
GVAR(ping_list) = [];
GVAR(ping_list_update) = 0;

private _display = uiNamespace getVariable "crowsza_pingbox_hud";

//get list 
private _ctrlList = _display displayCtrl IDC_PINGBOX_LIST;

// clear list 
lnbClear _ctrlList;