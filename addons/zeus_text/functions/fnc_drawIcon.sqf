#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_drawIcon.sqf
Parameters: 
Return: none

Draws Icon as called

*///////////////////////////////////////////////
params ["_zeusPos", "_unit", "_icon", "_color"];

// calculate distance from zeus camera to unit
private _dist = _zeusPos distance _unit;
private _scale = _dist * 0.01;
private _offset = 0.0;

// clamp max scale
if (_scale > 0.26) then {_scale = 0.26};

// // if not within 500m, we don't draw it as the text does not scale and disappear with distance
if (_dist > 500) then {continue;};

// //offset for longer distance
if (_dist > 60) then {
	_offset = ((_dist - 60) * 0.03);
};

// draw icon on relative pos 
// offset: z: +2.15
private _pos = ASLToAGL getPosASLVisual _unit;
_pos = _pos vectorAdd [0, 0, 2.15 + _offset];

drawIcon3D [_icon, _color, _pos, 1 + _scale, 1 + _scale, 0];