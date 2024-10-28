#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_animalFollowZeus.sqf
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
	[_animalType, _unit, _amount, _invincible, _offset, _scale, _attack] call FUNC(animalFollow);
};

private _selectAnimal_value = ["Dog", "Sheep", "Goat", "Rabbit", "Hen", "Snake"];
private _selectAnimal_title = [localize "STR_CROWSZA_Misc_dog", localize "STR_CROWSZA_Misc_sheep", localize "STR_CROWSZA_Misc_goat", localize "STR_CROWSZA_Misc_rabbit", localize "STR_CROWSZA_Misc_hen", localize "STR_CROWSZA_Misc_snake"];

if (EGVAR(main,wsLoaded)) then {
	_selectAnimal_value append ["Dromedary"];
	_selectAnimal_title append [localize "STR_CROWSZA_Misc_dromedary"]
};

if (EGVAR(main,speLoaded)) then {
	_selectAnimal_value append ["Rat"];
	_selectAnimal_title append [localize "STR_CROWSZA_Misc_rat"]
};

[
	localize "STR_CROWSZA_Misc_follow_animal", 
	[
		["COMBO",localize "STR_CROWSZA_Misc_animal",[_selectAnimal_value, _selectAnimal_title,0]],
		["SLIDER",localize "STR_CROWSZA_Misc_animal_amount",[1,20,1,0]], //1 to 20, default 1 and showing 0 decimal
		["SLIDER",[localize "STR_CROWSZA_Misc_animal_spawn_offset", localize "STR_CROWSZA_Misc_animal_spawn_offset_tooltip"],[0,200,0,0]], //0 to 200, default 0 and showing 0 decimal
		["SLIDER",[localize "STR_CROWSZA_Misc_animal_scale", localize "STR_CROWSZA_Misc_animal_scale_tooltip"],[1,10,1,0]], //1 to 10, default 1 and showing 0 decimal
		["CHECKBOX", localize "STR_CROWSZA_Misc_animal_invincible",[false]], // checkbox default to false
		["CHECKBOX", localize "STR_CROWSZA_Misc_animal_attack_nearby",[false]] // checkbox default to false
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
