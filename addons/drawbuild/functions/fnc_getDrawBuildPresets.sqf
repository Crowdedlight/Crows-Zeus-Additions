#include "script_component.hpp"
/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fnc_getDrawBuildPresets.sqf

Parameters: classname
Return: Array - [objectLength, objectLengthOffset, objectDirOffset], or objNull if no matching preset

Returns preset lengths/offsets for predetermined classnames

*///////////////////////////////////////////////

params ["_classname"];

private _return = switch(_classname) do {
	// smaller hesco
	case "Land_HBarrier_3_F":
	{
		[3.45376, 1.7, 90]
	};
	// large hesco
	case "Land_HBarrier_Big_F":
	{
		[8.5, 4.25, 90]
	};		
	// sandbags
	case "Land_BagFence_Short_F":
	{
		[1.6, 0.7, 90]
	};
	// tall sandbags
	case "Land_SandbagBarricade_01_F":
	{
		[1.7, 1.7, 90]
	};
	// trench
	case "fort_envelopebig": //only exists if grad trenches is on the server
	{
		[6, 3, 270]
	};
	// concrete wall
	case "Land_ConcreteWall_01_m_4m_F":
	{
		[4, 2, 90]
	};
	// smaller hesco - green
	case "Land_HBarrier_01_line_3_green_F":
	{
		[3.45376, 1.7, 90]
	};
	// big hesco - green 
	case "Land_HBarrier_01_big_4_green_F":
	{
		[8.5, 4.25, 90]
	};
	// sandbag wall - green
	case "Land_BagFence_01_short_green_F":
	{
		[1.6, 0.7, 90]
	};
	// military wall big
	case "Land_Mil_WallBig_4m_F":
	{
		[4, 2, 90]
	};
	// land fortress wall 5m
	case "Land_Fortress_01_5m_F":
	{
		[10, 5, 90]
	};
	// grass hedge
	case "Land_Hedge_01_s_2m_F":
	{
		[2, 0.5, 0]
	};
	// net fence
	case "Land_NetFence_02_m_4m_F":
	{
		[4, 2, 90]
	};
	// wired fence
	case "Land_New_WiredFence_5m_F":
	{
		[5.20, 2.6, 90]
	};
	// razorwire
	case "Land_Razorwire_F":
	{
		[8.46, 4.20, 90]
	};
	// tire barrier
	case "Land_TyreBarrier_01_line_x4_F":
	{
		[2.6, 1.2, 90]
	};
	// power cables
	case "PowerCable_01_StraightLong_F":
	{
		[5.02368, 2.49, 0]
	};
	// blood trail
	case "BloodTrail_01_New_F":
	{
		[12, 6, 0]
	};
	//minefield sign
	case "Land_Sign_MinesDanger_Greek_F":
	{
		[50, 25, 90]
	};
	default
	{
		objNull
	};
};

_return
