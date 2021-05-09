/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_radiusHeal.sqf
Parameters: pos
Return: none

heals all players in a radius around the spot clicked

*///////////////////////////////////////////////

// heal function
private _healFunc = 
{
	params ["_position, _radius"];

	//get all players in radius
	_list = (ASLToAGL _position) nearEntities [["Man"], _radius];

	//ace heal 
	{
		["ace_medical_treatment_fullHealLocal", [_x], _x] call CBA_fnc_targetEvent;
	} forEach _list;
};

// open dialog function
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_radiusSelect"
	];
	_in params ["_position"];

	// as this scope doesn't have access to heal func, we need to redo it here
	_list = (ASLToAGL _position) nearEntities [["Man"], _radiusSelect];
	{["ace_medical_treatment_fullHealLocal", [_x], _x] call CBA_fnc_targetEvent;} forEach _list;
};

// get params 
params ["_position", "_radius"];

// check if _radius == -1, then show dialog, else use the params
if (!isNil "_radius") then {
	[_position, _radius] call _healFunc;
} else 
{
	[
		"Radius to heal", 
		[
			["SLIDER","Radius",[0,500,10,0]] //0 to 500, default 10 and showing 0 decimal
		],
		_onConfirm,
		{},
		_this
	] call zen_dialog_fnc_create;
};

