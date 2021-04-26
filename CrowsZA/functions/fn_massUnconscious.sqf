/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_massUnconscious.sqf
Parameters: pos, _unit (We don't use unit or pos)
Return: none

Toggles ace unconscious on selected units

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_selection"
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
		diag_log "CrowsZA-MassUnconscious: None was selected to apply action on";
		exit;
	};

	//only include infantry
	_selectArray = _selectArray select {alive _x && {_x isKindOf "CAManBase"}}; //only get infantry
	_selectArray = _selectArray arrayIntersect _selectArray; //removes duplicates

	{
		//get current value of unconscious
		private _unconscious = _x getVariable ["ACE_isUnconscious", false];
		[_x, !_unconscious, 10e10] call ace_medical_fnc_setUnconscious
	} forEach _selectArray;
};
[
	"Mass Unconscious", 
	[
		["OWNERS","Units",[[],[],[],0], true] //no preselected defaults, and default tab open side. Forcing defaults to deselect.
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
