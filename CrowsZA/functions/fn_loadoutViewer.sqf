#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_loadoutViewer.sqf
Parameters: Hovered Entity
Return: none

shows the loadout of the unit in an quick view

*///////////////////////////////////////////////
params ["_entity"];

//create display 
if (!createDialog "crowsZA_loadout_display") exitWith {};

//get display
private _display = uiNamespace getVariable "crowsZA_loadout_display";

// save object that is selected 
_display setVariable ["crowsZA_loadout_viewer_unit", _entity];

//use ZENs method to init display posisions. I can use it as I should have same base setup as ZEN uses in their gui
[_display] call zen_common_fnc_initDisplayPositioning;

//get common info, weight, name etc.
private _displayName = name _entity;

// Set the display's title to the object name
private _ctrlTitle = _display displayCtrl IDC_TITLE;
_ctrlTitle ctrlSetText toUpper format ["Loadout - %1", _displayName];

// Refresh the items list when the search field changes
// private _ctrlSearchBar = _display displayCtrl IDC_SEARCH_BAR;
// _ctrlSearchBar ctrlAddEventHandler ["KeyUp", {
//     params ["_ctrlSearchBar"];

//     private _display = ctrlParent _ctrlSearchBar;
//     [_display] call FUNC(refresh);
// }];

// Clear search when the search bar is right clicked
// _ctrlSearchBar ctrlAddEventHandler ["MouseButtonClick", {
//     params ["_ctrlSearchBar", "_button"];

//     if (_button != 1) exitWith {};

//     _ctrlSearchBar ctrlSetText "";
//     ctrlSetFocus _ctrlSearchBar;

//     private _display = ctrlParent _ctrlSearchBar;
//     [_display] call FUNC(refresh);
// }];

// Clear search when the search button is clicked
// private _ctrlButtonSearch = _display displayCtrl IDC_BTN_SEARCH;
// _ctrlButtonSearch ctrlAddEventHandler ["ButtonClick", {
//     params ["_ctrlButtonSearch"];

//     private _display = ctrlParent _ctrlButtonSearch;
//     private _ctrlSearchBar = _display displayCtrl IDC_SEARCH_BAR;
//     _ctrlSearchBar ctrlSetText "";
//     ctrlSetFocus _ctrlSearchBar;

//     [_display] call FUNC(refresh);
// }];

// Initially populate the list with items
[_display] call crowsZA_fnc_loadoutRefresh;