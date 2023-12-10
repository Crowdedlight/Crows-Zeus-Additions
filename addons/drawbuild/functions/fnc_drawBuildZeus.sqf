#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_drawBuildZeus.sqf
Parameters:
Return: none

Starts the selection handler to select multiple points for you to draw

*///////////////////////////////////////////////
#define SCALE_NORMAL   1
#define SCALE_SELECTED 1.2

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];


// array of "options" to build with
private _arrOptions = [
	"Land_HBarrier_3_F",					//hesco default
	"Land_HBarrier_Big_F",					//big hesco default
	"Land_BagFence_Short_F",				//sandbag wall - default
	"Land_SandbagBarricade_01_F",			//tall sandbags
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
	"Land_Razorwire_F",						//razor wire

	//misc.
	"PowerCable_01_StraightLong_F",			//power cable
	"BloodTrail_01_New_F", 					//blood trail
	"Land_Sign_MinesDanger_Greek_F"			//minefield sign
];

// only add grad trenches if that mod is loaded
private _hasGradTrench = isClass (configFile >> "CfgPatches" >> "grad_trenches_main");
if (_hasGradTrench) then {
	_arrOptions pushBack "fort_envelopebig";
};

// TODO: sort by display name? Or by category?
_arrOptions = [_arrOptions, [], { getText(configfile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy;

private _objects = [];
private _prettyNames = [];
{
    private _displayName = getText(configfile >> "CfgVehicles" >> _x >> "displayName");
    private _picture = getText(configfile >> "CfgVehicles" >> _x >> "editorPreview");

    _objects pushBack _x;
    _prettyNames pushBack [_displayName, "", _picture];

} forEach _arrOptions;

[
	"Draw Build", 
	[
		["LIST","Object",[_objects, _prettyNames, 0, 15]],
		["EDIT",["Custom Object", "classname of an object to be used"+endl+"The smaller the object, the more will be created"+endl+"Warning: behaviour is experimental and not guaranteed!"],["", {}]],
		["EDIT",["Offset", "Distance to offset each object by"+endl+"Smaller distance results in overlapping objects; larger distance results in spacing between objects"+endl+"Leave empty for default offset"],["1.7", {}]],
		["CHECKBOX","Enable simulation",true],
		["CHECKBOX","Enable damage",true]
	],
	FUNC(drawBuildSelectPosition),
	{},
	_this
] call zen_dialog_fnc_create;


private _allControls = allControls (uiNamespace getVariable "zen_common_display");
private _listbox = _allControls select { ctrlType _x == 5} select 0;
_listbox ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	// There's got to be a better way than this
	private _edit = (allControls (uiNamespace getVariable "zen_common_display")) select { ctrlType _x == 2} select 1;

	// Surely a better way to do this too
	((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
	private _values = _controls apply {
	    _x params ["_controlsGroup", "_settings"];
	    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
	};

	private _object = _values#0;	
	private _offset = ([_object] call FUNC(getDrawBuildPresets))#0;
	if(isNil "_offset") then { _offset = ""; }; // This should never be nil if we've setup the presets correctly, but just in case...
	_edit ctrlSetText format ["%1", _offset]; 
}];
