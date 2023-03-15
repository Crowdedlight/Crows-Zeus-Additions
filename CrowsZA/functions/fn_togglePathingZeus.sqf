/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_togglePathingZeus.sqf
Parameters: pos, unit
Return: none

Allows zeus to toggle pathing for units, groups, or sides

*///////////////////////////////////////////////

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// ZEN Dialogue
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];


	private _units = if(isNull _unit) then {
		_dialogResult params ["_side"];
		units _side;
	} else {
		_dialogResult params ["_group"];
		if(_group) then {
			units (group _unit)
		} else {
			[_unit]
		};
	};

	_dialogResult params ["_", "_action"];
	{
		if(isPlayer _x) then { continue };

		switch(_action) do {
			case 0: { _x disableAI "PATH"; };
			case 1: { _x enableAI "PATH"; };
			default {

				if(_x checkAIFeature "PATH") then {
					_x disableAI "PATH";
				} else {
					_x enableAI "PATH";
				}
			};
		};	
	} forEach _units;
};

private _controls = if(isNull _unit) then {
	[["SIDES", "Side", east]]
}
else{
	[["TOOLBOX:YESNO", ["Whole Group", "Affect pathing for the whole of this unit's group"], true]]
};

_controls pushBack ["TOOLBOX", ["Pathing", "AI's ability to 'path' (or move); note they will still turn, aim, and fire"], [2, 1, 3, ["Off", "On", "Toggle"]]];

[
	"Toggle Pathing",
	_controls,
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

