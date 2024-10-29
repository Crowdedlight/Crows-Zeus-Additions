#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_animalFollowZeus.sqf
Parameters: animalType and source to follow
Return: none

Creates an animal that follows the source while it is alive

*///////////////////////////////////////////////
params ["_animalType", "_src", "_amount", "_invincible", "_offset", "_scale", "_attack"];
private["_animalClassname", "_animalResponse", "_animalAceOffset"]; 

// set correct class names

switch (_animalType) do {
	case "Dog": 	 { _animalClassname = "Fin_random_F"; 	        _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_dog"; 	    _animalAceOffset = [0,0,0.5]; 	};
	case "Sheep": 	 { _animalClassname = "Sheep_random_F"; 	    _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_sheep"; 	    _animalAceOffset = [0,0.5,0.8];	};
	case "Goat": 	 { _animalClassname = "Goat_random_F"; 	        _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_goat"; 	    _animalAceOffset = [0,0.4,0.7];	}; 
	case "Rabbit": 	 { _animalClassname = "Rabbit_F"; 		        _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_rabbit"; 	    _animalAceOffset = [0,0.2,0.2];	}; 
	case "Hen": 	 { _animalClassname = "Hen_random_F"; 	        _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_hen"; 	    _animalAceOffset = [0,0.2,0.3];	}; 
	case "Snake": 	 { _animalClassname = "Snake_random_F"; 	    _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_snake"; 	    _animalAceOffset = [0,0,0];		};  
	case "Dromedary":{ _animalClassname = "Dromedary_random_lxWS";  _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_dromedary";   _animalAceOffset = [0,1.2,1.4];	};
	case "Rat":		 { _animalClassname = "SPE_Black_Rat";  		_animalResponse = localize "STR_CROWSZA_Misc_animal_sound_rat";   		_animalAceOffset = [0,0,0];		};
	default 		 { _animalClassname = "Fin_random_F"; 	        _animalResponse = localize "STR_CROWSZA_Misc_animal_sound_dog"; 	    _animalAceOffset = [0,0,0.5]; 	}; // Dog as default
};

GVAR(addAceActionPetDog) = 
{
	params["_animal", "_animalType", "_response", "_animalAceOffset"];
	private _action = ["crowszaPetAnimal",format ["%2 %1",_animalType, localize "STR_CROWSZA_Misc_animal_pet_animal"],"",
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

// const array of snake textures
private _sogSnakes = ["vn\animals_f_vietnam\snake\data\vn_snake_black.paa", "vn\animals_f_vietnam\snake\data\vn_snake_green.paa"];

for "_x" from 1 to round _amount do {
	// spawn animal
	_animal = createAgent [_animalClassname, _pos, [], 5, "CAN_COLLIDE"]; 
	_animal setVariable ["BIS_fnc_animalBehaviour_disable", true]; 

	//set invincible if param is chosen 
	if (_invincible) then {
		_animal allowDamage false;
	};

	//save animal to public var
	GVAR(animalFollowList) pushBack _animal;

	//make animal curator editable 
	["zen_common_updateEditableObjects", [[_animal]]] call CBA_fnc_serverEvent;

	//add ace interaction option to pet the animal, if ace is loaded 
	if (EGVAR(main,aceLoaded)) then {
		[[_animal, _animalType, _animalResponse, _animalAceOffset], GVAR(addAceActionPetDog)] remoteExec ["call", [ 0, -2 ] select isDedicated, true];
	};

	// scale it if != 1. first spawn object to attach to
	if (_scale != 1) then {
		private _spawnedScaleFunc = [_scale, _animal, _sogSnakes] spawn {
			params ["_scale", "_animal", "_sogSnakes"];

			private _scaleObj = createVehicle ["Land_Can_V2_F", getPos _animal, [], 5, "CAN_COLLIDE"];
			_animal attachTo [_scaleObj, [0,0,0]]; 
			_animal setObjectScale _scale;
			sleep 0.1;
			deleteVehicle _scaleObj;

			// if SOG is loaded, use random selection of sog textures
			if (EGVAR(main,sogLoaded)) then {
				private _skin = selectRandom _sogSnakes;
				_animal setObjectTextureGlobal [0, _skin];
			};
		};
	};

	//log it
	diag_log format["CrowsZA: animalFollow: Zeus has spawned a %1 to follow %2", _animalType, _src];

	// spawn thread that handle behaviour
	[_src, _animal, _animalType, _attack] spawn { 
		params["_src", "_animal", "_animalType", "_attack"]; 
		
		_animalGoMove = switch (_animalType) do {
			case "Dog": 	  { "Dog_Sprint" }; 
			case "Rabbit": 	  { "Rabbit_Hop" }; 
			case "Hen": 	  { "Hen_Walk" }; 
			case "Snake": 	  { "Snakes_Move" }; 
			case "Dromedary": { "Camel_Walk" };
			case "Rat": 	  { "SPE_Rat_idle_Sprint" };
			default { _animalType + "_Run" };
		};
		
		_animalIdleMove = switch (_animalType) do {
			case "Snake": 	  { "Snakes_Idle_Stop" }; 
			case "Dromedary": { "Camel_Idle_Stop" };
			case "Rat": 	  { "SPE_Rat_Idle_Stop" };
			default { _animalType + "_Idle_Stop" };
		};




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

			if ( _animalMoving ) then { _animal moveTo getPos _src; }; 

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
				if (EGVAR(main,aceLoaded)) then {
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
publicVariable QGVAR(animalFollowList);
