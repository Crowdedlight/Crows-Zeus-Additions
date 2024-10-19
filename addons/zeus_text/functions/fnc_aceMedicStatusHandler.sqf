
#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_aceMedicStatusHandler.sqf
Parameters: 
Return: none

the PFH that updates the array with ace medic information for the display handler 

*///////////////////////////////////////////////

// only update and run when text is toggled
if (!GVAR(medicalDisplay)) exitWith {};

private _medicList = [];
{
	// get ace medical information
	private _openWounds = count (_x getVariable["ace_medical_openWounds",[]]);
	private _heartrate = round (_x getVariable["ace_medical_heartRate",-1]);
	private _bleedingRate = _x getVariable["ace_medical_woundBleeding",0];
	private _inCRDC = _x getVariable ["ace_medical_inCardiacArrest", false];
	private _inPain = _x getVariable ["ace_medical_inPain", false];
	private _medications = _x getVariable["ace_medical_medications",[]];

	_bleedingRate = [_bleedingRate, 3] call BIS_fnc_cutDecimals;

	//White [1,1,1,1]
	//Red [1,0,0,1]
	//Orange [1,0.3,0,1]

	private _color = [1,1,1,1]; 
	private _color2 = [1,1,1,1];

	if(_openWounds > 0 || _heartrate > 90 || _heartrate < 70) then {_color = [1,0.3,0,1] }; //orange
	if(_openWounds > 2 || _heartrate > 100 || _heartrate < 60) then {_color = [1,0,0,1]}; //red

	if(_bleedingRate > 0.01 ) then {_color2 = [1,0.3,0,1]}; //orange
	if(_bleedingRate > 0.06 ) then {_color2 = [1,0,0,1]}; //red
	if(_inCRDC ) then {_color2 = [1,0,0,1]}; //red

	private _txt = format["%3:%1, %4:%2", _openWounds, _heartrate, localize "STR_CROWSZA_zeustext_wounds", localize "STR_CROWSZA_zeustext_hr"];
	private _txt2 = "";
	private _txt3 = "";

	if(_inPain || _bleedingRate > 0) then { _txt2 = format["%2:%1", _bleedingRate, localize "STR_CROWSZA_zeustext_in_pain"] };
	if(_inCRDC) then { _txt2 = format[localize "STR_CROWSZA_zeustext_bleed_rate", _bleedingRate] };

	if(count _medications > 0) then 
	{
		_medications = _medications apply { _x#0 };
		_txt3 = localize "STR_CROWSZA_zeustext_effected_by" + ": "; 
		{
    		private _comma = [", ", " "] select (_forEachIndex == (count _medications -1));

    		_txt3 = _txt3 + format["%1%2", _x,_comma]; 
		} forEach _medications;
	};

	// save in list
	_medicList pushBack [_x, _color, _color2, _txt, _txt2, _txt3];
} forEach allPlayers;

GVAR(medical_status_players) = _medicList;


// LIST FROM : https://github.com/acemod/ACE3/blob/master/addons/medical_engine/script_macros_medical.hpp
//
// #define VAR_BLOOD_PRESS       QEGVAR(medical,bloodPressure)    ace_medical_bloodPressure
// #define VAR_BLOOD_VOL         QEGVAR(medical,bloodVolume)
// #define VAR_WOUND_BLEEDING    QEGVAR(medical,woundBleeding)
// #define VAR_CRDC_ARRST        QEGVAR(medical,inCardiacArrest)
// #define VAR_HEART_RATE        QEGVAR(medical,heartRate)
// #define VAR_PAIN              QEGVAR(medical,pain)
// #define VAR_PAIN_SUPP         QEGVAR(medical,painSuppress)
// #define VAR_PERIPH_RES        QEGVAR(medical,peripheralResistance)
// #define VAR_UNCON             "ACE_isUnconscious"
// #define VAR_OPEN_WOUNDS       QEGVAR(medical,openWounds)
// #define VAR_BANDAGED_WOUNDS   QEGVAR(medical,bandagedWounds)
// #define VAR_STITCHED_WOUNDS   QEGVAR(medical,stitchedWounds)
// // These variables track gradual adjustments (from medication, etc.)
// #define VAR_MEDICATIONS       QEGVAR(medical,medications)
// // These variables track the current state of status values above
// #define VAR_HEMORRHAGE        QEGVAR(medical,hemorrhage)
// #define VAR_IN_PAIN           QEGVAR(medical,inPain)
// #define VAR_TOURNIQUET        QEGVAR(medical,tourniquets)
// #define VAR_FRACTURES         QEGVAR(medical,fractures)
