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
    onLoad = (uiNamespace setVariable ["crowsZA_loadout_display",_this select 0]);
    class controls {
        class Title: RscText {
            idc = IDC_TITLE;
            x = POS_X(6.5);
            w = POS_W(27);
            h = POS_H(1);
            colorBackground[] = GUI_THEME_COLOR;
            moving = 1;
        };
        class Background: RscText {
            idc = IDC_BACKGROUND;
            x = POS_X(6.5);
            w = POS_W(27);
            colorBackground[] = {0, 0, 0, 0.7};
        };
        class Content: RscControlsGroupNoScrollbars {
            idc = IDC_CONTENT;
            h = POS_H(13/3 + 15.3);
            x = POS_X(7);
            w = POS_W(26);
            class controls {
                /* Store the display's config, onLoad event for displays is not passed the config
                onLoad = QUOTE( \
                    params [ARR_2('_control','_config')]; \
                    private _display = ctrlParent _control; \
                    _config = configHierarchy _config select 1; \
                    _display setVariable [ARR_2(QQGVAR(config),_config)]; \ */
                //);
                class Sorting: ctrlListNBox {
                    idc = IDC_SORTING;
                    x = 0;
                    y = 0;
                    w = POS_W(26);
                    h = POS_H(1);
                    disableOverflow = 1;
                    columns[] = {0, 0.8};
                    class Items {
                        class Name {
                            text = "Name";
                            value = 1;
                        };
                        class Amount {
                            text = "Amount";
                            data = "value";
                        };
                    };
                };
                class RscBackground: RscText {
                    idc = -1;
                    style = ST_CENTER;
                    x = 0;
                    y = POS_H(13/3 + 1);
                    w = POS_W(26);
                    h = POS_H(13);
                    colorText[] = {1, 1, 1, 0.5};
                    colorBackground[] = COLOR_BACKGROUND_SETTING;
                };
                class List: ctrlListNBox {
                    idc = IDC_LIST;
                    idcLeft = IDC_BTN_REMOVE;
                    idcRight = IDC_BTN_ADD;
                    x = 0;
                    y = POS_H(13/3 + 1);
                    w = POS_W(26);
                    h = POS_H(13);
                    drawSideArrows = 1;
                    disableOverflow = 1;
                    tooltipPerColumn = 0;
                    columns[] = {0.05, 0.15, 0.8};
                };
                class ButtonRemove: ctrlButton {
                    idc = IDC_BTN_REMOVE;
                    text = "−";
                    font = "RobotoCondensedBold";
                    x = -1;
                    y = -1;
                    w = POS_W(1);
                    h = POS_H(1);
                    sizeEx = POS_H(1.2);
                };
                class ButtonAdd: ButtonRemove {
                    idc = IDC_BTN_ADD;
                    text = "+";
                };
                class ButtonSearch: ctrlButtonPicture {
                    idc = IDC_BTN_SEARCH;
                    text = "\a3\Ui_f\data\GUI\RscCommon\RscButtonSearch\search_start_ca.paa";
                    tooltip = "Search for specific item";
                    x = 0;
                    y = POS_H(13/3 + 14.3);
                    w = POS_W(1);
                    h = POS_H(1);
                    colorBackground[] = {0, 0, 0, 0.5};
                };
                //maybe delete... hardly used when using it on unit/player
                class SearchBar: RscEdit {
                    idc = IDC_SEARCH_BAR;
                    x = POS_W(1.2);
                    y = POS_H(13/3 + 14.3);
                    w = POS_W(8);
                    h = POS_H(1);
                    sizeEx = POS_H(0.9);
                    colorText[] = {1, 1, 1, 1};
                    colorBackground[] = {0, 0, 0, 0.2};
                };
                class weightNumber : RscText {
                    idc = IDC_WEIGHT;
                    x = POS_W(25);
                    y = POS_H(13/3 + 14.3);
                    w = POS_W(1);
                    h = POS_H(1);
                };
                // class Load: ctrlProgress {
                //     idc = IDC_LOAD_BAR;
                //     x = POS_W(14.4 + 3.6);
                //     y = POS_H(13/3 + 14.4);
                //     w = POS_W(8);
                //     h = POS_H(0.8);
                //     colorFrame[] = {1, 1, 1, 1};
                // };
                //TODO should figure out how to show attachments to weapons...
                // class ButtonWeapon: ButtonSearch {
                //     idc = IDC_BTN_WEAPON;
                //     text = "\a3\3den\data\displays\display3den\entitymenu\arsenal_ca.paa";
                //     tooltip = CSTRING(Weapon_Tooltip);
                //     x = POS_W(22.6);
                // };
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
