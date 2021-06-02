class RscActivePicture;
class RscCheckBox;

//main display class
class crowsZA_drawbuild_display {
    idd = -1;
    movingEnable = 1;
    onLoad = "uiNamespace setVariable ['crowsZA_drawbuild_display',_this select 0];";
    class controls {
        class Title: RscText {
            idc = IDC_TITLE;
            x = POS_X(11.5);
            w = POS_W(15);
            h = POS_H(1);
            colorBackground[] = GUI_THEME_COLOR;
            moving = 1;
            text = "Select Object To Build";
        };
        class Background: RscText {
            idc = IDC_BACKGROUND;
            x = POS_X(11.5);
            w = POS_W(15);
            h = POS_H(4);
            colorBackground[] = {0, 0, 0, 0.7};
        };
        class Content: RscControlsGroupNoScrollbars {
            idc = IDC_CONTENT;
            h = POS_H(11);
            x = POS_X(12);
            w = POS_W(14);
            class controls {
                class grid1: RscActivePicture {
                    idc = IDC_ICON_GRID_FIRST;
                    text = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_BagFence_Short_F.jpg";
                    color[] = {1,1,1,0.8}; //change from 0.5 alpha to not be too dark but still show when hovered
                    tooltip = "";
                    x = 0;
                    y = POS_H(0.5);
                    w = POS_W(2);
                    h = POS_H(2);
                };
                class grid2: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 1;
                    x = POS_W(3);
                };
                class grid3: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 2;
                    x = POS_W(6);
                };
                class grid4: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 3;
                    x = POS_W(9);
                };
                class grid5: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 4;
                    x = POS_W(12);
                };
                // row 2
                class row2: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 5;
                    x = 0;
                    y = POS_H(3);
                };
                class grid7: row2 {
                    idc = IDC_ICON_GRID_FIRST + 6;
                    x = POS_W(3);
                };
                class grid8: row2 {
                    idc = IDC_ICON_GRID_FIRST + 7;
                    x = POS_W(6);
                };
                class grid9: row2 {
                    idc = IDC_ICON_GRID_FIRST + 8;
                    x = POS_W(9);
                };
                class grid10: row2 {
                    idc = IDC_ICON_GRID_FIRST + 9;
                    x = POS_W(12);
                };
                // row 3
                class row3: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 10;
                    x = 0;
                    y = POS_H(5.5);
                };
                class grid12: row3 {
                    idc = IDC_ICON_GRID_FIRST + 11;
                    x = POS_W(3);
                };
                class grid13: row3 {
                    idc = IDC_ICON_GRID_FIRST + 12;
                    x = POS_W(6);
                };
                class grid14: row3 {
                    idc = IDC_ICON_GRID_FIRST + 13;
                    x = POS_W(9);
                };
                class grid15: row3 {
                    idc = IDC_ICON_GRID_FIRST + 14;
                    x = POS_W(12);
                };
                // bottom rows for toggle enables, simulation
                class cbSimulation: RscCheckBox {
                    idc = IDC_CHECKBOX_SIMULATION;
                    x = 0;
                    y = POS_H(8);
                    w = POS_W(1);
                    h = POS_H(1);
                    soundClick[] = {"\a3\ui_f\data\sound\rscbutton\soundclick", 0.09, 1};
                    soundEnter[] = {"\a3\ui_f\data\sound\rscbutton\soundenter", 0.09, 1};
                    soundEscape[] = {"\a3\ui_f\data\sound\rscbutton\soundescape", 0.09, 1};
                    soundPush[] = {"\a3\ui_f\data\sound\rscbutton\soundpush", 0.09, 1};
                    checked = 1; //default to be enabled
                };
                class lblSimulation: RscText {
                    idc = -1;
                    x = POS_W(1);
                    y = POS_H(8);
                    w = POS_W(10);
                    h = POS_H(1);
                    // colorBackground[] = {0, 0, 0, 0.7};
                    text = "Enable Simulation";
                };
                // damage
                class cbDamage: cbSimulation {
                    idc = IDC_CHECKBOX_DAMAGE;
                    y = POS_H(9.5);
                    checked = 0; //default to be disabled
                };
                class lblDamage: lblSimulation {
                    y = POS_H(9.5);
                    text = "Enable Damage";
                };        
            };
        };
    };
};
