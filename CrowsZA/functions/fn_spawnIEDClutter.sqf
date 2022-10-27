/*/////////////////////////////////////////////////
Author: Landric
			   
File: fn_spawnIEDClutter.sqf
Parameters: 
	position		- ([int])
	radius			- (int)
	density			- (float) modifier for the amount of clutter to spawn
	maxClutterSize	- (float) affects the size of clutter-type objects spawned
	iedSize			- (string) valid values are: "small", "large", "random"
	iedType			- (string) valid values are: "urban", "dug-in", "clutter", "random"
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
	"Land_Tyre_F"
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
	"Land_Wreck_UAZ_F"
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
private _smallClutter = _smallJunk + _smallElectronics;
private _mediumClutter = _mediumJunk + _mediumWrecks;
private _largeClutter = _mediumJunk + _largeWrecks;


/*/////////////////////////////////////////////////
 Place clutter
/*/////////////////////////////////////////////////

// TODO: Amount may require fine-tuning
private _clutterAmount = 3.14 * _radius * _radius * _density * 0.1;
for "_i" from 1 to _clutterAmount do {
	private _safePos = [_pos, 0, _radius, 0.5, 0, 0, 0, [], [[0,0], [0,0]]] call BIS_fnc_findSafePos;

	if(_safePos isEqualTo [0,0]) then {
		break;
	};

	private _clutterSize = random _maxClutterSize;
	private _clutter = switch (true) do
	{
		case (_clutterSize > 0.95): { selectRandom _largeClutter };
		case (_clutterSize > 0.75): { selectRandom _mediumClutter };
		default { selectRandom _smallClutter }; 
	};
	_clutter = _clutter createVehicle _safePos;
	_clutter setDir (random 360);
	_clutter enableSimulationGlobal false;
	["zen_common_addObjects", [[_clutter], objNull]] call CBA_fnc_serverEvent;
};


/*/////////////////////////////////////////////////
 Place IED(s)
/*/////////////////////////////////////////////////

private _ieds = [
	"ACE_IEDLandBig_Range_Ammo",
	"ACE_IEDUrbanBig_Range_Ammo",
	"ACE_IEDLandSmall_Range_Ammo",
	"ACE_IEDUrbanSmall_Range_Ammo"
];

if(_iedSize isEqualTo "small") then {
	_ieds = _ieds - ["ACE_IEDLandBig_Range_Ammo","ACE_IEDUrbanBig_Range_Ammo"];
};
if(_iedSize isEqualTo "large") then {
	_ieds = _ieds - ["ACE_IEDLandSmall_Range_Ammo","ACE_IEDUrbanSmall_Range_Ammo"];
};


if(_iedType isEqualTo "urban") then {
	_ieds = _ieds - ["ACE_IEDLandBig_Range_Ammo","ACE_IEDLandSmall_Range_Ammo"];
};
if(_iedType isEqualTo "dug-in") then {
	_ieds = _ieds - ["ACE_IEDUrbanBig_Range_Ammo","ACE_IEDUrbanSmall_Range_Ammo"];
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
	if(_iedType isEqualTo "clutter" || (_iedType isEqualTo "random" && (random 1) < 0.33)) then {
		_clutter = (selectRandom _smallClutter) createVehicle _safePos;
		_clutter setDir (random 360);
		_clutter enableSimulationGlobal false;
		["zen_common_addObjects", [[_clutter], objNull]] call CBA_fnc_serverEvent;

		_ied = createVehicle [_ied, _safePos, [], 0, "CAN_COLLIDE"];
		hideObjectGlobal _ied;
	} else {
		_ied = _ied createVehicle _safePos;
		_ied setDir (random 360);
	};

	// TODO: This doesn't seem to work for (armed) explosives
	["zen_common_addObjects", [[_ied], objNull]] call CBA_fnc_serverEvent;
};