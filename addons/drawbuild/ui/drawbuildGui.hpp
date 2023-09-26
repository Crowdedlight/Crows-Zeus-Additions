class RscActivePicture;
class RscCheckBox;
class RscText;
class RscControlsGroupNoScrollbars;

//main display class
class crowsza_drawbuild_display {
    idd = -1;
    movingEnable = 1;
    fadein = 0.05;
    fadeout = 0;
    duration = 9999999;
    onLoad = "uiNamespace setVariable ['crowsza_drawbuild_display',_this select 0];";
    class controls {
        class Title: RscText {
            idc = IDC_TITLE;
            x = QUOTE(POS_X(11.5));
            w = QUOTE(POS_W(15));
            h = QUOTE(POS_H(1));
            colorBackground[] = GUI_THEME_COLOR;
            moving = 1;
            text = QUOTE(Select Object To Build);
        };
        class Background: RscText {
            idc = IDC_BACKGROUND;
            x = QUOTE(POS_X(11.5));
            w = QUOTE(POS_W(15));
            h = QUOTE(POS_H(4));
            colorBackground[] = {0, 0, 0, 0.7};
        };
        class Content: RscControlsGroupNoScrollbars {
            idc = IDC_CONTENT;
            h = QUOTE(POS_H(13.5));
            x = QUOTE(POS_X(12));
            w = QUOTE(POS_W(14));
            class controls {
                class grid1: RscActivePicture {
                    idc = IDC_ICON_GRID_FIRST;
                    //text = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_BagFence_Short_F.jpg";
                    text = ""; // Don't display a preview image if there's no content for the grid
                    color[] = {1,1,1,0.8}; //change from 0.5 alpha to not be too dark but still show when hovered
                    tooltip = "";
                    x = 0;
                    y = QUOTE(POS_H(0.5));
                    w = QUOTE(POS_W(2));
                    h = QUOTE(POS_H(2));
                };
                class grid2: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 1);
                    x = QUOTE(POS_W(3));
                };
                class grid3: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 2);
                    x = QUOTE(POS_W(6));
                };
                class grid4: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 3);
                    x = QUOTE(POS_W(9));
                };
                class grid5: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 4);
                    x = QUOTE(POS_W(12));
                };
                // row 2
                class row2: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 5);
                    x = 0;
                    y = QUOTE(POS_H(3));
                };
                class grid7: row2 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 6);
                    x = QUOTE(POS_W(3));
                };
                class grid8: row2 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 7);
                    x = QUOTE(POS_W(6));
                };
                class grid9: row2 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 8);
                    x = QUOTE(POS_W(9));
                };
                class grid10: row2 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 9);
                    x = QUOTE(POS_W(12));
                };
                // row 3
                class row3: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 10);
                    x = 0;
                    y = QUOTE(POS_H(5.5));
                };
                class grid12: row3 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 11);
                    x = QUOTE(POS_W(3));
                };
                class grid13: row3 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 12);
                    x = QUOTE(POS_W(6));
                };
                class grid14: row3 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 13);
                    x = QUOTE(POS_W(9));
                };
                class grid15: row3 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 14);
                    x = QUOTE(POS_W(12));
                };
                // row 4
                class row4: grid1 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 15);
                    x = 0;
                    y = QUOTE(POS_H(8));
                };
                class grid17: row4 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 16);
                    x = QUOTE(POS_W(3));
                };
                class grid18: row4 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 17);
                    x = QUOTE(POS_W(6));
                };
                class grid19: row4 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 18);
                    x = QUOTE(POS_W(9));
                };
                class grid20: row4 {
                    idc = QUOTE(IDC_ICON_GRID_FIRST + 19);
                    x = QUOTE(POS_W(12));
                };
                // bottom rows for toggle enables, simulation
                class cbSimulation: RscCheckBox {
                    idc = IDC_CHECKBOX_SIMULATION;
                    x = 0;
                    y = QUOTE(POS_H(10.5));
                    w = QUOTE(POS_W(1));
                    h = QUOTE(POS_H(1));
                    soundClick[] = {QUOTE(\a3\ui_f\data\sound\rscbutton\soundclick), 0.09, 1};
                    soundEnter[] = {QUOTE(\a3\ui_f\data\sound\rscbutton\soundenter), 0.09, 1};
                    soundEscape[] = {QUOTE(\a3\ui_f\data\sound\rscbutton\soundescape), 0.09, 1};
                    soundPush[] = {QUOTE(\a3\ui_f\data\sound\rscbutton\soundpush), 0.09, 1};
                    checked = 1; //default to be enabled
                };
                class lblSimulation: RscText {
                    idc = -1;
                    x = QUOTE(POS_W(1));
                    y = QUOTE(POS_H(10.5));
                    w = QUOTE(POS_W(10));
                    h = QUOTE(POS_H(1));
                    // colorBackground[] = {0, 0, 0, 0.7};
                    text = QUOTE(Enable Simulation);
                };
                // damage
                class cbDamage: cbSimulation {
                    idc = IDC_CHECKBOX_DAMAGE;
                    y = QUOTE(POS_H(12));
                    checked = 0; //default to be disabled
                };
                class lblDamage: lblSimulation {
                    y = QUOTE(POS_H(12));
                    text = QUOTE(Enable Damage);
                };        
            };
        };
    };
};
