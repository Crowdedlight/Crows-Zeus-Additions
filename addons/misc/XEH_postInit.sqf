#include "script_component.hpp"

// if not a player we don't do anything
if (!hasInterface) exitWith {}; 

publicVariable QGVAR(animalFollowList);

// zeus modules
private _moduleList = [
    [localize "STR_CROWSZA_Misc_activate_on_death",{_this call FUNC(onDeathZeus)}, "\a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"],
    [localize "STR_CROWSZA_Misc_remove_activate_on_death",{_this call FUNC(removeOnDeathZeus)}, "\a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"],
    [localize "STR_CROWSZA_Misc_remove_trees",{_this call FUNC(removeTreesZeus)}, QPATHTOF(data\axe.paa)],
    [localize "STR_CROWSZA_Misc_restore_trees",{_this call FUNC(restoreTreesZeus)}, QPATHTOF(data\tree.paa)],
    [localize "STR_CROWSZA_Misc_follow_unit_animals",{_this call FUNC(animalFollowZeus)}, QPATHTOF(data\sheep.paa)],
    [localize "STR_CROWSZA_Misc_delete_follow_unit_animals",{_this call FUNC(deleteAllAnimalFollow)}, QPATHTOF(data\sheep.paa)],
    [localize "STR_CROWSZA_Misc_spawn_arsenal",{_this call FUNC(spawnArsenal)}, "\a3\ui_f\data\logos\a_64_ca.paa"],
    [localize "STR_CROWSZA_Misc_set_numberplate",{_this call FUNC(setNumberplate)}, QPATHTOF(data\numberplate.paa)],
    [localize "STR_CROWSZA_Misc_delete_all_dead",{_this call FUNC(deleteAllDead)}, QPATHTOF(data\cleanup.paa)],
    [localize "STR_CROWSZA_Misc_set_colour",{_this call FUNC(setColour)}, QPATHTOF(data\paint.paa)],
    [localize "STR_CROWSZA_Misc_fire_support",{_this call FUNC(fireSupport)}, "\x\zen\addons\modules\ui\target_ca.paa"],
    [localize "STR_CROWSZA_Misc_resupply_player_loadouts",{_this call FUNC(resupplyPlayerLoadouts)}, QPATHTOF(data\resupplyplayerloadout.paa)],
    [localize "STR_CROWSZA_Misc_remove_bino_radio",{_this call FUNC(removeRadioBino)}, "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"],
    [localize "STR_CROWSZA_Misc_spawn_ied_clutter",{_this call FUNC(spawnIEDClutterZeus)}, "\a3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa"],
    [localize "STR_CROWSZA_Misc_strip_explosives",{_this call FUNC(stripExplosivesZeus)}, "\a3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa"],
    [localize "STR_CROWSZA_Misc_suitcaseNuke",{_this call FUNC(suitcaseNukeZeus)}, "\x\zen\addons\modules\ui\nuke_ca.paa"],
    [localize "STR_CROWSZA_Misc_surrender_chance",{_this call FUNC(surrenderChanceZeus)}, "\a3\ui_f\data\igui\cfg\holdactions\holdAction_secure_ca.paa"]
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
        ["camera_center_unit",localize "STR_CROWSZA_Misc_camera_center_unit",QPATHTOF(data\camera.paa), {_hoveredEntity call FUNC(centerZeusViewUnit)}, {_hoveredEntity isEqualType objNull && {!isNull _hoveredEntity && (typeName _hoveredEntity) isNotEqualTo "GROUP"}}] call zen_context_menu_fnc_createAction,
        [],
        0
    ],
    [
        ["paste_loadout_to_inventory", localize "STR_CROWSZA_Misc_paste_loadout",QPATHTOF(data\paste.paa), {_hoveredEntity call FUNC(contextPasteLoadout)}, {!isNil "zen_context_actions_loadout" && _hoveredEntity isEqualType objNull && {!isNull _hoveredEntity}}] call zen_context_menu_fnc_createAction,
        ["Inventory"],
        0
    ],
    [
        ["loadout_viewer", localize "STR_CROWSZA_Misc_view","\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_0_ca.paa", {_hoveredEntity call FUNC(loadoutViewer)}, {[_hoveredEntity] call EFUNC(main,isAliveManUnit)}] call zen_context_menu_fnc_createAction,
        ["Loadout"],
        0
    ],
    [
        ["radius_heal", localize "STR_CROWSZA_Misc_radius_heal",QPATHTOF(data\radiusheal.paa), {[_position] call FUNC(radiusHealDialog)}, {true}, [], {[
            [["radius_heal_10", localize "STR_CROWSZA_Misc_10m",QPATHTOF(data\radiusheal.paa), {[_position, 10] call FUNC(radiusHeal)}] call zen_context_menu_fnc_createAction, [], 10],
            [["radius_heal_50", localize "STR_CROWSZA_Misc_50m",QPATHTOF(data\radiusheal.paa), {[_position, 50] call FUNC(radiusHeal)}] call zen_context_menu_fnc_createAction, [], 10],
            [["radius_heal_100", localize "STR_CROWSZA_Misc_100m",QPATHTOF(data\radiusheal.paa), {[_position, 100] call FUNC(radiusHeal)}] call zen_context_menu_fnc_createAction, [], 10],
            [["radius_heal_150", localize "STR_CROWSZA_Misc_150m",QPATHTOF(data\radiusheal.paa), {[_position, 150] call FUNC(radiusHeal)}] call zen_context_menu_fnc_createAction, [], 10]
        ]}] call zen_context_menu_fnc_createAction,
        ["HealUnits"],
        0
    ],
    [
        ["toggle_pathing", localize "STR_CROWSZA_Misc_toggle_pathing","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", {}, {true}, [], {[
            [["toggle_pathing_radius","Radius",QPATHTOF(data\radiusheal.paa), {}, {true}, [], {[
                [["toggle_pathing_radius_10", localize "STR_CROWSZA_Misc_10m",QPATHTOF(data\radiusheal.paa), { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 10]; [_units, 2] call FUNC(togglePathing) }, {true}, [], {[
                    [["toggle_pathing_unit_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 10]; [_units, 0] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_on",localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 10]; [_units, 1] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 10]; [_units, 2] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_radius_50", localize "STR_CROWSZA_Misc_50m",QPATHTOF(data\radiusheal.paa), { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 50]; [_units, 2] call FUNC(togglePathing) }, {true}, [], {[
                    [["toggle_pathing_unit_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 50]; [_units, 0] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 50]; [_units, 1] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 50]; [_units, 2] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_radius_100", localize "STR_CROWSZA_Misc_100m",QPATHTOF(data\radiusheal.paa), { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 100]; [_units, 2] call FUNC(togglePathing)}, {true}, [], {[
                    [["toggle_pathing_unit_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 100]; [_units, 0] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 100]; [_units, 1] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 100]; [_units, 2] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_radius_200", localize "STR_CROWSZA_Misc_200m",QPATHTOF(data\radiusheal.paa), { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 200]; [_units, 2] call FUNC(togglePathing) }, {true}, [], {[
                    [["toggle_pathing_unit_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 200]; [_units, 0] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 200]; [_units, 1] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_unit_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], { private _units = (ASLToAGL _position) nearEntities [["Man", "LandVehicle"], 200]; [_units, 2] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10]
            ]}] call zen_context_menu_fnc_createAction, [], 10],

            [["toggle_pathing_unit", localize "STR_CROWSZA_Misc_unit","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { [[_hoveredEntity], 2] call FUNC(togglePathing) }, {((typeName _hoveredEntity) isEqualTo "OBJECT") && {(group _hoveredEntity) isNotEqualTo grpNull}}, [], {[
                [["toggle_pathing_unit_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], { [[_hoveredEntity], 0] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_unit_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { [[_hoveredEntity], 1] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_unit_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], { [[_hoveredEntity], 2] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10]
            ]}] call zen_context_menu_fnc_createAction, [], 10],

            [["toggle_pathing_unit", localize "STR_CROWSZA_Misc_group","\A3\ui_f\data\map\markers\nato\o_unknown.paa", { [units _hoveredEntity, 2] call FUNC(togglePathing) }, {(typeName _hoveredEntity) isEqualTo "GROUP" || {((typeName _hoveredEntity) isEqualTo "OBJECT") && {(group _hoveredEntity) isNotEqualTo grpNull}}}, [], {[
                [["toggle_pathing_group_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], { [units _hoveredEntity, 0] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_group_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", { [units _hoveredEntity, 1] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10],
                [["toggle_pathing_group_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], { [units _hoveredEntity, 2] call FUNC(togglePathing) }] call zen_context_menu_fnc_createAction, [], 10]
            ]}] call zen_context_menu_fnc_createAction, [], 10],

            [["toggle_pathing_side", localize "STR_CROWSZA_Misc_side","\A3\ui_f\data\map\markers\nato\b_unknown.paa", {}, {true}, [], {[
                [["toggle_pathing_blufor", localize "STR_CROWSZA_Misc_blufor",["\A3\ui_f\data\map\markers\nato\b_unknown.paa", [0,0.3,0.6,1]], {[units west, 2] call FUNC(togglePathing)}, {true}, [], {[
                    [["toggle_pathing_b_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], {[units west, 0] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_b_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", {[units west, 1] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_b_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], {[units west, 2] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10],
                
                [["toggle_pathing_opfor", localize "STR_CROWSZA_Misc_opfor",["\A3\ui_f\data\map\markers\nato\o_unknown.paa", [0.5,0,0,1]], {[units east, 2] call FUNC(togglePathing)}, {true}, [], {[
                    [["toggle_pathing_o_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], {[units east, 0] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_o_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", {[units east, 1] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_o_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], {[units east, 2] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10],

                [["toggle_pathing_indfor", localize "STR_CROWSZA_Misc_indfor",["\A3\ui_f\data\map\markers\nato\n_unknown.paa", [0,0.5,0,1]], {[units independent, 2] call FUNC(togglePathing)}, {true}, [], {[
                    [["toggle_pathing_i_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], {[units independent, 0] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_i_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", {[units independent, 1] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_i_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], {[units independent, 2] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10],

                [["toggle_pathing_civ", localize "STR_CROWSZA_Misc_civ",["\A3\ui_f\data\map\markers\nato\c_unknown.paa", [0.4,0,0.5,1]], {[units civilian, 2] call FUNC(togglePathing)}, {true}, [], {[
                    [["toggle_pathing_c_off", localize "STR_CROWSZA_Misc_off",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0.5,0,0,1]], {[units civilian, 0] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_c_on", localize "STR_CROWSZA_Misc_on","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", {[units civilian, 1] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10],
                    [["toggle_pathing_c_toggle", localize "STR_CROWSZA_Misc_toggle",["\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa", [0,0.3,0.6,1]], {[units civilian, 2] call FUNC(togglePathing)}] call zen_context_menu_fnc_createAction, [], 10]
                ]}] call zen_context_menu_fnc_createAction, [], 10]
            ]}] call zen_context_menu_fnc_createAction, [], 10]
        ]}] call zen_context_menu_fnc_createAction,
        [],
        0
    ]
];
{
    [
        // action, parent path, priority
        (_x select 0), (_x select 1), (_x select 2)
    ] call zen_context_menu_fnc_addAction;
} forEach _contextActionList;
