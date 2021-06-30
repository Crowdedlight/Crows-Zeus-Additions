/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_animalFollowZeus.sqf
Parameters: animalType and source to follow
Return: none

Creates an animal that follows the source while it is alive

*///////////////////////////////////////////////
params ["_animalType", "_src", "_amount", "_invincible"];
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

for "_x" from 1 to _amount do {
	// spawn animal
	_animal = createAgent [_animalClassname, getPos _src, [], 5, "CAN_COLLIDE"]; 
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

	//log it
	diag_log format["CrowZA:animalFollow: Zeus has spawned a %1 to follow %2", _animalType, _src];

	// spawn thread that handle behaviour
	nul = [_src, _animal, _animalType] spawn { 
		params["_src", "_animal", "_animalType"]; 
		_animalGoMove = _animalType + "_Run"; _animalIdleMove = _animalType + "_Idle_Stop"; 

		if ( _animalType == "Dog" ) then { _animalGoMove = "Dog_Sprint"; }; 
		if ( _animalType == "Rabbit" ) then { _animalGoMove = "Rabbit_Hop"; }; 
		if ( _animalType == "Hen" ) then { _animalGoMove = "Hen_Walk"; }; 
		if ( _animalType == "Snake" ) then { _animalGoMove = "Snakes_Move"; }; 

		_animalMoving = true; 
		_moveDist = 5; 
		//consider stopping run loop if source dies... I assume it would mean all the animals just stop and look at the corpse?
		while {alive _animal || alive _src} do 
		{ 
			if (_animal distance _src > _moveDist) then 
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
			sleep 0.5; 
		};
	};  
};
//update globally
publicVariable "crowsZA_animalFollowList";
