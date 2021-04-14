#include "\CrowsZA\include\a3\ui_f\hpp\defineDIKCodes.inc"
#include "\CrowsZA\include\a3\ui_f\hpp\defineCommonGrids.inc"
#include "\CrowsZA\include\a3\ui_f_curator\ui\defineResinclDesign.inc"

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
#define COLOR_BACKGROUND_SETTING {1,1,1,0.1}

//IDC for the gui
#define IDC_TITLE 10
#define IDC_BACKGROUND 20
#define IDC_CONTENT 30

#define IDC_SORTING    1501
#define IDC_LIST       1503
#define IDC_BTN_REMOVE 1504
#define IDC_BTN_ADD    1505
#define IDC_BTN_SEARCH 1506
#define IDC_SEARCH_BAR 1507
#define IDC_WEIGHT	   1508

// #define IDC_BTN_WEAPON 1509

//array types
#define TYPE_WEAPON "weapon"
#define TYPE_MAGAZINE "magazine"
#define TYPE_CONTAINER "container"
#define TYPE_ITEM "item"