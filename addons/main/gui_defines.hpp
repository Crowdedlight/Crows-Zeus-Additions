#include "\a3\ui_f\hpp\defineCommonGrids.inc"
#include "\a3\ui_f\hpp\defineResinclDesign.inc"
#include "\a3\ui_f_curator\ui\defineResinclDesign.inc"

//gui defines - Using same approach as ZEN for gui styling
#define POS_X(N) ((N) * GUI_GRID_W + GUI_GRID_CENTER_X)
#define POS_Y(N) ((N) * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define POS_W(N) ((N) * GUI_GRID_W)
#define POS_H(N) ((N) * GUI_GRID_H)

//get gui theme
#define GUI_THEME_RGB_R "(profileNamespace getVariable ['GUI_BCG_RGB_R',0.13])"
#define GUI_THEME_RGB_G "(profileNamespace getVariable ['GUI_BCG_RGB_G',0.54])"
#define GUI_THEME_RGB_B "(profileNamespace getVariable ['GUI_BCG_RGB_B',0.21])"
#define GUI_THEME_ALPHA "(profileNamespace getVariable ['GUI_BCG_RGB_A',0.8])"

#define GUI_THEME_COLOR {GUI_THEME_RGB_R,GUI_THEME_RGB_G,GUI_THEME_RGB_B,GUI_THEME_ALPHA}

//colour defines 
#define COLOR_BACKGROUND_SETTING {1,1,1,0.2}

//IDC for the gui - Cannot change this as the initial display pos from ZEN depends on the same three defines
#define IDC_TITLE 			10
#define IDC_BACKGROUND 		20
#define IDC_CONTENT 			30

#define IDC_TITLE_GROUP 		1540
#define IDC_TITLE_GROUP_LEADER		1541
#define IDC_LIST       		1543
#define IDC_BTN_SEARCH 		1546
#define IDC_SEARCH_BAR 		1547
#define IDC_WEIGHT	   		1548
	
//IDC for pingbox
#define IDC_PINGBOX 			1720
#define IDC_PINGBOX_LIST 		1730
#define IDC_PINGBOX_TITLE 		1740
#define IDC_PINGBOX_BACKGROUND	1750

//Pingbox Sizes
#define PINGBOX_LINE_HEIGHT    0.020
#define PINGBOX_POS_Y_DEFAULT  0.929
#define PINGBOX_POS_X_DEFAULT  0.139062
#define PINGBOX_WIDTH_DEFAULT  0.108281
#define PINGBOX_SIZE_DEFAULT   3

//array types
#define TYPE_WEAPON "weapon"
#define TYPE_WEAPON_ATTACHMENT "attachment"
#define TYPE_CONTAINER "container"
#define TYPE_ITEM "item"
