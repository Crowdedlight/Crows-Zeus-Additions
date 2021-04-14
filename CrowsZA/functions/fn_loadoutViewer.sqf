/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_loadoutViewer.sqf
Parameters: Hovered Entity
Return: none

shows the loadout of the unit in an quick view

*///////////////////////////////////////////////
params ["_entity"];

//create display 
if (!createDialog crowsZA_loadout_display) exitWith {};

//get display
private _display = uiNamespace getVariable "crowsZA_loadout_display";

//get common info, weight, name etc.
private _displayName = name _entity;
private _weightABS = (loadAbs _entity) * 0.1;
private _weightKG = (round (_weightABS * (1/2.2046) * 100)) / 100;

// save object that is selected 
_display setVariable ["crowsZA_loadout_viewer_unit", _entity];

// Set the display's title to the object name
private _ctrlTitle = _display displayCtrl IDC_TITLE;
_ctrlTitle ctrlSetText toUpper format ["See Loadout - %1", _displayName];


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

// Handle adding/removing items using the list buttons
// private _ctrlButtonAdd = _display displayCtrl IDC_BTN_ADD;
// _ctrlButtonAdd ctrlAddEventHandler ["ButtonClick", {
//     params ["_ctrlButtonAdd"];

//     private _display = ctrlParent _ctrlButtonAdd;
//     [_display, true] call FUNC(modify);
// }];

// private _ctrlButtonRemove = _display displayCtrl IDC_BTN_REMOVE;
// _ctrlButtonRemove ctrlAddEventHandler ["ButtonClick", {
//     params ["_ctrlButtonRemove"];

//     private _display = ctrlParent _ctrlButtonRemove;
//     [_display, false] call FUNC(modify);
// }];


// Update add/remove buttons when list selection changes
// _ctrlList ctrlAddEventHandler ["LBSelChanged", {
//     params ["_ctrlList"];

//     private _display = ctrlParent _ctrlList;
//     [_display, true] call FUNC(update);
// }];

// Confirm changes to the inventory when the OK button is clicked
// private _ctrlButtonOK = _display displayCtrl IDC_OK;
// _ctrlButtonOK ctrlAddEventHandler ["ButtonClick", {call FUNC(confirm)}];

// Initialize the list sorting modes
private _ctrlSorting = _display displayCtrl IDC_SORTING;
[_ctrlSorting, _ctrlList, [1, 2]] call EFUNC(common,initListNBoxSorting);

// Initially populate the list with items
[_display] call crowsZA_fnc_loadoutRefresh;