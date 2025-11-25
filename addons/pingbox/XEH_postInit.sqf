#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// launch custom "handlers" for ping box, when opened curator display for the first time
["zen_curatorDisplayLoaded", {
    // remove event immediately
    [_thisType, _thisId] call CBA_fnc_removeEventHandler;

    call FUNC(enablePingBoxHUD);

}] call CBA_fnc_addEventHandlerArgs;
