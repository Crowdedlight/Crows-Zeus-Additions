/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_massSurrender.sqf
Parameters: pos, _unit (We don't use unit or pos)
Return: none

Toggles Surrender or captive on selection 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_selection",
		"_action"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	private _selectArray = [];
	//find selection check what array is not empty or if all are empty 
	//dialog returns: [[WEST],[],[],0]] or [[CIV],[C Alpha 1-1],[PZA],0]

	//If SIDE is selected
	if (count (_selection select 0) > 0) then
	{
		//units works both with group and sides
		{
			_selectArray append (units _x);
		} forEach (_selection select 0);
	};
	//if GROUP is selected
	if (count (_selection select 1) > 0) then
	{
		//units works both with group and sides
		{
			_selectArray append (units _x);
		} forEach (_selection select 1);
	};
	//if Players is selected
	if (count (_selection select 2) > 0) then
	{
		//get array of players, should just be able to pass _selection on
		_selectArray append (_selection select 2);
	};

	//no selection chosen
	if (count _selectArray <= 0) then {
		diag_log "CrowsZA-MassSurrender: None was selected to apply action on";
		exit;
	};

	//only include infantry
	_selectArray = _selectArray select {alive _x && {_x isKindOf "CAManBase"}}; //only get infantry
	_selectArray = _selectArray arrayIntersect _selectArray; //removes duplicates

	//set captive or surrender for each
	{
		switch (_action) do {
			case "surrender":
			{
				if (!(_x getVariable ["ace_captives_isHandcuffed", false])) then 
				{
					//get current status, then toggle it
					private _surrendering = _x getVariable ["ace_captives_isSurrendering", false];
					["ace_captives_setSurrendered", [_x, !_surrendering], _x] call CBA_fnc_targetEvent;
				};
			};
			case "captive": 
			{
				//get current status to toggle
				private _handcuffed = _x getVariable ["ace_captives_isHandcuffed", false];
				["ace_captives_setHandcuffed", [_x, !_handcuffed], _x] call CBA_fnc_targetEvent;
			};
			default {diag_log "CrowsZA-MassSurrender: _action error. Is not one of the two valid cases."};
		};	
	} forEach _selectArray;
};
[
	"Mass Surrender/Captive", 
	[
		["OWNERS","Units",[[],[],[],0], true], //no preselected defaults, and default tab open side. Forcing defaults to deselect.
		["LIST","Action",[["surrender","captive"],["Surrender", "Captive"],0,2]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
