#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addZeusTextDisplayEH.sqf
Parameters: 
Return: none

Adds the drawEvent handlers to zeus to show the helper text for modules applied to players

*///////////////////////////////////////////////

// only if zeus, add draw3D handler for zeus-labels
GVAR(unit_medical_drawEH) = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	//if (isNull(findDisplay 312)) exitWith {};
	if (isNull(findDisplay 312)) exitWith {};
	if (!GVAR(medicalDisplay)) exitWith {};

	// cam position
	private _zeusPos = positionCameraToWorld [0,0,0];

	// Medic 
	{
		_x params["_player", "_color", "_color2", "_txt", "_txt2", "_txt3"];

		if (!alive _player) then {continue;};

		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _player;
		private _offset = 0.0;

		// // if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		//offset for longer distance
		if (_dist > 60) then {
			_offset = ((_dist - 60) * 0.03);
		};

		//dist mod
		_dist = _dist * 0.010;

		// draw icon on relative pos 
		// offset: z: +2
		private _pos = ASLToAGL getPosASLVisual _player;
		if (GVAR(CBA_Setting_zeusTextLine1)) then { drawIcon3D ["", _color, [_pos#0, _pos#1, _pos#2 + 2.05 + (_dist * 2 ) + _offset], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false] };
		if (GVAR(CBA_Setting_zeusTextLine2)) then { drawIcon3D ["", _color2, [_pos#0, _pos#1, _pos#2 + 2.00 + _dist + _offset], 0, 0, 0, _txt2, 1, 0.03 , "RobotoCondensed", "center", false] };
		if (GVAR(CBA_Setting_zeusTextLine3)) then { drawIcon3D ["", _color2, [_pos#0, _pos#1, _pos#2 + 1.95 + _offset], 0, 0, 0, _txt3, 1, 0.03 , "RobotoCondensed", "center", false] };
	} forEach GVAR(medical_status_players);
}];

GVAR(unit_icon_drawEH) = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open // Changed, we draw this so zeus while RC'ing others, can see who else RC at same time
	//if (isNull(findDisplay 312)) exitWith {};
	if (!GVAR(CBA_Setting_rc_helper)) exitWith {};
	if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false]) exitWith {};

	// cam position
	private _zeusPos = positionCameraToWorld [0,0,0];

	// get variable
	private _rcUnits = missionNamespace getVariable[QGVAR(rcUnits), []];

	// RC ICON
	{
		_x params["_unit", "_name"];
		[_zeusPos, _unit, "\a3\ui_f_curator\data\logos\arma3_curator_eye_512_ca.paa", GVAR(CBA_Setting_rc_helper_color), _name] call FUNC(drawIcon);

	} forEach _rcUnits;
}];


GVAR(unit_surrender_drawEH) = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	if (isNull(findDisplay 312)) exitWith {};
	if (!GVAR(CBA_Setting_surrender_helper)) exitWith {};
	if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false]) exitWith {};

	// cam position
	private _zeusPos = positionCameraToWorld [0,0,0];

	// SURRENDER ICON
	{
		_x params["_unit"];
		[_zeusPos, _unit, "\a3\ui_f\data\igui\cfg\holdactions\holdAction_secure_ca.paa", GVAR(CBA_Setting_surrender_helper_color)] call FUNC(drawIcon);
	} forEach (missionNamespace getVariable["crowsZA_surrenderUnits", []]);
}];

GVAR(unit_onKilledModule_drawEH) = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	if (isNull(findDisplay 312) ||
		{!GVAR(CBA_Setting_OnKilledModule_helper) ||
		{uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false]}}
	) exitWith {};

	// cam position
	private _zeusPos = positionCameraToWorld [0,0,0];

	// OnKilled ICON
	{
		_x params ["_unit"];
		[_zeusPos, _unit, "\a3\ui_f_curator\data\cfgmarkers\kia_ca.paa", GVAR(CBA_Setting_OnKilledModule_helper_color)] call FUNC(drawIcon);
	} forEach GETMVAR(EGVAR(misc,OnKilledModuleUnits),[]);
}];

// TODO: account for multiple icons being displayed at once. E.g. surrender *AND* onDeath
// Should draw all icons in one event and then arrange icons based on total number present, e.g. either vertically or horizontally
