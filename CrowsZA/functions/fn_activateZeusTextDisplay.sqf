#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight

File: fn_activateZeusTextDisplay.sqf
Parameters:
Return: none

Is called if ace is loaded, starts the display EH and ace medic status handler

*///////////////////////////////////////////////

// data array
crowsZA_medical_status_players = [];
crowsZA_zeusTextMedicalDisplay = false; // Not showing text by default

// add ace medic update handler
crowsZA_PFH_aceMedicTextUpdater = [crowsZA_fnc_aceMedicStatusHandler, 1] call CBA_fnc_addPerFrameHandler;

// add displayEH
call crowsZA_fnc_addZeusTextDisplayEH;
