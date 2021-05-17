#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_selectPositions.sqf
Parameters:
Return: none

handles selection of multiple points to draw lines between them

Inspired by how ZEN handles selection with teleport players

*///////////////////////////////////////////////
/*
 * The function passed is passed the following:
 *   0: Successful <BOOL>
 *   2: Position ASL <ARRAY>


 * Arguments:
 * 1: Pos array (Comes with clicked position already entered)
 * 1: Function <CODE>
 * 3: Text <STRING> (default: "")
 */

params [
    ["_positions", [], [[]]],
    ["_function", {}, [{}]],
    ["_text", "", [""]]
];

diag_log "entered selectPositions";

// exit if instance is already running
if (crowsZA_common_selectPositionActive) exitWith {
	// didn't succeed
    [false, []] call _function;
};

// set as active 
crowsZA_common_selectPositionActive = true;

// global vars, as we need to update between event calls
crowsZA_drawBuild_positions = _positions;

// icon vars
private _angle = 45;
private _colour = [0.28, 0.78, 0.96, 1]; //xcom blue
private _icon = "\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa";
private _iconPastPos = "\a3\modules_f\data\portraitModule_ca.paa";

// display vars 
private _display = findDisplay IDD_RSCDISPLAYCURATOR;
private _ctrlMap = _display displayCtrl IDC_RSCDISPLAYCURATOR_MAINMAP;
private _visuals = [_text, _icon, _angle, _colour, _iconPastPos];

diag_log "before event handlers";

// mouse eventhandler to get clicks/positions
private _mouseEH = [_display, "MouseButtonUp", {
    params ["", "_button", "", "", "_shift", "_ctrl", "_alt"];

	// if not leftclick
    if (_button != 0) exitWith {};

	diag_log "left click";

	// get position clicked
    private _position = [] call crowsZA_fnc_getPosFromMouse;

	// add to array
	crowsZA_drawBuild_positions pushBack _position;
}, []] call CBA_fnc_addBISEventHandler;

// eventhandler to register ESC/space so we can end selection
private _keyboardEH = [_display, "KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

	// exit if key is not ESC or space
    if (_key != DIK_ESCAPE && _key != DIK_SPACE) exitWith {false};

	diag_log "space/esc hit";

	// if ESC, we are calling _function with the positions gathered
    _thisArgs params ["_function"];

    [true, crowsZA_drawBuild_positions] call _function;

	// and setting instance to false
    crowsZA_common_selectPositionActive = false;

    true // handled
}, [_function]] call CBA_fnc_addBISEventHandler;

// draw event handler for map
private _drawEH = [_ctrlMap, "Draw", {
    params ["_ctrlMap"];
    _thisArgs params ["_visuals"];

	// get visual params
    _visuals params ["_text", "_icon", "_angle", "_color", "__iconPastPos"];

	// get 2d pos for mouse and draw icon on it
    private _pos2D = _ctrlMap ctrlMapScreenToWorld getMousePosition;
    private _textSize = 0.05 max ctrlMapScale _ctrlMap min 0.07;

    _ctrlMap drawIcon [_icon, _color, _pos2D, 24, 24, _angle, _text, 0, _textSize, "RobotoCondensed", "right"];

	// draw lines between each pos in _positions and line between them
    {
		// draw icon - blue circle
		_ctrlMap drawIcon [_iconPastPos, _color, _x, 24, 24, 0];

		// draw line if not first pos
		if (_forEachIndex != 0) then {
			private _linePos = crowsZA_drawBuild_positions select (_forEachIndex - 1);
			_ctrlMap drawLine [_linePos, _x, _color];	
		};        
    } forEach crowsZA_drawBuild_positions;
}, [_visuals]] call CBA_fnc_addBISEventHandler;

diag_log "before main handler";
// main handler
[{
    params ["_args", "_pfhID"];
    _args params ["_function", "_visuals", "_mouseEH", "_keyboardEH", "_drawEH"];

    // End selection with failure if an object is deleted, Zeus display is closed, or pause menu is opened
	if (isNull findDisplay IDD_RSCDISPLAYCURATOR || !isNull findDisplay IDD_INTERRUPT) then {
        [false, crowsZA_drawBuild_positions] call _function;
        crowsZA_common_selectPositionActive = false;
    };

    // If no longer actice, exit and remove event handlers
    if (!crowsZA_common_selectPositionActive) exitWith {
        private _display = findDisplay IDD_RSCDISPLAYCURATOR;
		// mouse and keyboard
        _display displayRemoveEventHandler ["MouseButtonDown", _mouseEH];
        _display displayRemoveEventHandler ["KeyDown", _keyboardEH];

		// map drawing
        private _ctrlMap = _display displayCtrl IDC_RSCDISPLAYCURATOR_MAINMAP;
        _ctrlMap ctrlRemoveEventHandler ["Draw", _drawEH];

		// clear global vars
		crowsZA_drawBuild_positions = []; 

		// remove myself
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };

    // only draw 3D if map is visible
    if (visibleMap) exitWith {};

	// get current pos to draw as pointer
    private _currPos = [] call crowsZA_fnc_getPosFromMouse;
    _visuals params ["_text", "_icon", "_angle", "_color", "__iconPastPos"];
    
	// convert to AGL for drawing
	_currPos = ASLtoAGL _currPos;
	// draw icon in 3D, xcom blue
    drawIcon3D [_icon, _color, _currPos, 1.5, 1.5, _angle, _text];

	// draw lines between each pos in _positions and line between them
    {
		diag_log format["Draw icon from array positions, current position: ASL: %1, AGL: %2", _x, ASLToAGL _x];
		// draw icon - blue circle
		drawIcon3D [_icon, _color, (ASLtoAGL _x), 1.5, 1.5, 0, str(_forEachIndex+1)];  
    } forEach crowsZA_drawBuild_positions;

	// draw line from last position to current pos to show where next click would be
	private _lastPos = ASLtoAGL (crowsZA_drawBuild_positions select (count crowsZA_drawBuild_positions -1));
	drawLine3D [_lastPos, _currPos, _color];	

}, 0, [_function, _visuals, _mouseEH, _keyboardEH, _drawEH]] call CBA_fnc_addPerFrameHandler;
