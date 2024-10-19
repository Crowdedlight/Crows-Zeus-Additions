#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_drawBuildSelectPosition.sqf
Parameters:
Return: none

handles selection of multiple points to draw lines between them

Inspired by how ZEN handles selection with teleport player

*///////////////////////////////////////////////
params ["_dialogResult","_in"];
_dialogResult params ["_filter", "_object", "_customObject", "_enableSim", "_enableDmg"];

// exit if instance is already running
if (GVAR(selectPositionActive)) exitWith {};

// exit if custom class isn't recognised
if(_customObject isNotEqualTo "") then { _object = _customObject; };

if(! isClass (configFile >> "CfgVehicles" >> _object)) exitWith {
    hint parseText format [localize "STR_CROWSZA_Drawbuild_error_unknown_object", _object];
};


// set as active 
GVAR(selectPositionActive) = true;

// global vars, as we need to update between event calls
GVAR(startPos) = [];

// icon vars
private _angle = 45;
private _colour = [0.28, 0.78, 0.96, 1]; //xcom blue
private _icon = "\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa";
private _text = localize "STR_CROWSZA_Drawbuild_build_to_here";
private _textStart = localize "STR_CROWSZA_Drawbuild_start_pos";

// display vars 
private _display = findDisplay IDD_RSCDISPLAYCURATOR;
private _visuals = [_text, _icon, _angle, _colour, _textStart];

// mouse eventhandler to get clicks/positions
private _mouseEH = [_display, "MouseButtonDown", {
    params ["", "_button", "", "", "_shift", "_ctrl", "_alt"];

	// if not leftclick
    if (_button != 0) exitWith {};

	// get position clicked
    private _position = [] call FUNC(getPosFromMouse);

    // check if first position, and set start point
    if ((count GVAR(startPos)) != 0) then {
        // get extra options
        _thisArgs params ["_object", "_enableSim", "_enableDmg"];

        // call build function 
        [GVAR(startPos), _position, _object, _enableSim, _enableDmg] call FUNC(drawBuild);   
    };

    // set start pos to new pos 
    GVAR(startPos) = _position;

}, [_object, _enableSim, _enableDmg]] call CBA_fnc_addBISEventHandler;

// eventhandler to register ESC/space so we can end selection
private _keyboardEH = [_display, "KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

	// exit if key is not ESC or space
    if (_key != DIK_ESCAPE && _key != DIK_SPACE && _key != DIK_R) exitWith {false};

    // if space reset start position, so we can do multiple segments. 
    if (_key == DIK_SPACE) then {
        // reset start position
        GVAR(startPos) = [];
    };

    // if R select new object
    if (_key == DIK_R) then {
        GVAR(selectPositionActive) = false;
        // relaunch module, the time it takes to select a new object should make sure the previous eventhandlers are removed
        [] call FUNC(drawBuildZeus);
    };

    // if ESCAPE
    if (_key == DIK_ESCAPE) then {
        // if ESC, setting instance to false
        GVAR(selectPositionActive) = false;
    };

    //todo, maybe add so if R, we go back to object select screen?

    true // handled
}, []] call CBA_fnc_addBISEventHandler;

// main handler
[{
    params ["_args", "_pfhID"];
    _args params ["_visuals", "_mouseEH", "_keyboardEH", "_drawEH"];

    // End selection with failure if an object is deleted, Zeus display is closed, or pause menu is opened
	if (isNull findDisplay IDD_RSCDISPLAYCURATOR || !isNull findDisplay IDD_INTERRUPT) then {
        GVAR(selectPositionActive) = false;
    };

    // If no longer actice, exit and remove event handlers
    if (!GVAR(selectPositionActive)) exitWith {
        private _display = findDisplay IDD_RSCDISPLAYCURATOR;
		// mouse and keyboard
        _display displayRemoveEventHandler ["MouseButtonDown", _mouseEH];
        _display displayRemoveEventHandler ["KeyDown", _keyboardEH];

		// clear global vars
		GVAR(startPos) = []; 

		// remove myself
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };

    // only draw 3D if map is not visible
    if (visibleMap) exitWith {};

	// get current pos to draw as pointer
    private _currPos = [] call FUNC(getPosFromMouse);
    _visuals params ["_text", "_icon", "_angle", "_color", "_textStart"];
    
	// convert to AGL for drawing
	_currPos = ASLToAGL _currPos;
    
	// draw from start pos, only if we got start pos
    if ((count GVAR(startPos) ) > 0) then {
        private _startPos = ASLToAGL GVAR(startPos) ;

        // draw start pos icon in 3D
        drawIcon3D [_icon, _color, _startPos, 1, 1, _angle, _textStart];

        // draw line between the positions 
        drawLine3D [_startPos, _currPos, _color];	

        // draw current icon in 3D, xcom blue
        drawIcon3D [_icon, _color, _currPos, 1.5, 1.5, _angle, _text];
        
    } else {
        // draw start pos icon
        drawIcon3D [_icon, _color, _currPos, 1.5, 1.5, _angle, _textStart];
    };

}, 0, [_visuals, _mouseEH, _keyboardEH]] call CBA_fnc_addPerFrameHandler;
