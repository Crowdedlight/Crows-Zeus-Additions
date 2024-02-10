#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_drawBuildZeus.sqf
Parameters:
Return: none

Starts the selection handler to select multiple points for you to draw

*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _drawPresets = [keys GVAR(drawBuildPresets), [], { getText(configfile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy;

private _objects = [];
private _prettyNames = [];
{
    private _displayName = getText (configfile >> "CfgVehicles" >> _x >> "displayName");
    private _picture = getText (configFile >> "CfgVehicles" >> _x >> "editorPreview");
    if !(fileExists _picture) then { _picture = getText (configFile >> "CfgVehicles" >> _x >> "icon") };
    if !(fileExists _picture) then { _picture = getText (configFile >> "CfgVehicles" >> _x >> "picture") };

    _objects pushBack _x;
    _prettyNames pushBack [_displayName, "", _picture];

} forEach _drawPresets;


// Get the offset of the first (alphabetical) object, to populate the default for the appropriate field
private _firstObject = ([keys GVAR(drawBuildPresets), [], { getText(configfile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy)#0;
private _initialOffset = str((GVAR(drawBuildPresets) get _firstObject)#0);

[
	"Draw Build", 
	[
		["EDIT","Filter",["", {

			private _filter = _this;
			private _filteredObjects = (keys GVAR(drawBuildPresets) select { ([_filter, getText(configfile >> "CfgVehicles" >> _x >> "displayName")] call BIS_fnc_inString) });
			_filteredObjects = [_filteredObjects, [], { getText(configfile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy;

			private _listbox = (allControls (uiNamespace getVariable "zen_common_display")) select { ctrlType _x == 5} select 0;
			lbClear _listbox;
			private _index = 0;
			{
				_listbox lbAdd getText(configfile >> "CfgVehicles" >> _x >> "displayName");
			    _listbox lbSetPicture [_index, getText(configfile >> "CfgVehicles" >> _x >> "editorPreview")];
			    _listbox setVariable [str _index, _x];
			    _index = _index+1;
			} forEach _filteredObjects;


			// TODO: this duplicates the code below - move to a function?
			// There's got to be a better way than this
			private _edit = (allControls (uiNamespace getVariable "zen_common_display")) select { ctrlType _x == 2} select 2;

			// Surely a better way to do this too
			((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
			private _values = _controls apply {
			    _x params ["_controlsGroup", "_settings"];
			    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
			};

			private _object = _values#1;	
			private _offset = (GVAR(drawBuildPresets) get _object)#0;
			if(isNil "_offset") then { _offset = "ERROR"; }; // This should never be nil if we've setup the presets correctly, but just in case...
			_edit ctrlSetText format ["%1", _offset];

			_this
		}], true],
		["LIST","Object",[_objects, _prettyNames, 0, 15]],
		["EDIT",["Custom Object", "classname of an object to be used"+endl+"The smaller the object, the more will be created"+endl+"Warning: behaviour is experimental and not guaranteed!"],["", {}]],
		["EDIT",["Offset", "Distance to offset each object by"+endl+"Smaller distance results in overlapping objects; larger distance results in spacing between objects"+endl+"Leave empty for default offset"],[_initialOffset, {}]],
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
	private _edit = (allControls (uiNamespace getVariable "zen_common_display")) select { ctrlType _x == 2} select 2;

	// Surely a better way to do this too
	((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
	private _values = _controls apply {
	    _x params ["_controlsGroup", "_settings"];
	    [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
	};

	private _object = _values#1;	
	private _offset = (GVAR(drawBuildPresets) get _object)#0;
	if(isNil "_offset") then { _offset = ""; }; // This should never be nil if we've setup the presets correctly, but just in case...
	_edit ctrlSetText format ["%1", _offset]; 
}];
