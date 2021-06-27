/*/////////////////////////////////////////////////
Author: Radkewolf
			   
File: fn_fireSupport.sqf
Parameters: pos
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
		"_guns"
	];

	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_logic",objNull,[objNull]]];

	//Check if placed on an object
	_create = isNull _logic;

	//Check if object is firesupport module
	if(!_create)
	then
	{
		if(!(_logic isKindOf "Logic"))
		then
		{
			_create = true;
		}
		else {
			_mod = _logic getVariable ["_module", ""];
			if(_mod != "firesupport")
			then
			{
				_create = true;
			};
		}
	};

	//Create new module if not placed on existing one
	if(_create)
	then{
		_logicCenter = createCenter sideLogic;
		_logicGroup = createGroup _logicCenter;
		_logic = _logicGroup createUnit ["Logic", _pos, [], 0, "NONE"];
		_logic setVariable ["_module", "firesupport"];
		["zen_common_addObjects", [[_logic], objNull]] call CBA_fnc_serverEvent;
	};

	//Use specific cfgAmmo if filled
	if(_customType != "")
	then{
		_type = _customType;
	};

	//Set variables to logic gameobject
	_logic setVariable ["_type", _type];
	_logic setVariable ["_radius", _radius];
	_logic setVariable ["_seconds", _seconds];
	_logic setVariable ["_salvos", floor _salvos];
	_logic setVariable ["_guns", floor _guns];
	

	_spawnBarrage = 
	{
		_logic = (_this select 0);
		_code = (_this select 1);

		if(!(isNull _logic))
		then{
			//Read values from logic gameobject
			_pos = getPos _logic;
			_type = _logic getVariable "_type";
			_radius = _logic getVariable "_radius";
			_seconds = _logic getVariable "_seconds";
			_salvos = _logic getVariable "_salvos";
			_guns = _logic getVariable "_guns";

			//Spawn salvo with values
			[_pos, _type, _radius, _guns, [0, 0.5]] spawn BIS_fnc_fireSupportVirtual;

			//Wait till next salvo
			sleep _seconds;
			
			//Check if more salvos should be spawned
			if (_salvos > 1) 
			then { 
				//Reduces amount of remaining salvos and spawn next
				_logic setVariable ["_salvos", _salvos -1];
				[_logic, _code] spawn _code; 
			} 
			else {if (_salvos == 1) 
				then{
					//Delete if all salvos are done
					deleteVehicle _logic;
				}
				else {if(_salvos == 0)
					then {
						//Don't stop if savlos is equal to 0
						[_logic, _code] spawn _code;
					}
					else{
						deleteVehicle _logic;
					}
				}
			}
		}
	};

	_delayedBarrage =
	{
		_logic = (_this select 0);
		_delay = (_this select 1);
		_code = (_this select 2);
		
		//Spawn barrage after delay
		sleep _delay;
		[_logic, _code] spawn _code;
	};

	// _spawnAreaMarker =
	// {
	// 	_logic = (_this select 0);
	// 	_radius = (_this select 1);
	// 	_pos = (_this select 2);
		
	// 	_obj = createSimpleObject ["\a3\Modules_F_Curator\Ordnance\surfaceMortar.p3d", _pos];
	// 	_scale = 0.025 * _radius;
	// 	_obj setObjectScale _scale;

	// 	[_logic, _obj] spawn {
	// 		_logic = (_this select 0);
	// 		_obj = (_this select 1);

	// 		while{!(isNull _logic)}
	// 		do {
	// 			sleep 0.5;

	// 			if(isNull _logic)
	// 			then{
	// 				deleteVehicle _obj;
	// 			}
	// 			else{
	// 				_pos1 = getPos _logic;
	// 				_pos2 = getPos _obj;

	// 				diag_log str _pos1;
	// 				diag_log str _pos2;

	// 				if(_pos1 select 0 != _pos2 select 0 && _pos1 select 1 != _pos2 select 1)
	// 				then{
	// 					_obj setPosWorld (getPos _logic);
	// 				}
	// 			}
	// 		};
	// 	};

	// };

	if(_create)
	then{
		[_logic, _delay, _spawnBarrage] spawn _delayedBarrage;
		// [_logic, _radius, _pos] spawn _spawnAreaMarker;
	};
};

//Display dialog
[
	"Select Firesupport Type and Area", 
	[
		["COMBO","Type",[["Sh_82mm_AMOS", "Sh_155mm_AMOS", "Cluster_155mm_AMOS"], ["82 mm Mortar", "155 mm Howitzer", "230 mm Rocket"],0]],
		["EDIT","Custom Type (ex.)",""],
		["SLIDER","Radius",[0,5000,500,0]],
		["SLIDER","Seconds between Salvos",[0,30,5,1]],
		["SLIDER","Start after ... seconds",[0,30,1,1]],
		["SLIDER","Stop After Salvos (0 = indef.)",[0,100,1,0]],
		["SLIDER","Guns",[1,30,1,0]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;