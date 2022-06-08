/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addZeusTextDisplayEH.sqf
Parameters: 
Return: none

Adds the drawEvent handlers to zeus to show the helper text for modules applied to players

*///////////////////////////////////////////////

// only if zeus, add draw3D handler for zeus-labels
crowsZA_unit_icon_drawEH = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	//if (isNull(findDisplay 312)) exitWith {};
	if (isNull _x) exitWith {};
	if (!crowsZA_zeusTextDisplay) exitWith {};

	// cam position
	//private _zeusPos = positionCameraToWorld [0,0,0];

	// Medic 
	{
		// calculate distance from zeus camera to unit
		// private _unit = _x select 0;
		// private _dist = _zeusPos distance _unit;

		// // if not within 500m, we don't draw it as the text does not scale and disappear with distance
		// if (_dist > 500) then {continue;};
		_x params["_player", "_color", "_color2", "_woundNum", "_hr", "_bleedingRate", "_inCRDC", "_inPain", "_txt", "_txt2"];

		// draw icon on relative pos 
		// offset: z: +2
		private _pos = ASLToAGL getPosASL _player;
		drawIcon3D ["", _color, [_pos#0, _pos#1, _pos#2+2], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false];
		drawIcon3D ["", _color2, [_pos#0, _pos#1, _pos#2+1.95], 0, 0, 0, _txt2, 1, 0.03, "RobotoCondensed", "center", false];
	} forEach crowsZA_medical_status_players;
}];