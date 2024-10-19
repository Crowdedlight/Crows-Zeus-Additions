#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_teleportToSquadMember.sqf
Parameters: position ASL and unit clicked
Return: none

Shows dialog with all members in the squad the player belongs and 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]]], ["_unit",objNull,[objNull]]];

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
	_in params [["_pos",[0,0,0],[[]]], ["_unit",objNull,[objNull]]];
	if (isNull _unit) exitWith { _return; };

	//reset velocity 
	_unit setVelocity [0,0,0];

	//if target in vehicle
	if (!isNull objectParent _tpTarget) then
	{
		//try to move into vehicle, if it can't, just move next to vehicle
		private _movedIntoVic = _unit moveInAny (vehicle _tpTarget);
		if (!_movedIntoVic) then {
			//failed to move into, we just gonna tp next to vic
			_unit setVehiclePosition [_tpTarget, [], 0, ""];
		};
	} else 
	{
		//not in vic, teleport directly
		_unit setVehiclePosition [_tpTarget, [], 0, ""];
	};	
};

//get squad members
private _allSquadMembers = units group _unit;
//remove _unit from the list - We don't need to check, as deleteAt supports handling -1
_allSquadMembers deleteAt (_allSquadMembers find _unit);
//get pretty names
private _allSquadMembersNames = _allSquadMembers apply {
	private _name = "";
	if (_x == leader _x) then 
	{
		_name = format ["%1 [%2]", name _x, localize "STR_CROWSZA_Teleport_squadleader"]
	} else 
	{
		_name = name _x
	};
	//if in vic, add vic tag
	if (!isNull objectParent _x) then {_name = _name + " " + localize "STR_CROWSZA_Teleport_in_vehicle"};
	_name;
};

[
	localize "STR_CROWSZA_Teleport_select_member_to_teleport_to", 
	[
		["LIST",localize "STR_CROWSZA_Teleport_squad_members",[_allSquadMembers, _allSquadMembersNames,0, 10]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
