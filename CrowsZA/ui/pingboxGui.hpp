class ctrlListNBox;
class RscText;

class RscTitles
{
    class Default 
    {
       idd = -1;
       fadein = 0;
       fadeout = 0;
       duration = 0;
    };

	class crowsZA_pingbox_hud
	{
		idd = -1;
		fadein = 0.05;
		fadeout = 0;
		duration = 9999999;
        name = "crowsZA_pingbox_hud";
		onLoad = "uiNamespace setVariable ['crowsZA_pingbox_hud', _this select 0];";
		onUnLoad = "uinamespace setVariable ['crowsZA_pingbox_hud', nil]";
		class Controls
		{
            class list: ctrlListNBox
            {
                idc = IDC_PINGBOX_LIST;
                x = 0.139062 * safezoneW + safezoneX;
                y = 0.929 * safezoneH + safezoneY;
                w = 0.108281 * safezoneW;
                h = 0.066 * safezoneH;
                drawSideArrows = 0;
                disableOverflow = 1;
                tooltipPerColumn = 0;
                columns[] = {0.00, 0.8};
                colorBackground[] = COLOR_BACKGROUND_SETTING;
            };
            class title: RscText
            {
                idc = -1;
                text = "PingBox";
                style = ST_CENTER;
                x = 0.139062 * safezoneW + safezoneX;
                y = 0.907 * safezoneH + safezoneY;
                w = 0.108281 * safezoneW;
                h = 0.022 * safezoneH;
                colorBackground[] = GUI_THEME_COLOR;
            };
            class ListBackground: RscText {
                idc = -1;
                style = ST_CENTER;
                x = 0.139062 * safezoneW + safezoneX;
                y = 0.929 * safezoneH + safezoneY;
                w = 0.108281 * safezoneW;
                h = 0.066 * safezoneH;
                colorText[] = {1, 1, 1, 0.5};
                colorBackground[] = {0, 0, 0, 0.5};
            };
		};
	};
};
