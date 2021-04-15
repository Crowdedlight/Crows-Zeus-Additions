#include "common_defines.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_loadoutRefresh.sqf
Parameters: display
Return: none

updates the display with current loadout of unit

*///////////////////////////////////////////////

params ["_display"];

//get list 
private _ctrlList = _display displayCtrl IDC_LIST;
lnbClear _ctrlList;

//get unit selected
private _unit = _display getVariable "crowsZA_loadout_viewer_unit";
private _loadoutArr = getUnitLoadout _unit;

diag_log _loadoutArr;

// Update weight number
private _weightABS = (loadAbs _unit) * 0.1;
private _weightKG = (round (_weightABS * (1/2.2046) * 100)) / 100;

private _ctrlWeight = _display displayCtrl IDC_WEIGHT;
_ctrlWeight ctrlSetText format ["Weight: %1kg", _weightKG];

//make array for loadout list in format [[type, item, amount, [attachments if weapon]], [type, item, amount, [attachments if weapon]]...]
private _list = [];

//main wep, secondary, handgun
private _weapons = (_loadoutArr select [0, 3]) + [_loadoutArr select 8];
private _containers = _loadoutArr select [3,3]; //3,4,5 == uniform, vest and backpack 
private _helmet = _loadoutArr select 6;
private _facewear = _loadoutArr select 7;
private _items = _loadoutArr select 9;

crowsZA_loadout_addOrIncrement = {
    params ["_type", "_item", "_count", "_array"];

    //check if it exists in array
    private _exists = -1;
    {
        if (_x select 1 isEqualTo _item) exitWith{_exists = _forEachIndex};
    } forEach _array;

    //add if not found, otherwise increment count
    if (_exists == -1) then 
    {
        //add to array
        _array pushBack [_type, _item, _count];
    } else 
    {
        //we got index of element 
        private _temp = _array select _exists;
        //add to count variable
        _temp set [2, (_temp select 2) + _count];
        //save to original array 
        _array set [_exists, _temp];
    }
};

//handle weapons, for now we don't show accessorys, so just add weapons
{
    if (isNil "_x" || count _x < 1) then {continue};
    //_x == ["main weapon", "silencer", "pointer", "optic", ["loaded primary mag", ammo count], ["loaded secoundary mag", ammo count], "bipod"]
    private _mainWep = _x select 0;
    //add to list 
    [TYPE_WEAPON, _mainWep, 1, _list] call crowsZA_loadout_addOrIncrement;
} forEach _weapons;

//helmet 
if (_helmet != "") then {[TYPE_ITEM, _helmet, 1, _list] call crowsZA_loadout_addOrIncrement};

//facewear
if (_facewear != "") then {[TYPE_ITEM, _facewear, 1, _list] call crowsZA_loadout_addOrIncrement};

//adding containers here instead of in loop, to make the loadout show in format of weapons, headgear, facewear, containers, items
//uniform
private _uniform = (_containers select 0); 
if (!isNil "_uniform" && count _uniform > 0) then {[TYPE_CONTAINER, (_uniform select 0), 1, _list] call crowsZA_loadout_addOrIncrement};
    
//vest
private _vest = (_containers select 1); 
if (!isNil "_vest" && count _vest > 0) then {[TYPE_CONTAINER, (_vest select 0), 1, _list] call crowsZA_loadout_addOrIncrement};

//backpack
private _backpack = (_containers select 2); 
if (!isNil "_backpack" && count _backpack > 0) then {[TYPE_CONTAINER, (_backpack select 0), 1, _list] call crowsZA_loadout_addOrIncrement};

