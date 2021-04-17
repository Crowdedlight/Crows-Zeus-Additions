/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_contextPasteLoadout.sqf
Parameters: Hovered Entity
Return: none

Paste loadout into inventory if space

*///////////////////////////////////////////////
params ["_entity"];

//get array
private _arr = zen_context_actions_loadout;

private _mainWep = _arr select 0;
private _secWep = _arr select 1;
private _handgun = _arr select 2;

private _containers = _arr select [3,3]; //3,4,5 == uniform, vest and backpack 

private _helmet = _arr select 6;
private _facewear = _arr select 7;

private _bino = _arr select 8;
private _items = _arr select 9;

//add weapon, if not empty
if (count _mainWep != 0) then { _entity addWeaponWithAttachmentsCargoGlobal [_mainWep, 1]};
if (count _secWep != 0) then { _entity addWeaponWithAttachmentsCargoGlobal [_secWep, 1]};
if (count _handgun != 0) then { _entity addWeaponWithAttachmentsCargoGlobal [_handgun, 1]};

//helmet & facegear 
if (!isNil "_helmet") then {_entity addItemCargoGlobal [_helmet,1]};
if (!isNil "_facewear") then {_entity addItemCargoGlobal [_facewear,1]};

//binos 
if (count _bino != 0) then {_entity addItemCargoGlobal [_bino select 0, 1]};

//containers
//backpack, vest and uniform - We cannot add items directly into the containers as if there is multiple backpacks in an container we can't ensure we get ours.
// And vest and uniforms seemingly only support adding items into them when they are worn by a unit.  
{
	//if empty container, skip
	if (count _x == 0) then {continue};

	//always add parent container
	_entity addItemCargoGlobal [_x select 0, 1];

	//loop through items to add
	{
		// if size is 3, then we got [item, amount, clipload]
		// if size is 2, then we got [item, amount]
		_entity addItemCargoGlobal [_x select 0, _x select 1];
	} forEach (_x select 1);
} forEach _containers;

//items
{
	//check if empty 
	if (!isNil "_x") then {continue};

	//add item 
	_entity addItemCargoGlobal [_x, 1];
} forEach _items;
