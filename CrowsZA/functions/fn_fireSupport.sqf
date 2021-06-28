/*/////////////////////////////////////////////////
Author: Radkewolf
			   
File: fn_fireSupport.sqf
Parameters: pos, logic
Return: none

Sets off firesupport in the targeted area

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_logic",objNull,[objNull]]];

// Validate module target
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];
    diag_log _msg;
    breakOut "Main";
};

private _checkIfFireSupport = 
{
	params ["_logic"];

	private _is = !isNull _logic;

	// check if object is firesupport module
	if(_is) then {
		if(!(_logic isKindOf "Logic")) then {
			_is = false;
		}
		else {
			_mod = _logic getVariable ["crowsZA_module", ""];
			if(_mod == "firesupport") then {
				_is = true;
			};
		}
	};
	_is
};

// open dialog
//ZEN
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_type",
		"_customType",
		"_radius",
		"_seconds",
		"_delay",
		"_salvos",
		"_guns",
		"_display"
	];

	// get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_logic",objNull,[objNull]], ["_isFireSupport", false]];

	if(_radius > 200) then {
		_display = false;
	};

	// create new module if not placed on existing one
	if(!_isFireSupport) then {
		_logicCenter = createCenter sideLogic;
		_logicGroup = createGroup _logicCenter;
		_logic = _logicGroup createUnit ["Logic", _pos, [], 0, "NONE"];
		_logic setVariable ["crowsZA_module", "firesupport"];
		["zen_common_addObjects", [[_logic], objNull]] call CBA_fnc_serverEvent;
	};
	
	private _currDisplay = _logic getVariable ["crowsZA_firesupport_display", false];
	diag_log format ["_currDisplay: %1", str _currDisplay];
	private _createDisplay = (!_isFireSupport || !_currDisplay) && _display;
	diag_log format ["_createDisplay : %1", str _createDisplay ];

	// use specific cfgAmmo if filled
	if(_customType != "") then {
		_type = _customType;
	};
	
	// set variables to logic gameobject
	_logic setVariable ["crowsZA_firesupport_type", _type, true];
	_logic setVariable ["crowsZA_firesupport_radius", _radius, true];
	_logic setVariable ["crowsZA_firesupport_seconds", _seconds, true];
	_logic setVariable ["crowsZA_firesupport_salvos", round _salvos, true];
	_logic setVariable ["crowsZA_firesupport_guns", round _guns, true];
	_logic setVariable ["crowsZA_firesupport_display", _display, true];
	

	private _spawnBarrage = 
	{
		params ["_logic", "_code"];

		while {!isNull _logic} do {
			// read values from logic object
			private _pos = getPos _logic;
			private _type = _logic getVariable ["crowsZA_firesupport_type", ""];
			private _radius = _logic getVariable ["crowsZA_firesupport_radius", 0];
			private _seconds = _logic getVariable ["crowsZA_firesupport_seconds", 1];
			private _salvos = _logic getVariable ["crowsZA_firesupport_salvos", 1];
			private _guns = _logic getVariable ["crowsZA_firesupport_guns", 1];

			// spawn salvo with values
			[_pos, _type, _radius, _guns, [0, 0.5]] spawn BIS_fnc_fireSupportVirtual;

			// wait till next salvo
			sleep _seconds;
			
			// check if more salvos should be spawned
			switch (true) do {
				// case salvo == 1
				case (_salvos == 1): {
					// delete if all salvos are done
					deleteVehicle _logic;
				};
				// case more than 1 salvo left
				case (_salvos > 1): {
					// reduces amount of remaining salvos, sync variable
					_logic setVariable ["crowsZA_firesupport_salvos", _salvos -1,true];
				};
			};

			// wait till next salvo
			sleep _seconds;
		}
	};

	private _delayedBarrage =
	{
		params ["_logic","_delay","_code"];
		
		// spawn barrage after delay
		sleep _delay;
		[_logic, _code] spawn _code;
	};

	crowsZA_fnc_spawnAreaMarker =
	{
		params ["_logic","_radius","_pos"];
		diag_log "Called spawn";
		private _obj = createSimpleObject ["\a3\Modules_F_Curator\Ordnance\surfaceHowitzer.p3d", _pos, true];
		private _scale = 0.0125 * _radius;
		_obj setObjectScale _scale;

		[_logic, _obj, _radius] spawn {
			params ["_logic","_obj","_radius"];
			private _display = true;
			while{!(isNull _logic) && _display} do {
				sleep 0.5;

				_display = _logic getVariable ["crowsZA_firesupport_display", false];

				if(isNull _logic || !_display) then {
					deleteVehicle _obj;
				}
				else{
					private _pos1 = getPos _logic;
					private _pos2 = getPos _obj;

					if(_pos1 select 0 != _pos2 select 0 && _pos1 select 1 != _pos2 select 1) then {
						_obj setPosWorld (getPos _logic);
					};

					private _logicRadius = _logic getVariable ["crowsZA_firesupport_radius", 0];
					if(_radius != _logicRadius) then {
						_radius = _logicRadius;
						_scale = 0.0125 * _radius;
						_obj setObjectScale _scale;
					};
				}
			};
		};

	};
	
	if(!_isFireSupport) then {
		[_logic, _delay, _spawnBarrage] spawn _delayedBarrage;
	};
	if(_createDisplay) then {
		{
			[[_logic,_radius,_pos], crowsZA_fnc_spawnAreaMarker] remoteExec ["call", _x, true]; 
		} forEach allCurators;
	};
};

// check if _logic is fire support module
private _isFireSupport = _logic call _checkIfFireSupport;

// set default values
private _type = 0;
private _customType = "";
private _radius = 100;
private _seconds = 5;
private _salvos = 1;
private _guns = 1;
private _display = false;

// if _logic is fire support set default to current values
if(_isFireSupport) then {
	_radius = _logic getVariable ["crowsZA_firesupport_radius", 0];
	_seconds = _logic getVariable ["crowsZA_firesupport_seconds", 1];
	_salvos = _logic getVariable ["crowsZA_firesupport_salvos", 1];
	_guns = _logic getVariable ["crowsZA_firesupport_guns", 1];
	_display = _logic getVariable ["crowsZA_firesupport_display", false];

	private _varType = _logic getVariable ["crowsZA_firesupport_type", ""];

	// check whether or not _type is custom and set default _type and _customType accordingly
	switch (_varType) do {
		case ("Sh_82mm_AMOS"): {
			_type = 0;
		};
		case ("Sh_155mm_AMOS"): {
			_type = 1;
		};
		case ("Cluster_155mm_AMOS"): {
			_type = 2;
		};
		default {
			_customType = _varType;
		};
	};
};

// display dialog
[
	"Select Firesupport Type and Area", 
	[
		["COMBO","Type",[["Sh_82mm_AMOS", "Sh_155mm_AMOS", "Cluster_155mm_AMOS"], ["82 mm Mortar", "155 mm Howitzer", "230 mm Rocket"],_type],_isFireSupport],
		["EDIT","Custom Type (ex.)",_customType,_isFireSupport],
		["SLIDER","Radius",[0,5000,_radius,0],_isFireSupport],
		["SLIDER","Seconds between Salvos",[0,30,_seconds,1],_isFireSupport],
		["SLIDER","Start after ... seconds",[0,30,1,1],_isFireSupport],
		["SLIDER","Stop After Salvos (0 = indef.)",[0,100,_salvos,0],_isFireSupport],
		["SLIDER","Guns",[1,30,_guns,0],_isFireSupport],
		["CHECKBOX","Display Radius (not supported above 200m radius)",_display,_isFireSupport]
	],
	_onConfirm,
	{},
	[_pos, _logic, _isFireSupport]
] call zen_dialog_fnc_create;