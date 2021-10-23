/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_animalFollowZeus.sqf
Parameters: position ASL and unit clicked
Return: none

Creates an animal that follows the player while it is alive

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith { };

// open dialog
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_animalType",
		"_amount",
		"_offset",
		"_scale",
		"_invincible",
		"_attack"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	if (isNull _unit) exitWith { _return; };

	//spawn script with animal type
	[_animalType, _unit, _amount, _invincible, _offset, _scale, _attack] call crowsZA_fnc_animalFollow;
};
[
	"Select Animal Type", 
	[
		["COMBO","Animal",[["Dog", "Sheep", "Goat", "Rabbit", "Hen", "Snake"], ["Dog", "Sheep", "Goat", "Rabbit", "Hen", "Snake"],0]],
		["SLIDER","Amount",[1,20,1,0]], //1 to 20, default 1 and showing 0 decimal
		["SLIDER",["Spawn offset [m]", "How far away in random direction the animals should spawn"],[0,200,0,0]], //0 to 200, default 0 and showing 0 decimal
		["SLIDER",["Scale*", "Experimental feature that doesn't always work. Works best on snakes"],[1,10,1,0]], //1 to 10, default 1 and showing 0 decimal
		["CHECKBOX","Set Invincible",[false]], // checkbox default to false
		["CHECKBOX","Attack Nearby Units",[false]] // checkbox default to false
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
