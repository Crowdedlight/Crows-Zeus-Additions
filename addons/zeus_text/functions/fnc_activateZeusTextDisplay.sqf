#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight

File: fnc_activateZeusTextDisplay.sqf
Parameters:
Return: none

Is called if ace is loaded, starts the display EH and ace medic status handler

*///////////////////////////////////////////////

// data array
GVAR(medical_status_players) = [];
GVAR(medicalDisplay) = false; // Not showing text by default

// add ace medic update handler
GVAR(PFH_aceMedicTextUpdater) = [FUNC(aceMedicStatusHandler), 1] call CBA_fnc_addPerFrameHandler;

// add displayEH
call FUNC(addZeusTextDisplayEH);
