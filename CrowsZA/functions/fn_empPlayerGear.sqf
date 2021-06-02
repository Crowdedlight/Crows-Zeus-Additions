/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_empPlayerGear.sqf
Parameters: pos
Return: none

Removes night vision, gps and radio from selected players to simulate the equipment being destroyed by emp. Each option is toggleable

ON HOLD FOR NOW - GETTING CLOSE TO MODERATION TOOL AND I DON'T WANT THAT

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

// open dialog
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_selection",
		"_removeGPS",
		"_removeNV",
		"_removeRadio"
	];
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	//get selection of units 
	private _selectArray = [];

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

	//removes duplicates
	_selectArray = _selectArray arrayIntersect _selectArray; 

	//no selection chosen
	if (count _selectArray <= 0) then {
		["CrowsZA-rmpPlayerGear: None was selected to EMP"] call crowsZA_fnc_showHint;
		exit;
	};

	{
		// call remove function
		if (_removeNV) then {
			[_x, "NVGoggles"] call crowsZA_fnc_removeItemFromUnit;
		};
		// todo, remove radio and gps
	} forEach _selectArray;
	
};
[
	"Select players to remove EMP'ed items and what items to include", 
	[
		["OWNERS","Units to TP",[[],[],[],1], true], //no preselected defaults, and default tab open is groups. Forcing defaults to deselect tp selection.
		["CHECKBOX",["Remove Nightvision", "Removes Nightvision"],[true]],
		["CHECKBOX",["Remove GPS", "Removes GPS"],[true]],
		["CHECKBOX",["Remove Radio", "Removes Radio"],[true]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
