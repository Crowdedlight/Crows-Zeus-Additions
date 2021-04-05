/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_scatterTeleportZeus.sqf
Parameters: pos, _unit (We don't use unit, just pos)
Return: none

Teleports selected players to the position clicked in a pattern with the selected distance between each and at set altitude over ground. 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog, just ignore ARES, as that mod itself is EOL and links to ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_selection",
		"_offset",
		"_altitude",
		"_includeVehicles",
		"_tpPattern",
		"_tpDirection"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	// change target pos from ASL to AGL, as we use AGL for internal and setPos TP command
	private _targetPos = ASLToAGL _pos;

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
		diag_log "Side or group chosen";
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
		diag_log "CrowsZA-ScatterTeleport: None was selected to TP";
		exit;
	};

	//if include vics, get the vics, otherwise we remove all players inside vics for TP. 
	if (_includeVehicles) then {
		_selectArray = _selectArray apply {vehicle _x}; //if in vic, gets the vic instead
		_selectArray = _selectArray arrayIntersect _selectArray; //removes duplicates
	} else {
		_selectArray = _selectArray select { isNull objectParent _x }; //removes units inside vehicles
	};

	//Run teleport script
	[_targetPos, _selectArray, _offset, _altitude, _tpPattern, _tpDirection] call crowsZA_fnc_scatterTeleport;
};
[
	"Scatter Teleport Players", 
	[
		["OWNERS","Units to TP",[[],[],[],1], true], //no preselected defaults, and default tab open is groups. Forcing defaults to deselect tp selection.
		["SLIDER","Distance Between Players [m]",[5,500,15,0]], //5 to 500, default 15 and showing 0 decimal. (Don't allow teleport with 0 seperation, use normal TP for that...)
		["SLIDER","Altitude Above Ground [m]",[0,10000,1000,0]], //0 to 10km, default 1km and showing 0 decimal
		["TOOLBOX:YESNO", ["Include Vehicles", "Teleports vehicles if selected player is crew"], false],
		["COMBO",["TP Pattern", "What pattern the units should be teleported as"],[["outward_spiral", "line"], ["Outward Spiral", "Line"],0]],
		["COMBO",["Direction (If LinePattern)", "The direction the line grows"],[["north", "north_east", "north_west", "east", "south", "south_east", "south_west", "west"], ["North", "North East", "North West", "East", "South", "South East", "South West", "West"],0]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;
