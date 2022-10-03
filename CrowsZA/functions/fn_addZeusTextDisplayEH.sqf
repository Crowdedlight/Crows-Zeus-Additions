/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_addZeusTextDisplayEH.sqf
Parameters: 
Return: none

Adds the drawEvent handlers to zeus to show the helper text for modules applied to players

*///////////////////////////////////////////////

// only if zeus, add draw3D handler for zeus-labels
crowsZA_unit_medical_drawEH = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	//if (isNull(findDisplay 312)) exitWith {};
	if (isNull _x) exitWith {};
	if (!crowsZA_zeusTextMedicalDisplay) exitWith {};

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
		if (crowsZA_zeusTextLine1) then { drawIcon3D ["", _color, [_pos#0, _pos#1, _pos#2 + 2.05 + (_dist * 2 ) + _offset], 0, 0, 0, _txt, 1, 0.03, "RobotoCondensed", "center", false] };
		if (crowsZA_zeusTextLine2) then { drawIcon3D ["", _color2, [_pos#0, _pos#1, _pos#2 + 2.00 + _dist + _offset], 0, 0, 0, _txt2, 1, 0.03 , "RobotoCondensed", "center", false] };
		if (crowsZA_zeusTextLine3) then { drawIcon3D ["", _color2, [_pos#0, _pos#1, _pos#2 + 1.95 + _offset], 0, 0, 0, _txt3, 1, 0.03 , "RobotoCondensed", "center", false] };
	} forEach crowsZA_medical_status_players;
}];

crowsZA_unit_icon_drawEH = addMissionEventHandler ["Draw3D", {
	// if zeus display is null, exit. Only drawing when zeus display is open
	//if (isNull(findDisplay 312)) exitWith {};
	if (isNull _x) exitWith {};
	if (!crowsZA_zeus_rc_helper) exitWith {};
	if (uiNamespace getVariable ["RscDisplayCurator_screenshotMode", false]) exitWith {};

	// cam position
	private _zeusPos = positionCameraToWorld [0,0,0];

	// get variable
	private _rcUnits = missionNamespace getVariable["crowsZA_rcUnits", []];

	// RC ICON
	{
		_x params["_unit"];

		// calculate distance from zeus camera to unit
		private _dist = _zeusPos distance _unit;
		private _scale = _dist * 0.01;
		private _offset = 0.0;

		// clamp max scale
		if (_scale > 0.26) then {_scale = 0.26};

		// // if not within 500m, we don't draw it as the text does not scale and disappear with distance
		if (_dist > 500) then {continue;};

		// //offset for longer distance
		if (_dist > 60) then {
			_offset = ((_dist - 60) * 0.03);
		};

		// draw icon on relative pos 
		// offset: z: +2.15
		private _pos = ASLToAGL getPosASLVisual _unit;
		_pos = _pos vectorAdd [0, 0, 2.15 + _offset];

		drawIcon3D ["\a3\ui_f_curator\data\logos\arma3_curator_eye_512_ca.paa", crowsZA_zeus_rc_helper_color, _pos, 1 + _scale, 1 + _scale, 0];
		// drawIcon3D ["\a3\ui_f_curator\data\logos\arma3_curator_eye_512_ca.paa", [1,1,1,1], [_pos#0, _pos#1, _pos#2 + 2.10 + (_dist * 2 ) + _offset], 0, 0, 0];
	} forEach _rcUnits;
}];

