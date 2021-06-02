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
	"Land_HBarrier_3_F",					//hesco default
	"Land_HBarrier_Big_F",					//big hesco default
	"Land_BagFence_Short_F",				//sandbag wall - default
	"Land_TyreBarrier_01_line_x4_F",		//tire wall
	"Land_ConcreteWall_01_m_4m_F", 			//concrete wall
	
	//tanoa sandbags
	"Land_HBarrier_01_line_3_green_F",		//tanoa hesco (green)
	"Land_HBarrier_01_big_4_green_F",		//big tanoa hesco 
	"Land_BagFence_01_short_green_F",		//tanoa sandbag wall
	"Land_Mil_WallBig_4m_F",				//military wall
	"Land_Fortress_01_5m_F",				//land fortress wall 5m

	//fences
	"Land_Hedge_01_s_2m_F",					//grass hedge
	"Land_NetFence_02_m_4m_F",				//net fence
	"Land_New_WiredFence_5m_F",				//wire fence
	"Land_Razorwire_F"						//razor wire
];

// only add grad trenches if that mod is loaded
private _hasGradTrench = isClass (configFile >> "CfgPatches" >> "grad_trenches_main");
if (_hasGradTrench) then {
	_arrOptions = _arrOptions + ["fort_envelopebig"]
};

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
            _thisArgs params ["_object", "_display"];

			// close dialog
			closeDialog 1;

			// get options for simulation and damage 
			private _ctrlSimCheckbox = _display displayCtrl IDC_CHECKBOX_SIMULATION;
			private _ctrlDmgCheckbox = _display displayCtrl IDC_CHECKBOX_DAMAGE;

			private _enableSim = cbChecked _ctrlSimCheckbox;
			private _enableDmg = cbChecked _ctrlDmgCheckbox;

			// start draw building
			[_object, _enableSim, _enableDmg] call crowsZA_fnc_drawBuildSelectPosition;
			
    }, [_mainItem, _display]] call CBA_fnc_addBISEventHandler;

} forEach _arrOptions;
