#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_drawBuildZeus.sqf
Parameters:
Return: none

Starts the selection handler to select multiple points for you to draw

*///////////////////////////////////////////////
#define SCALE_NORMAL   1
#define SCALE_SELECTED 1.2

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//create display 
if (!createDialog "crowsZA_drawbuild_display") exitWith {["Failed to open drawbuild dialog"] call crowsZA_fnc_showHint};

//get display
private _display = uiNamespace getVariable "crowsZA_drawbuild_display";

//use ZENs method to init display posisions. I can use it as I should have same base setup as ZEN uses in their gui
[_display] call zen_common_fnc_initDisplayPositioning;

// save position that is selected 
// _display setVariable ["crowsZA_drawbuild_pos", _pos];

// array of "options" to build with
private _arrOptions = [
	"Land_HBarrier_3_F",
	"Land_HBarrier_Big_F",
	"Land_BagFence_Short_F"
	//trenches
	//green tanoa sandbags
];

//display all items
{
    private _mainItem = _x;

	// picture and name
    private _picture = getText(configfile >> "CfgVehicles" >> _mainItem >> "editorPreview");
    private _name = getText(configfile >> "CfgVehicles" >> _mainItem >> "displayName");

    private _tooltip = format ["%1", _name];
    // private _tooltip = format ["%1\n%2", _name, _mainItem];

	// put in object
	private _spot = IDC_ICON_GRID_FIRST + _forEachIndex;
	// get spot
	private _ctrlSpot = _display displayCtrl _spot;

	// set picture and tooltip
	_ctrlSpot ctrlSetText _picture;
	_ctrlSpot ctrlSetTooltip _tooltip;

	// handler for click on icon
	[_ctrlSpot, "ButtonClick", {
            params ["_ctrlSpot"];
            _thisArgs params ["_object"];

			// close dialog
			closeDialog 1;

			//todo change so we don't give first position, but selectPosition script expects to select the first point first, then goes into the loop. 

			// start draw building
			[_object] call crowsZA_fnc_drawBuildSelectPosition;
			
    }, [_mainItem]] call CBA_fnc_addBISEventHandler;

} forEach _arrOptions;
