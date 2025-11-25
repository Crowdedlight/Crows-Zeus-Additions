#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_spawnIEDClutter.sqf
Parameters: 
	position		- ([int])
	radius			- (int)
	density			- (float) modifier for the amount of clutter to spawn
	maxClutterSize	- (int) valid values are: 0 (small), 1 (medium), or 2 (large)
	iedSize			- (int) valid values are: 0 (small), 1 (large), or 2 (random)
	iedType			- (int) valid values are: 0 ("urban"), 1 ("dug-in"), 2 ("clutter"), or 3 (random)
	iedAmount		- (int) number of explosives to create

Return: none

Spawns item clutter (e.g. garbage piles) and hidden IEDs

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_radius", 5, [0]], "_density", "_maxClutterSize", "_iedSize", "_iedType", "_iedAmount"];


/*/////////////////////////////////////////////////
 Clutter Types
/*/////////////////////////////////////////////////

private _smallJunk = [
	"Land_Garbage_square3_F",
	"Land_Garbage_square5_F",
	"Land_Garbage_line_F",
	"Land_GarbageBarrel_02_buried_F",
	"Land_Tyre_F",
	"Land_FlowerPot_01_F",
	"Land_Bucket_painted_F",
	"Land_ButaneCanister_F",
	"Land_Matches_F",
	"Land_PlasticBucket_01_open_F",
	"Land_PlasticBucket_01_closed_F",
	"Land_MoneyBills_01_bunch_F",
	"Land_MultiMeter_F",
	"Tire_Van_02_F",
	"Land_BottlePlastic_V1_F",
	"Land_Can_Dented_F",
	"Land_BakedBeans_F",
	"Land_CerealsBox_F",
	"Land_GasTank_01_blue_F",
	"Land_CanisterFuel_White_F",
	"Land_CanisterFuel_Red_F",
	"Land_CanisterFuel_F"
];

private _mediumJunk = [
	"Land_GarbageBags_F",
	"Land_GarbageBarrel_02_F",
	"Land_GarbageBarrel_01_english_F",
	"Land_GarbagePallet_F",
	"Land_GarbageHeap_04_F",
	"Land_GarbageHeap_03_F",
	"Land_GarbageHeap_02_F",
	"Land_GarbageWashingMachine_F",
	"Land_Tyres_F"
];

private _largeJunk = [

];

private _smallSports = [
	"Land_Baseball_01_F",
	"Land_BaseballMitt_01_F",
	"Land_Basketball_01_F",
	"Land_Football_01_F",
	"Land_Rugbyball_01_F",
	"Land_Volleyball_01_F",
	"Land_AirHorn_01_F"
];


private _mediumConstruction = [
	"Land_CinderBlocks_01_F",
	"Land_Pallets_stack_F",
	"Land_Pallets_F"
];

private _largeConstruction = [
	"Land_IronPipes_F",
	"Land_TimberPile_05_F",
	"Land_WoodenPlanks_01_messy_pine_F"
];

private _smallElectronics = [
	"Land_CarBattery_02_F",
	"Land_Microwave_01_F",
	"Land_FMradio_F"
];

private _mediumWrecks = [

];

private _largeWrecks = [
	"Land_Wreck_BRDM2_F",
	"Land_Wreck_BMP2_F",
	"Land_V3S_wreck_F",
	"Land_Wreck_T72_hull_F",
	"Land_Wreck_Car2_F",
	"Land_Wreck_Offroad2_F",
	"Land_Wreck_UAZ_F",
	"Land_ScrapHeap_2_F",
	"Land_ScrapHeap_1_F"
];

/*/////////////////////////////////////////////////
 Compile clutter
/*/////////////////////////////////////////////////

// TODO: Allow the user to select types of clutter for different settings? (e.g. vegetation? luggage?)
// private _smallClutter = [];
// private _mediumClutter = [];
// private _largeClutter = [];

// if(_junk) then {
// 	_smallClutter = _smallClutter + _smallJunk;
// 	_mediumClutter = _mediumClutter + _mediumJunk;
// 	_largeClutter = _largeClutter + _largeJunk;
// };

// if(_luggage) then {
//	 ...etc. etc.
// };

// For now, just curate it on their behalf
private _smallClutter = _smallJunk + _smallSports + _smallElectronics;
private _mediumClutter = _mediumJunk + _mediumWrecks + _mediumConstruction;
private _largeClutter = _mediumJunk + _largeWrecks + _largeConstruction;


/*/////////////////////////////////////////////////
 Place clutter
/*/////////////////////////////////////////////////

