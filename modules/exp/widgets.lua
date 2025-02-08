XP.Widgets = {}

------------------------------------------------------------------------------------------------------
-- Toggles XP tracking information showing.
------------------------------------------------------------------------------------------------------
XP.Widgets.Tracking_Button = function()
    if Debug.Is_Enabled() then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        if UI.SmallButton("Tracking") then
            XP.Tracking.Show_Debug = not XP.Tracking.Show_Debug
            Window_Manager.Set_Bar_Delay()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Confirmation button showing for the XP window.
------------------------------------------------------------------------------------------------------
XP.Widgets.Reset_Button = function()
    UI.SameLine() UI.Text(" ") UI.SameLine()
    if UI.SmallButton("Reset") then
        XP.Show_Reset_Confirmation = not XP.Show_Reset_Confirmation
    end
end

------------------------------------------------------------------------------------------------------
-- Confirms XP reset.
------------------------------------------------------------------------------------------------------
XP.Widgets.Reset_Confirmation_Button = function()
    if XP.Show_Reset_Confirmation then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        if UI.SmallButton("I'm sure.") then
            XP.Is_Initialized = false
            XP.Show_Reset_Confirmation = false
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the level progress bar.
------------------------------------------------------------------------------------------------------
XP.Widgets.Level_Progress_Bar = function()
    if XP.Settings.Show_XP_Progress_Bar then
        local color  = Res.Colors.Get_XP(XP.Display_Mode)
        local height = XP.Full_Bar_Height
        local caption = nil

        -- Update bar height if necessary.
        if XP.Settings.Small_Progress_Bars then
            height = XP.Tiny_Bar_Height
            caption = ""
        end

        -- Calculate progress.
        local current_xp = Ashita.Player.CurrentXP()
        local level_xp   = Ashita.Player.LevelMaxXP()
        if XP.Display_Mode == XP.Type.LIMIT then
            current_xp = Ashita.Player.CurrentLimit()
            level_xp   = 10000
        end
        if not current_xp or not level_xp or level_xp == 0 then return 0 end
        local progress = current_xp / level_xp

        UI.PushStyleColor(ImGuiCol_PlotHistogram, color)
        UI.ProgressBar(progress, {-1, height}, caption)
        UI.PopStyleColor(1)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the boost progress bar.
------------------------------------------------------------------------------------------------------
XP.Widgets.Boost_Progress_Bar = function()
    if XP.Settings.Show_Boost_Progress_Bar and XP.Dedication.Is_Active then
        local height = XP.Full_Bar_Height
        local caption = nil
        local progress = XP.Dedication.Progress()

        -- We know what dedication item was used.
        if XP.Settings.Boost_Item_Rate > 0 then
            if XP.Settings.Small_Progress_Bars then
                height = XP.Tiny_Bar_Height
                caption = ""
            end

        -- We DON'T know what dedication item was used.
        else
            caption = "Unknown dedication item used."
            progress = 0
        end

        UI.ProgressBar(progress, {-1, height}, caption)
    end
end