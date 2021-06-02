#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: drawBuildSelectPosition.sqf
Parameters:
Return: none

handles selection of multiple points to draw lines between them

Inspired by how ZEN handles selection with teleport player

*///////////////////////////////////////////////
params ["_object", "_enableSim", "_enableDmg"];

// exit if instance is already running
if (crowsZA_common_selectPositionActive) exitWith {};

// set as active 
crowsZA_common_selectPositionActive = true;

// global vars, as we need to update between event calls
crowsZA_drawBuild_startPos = [];
// crowsza_drawBuild_objectType = _object;

// icon vars
private _angle = 45;
private _colour = [0.28, 0.78, 0.96, 1]; //xcom blue
private _icon = "\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa";
private _text = "Build to here";
private _textStart = "Start Position";

// display vars 
private _display = findDisplay IDD_RSCDISPLAYCURATOR;
private _visuals = [_text, _icon, _angle, _colour, _textStart];

// mouse eventhandler to get clicks/positions
private _mouseEH = [_display, "MouseButtonDown", {
    params ["", "_button", "", "", "_shift", "_ctrl", "_alt"];


	// if not leftclick
    if (_button != 0) exitWith {};

	// get position clicked
    private _position = [] call crowsZA_fnc_getPosFromMouse;

    // check if first position, and set start point
    if ((count crowsZA_drawBuild_startPos) != 0) then {
        // get extra options
        _thisArgs params ["_object", "_enableSim", "_enableDmg"];
        
        // call build function 
        [crowsZA_drawBuild_startPos, _position, _object, _enableSim, _enableDmg] call crowsZA_fnc_drawBuild;   
    };

    // set start pos to new pos 
    crowsZA_drawBuild_startPos = _position;

}, [_object, _enableSim, _enableDmg]] call CBA_fnc_addBISEventHandler;

// eventhandler to register ESC/space so we can end selection
private _keyboardEH = [_display, "KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

	// exit if key is not ESC or space
    if (_key != DIK_ESCAPE && _key != DIK_SPACE && _key != DIK_R) exitWith {false};

    // if space reset start position, so we can do multiple segments. 
    if (_key == DIK_SPACE) then {
        // reset start position
        crowsZA_drawBuild_startPos = [];
    };

    // if R select new object
    if (_key == DIK_R) then {
        crowsZA_common_selectPositionActive = false;
        // relaunch module, the time it takes to select a new object should make sure the previous eventhandlers are removed
        [] call crowsZA_fnc_drawBuildZeus;
    };

    // if ESCAPE
    if (_key == DIK_ESCAPE) then {
        // if ESC, setting instance to false
        crowsZA_common_selectPositionActive = false;
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
        crowsZA_common_selectPositionActive = false;
    };

    // If no longer actice, exit and remove event handlers
    if (!crowsZA_common_selectPositionActive) exitWith {
        private _display = findDisplay IDD_RSCDISPLAYCURATOR;
		// mouse and keyboard
        _display displayRemoveEventHandler ["MouseButtonDown", _mouseEH];
        _display displayRemoveEventHandler ["KeyDown", _keyboardEH];

		// clear global vars
		crowsZA_drawBuild_startPos = []; 

		// remove myself
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };

    // only draw 3D if map is not visible
    if (visibleMap) exitWith {};

	// get current pos to draw as pointer
    private _currPos = [] call crowsZA_fnc_getPosFromMouse;
    _visuals params ["_text", "_icon", "_angle", "_color", "_textStart"];
    
	// convert to AGL for drawing
	_currPos = ASLtoAGL _currPos;
    
	// draw from start pos, only if we got start pos
    if ((count crowsZA_drawBuild_startPos) > 0) then {
        private _startPos = ASLToAGL crowsZA_drawBuild_startPos;

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
