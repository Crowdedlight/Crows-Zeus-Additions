



//WIP - Not loaded or used currently

// NOTES
//save current curator cam, as the cam will move around if we use move around while the cam is fixed. 
_curatorCameraData = [getPosASL curatorCamera, [vectorDir curatorCamera, vectorUp curatorCamera]];

//when we exit with spacebar and want to go back, just set curatorCamera to the current position of the fixed camera, So we get the feeling that the zeus cam just stops following

// Create the camera
private _camhelp = "Logic" createVehicleLocal [0, 0, 0];
_camhelp attachTo [_this, [0, 0, -1]];

private _cam = "camera" camCreate ASLtoAGL getPosASL _this;
_cam cameraEffect ["internal", "back"];
_cam camPrepareFocus [-1, -1];
_cam camPrepareFov 0.35;
_cam camCommitPrepared 0;
showCinemaBorder false;
_cam setPos (_camhelp modelToWorld [0, -40, 0]);

//display 312 == zeus. Can add events like this for possible override of keyboard and mouse
findDisplay 312 displayAddEventHandler ["KeyDown", "diag_log str _this;"];

//escape key, 
16:21:49 "[Display #312,57,false,false,false]"

//mousebuttondown
16:24:31 "[Display #312,1,0.436869,0.8367,false,false,false]"

//mouseZChanged
16:26:42 "[Display #312,-2.4]"

//events
onKeyDown = QUOTE(_this call FUNC(onKeyDown));
onMouseButtonDown = QUOTE(_this call FUNC(onMouseButtonDown));
onMouseButtonUp = QUOTE(_this call FUNC(onMouseButtonUp));

onMouseMoving = QUOTE(_this call FUNC(handleMouse));
onMouseHolding = QUOTE(_this call FUNC(handleMouse));
onMouseZChanged = QUOTE(_this call FUNC(onMouseZChanged));
