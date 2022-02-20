/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_animalFollowZeus.sqf
Parameters: animalType and source to follow
Return: none

Creates an animal that follows the source while it is alive

*///////////////////////////////////////////////
params ["_animalType", "_src", "_amount", "_invincible", "_offset", "_scale", "_attack"];
private["_animalClassname", "_animalResponse", "_animalAceOffset"]; 

// set correct class names
if ( _animalType == "Dog" ) then { _animalClassname = "Fin_random_F"; _animalResponse = "WOOF"; _animalAceOffset = [0,0,0.5]; }; 
if ( _animalType == "Sheep" ) then { _animalClassname = "Sheep_random_F"; _animalResponse = "MÆÆÆÆÆHH"; _animalAceOffset = [0,0.5,0.8];}; 
if ( _animalType == "Goat" ) then { _animalClassname = "Goat_random_F"; _animalResponse = "MAAAAA..Mariner..AAAA"; _animalAceOffset = [0,0.4,0.7];}; 
if ( _animalType == "Rabbit" ) then { _animalClassname = "Rabbit_F"; _animalResponse = "PUUUUUUURRRRR"; _animalAceOffset = [0,0.2,0.2];}; 
if ( _animalType == "Hen" ) then { _animalClassname = "Hen_random_F"; _animalResponse = "CLUCK-CLUCK"; _animalAceOffset = [0,0.2,0.3];}; 
if ( _animalType == "Snake" ) then { _animalClassname = "Snake_random_F"; _animalResponse = "HISSSSS, No Step On Snek!"; _animalAceOffset = [0,0,0];}; 

crowsZA_fnc_addAceActionPetDog = 
{
	params["_animal", "_animalType", "_response", "_animalAceOffset"];
	private _action = ["crowszaPetAnimal",format ["Pet %1",_animalType],"",
	{		
		params ["_target", "_player", "_actionParams"];
		_player playActionNow "gesturePoint";
		hint (_actionParams select 0);
		[(_actionParams select 0), true, 5, 2] call ace_common_fnc_displayText;

	},{true},{},[_response], _animalAceOffset, 3] call ace_interact_menu_fnc_createAction;

	[_animal, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
};

// get offset where to spawn
private _pos = getPosATL _src;
if (_offset != 0) then {
	// random direction
	private _direction = (random 7) * 45;
	_pos = _pos getPos [_offset, _direction];
};

for "_x" from 1 to round _amount do {
	// spawn animal
	_animal = createAgent [_animalClassname, _pos, [], 5, "CAN_COLLIDE"]; 
	_animal setVariable ["BIS_fnc_animalBehaviour_disable", true]; 

	//set invincible if param is chosen 
	if (_invincible) then {
		_animal allowDamage false;
	};

	//save animal to public var
	crowsZA_animalFollowList pushback _animal;

	//make animal curator editable 
	["zen_common_addObjects", [[_animal], objNull]] call CBA_fnc_serverEvent;

	//add ace interaction option to pet the animal, if ace is loaded 
	if (crowsZA_common_aceModLoaded) then {
		[[_animal, _animalType, _animalResponse, _animalAceOffset], crowsZA_fnc_addAceActionPetDog] remoteExec ["call", [ 0, -2 ] select isDedicated, true];
	};

	// scale it if != 1. first spawn object to attach to
	if (_scale != 1) then {
		private _spawnedScaleFunc = [_scale, _animal] spawn {
			params ["_scale", "_animal"];

			private _scaleObj = createVehicle ["Land_Can_V2_F", getPos _animal, [], 5, "CAN_COLLIDE"];
			_animal attachTo [_scaleObj, [0,0,0]]; 
			_animal setObjectScale _scale;
			sleep 0.1;
			deleteVehicle _scaleObj;
		};
	};


	//log it
	diag_log format["CrowZA:animalFollow: Zeus has spawned a %1 to follow %2", _animalType, _src];

	// spawn thread that handle behaviour
	[_src, _animal, _animalType, _attack] spawn { 
		params["_src", "_animal", "_animalType", "_attack"]; 
		_animalGoMove = _animalType + "_Run"; _animalIdleMove = _animalType + "_Idle_Stop"; 

		if ( _animalType == "Dog" ) then { _animalGoMove = "Dog_Sprint"; }; 
		if ( _animalType == "Rabbit" ) then { _animalGoMove = "Rabbit_Hop"; }; 
		if ( _animalType == "Hen" ) then { _animalGoMove = "Hen_Walk"; }; 
		if ( _animalType == "Snake" ) then { _animalGoMove = "Snakes_Move"; }; 

		_moveDist = 3; 
		_animalMoving = false; 
		// init idle
		_animal playMove _animalIdleMove;
		sleep 0.2;

		//consider stopping run loop if source dies... I assume it would mean all the animals just stop and look at the corpse?
		while {alive _animal} do 
		{ 
			if ((_animal distance _src) > _moveDist) then 
			{ 
				if ( !_animalMoving ) then { _animal playMove _animalGoMove; _animalMoving = true; }; 
			}
			else 
			{ 
				if ( _animalMoving ) then 
				{ 
					_animal playMove _animalIdleMove; _animalMoving = false; 
				}; 
			}; 

			if ( _animalMoving ) then { _animal moveto getPos _src; }; 

			// if attack, get closest unit and attack it
			if (_attack) then {
				private _closestUnits = nearestObjects [_animal, ["CAManBase"], 1];
				private _attackUnit = objNull;
				{
					if (alive _x) exitWith {_attackUnit = _x};
				} forEach _closestUnits;

				// only attack if we got target
				if (isNull _attackUnit) exitWith {};

				// if ace, do ace damage, otherwise to basegame damage 
				if (crowsZA_common_aceModLoaded) then {
					private _damageSelectionArray = [
						0, 0, 1, 0, 2, 0, 
						3, 0, 4, 0, 5, 0
					];
					private _bodyPart = selectRandom ["leg_l", "leg_r", "hand_l", "hand_r", "body"];
					switch (_bodyPart) do {
						case "body": {
							_damageSelectionArray set [3, 1];
						};
						case "hand_l": {
							_damageSelectionArray set [5, 1];
						};
						case "hand_r": {
							_damageSelectionArray set [7, 1];
						};
						case "leg_l": {
							_damageSelectionArray set [9, 1];
						};
						case "leg_r": {
							_damageSelectionArray set [11, 1];
						};
					};

					// ace damage, legs, bite
					[_attackUnit, 0.4, _bodyPart, "bite", _animal, _damageSelectionArray] remoteExec ["ace_medical_fnc_addDamageToUnit", _attackUnit];
				} else {
					// base game
					private _currDmg = damage _attackUnit;
					_attackUnit setDamage (_currDmg + 0.1);
				};
				private _soundHurt = selectRandom 	["A3\Sounds_F\characters\human-sfx\P03\Hit_Low_1.wss", "A3\Sounds_F\characters\human-sfx\P03\Hit_Low_2.wss", "A3\Sounds_F\characters\human-sfx\P03\Hit_Low_3.wss", 
													"A3\Sounds_F\characters\human-sfx\P02\Low_hit_1.wss", "A3\Sounds_F\characters\human-sfx\P02\Low_hit_2.wss", "A3\Sounds_F\characters\human-sfx\P02\Low_hit_3.wss", "A3\Sounds_F\characters\human-sfx\P02\Low_hit_4.wss"];
				playSound3D [_soundHurt, _attackUnit, false];
			};
			sleep 0.4; 
		};
	};  
};
//update globally
publicVariable "crowsZA_animalFollowList";
