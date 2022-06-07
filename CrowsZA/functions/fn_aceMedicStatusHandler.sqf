
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_aceMedicStatusHandler.sqf
Parameters: 
Return: none

the PFH that updates the array with ace medic information for the display handler 

*///////////////////////////////////////////////

// only update and run when text is toggled
if (!crowsZA_zeusTextDisplay) exitWith {};

private _medicList = [];
{
	params["_player"];

	// get ace medical information
	private _openWounds = count(_x getVariable["ace_medical_openWounds",[]]);
	private _heartrate = (_x getVariable["ace_medical_heartRate",-1]);
	private _bleedingWounds = count(_x getVariable["ace_medical_woundBleeding",[]]);
	private _inCRDC = (_x getVariable ["ace_medical_inCardiacArrest", false]);
	private _inPain = (_x getVariable ["ace_medical_inPain", false]);

	// save in list
	_medicList pushBack [_openWounds, _heartrate, _bleedingWounds, _inCRDC, _inPain];
} forEach allPlayers;

crowsZA_medical_status_players = _medicList;


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

// #define VAR_BLOOD_PRESS       QEGVAR(medical,bloodPressure)
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