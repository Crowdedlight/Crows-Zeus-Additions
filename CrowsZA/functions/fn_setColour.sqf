/*/////////////////////////////////////////////////
Author: Crowdedlight
			   
File: fn_setColour.sqf
Parameters: pos, _unit
Return: none

Set colour of selected texture if possible

*///////////////////////////////////////////////
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_texture",
		"_colour",
		"_applyAll",
		"_reset"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	//set texture on object
	if (!_reset) then {
		private _newColour = format ["#(argb,8,8,3)color(%1,%2,%3,%4)", (_colour select 0), (_colour select 1), (_colour select 2), (_colour select 3)];

		// if we are applying to all textures
		if (_applyAll) then {
			// loop all textures
			{
				_unit setObjectTextureGlobal [_forEachIndex, _newColour];
			} forEach (getObjectTextures _unit);
		} else {
			_unit setObjectTextureGlobal [_texture, _newColour];
		};
	} else {
		//get default textures
		private _textureArray = _unit getVariable "crowsZA_setcolour_var_textureArray";
		//apply them 
		{
			_unit setObjectTextureGlobal [_forEachIndex, _x];
		} forEach _textureArray;
	};
};

//if unit is zero, exit
if (isNull _unit) exitWith { };

//get textures from object
private _textureOptions = getObjectTextures _unit;
//check if it can be textured, otherwise exit
if (count _textureOptions <= 0) then {
	diag_log "CrowsZA-setColour: This object does not have texture that can change colour";
	exit;
};

//make array for selection
private _arraySelection = [];
for "_k" from 0 to (count _textureOptions) - 1 do {
	_arraySelection pushBack _k;
};

//if texture object is not set, then get textures and set it. We always use the texture array as pretty text as in that way we don't override the pretty text and can reset 
private _textureArray = _unit getVariable "crowsZA_setcolour_var_textureArray";
if (isNil "_textureArray") then {
	_textureArray = _textureOptions;
	//Has to be public as if another zeus click colour after we have coloured they will see our colour text
	_unit setVariable ["crowsZA_setcolour_var_textureArray", _textureOptions, true]; 
};

[
	"Set Colour", 
	[
		["COMBO","Texture",[_arraySelection, _textureArray,0]],
		["COLOR","Colour",+[0,0,0,1]],
		["CHECKBOX",["Apply to all textures", "Adds the colour to all textures"],[false]], //reset to defaults
		["CHECKBOX",["RESET", "Resets Texture to default"],[false], true] //reset to defaults
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;