//containers 
diag_log "_containers";
diag_log _containers;
{
    if (isNil "_x" || count _x < 1) then {continue};

    diag_log "single container array";
    diag_log _x;

    //iterate the container and add items
    {
        //_x = ["30Rnd_65x39_caseless_mag", 3, 30], or ["FirstAidKit", 1]
        // as both item and magazines has the amount as param 1, we can ignore the ones with an extra param and deal with all identically
        diag_log "item in container array";
        diag_log _x;
        [TYPE_ITEM, (_x select 0), (_x select 1), _list] call crowsZA_loadout_addOrIncrement;
    } forEach (_x select 1);
} forEach _containers;

//items
{
    if (isNil "_x" || _x == "") then {continue};
    [TYPE_ITEM, _x, 1, _list] call crowsZA_loadout_addOrIncrement;
} forEach _items;

diag_log _list;

//loop our array and add to list - TODO handle weapon cases and show attachments or something
// _list = [[type, item, amount, [attachments if weapon]],...]
{
    private _mainItem = _x select 1;

    private _config = [_mainItem] call CBA_fnc_getItemConfig;
    private _name = getText (_config >> "displayName");

    // Handle searching items by display name or class name
    // private _text = [_name, _mainItem] select _filterByClass;

    //TODO allow filtering
    // if (_filter in toLower _text) then {
        private _picture = getText (_config >> "picture");
        private _tooltip = format ["%1\n%2", _name, _mainItem];
        private _count = _x select 2;
        private _alpha = 1;

        private _index = _ctrlList lnbAddRow ["", _name, str _count];
        _ctrlList lnbSetPicture [[_index, 0], _picture];
        _ctrlList lnbSetTooltip [[_index, 0], _tooltip];
        _ctrlList lnbSetColor   [[_index, 1], [1, 1, 1, _alpha]];
        _ctrlList lnbSetColor   [[_index, 2], [1, 1, 1, _alpha]];
        _ctrlList lnbSetValue   [[_index, 2], _count];
        _ctrlList lnbSetData    [[_index, 0], _mainItem];
    // };
} forEach _list;

// test funciton 
// private _arr = [];
// crowsZA_loadout_addOrIncrement = {
//     params ["_type", "_item", "_count", "_array"];
//     private _exists = -1;
//     {
//         if (_x select 1 isEqualTo _item) exitWith{_exists = _forEachIndex};
//     } forEach _array;
//     if (_exists == -1) then 
//     {
//         _array pushBack [_type, _item, _count];
//     } else 
//     {
//         private _temp = _array select _exists;
//         _temp set [2, (_temp select 2) + _count];
//         _array set [_exists, _temp];
//     }
// };
// ["weapon","arifle_MXC_Holo_pointer_F",2,_arr] call crowsZA_loadout_addOrIncrement;
// ["weapon","arifle_MXC_Holo_pointer_F",3,_arr] call crowsZA_loadout_addOrIncrement;



//test weapons array
// private _arr = [
// 	["arifle_MXC_Holo_pointer_F", "", "acc_pointer_IR", "optic_Holosight", ["30Rnd_65x39_caseless_mag", 30], [], ""],
// 	["launch_B_Titan_short_F", "", "", "", ["Titan_AT", 1], [], ""],
// 	["hgun_P07_F", "", "", "", ["16Rnd_9x21_Mag", 16], [], ""],
// 	["U_B_CombatUniform_mcam", [["FirstAidKit", 1], ["30Rnd_65x39_caseless_mag", 2, 30], ["Chemlight_green", 1, 1]]],
// 	["V_PlateCarrier1_rgr", [["30Rnd_65x39_caseless_mag", 3, 30], ["16Rnd_9x21_Mag", 2, 16], ["SmokeShell", 1 ,1], ["SmokeShellGreen", 1, 1], ["Chemlight_green", 1, 1]]],
// 	["B_AssaultPack_mcamo_AT",[["Titan_AT", 2, 1]]],
// 	"H_HelmetB_light_desert", "G_Bandanna_tan",["Binocular", "", "", "", [], [], ""],
// 	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]
// ];
// systemChat str ((_arr select [0, 3]) + [_arr select 8]);






