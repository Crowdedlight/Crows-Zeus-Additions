#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

// zeus modules
private _moduleList = [
    [localize "STR_CROWSZA_Teleport_scatter_teleport",{_this call FUNC(scatterTeleportZeus)}, QPATHTOF(data\tp.paa)],
    [localize "STR_CROWSZA_Teleport_teleport_to_squadmate",{_this call FUNC(teleportToSquadMember)}, QPATHTOF(data\tpToSquad.paa)],
    [localize "STR_CROWSZA_Teleport_set_teleport_to_squadmate",{_this call FUNC(setTeleportToSquadMemberZeus)}, QPATHTOF(data\tpToSquad.paa)]
];

{
    [
        "Crows Zeus Modules", 
		(_x select 0), 
		(_x select 1), 
		(_x select 2)
    ] call zen_custom_modules_fnc_register;
} forEach _moduleList;

// register context actions
private _contextActionList = [
    // Action name, Display name, Icon and Icon colour, code, Condition to show, arguments, dynamic children, modifier functions
    [
        ["teleport_to_squadmate",localize "STR_CROWSZA_Teleport_teleport_to_squadmate",QPATHTOF(data\tpToSquad.paa),
        {[[],_hoveredEntity] call FUNC(teleportToSquadMember)}, 
        {_hoveredEntity isEqualType {} && {!isNull _hoveredEntity && [_hoveredEntity] call EFUNC(main,isAliveManUnit) && (count units group leader _hoveredEntity) > 1}}] call zen_context_menu_fnc_createAction,
        [],
        6
    ]
];
{
    [
        // action, parent path, priority
        (_x select 0), (_x select 1), (_x select 2)
    ] call zen_context_menu_fnc_addAction;
} forEach _contextActionList;