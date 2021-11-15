#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_refreshPingBoxHUD.sqf
Parameters: 
Return: none

refreshes hud based on array. Should be called every 0.8s for proper second update

call crowsZA_fnc_refreshPingBoxHUD;

*///////////////////////////////////////////////

// if we are faded, don't bother updating
if (crowsZA_pingbox_faded) exitWith {};
// if in screenshot mode, don't bother updating
if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false]) exitWith {};

// if fadeout setting is set and we should fade, fade and exit the call.
private _fadeDiff = time - crowsZA_pingbox_list_update;
if (crowsZA_CBA_Setting_pingbox_fade_enabled && _fadeDiff > crowsZA_CBA_Setting_pingbox_fade_duration && !crowsZA_pingbox_faded) exitWith {
	// fade it out 
	"crowsZA_pingbox_layer" cutFadeOut 2;

	// set as faded
	crowsZA_pingbox_faded = true;
};

// check if anything to draw 
if (count crowsZA_pingbox_list == 0) exitWith {};

//get display
private _display = uiNamespace getVariable "crowsZA_pingbox_hud";

//get list 
private _ctrlList = _display displayCtrl IDC_PINGBOX_LIST;

// clear list 
lnbClear _ctrlList;

private _delArr = [];
// add new entry
{
	_x params ["_player", "_pingtime"];
	private _timeDiff = round(time - _pingtime);
	private _name = name _player;

	// if we are over the set threshold, we should not draw and remove instead
	if (_timeDiff > crowsZA_CBA_Setting_pingbox_oldLimit) then {
		_delArr pushBack _x;
		continue;
	};

	private _index = _ctrlList lnbAddRow [_name, format["%1s",_timeDiff]];
	_ctrlList lnbSetColor   [[_index, 0], [1, 1, 1, 1]];
	_ctrlList lnbSetColor   [[_index, 1], [1, 1, 1, 1]];
	_ctrlList lnbSetValue   [[_index, 1], _timeDiff];
	_ctrlList lnbSetData    [[_index, 0], _name];

} forEach crowsZA_pingbox_list;

// delete entries that is over the time threshold
if (count _delArr > 0) then {
	crowsZA_pingbox_list = crowsZA_pingbox_list - _delArr;	
};
