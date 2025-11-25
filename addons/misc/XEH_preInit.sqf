#include "script_component.hpp"
#include "XEH_PREP.hpp"

ADDON = true;

GVAR(animalFollowList) = [];

// public vars for overriding resupply options -- Appending new entries to this list will let that classname be available in the dropdown for resupply module
GVAR(resupply_aircraftList) = ["B_T_VTOL_01_vehicle_F"];
GVAR(resupply_aircraftDisplayList) = ["Blackfish"];

// SOG loaded
if (EGVAR(main,sogLoaded)) then {
	GVAR(resupply_aircraftList) pushBack "vn_b_air_uh1c_07_07";
	GVAR(resupply_aircraftDisplayList) pushBack "Huey Slick (SOG)";
};

// RHS loaded 
if (EGVAR(main,rhsLoaded)) then {
	GVAR(resupply_aircraftList) append ["RHS_C130J_Cargo", "rhsusf_CH53e_USMC_D_cargo", "RHS_CH_47F_cargo", "RHS_Mi8t_civilian"];
	GVAR(resupply_aircraftDisplayList) append ["C-130 Plane (RHS)", "CH-53 Sea Stallion (RHS)", "CH-47F Chinook (RHS)", "MI-8T Civilian Helicopter (RHS)"];
};

// AMF loaded
if (EGVAR(main,amfHelicoptersLoaded)) then {
	GVAR(resupply_aircraftList) append ["amf_nh90_tth_cargo", "B_AMF_PLANE_TRANSPORT_01_F"];
	GVAR(resupply_aircraftDisplayList) append ["NH-90 Helicopter (AMF)", "CASA CN-235 Plane (AMF)"];
};

// OPTRE loaded 
if (EGVAR(main,optreLoaded)) then {
	GVAR(resupply_aircraftList) append ["OPTRE_Pelican_unarmed"];
	GVAR(resupply_aircraftDisplayList) append ["Pelican (OPTRE)"];
};
