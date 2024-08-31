#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Landric
               
File: fn_strongpoint.sqf
Parameters: _dialogResult, _in
Return: none

*///////////////////////////////////////////////
params ["_dialogResult","_in"];

_in params [["_pos",[0,0,0],[[]],3], "_unit"];

private _params = ["_composition", "_radius","_desiredStrongpointCount","_fill","_sandbags","_patrols"];
if(!isNull _unit) then { _params = _params - ["_composition"]; };
if(!EGVAR(main,zeiLoaded)) then { _params = _params - ["_sandbags"]; };

_dialogResult params _params;


private "_groupPrefab";
if(isNull _unit) then {
    // TODO: actually link _composition to the UI portion
    _groupPrefab = _composition;
}
else {
    _groupPrefab = group _unit;
};


// If an HC is registered, spawn units directly on that. Otherwise, spawn locally
private _hcRegister = GETMVAR(EGVAR(main,hcRegister),[]);
private _client = if(count _hcRegister > 0) then {
    // Get the HC(s) with the lowest fps
    private _minfps = selectMin (values _hcRegister);
    private _clients = (keys _hcRegister) select { _hcRegister get _x <= _minfps};
    if(count _clients > 0) exitWith { selectRandom _clients };
    // If we can't find a client for some reason (e.g. the register has updated since getting the fps)
    // just return any HC
    selectRandom (keys _hcRegister)
} else { clientOwner };

// Get all buildings in radius
// TODO: account for dispersion - i.e., cluster strongpoints together, or spread out
_buildings = ASLtoAGL _pos nearObjects ["House", _radius];
_buildings = _buildings call BIS_fnc_arrayShuffle;


private _strongpointCount = 0;
while { _strongpointCount < _desiredStrongpointCount && (count _buildings) > 0 } do {

    // Calculate the desired number of units to spawn for this strongpoint,
    // based on the number of available positions in the building
    private _building = _buildings deleteAt 0;
    private _positions = _building buildingPos -1;
    if(count _positions <= 0) then { continue; };
    private _desiredUnits = (round((count _positions) * _fill)) max 1;

    // TODO: spawn units directly on HC if exists
    // TODO: account for unit being null if we're selecting via dropdown
    private _group = createGroup (side _unit); 

    for "_i" from 0 to _desiredUnits-1 do {
        private _prefabUnit = (units _groupPrefab) select (_i % count (units _groupPrefab));
        [_group , [(typeOf _prefabUnit), position _building, [], 0, "NONE"]] remoteExec ["createUnit", _client];
        // private _newUnit = _group createUnit [(typeOf _prefabUnit), position _building, [], 0, "NONE"];
        //_newUnit setUnitLoadout (getUnitLoadout _prefabUnit);
        // How to set the unit's loadout now that we don't have a reference to it, without bundling both commands into a "call"?
    };

    if(EGVAR(main,lambsLoaded)) then {
        [_group, _building, 1, [], true, true] call lambs_wp_fnc_taskGarrison;
    } else {
        // This is a very basic implementation of garrisoning strongpoints
        private _units = units _group;
        for "_i" from 0 to (count _units)-1 do {
            _units#_i setPos _positions#_i;
            _units#_i setUnitPos (selectRandom ["UP", "MIDDLE"]);
            _units#_i disableAI "PATH";
        }
    };
    
    if(!isNil "_sandbags" && { _sandbags }) then {
        if(EGVAR(main,zeiLoaded)) then {
            [_building,"mil",false,true,false,0] call ZEI_fnc_createTemplate;
        } else {
            // TODO: if zei not loaded, do manually (lol)
        };
    };

    _strongpointCount = _strongpointCount + 1;
};


// Create patrols
for "_i" from 0 to _patrols-1 do {

    // TODO: account for unit being null if we're selecting via dropdown
    private _group = createGroup (side _unit);
    private _startPos = [[[ASLtoAGL _pos, _radius]]] call BIS_fnc_randomPos;
    {
        [_group , [(typeOf _x), _startPos, [], 0, "NONE"]] remoteExec ["createUnit", _client];
        // private _newUnit = _group createUnit [(typeOf _x), _startPos, [], 0, "NONE"];
        // _newUnit setUnitLoadout (getUnitLoadout _x);
        // How to set the unit's loadout now that we don't have a reference to it, without bundling both commands into a "call"?
    } forEach units _groupPrefab;

    if(EGVAR(main,lambsLoaded)) then {
        [_group, _pos, _radius, 4, [], true, true] call lambs_wp_fnc_taskPatrol;
    } else {
        
        // This is a very basic implementation of patroling
        _group setBehaviour "SAFE";
        for "_i" from 0 to 4 do {
            _group addWaypoint [_startPos, 200];
        };
        ((waypoints _group) select ((count waypoints _group)-1)) setWaypointType "CYCLE";
    };
};




{ deleteVehicle _x } forEach units _groupPrefab;
