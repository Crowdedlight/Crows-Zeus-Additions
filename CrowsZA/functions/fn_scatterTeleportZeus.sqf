/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_scatterTeleportZeus.sqf
Parameters: pos, _unit (We don't use unit, just pos)
Return: none

Teleports selected players to the position clicked in a pattern with the selected distance between each and at set altitude over ground. 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//if no zen, return. Should be cleaned up and only support ZEN. So remove the ARES register hook and only check of ZEN in registering script
if !(crowZA_zen) exitWith { };

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
	private _onConfirm =
	{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_selection",
		"_offset",
		"_altitude"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// change target pos from ASL to AGL, as we use AGL for internal and setPos TP command
	private _targetPos = ASLToAGL _pos;

	private _selectArray = [];

	//find selection check what array is not empty or if all are empty 
	//dialog returns: [[WEST],[],[],0]
	switch (true) do 
	{
		//If SIDE is selected
		case (count (_selection select 0) > 0):
		{
			//units works both with group and sides
			{
				_selectArray append (units _x);
			} forEach (_selection select 0);
		};
		//if GROUP is selected
		case (count (_selection select 1) > 0):
		{
			//units works both with group and sides
			diag_log "Side or group chosen";
			{
				_selectArray append (units _x);
			} forEach (_selection select 1);
		};
		//if Players is selected
		case (count (_selection select 2) > 0):
		{
			//get array of players, should just be able to pass _selection on
			_selectArray = _selection;
		};
		//no selection chosen
		default
		{
			diag_log "CrowsZA-ScatterTeleport: None was selected to TP";
			exit;
		};
	};

	//Run teleport script
	[_targetPos, _selectArray, _offset, _altitude] call crowsZA_fnc_scatterTeleport;
};
[
	"Scatter Teleport Selected Players", 
	[
		["OWNERS","Units to TP",[[],[],[],1]], //no preselected defaults, and default tab open is groups.
		["SLIDER","Distance Between Players [m]",[5,500,15,0]], //5 to 500, default 15 and showing 0 decimal. (Don't allow teleport with 0 seperation, use normal TP for that...)
		["SLIDER","Altitude Above Ground [m]",[0,10000,1000,0]] //0 to 10km, default 1km and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
