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
		idd = IDC_PINGBOX;
		fadein = 0;
		fadeout = 0;
		duration = 1e+011;
        name = "crowsZA_pingbox_hud";
		onLoad = "uiNamespace setVariable ['crowsZA_pingbox_hud', _this select 0];";
		onUnLoad = "uinamespace setVariable ['crowsZA_pingbox_hud', nil]";
		class Controls
		{
            // use GUI tool to make the gui. And figure out how to place it outside "safezone" so we can get it on the top left position
            class TitleName: RscText {
                idc = -1;
                x = 0;
                y = 0;
                w = POS_W(4);
                h = POS_H(1);
                text = "PingBox";
            };            
            class ListBackground: RscText {
                idc = -1;
                style = ST_CENTER;
                x = 0;
                y = 0;
                w = POS_W(10);
                h = POS_H(5);
                colorText[] = {1, 1, 1, 0.5};
                colorBackground[] = COLOR_BACKGROUND_SETTING;
            }; 
            class List: ctrlListNBox {
                idc = IDC_PINGBOX_LIST;
                x = 0;
                y = POS_H(1);
                w = POS_W(10);
                h = POS_H(5);
                drawSideArrows = 0;
                disableOverflow = 1;
                tooltipPerColumn = 0;
                columns[] = {0.75, 0.25};
            };
		};
	};
};