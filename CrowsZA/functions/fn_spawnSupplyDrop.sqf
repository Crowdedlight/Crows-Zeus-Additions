/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_spawnSupplyDrop.sqf
Parameters: position ASL and unit clicked
Return: none


*///////////////////////////////////////////////

params ["_groupLeader", "_addAmount", "_ammoList"];

// get aircraft
private _aircraft = vehicle _groupLeader; 
private _pos = ASLToAGL (getPosASL _aircraft);

// as we should be over drop-position, we spawn crate 0.5m behind us. 
private _airdropPos = _pos getPos [0.1, (getDir _aircraft) - 180];
_airdropPos set [2, _pos select 2];

// spawn container 
private _container = createVehicle ["C_IDAP_supplyCrate_F", _airdropPos,[],0,"CAN_COLLIDE"];

clearWeaponCargo _container;
clearMagazineCargo _container;
clearItemCargo _container;
clearBackpackCargo _container;

// go through all mags, and add them to container based on zeus amount set multiplied with player count
{
	// add to container 
	_container addMagazineCargoGlobal [_x, _addAmount];
} forEach _ammoList;

private _chute = createvehicle ["i_parachute_02_f", _airdropPos,[],0,"CAN_COLLIDE"]; 
_container attachTo [_chute,[0,0,0.5]];

// attach smoke/chemlight grenade to crate and make it smoke. Spawning function to ensure it keeps smoking and lighting up until at least 5min have passed
private _indicatorSpawn = [_container, 300] spawn {
	params ["_box", "_maxTime"];
	private _startTime = time;

	_supplyLight = "Chemlight_blue" createVehicle (position _box);
	_supplyLight attachTo [_box, [0,0,0]];

	_supplySmoke = "SmokeShellBlue" createVehicle (position _box);
	_supplySmoke attachTo [_box, [0,0,0]];

	// repeat until time is up
	while {(time - _startTime) <= _maxTime} do {
		// check if null, then respawn and attach
		if (isNull _supplyLight) then {
			_supplyLight = "Chemlight_blue" createVehicle (position _box);
			_supplyLight attachTo [_box, [0,0,0]];
		};

		if (isNull _supplySmoke) then {
			_supplySmoke = "SmokeShellBlue" createVehicle (position _box);
			_supplySmoke attachTo [_box, [0,0,0]];
		};
		// don't need to check more than once per second
		sleep 1;
	};
};

// add container to editable
["zen_common_addObjects", [[_container], objNull]] call CBA_fnc_serverEvent;

