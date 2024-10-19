#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_counterbat.sqf
Parameters: pos, unit
Return: none

Place on a unit and when it fires arty/mortar it will show on players map based on the speed of the sound

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// event callback on "fired" for the unit, check if kindof arty, calculate distance to closest player, delay marker based on speed of sound.
//  This module becomes a bit "magic" as the marker will just appear for all players when the first player receive it? 
//  Alternative instead of distance to closest player, it could be the average distance, almost same calculation as we still need to go through all players and get distance, then just divide it by number of players

// wip, for when I feel like it/have time