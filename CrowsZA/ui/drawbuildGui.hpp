// not needed as defined in loadoutGui apperently....
// class RscText;
// class RscEdit;
// class ctrlButton;
// class ctrlListNBox;
// class ctrlProgress;
// class ctrlButtonPicture;
// class RscButtonMenuOK;
// class RscButtonMenuCancel;
// class RscControlsGroupNoScrollbars;
class RscActivePicture;

//main display class
class crowsZA_drawbuild_display {
    idd = -1;
    movingEnable = 1;
    onLoad = "uiNamespace setVariable ['crowsZA_drawbuild_display',_this select 0];";
    class controls {
        class Title: RscText {
            idc = IDC_TITLE;
            x = POS_X(6.5);
            w = POS_W(27);
            h = POS_H(1);
            colorBackground[] = GUI_THEME_COLOR;
            moving = 1;
            text = "Select Object To Build";
        };
        class Background: RscText {
            idc = IDC_BACKGROUND;
            x = POS_X(6.5);
            w = POS_W(27);
            h = 15.3;
            colorBackground[] = {0, 0, 0, 0.7};
        };
        class Content: RscControlsGroupNoScrollbars {
            idc = IDC_CONTROL_GROUP;
            h = POS_H(15.3);
            x = POS_X(7);
            w = POS_W(26);
            class controls {
                class grid1: RscActivePicture {
                    idc = IDC_ICON_GRID_FIRST;
                    text = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_BagFence_Short_F.jpg";
                    tooltip = "";
                    // x = POS_W(2.5);
                    // y = POS_H(0.25);
                    // w = POS_W(2);
                    // h = POS_H(2);
                    x = 0;
                    y = POS_H(1);
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
                // class grid4: grid1 {
                //     idc = 1643;
                //     tooltip = "";
                //     x = POS_W(11.5);
                // };
            };
        };
    };
};
