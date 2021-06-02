/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_removeItemFromUnit.sqf
Parameters: _unit, _item
Return: none

Remove item from assigned slots and inventory of unit

*///////////////////////////////////////////////
params ["_unit", "_item"];

// remove item from player assigned slots
_unit unlinkItem _item;

// remove any in player inventory
_unit removeItems _item;