// TODO: Amount may require fine-tuning
private _clutterAmount = pi * _radius * _radius * _density * 0.1;
for "_i" from 1 to _clutterAmount do {
	private _safePos = [_pos, 0, _radius, 0.5, 0, 0, 0, [], [[0,0], [0,0]]] call BIS_fnc_findSafePos;

	if(_safePos isEqualTo [0,0]) then {
		break;
	};

	private _sizeChance = random 1;
	private _clutter = switch (_maxClutterSize) do {

		// Max size is "small"
		case 0: { selectRandom _smallClutter };
		// Max size is "medium"
		case 1: { 
			switch (true) do {
				case (_sizeChance > 0.66): { selectRandom _mediumClutter };
				default { selectRandom _smallClutter };
			}
		};
		// Max size is "large"
		case 2: {
			switch (true) do {
				case (_sizeChance > 0.95): { selectRandom _largeClutter };
				case (_sizeChance > 0.66): { selectRandom _mediumClutter };
				default { selectRandom _smallClutter };
			}
		};
	};
	_clutter = _clutter createVehicle _safePos;
	_clutter setDir (random 360);
	_clutter enableSimulationGlobal false;
	["zen_common_updateEditableObjects", [[_clutter]]] call CBA_fnc_serverEvent;
};


/*/////////////////////////////////////////////////
 Place IED(s)
/*/////////////////////////////////////////////////

private _ieds = if(EGVAR(main,aceLoaded)) then { 
	[
		"ACE_IEDLandBig_Range_Ammo",
		"ACE_IEDUrbanBig_Range_Ammo",
		"ACE_IEDLandSmall_Range_Ammo",
		"ACE_IEDUrbanSmall_Range_Ammo"
	]
} else {
	[
		"ModuleExplosive_IEDLandBig_F",
		"ModuleExplosive_IEDUrbanBig_F",
		"ModuleExplosive_IEDLandSmall_F",
		"ModuleExplosive_IEDUrbanSmall_F"
	]
};


if(_iedSize == 0) then {
	_ieds = _ieds - ["ACE_IEDLandBig_Range_Ammo","ACE_IEDUrbanBig_Range_Ammo", "ModuleExplosive_IEDLandBig_F", "ModuleExplosive_IEDUrbanBig_F"];
};
if(_iedSize == 1) then {
	_ieds = _ieds - ["ACE_IEDLandSmall_Range_Ammo","ACE_IEDUrbanSmall_Range_Ammo","ModuleExplosive_IEDLandSmall_F","ModuleExplosive_IEDUrbanSmall_F"];
};


if(_iedType == 0) then {
	_ieds = _ieds - ["ACE_IEDLandBig_Range_Ammo","ACE_IEDLandSmall_Range_Ammo", "ModuleExplosive_IEDLandBig_F","ModuleExplosive_IEDLandSmall_F"];
};
if(_iedType == 1) then {
	_ieds = _ieds - ["ACE_IEDUrbanBig_Range_Ammo","ACE_IEDUrbanSmall_Range_Ammo","ModuleExplosive_IEDUrbanBig_F","ModuleExplosive_IEDUrbanSmall_F"];
};


for "_i" from 1 to _iedAmount do {
	private _safePos = [_pos, 0, _radius, 0.1, 0, 0, 0, [], [[0,0], [0,0]]] call BIS_fnc_findSafePos;
	
	if(_safePos isEqualTo [0,0]) then {
		break;
	};

	private _ied = selectRandom _ieds;

	// If ied type is set to clutter (or random, with a 0.33 chance)
	// place an extra piece of clutter, and hide an invisible ied beneath it;
	// it should still be able to be detonated and defused as normal
	// (Non-ace ieds can't have their model hidden, so can't be disguised as clutter)
	if(EGVAR(main,aceLoaded) && (_iedType == 2 || (_iedType == 3 && (random 1) < 0.33))) then {
		_clutter = (selectRandom _smallClutter) createVehicle _safePos;
		_clutter setDir (random 360);
		_clutter enableSimulationGlobal false;
		["zen_common_updateEditableObjects", [[_clutter]]] call CBA_fnc_serverEvent;

		_ied = createVehicle [_ied, _safePos, [], 0, "CAN_COLLIDE"];
		hideObjectGlobal _ied;
	} else {
		_ied = _ied createVehicle _safePos;
		_ied setDir (random 360);
		["zen_common_updateEditableObjects", [[_ied]]] call CBA_fnc_serverEvent;
	};

	// If ace isn't loaded, mimic an ace pressure-plate ied
	if(!EGVAR(main,aceLoaded)) then {
		private _trigger = createTrigger ["EmptyDetector", getPos _ied, false];
		private _radius = 2;
		_trigger setTriggerArea [_radius, _radius, 0, false];
		_trigger setTriggerActivation ["ANY", "PRESENT", true];

		_trigger setVariable ["_ied", _ied];
		_ied setVariable ["_trigger", _trigger];

		private _condition = "this && (thisList findIf { !((stance _x) == ""PRONE"" || (stance _x) == """") } > -1);";

		private _activation = "
		(thisTrigger getVariable ""_ied"") setDamage 1;
		deleteVehicle thisTrigger;
		";

		_trigger setTriggerStatements [
			_condition,
			_activation,
			""
		];

		_ied addEventHandler ["Deleted", {
			params ["_entity"];
			deleteVehicle (_entity getVariable "_trigger");
		}];

		_ied addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			deleteVehicle (_unit getVariable "_trigger");
		}];
	};

	// TODO: This doesn't seem to work for (armed) explosives
	["zen_common_updateEditableObjects", [[_ied]]] call CBA_fnc_serverEvent;
};
