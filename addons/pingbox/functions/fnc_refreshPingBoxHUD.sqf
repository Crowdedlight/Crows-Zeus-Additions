#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_refreshPingBoxHUD.sqf
Parameters: 
Return: none

refreshes hud based on array. Should be called every 0.8s for proper second update

call crowsza_fnc_refreshPingBoxHUD;

*///////////////////////////////////////////////

// if we are faded, don't bother updating
if (GVAR(faded)) exitWith {};
// if in screenshot mode, don't bother updating
if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false]) exitWith {};

// if fadeout setting is set and we should fade, fade and exit the call.
private _fadeDiff = time - GVAR(ping_list_update);
if (GVAR(CBA_Setting_fade_enabled) && _fadeDiff > GVAR(CBA_Setting_fade_duration) && !GVAR(faded)) exitWith {
	// fade it out 
	QGVAR(layer) cutFadeOut 2;

	// set as faded
	GVAR(faded) = true;
};

//get display
private _display = uiNamespace getVariable "crowsza_pingbox_hud";

//--- DYNAMIC HEIGHT UPDATE ---
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

// check if anything to draw 
if (count GVAR(ping_list) == 0) exitWith {};

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
	if (_timeDiff > GVAR(CBA_Setting_oldLimit)) then {
		_delArr pushBack _x;
		continue;
	};

	private _index = _ctrlList lnbAddRow [_name, format["%1s",_timeDiff]];
	_ctrlList lnbSetColor   [[_index, 0], [1, 1, 1, 1]];
	_ctrlList lnbSetColor   [[_index, 1], [1, 1, 1, 1]];
	_ctrlList lnbSetValue   [[_index, 1], _timeDiff];
	_ctrlList lnbSetData    [[_index, 0], _name];

} forEach GVAR(ping_list);

// delete entries that is over the time threshold
if (count _delArr > 0) then {
	GVAR(ping_list) = GVAR(ping_list) - _delArr;	
};
