/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_scatterTeleportZeus.sqf
Parameters: pos, _unit (We don't use unit, just pos)
Return: none

Teleports selected players to the position clicked in a pattern with the selected distance between each and at set altitude over ground. 

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//if no zen, return
if !(crowZA_zen) exitWith { _return; };

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

	//apply ACE dmg as ZEN SLider is a number
	[_targetPos, _selection, _offset, _altitude] call crowsZA_fnc_scatterTeleport;
};
[
	"Scatter Teleport Selected Players", 
	[
		//TODO actually fill owners... haven't checked what to add to it yet.... https://zen-mod.github.io/ZEN/#/frameworks/dynamic_dialog?id=owners-owners 
		["OWNERS","Body Part",[["head", "body", "leg_l", "leg_r", "hand_l", "hand_r"], ["Head", "Body", "Left Leg", "Right Leg", "Left Hand", "Right Hand"],2]],
		["SLIDER","Distance Between Players",[5,500,15,0]], //5 to 500, default 15 and showing 0 decimal. (Don't allow teleport with 0 seperation, use normal TP for that...)
		["SLIDER","Altitude",[0,10000,1000,0]] //0 to 10km, default 1km and showing 0 decimal
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;


//Zeus should pick players/group to tp somehow.... dialog option "OWNERS" seems perfect. 