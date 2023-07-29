class RscText;
class RscEdit;
class ctrlButton;
class ctrlListNBox;
class ctrlProgress;
class ctrlButtonPicture;
class RscButtonMenuOK;
class RscButtonMenuCancel;
class RscControlsGroupNoScrollbars;

//main display class
class crowsZA_loadout_display {
    idd = -1;
    movingEnable = 1;
    onLoad = "uiNamespace setVariable ['crowsZA_loadout_display',_this select 0];";
    class controls {
        class Title: RscText {
            idc = IDC_TITLE;
            x = POS_X(6.5);
            w = POS_W(27);
            h = POS_H(1);
            colorBackground[] = GUI_THEME_COLOR;
            moving = 1;
            text = "test";
        };
        class Background: RscText {
            idc = IDC_BACKGROUND;
            x = POS_X(6.5);
            w = POS_W(27);
            colorBackground[] = {0, 0, 0, 0.7};
        };
        class Content: RscControlsGroupNoScrollbars {
            idc = IDC_CONTENT;
            h = POS_H(15.3);
            x = POS_X(7);
            w = POS_W(26);
            class controls {
                //item - amount coloumns
                class HeadlineBackground: RscText {
                    idc = -1;
                    style = ST_CENTER;
                    x = 0;
                    y = 0;
                    w = POS_W(26);
                    h = POS_H(1);
                    colorBackground[] = {0, 0, 0, 0.5};
                };
                class TitleName: RscText {
                    idc = -1;
                    x = POS_W(1);
                    y = 0;
                    w = POS_W(4);
                    h = POS_H(1);
                    text = "Name";
                };
                class TitleAmount: RscText {
                    idc = -1;
                    x = POS_W(20.8);
                    w = POS_W(4);
                    h = POS_H(1);
                    text = "Amount";
                };                
                class ListBackground: RscText {
                    idc = -1;
                    style = ST_CENTER;
                    x = 0;
                    y = POS_H(1);
                    w = POS_W(26);
                    h = POS_H(13);
                    colorText[] = {1, 1, 1, 0.5};
                    colorBackground[] = COLOR_BACKGROUND_SETTING;
                };
                class List: ctrlListNBox {
                    idc = IDC_LIST;
                    x = 0;
                    y = POS_H(1);
                    w = POS_W(26);
                    h = POS_H(13);
                    drawSideArrows = 0;
                    disableOverflow = 1;
                    tooltipPerColumn = 0;
                    columns[] = {0.05, 0.15, 0.8};
                };
                class TitleGroup: RscText {
                    idc = IDC_TITLE_GROUP;
                    x = 0;
                    y = POS_H(14.3);
                    w = POS_W(10);
                    h = POS_H(1);
                };   
                class TitleGroupLeader: RscText {
                    idc = IDC_TITLE_GROUP_LEADER;
                    style = ST_CENTER;
                    x = POS_W(8);
                    y = POS_H(14.3);
                    w = POS_W(10);
                    h = POS_H(1);
                };  
                class weightNumber : RscText {
                    idc = IDC_WEIGHT;
                    x = POS_W(21);
                    y = POS_H(14.3);
                    w = POS_W(6);
                    h = POS_H(1);
                };
            };
        };
        class ButtonOK: RscButtonMenuOK {
            x = POS_X(28.5);
            w = POS_W(5);
            h = POS_H(1);
        };
        class ButtonCancel: RscButtonMenuCancel {
            x = POS_X(6.5);
            w = POS_W(5);
            h = POS_H(1);
        };
    };
};
