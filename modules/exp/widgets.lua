XP.Widgets = { }

------------------------------------------------------------------------------------------------------
-- Toggles XP tracking information showing.
------------------------------------------------------------------------------------------------------
XP.Widgets.TrackingButton = function()
    if Debug.Is_Enabled() then
        UI.SameLine() UI.Text(" ") UI.SameLine()

        if UI.SmallButton("Tracking") then
            XP.Tracking.ShowDebug = not XP.Tracking.ShowDebug
            WindowManager.SetBarDelay()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the Confirmation button showing for the XP window.
------------------------------------------------------------------------------------------------------
XP.Widgets.ResetButton = function()
    UI.SameLine() UI.Text(" ") UI.SameLine()

    if UI.SmallButton("Reset") then
        XP.ShowResetConfirmation = not XP.ShowResetConfirmation
    end
end

------------------------------------------------------------------------------------------------------
-- Confirms XP reset.
------------------------------------------------------------------------------------------------------
XP.Widgets.ResetConfirmationButton = function()
    if XP.ShowResetConfirmation then
        UI.SameLine() UI.Text(" ") UI.SameLine()

        if UI.SmallButton("I'm sure.") then
            XP.IsInitialized = false
            XP.ShowResetConfirmation = false
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the level progress bar.
------------------------------------------------------------------------------------------------------
XP.Widgets.LevelProgressBar = function()
    if XP.Settings.Show_XP_Progress_Bar then
        local color   = Res.Colors.Get_XP(XP.DisplayMode)
        local height  = XP.FullBarHeight
        local caption = nil

        -- Update bar height if necessary.
        if XP.Settings.Small_Progress_Bars then
            height  = XP.TinyBarHeight
            caption = ""
        end

        -- Calculate progress.
        local currentXP = Ashita.Player.CurrentXP()
        local levelXP   = Ashita.Player.LevelMaxXP()

        if XP.DisplayMode == XP.Type.LIMIT then
            currentXP = Ashita.Player.CurrentLimit()
            levelXP   = 10000
        end

        if not currentXP or not levelXP or levelXP == 0 then
            return 0
        end

        local progress = currentXP / levelXP

        UI.PushStyleColor(ImGuiCol_PlotHistogram, color)
        UI.ProgressBar(progress, { -1, height }, caption)
        UI.PopStyleColor(1)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the boost progress bar.
------------------------------------------------------------------------------------------------------
XP.Widgets.BoostProgressBar = function()
    if XP.Settings.Show_Boost_Progress_Bar and XP.Dedication.IsActive then
        local height   = XP.FullBarHeight
        local caption  = nil
        local progress = XP.Dedication.GetProgress()

        -- We know what dedication item was used.
        if XP.Settings.Boost_Item_Rate > 0 then
            if XP.Settings.Small_Progress_Bars then
                height  = XP.TinyBarHeight
                caption = ""
            end

        -- We DON'T know what dedication item was used.
        else
            caption  = "Unknown dedication item used."
            progress = 0
        end

        UI.ProgressBar(progress, { -1, height }, caption)
    end
end