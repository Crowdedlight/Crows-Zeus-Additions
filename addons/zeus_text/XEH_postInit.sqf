#include "script_component.hpp"

// launch custom "handlers" for ace when opened curator display for the first time
["zen_curatorDisplayLoaded", {
    // remove event immediately
    [_thisType, _thisId] call CBA_fnc_removeEventHandler;

	call  crowsZA_fnc_activateZeusTextDisplay;

}] call CBA_fnc_addEventHandlerArgs;
