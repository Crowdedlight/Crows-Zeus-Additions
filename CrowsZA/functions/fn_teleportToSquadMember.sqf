/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_teleportToSquadMember.sqf
Parameters: position ASL and unit clicked
Return: none

Shows dialog with all members in the squad the player belongs and 

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
		"_tpTarget"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	if (isNull _unit) exitWith { _return; };

	//tp unit to target 
	//reset velocity 
	_unit setvelocity [0,0,0];
	_unit setPos (position _tpTarget);
};

//get squad members
private _allSquadMembers = units group _unit;
//remove _unit from the list - We don't need to check, as deleteAt supports handling -1
_allSquadMembers deleteAt (_allSquadMembers find _unit);
//get pretty names
private _allSquadMembersNames = _allSquadMembers apply {if (_x == leader _x) then {format ["%1 (SquadLeader)", name _x]} else {name _x}};

[
	"Select SquadMember to teleport to", 
	[
		["LIST","Squad Members",[_allSquadMembers, _allSquadMembersNames,0, 10]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
