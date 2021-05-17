/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_getPosFromMouse.sqf
Parameters:
Return: none

returns the coordinates in the world or map based on the mouse position
*/

// get screen pos 
private _screenPos = getMousePosition;

private _position = [];

// if map is visible get the 2D position and make 3D, otherwise use the mouse pointer position
if (visibleMap) then {
    // get ctrl map component for zeus
    private _ctrlMap = findDisplay IDD_RSCDISPLAYCURATOR displayCtrl IDC_RSCDISPLAYCURATOR_MAINMAP;
    // get the 2D position from the map
    private _pos2D = _ctrlMap ctrlMapScreenToWorld _screenPos;
    // set position from map
    _position = AGLtoASL (_pos2D + [0])
} else {
    // get mouse pos mapped to world 
    _position = AGLToASL screenToWorld _screenPos;
};
_position
