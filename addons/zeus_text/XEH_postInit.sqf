#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// launch custom "handlers" for ace when opened curator display for the first time
["zen_curatorDisplayLoaded", {
    // remove event immediately
    [_thisType, _thisId] call CBA_fnc_removeEventHandler;

	call FUNC(activateZeusTextDisplay);

}] call CBA_fnc_addEventHandlerArgs;

["zen_remoteControlStarted", FUNC(eventZeusStartRC)] call CBA_fnc_addEventHandler;
["zen_remoteControlStopped", FUNC(eventZeusStopRC)] call CBA_fnc_addEventHandler;
