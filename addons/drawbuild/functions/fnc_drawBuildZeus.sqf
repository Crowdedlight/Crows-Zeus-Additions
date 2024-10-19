#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
               
File: fnc_drawBuildZeus.sqf
Parameters:
Return: none

Starts the selection handler to select multiple points for you to draw

*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

FUNC(updateDrawBuildUI) = {
    // Get the third editbox
    private _edit = (allControls (uiNamespace getVariable "zen_common_display")) select { ctrlType _x == 2} select 2;

    // Get the ZEN-stored values
    ((uiNamespace getVariable "zen_common_display") getVariable "zen_dialog_params") params ["_controls", "_onConfirm", "_onCancel", "_args", "_saveID"];
    private _values = _controls apply {
        _x params ["_controlsGroup", "_settings"];
        [_controlsGroup, _settings] call (_controlsGroup getVariable "zen_dialog_fnc_value")
    };

    // Update the editbox with the new value
    private _object = _values#1;    
    private _offset = (GVAR(drawBuildPresets) get _object)#0;
    if(isNil "_offset") then { _offset = ""; };
    _edit ctrlSetText str _offset;
};

private _drawPresets = [keys GVAR(drawBuildPresets), [], { getText(configFile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy;

private _objects = [];
private _prettyNames = [];
{
    private _displayName = getText (configFile >> "CfgVehicles" >> _x >> "displayName");
    private _picture = getText (configFile >> "CfgVehicles" >> _x >> "editorPreview");
    if !(fileExists _picture) then { _picture = getText (configFile >> "CfgVehicles" >> _x >> "icon") };
    if !(fileExists _picture) then { _picture = getText (configFile >> "CfgVehicles" >> _x >> "picture") };

    _objects pushBack _x;
    _prettyNames pushBack [_displayName, "", _picture];

} forEach _drawPresets;


// Get the offset of the first (alphabetical) object, to populate the default for the appropriate field
private _firstObject = ([keys GVAR(drawBuildPresets), [], { getText(configFile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy)#0;
private _initialOffset = str((GVAR(drawBuildPresets) get _firstObject)#0);

[
    localize "STR_CROWSZA_Drawbuild_module_name", 
    [
        ["EDIT",localize "STR_CROWSZA_Drawbuild_filter",["", {
            private _filter = _this;
            private _filteredObjects = (keys GVAR(drawBuildPresets) select { ([_filter, getText(configFile >> "CfgVehicles" >> _x >> "displayName")] call BIS_fnc_inString) });
            _filteredObjects = [_filteredObjects, [], { getText(configFile >> "CfgVehicles" >> _x >> "displayName") }] call BIS_fnc_sortBy;

            private _listbox = (allControls (uiNamespace getVariable "zen_common_display")) select { ctrlType _x == 5} select 0;
            lbClear _listbox;
            private _index = 0;
            {
                _listbox lbAdd getText(configFile >> "CfgVehicles" >> _x >> "displayName");
                private _picture = getText (configFile >> "CfgVehicles" >> _x >> "editorPreview");
                if !(fileExists _picture) then { _picture = getText (configFile >> "CfgVehicles" >> _x >> "icon") };
                if !(fileExists _picture) then { _picture = getText (configFile >> "CfgVehicles" >> _x >> "picture") };
                _listbox lbSetPicture [_index, _picture];
                _listbox setVariable [str _index, _x];
                _index = _index+1;
            } forEach _filteredObjects;

            call FUNC(updateDrawBuildUI);

            _this
        }], true],
        ["LIST",localize "STR_CROWSZA_Drawbuild_objects_to_build",[_objects, _prettyNames, 0, 15]],
        ["EDIT",[localize "STR_CROWSZA_Drawbuild_custom_object",(localize "STR_CROWSZA_Drawbuild_custom_object_tooltip") regexReplace ["<br/>",endl]],["", {}]],
        ["EDIT",[localize "STR_CROWSZA_Drawbuild_custom_offset",(localize "STR_CROWSZA_Drawbuild_custom_offset_tooltip") regexReplace ["<br/>",endl]],[_initialOffset, {}]],
        // TODO: also add a "Custom Rotation" editbox, for custom objects with unusual rotations
        ["CHECKBOX",localize "STR_CROWSZA_Drawbuild_enable_simulation",false],
        ["CHECKBOX",localize "STR_CROWSZA_Drawbuild_enable_damage",false]
    ],
    FUNC(drawBuildSelectPosition),
    {},
    _this
] call zen_dialog_fnc_create;


private _allControls = allControls (uiNamespace getVariable "zen_common_display");
private _listbox = _allControls select { ctrlType _x == 5} select 0;
_listbox ctrlAddEventHandler ["LBSelChanged", FUNC(updateDrawBuildUI)];
