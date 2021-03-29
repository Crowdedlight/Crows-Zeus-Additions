/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_animalFollowZeus.sqf
Parameters: position ASL and unit clicked
Return: none

Creates an animal that follows the player while it is alive

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith { _return; };

// open dialog
//either Ares or ZEN
if (crowZA_zen) then 
{
	//ZEN
	private _onConfirm =
	{
		params ["_dialogResult","_in"];
		_dialogResult params
		[
			"_animalType"
		];
		//Get in params again
		_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
		if (isNull _unit) exitWith { _return; };

		//spawn script with animal type
		[_animalType, _unit] call crowsZA_fnc_animalFollow;
	};
[
	"Select Animal Type", 
	[
		["COMBO","Animal",[["Dog", "Sheep", "Goat", "Rabbit", "Hen", "Snake"], ["Dog", "Sheep", "Goat", "Rabbit", "Hen", "Snake"],0]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

} else 
{
	//ARES 
	private _dialogResult =
	[
		"Select what animal should follow",
		[
			["Animal", ["Dog", "Sheep", "Goat", "Rabbit", "Hen", "Snake"],0,true]
		]
	] call Ares_fnc_showChooseDialog;

	if (_dialogResult isEqualTo []) exitWith{};

	_dialogResult params 
	[
		"_animalType"
	];

	//spawn script with animal type
	[_animalType, _unit] call crowsZA_fnc_animalFollow;
};