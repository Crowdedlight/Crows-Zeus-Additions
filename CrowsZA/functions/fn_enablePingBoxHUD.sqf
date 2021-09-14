#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_enablePingBoxHUD.sqf
Parameters: 
Return: none

Enables and displays the pingbox hud

*///////////////////////////////////////////////
//create hud 
("crowsZA_pingbox_layer" call BIS_fnc_rscLayer) cutRsc ["crowsZA_pingbox_hud","PLAIN"]; // show
// ("myLayerName" call BIS_fnc_rscLayer) cutText ["","PLAIN"]; // remove

//get display
private _display = uiNamespace getVariable "crowsZA_pingbox_hud";

//get list 
private _ctrlList = _display displayCtrl IDC_PINGBOX_LIST;
lnbClear _ctrlList;

private _name = "tester";
private _timeSince = "20";
private _alpha = 1;

private _index = _ctrlList lnbAddRow [_name, _timeSince];
_ctrlList lnbSetColor   [[_index, 0], [1, 1, 1, _alpha]];
_ctrlList lnbSetColor   [[_index, 1], [1, 1, 1, _alpha]];
_ctrlList lnbSetValue   [[_index, 1], _timeSince];
_ctrlList lnbSetData    [[_index, 0], _name];
