/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_radiusHeal.sqf
Parameters: pos, radius
Return: none

heals all players in a radius around the spot clicked

call: [getPosASL player, 20] call crowsZA_fnc_radiusHeal;

*///////////////////////////////////////////////
params ["_position", "_radius"];

//get all players in radius
_list = (ASLToAGL _position) nearEntities [["Man"], _radius];

//heal 
{
	// ACE
	if (crowsZA_common_aceModLoaded) then {
		// extinguish people on fire
		_x setVariable ["ace_fire_intensity", 0, true];
		["ace_medical_treatment_fullHealLocal", [_x], _x] call CBA_fnc_targetEvent;
	} else { // BASE GAME
		_x setDamage 0;
	};
} forEach _list;
