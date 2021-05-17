/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_drawBuildZeus.sqf
Parameters:
Return: none

Starts the selection handler to select multiple points for you to draw

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

diag_log "called drawBuildZeus";
private _positions = [_pos];
diag_log _positions;

[_positions, {
    params ["_successful", "_positions"];

    // use systemChat as feedback, as its only executed on this computer, so only zeus using the module sees it
    if (!_successful) exitWith {
        systemChat "Selection of drawing points failed or zeus was exited before hitting escape/spacebar";
    };

    if (count _positions < 2) exitWith {
        systemChat "Only one position was selected...";
    };

    // call build script
    [_positions] call crowsZA_fnc_drawBuild;

}, "Click to Build"] call crowsZA_fnc_selectPositions;
