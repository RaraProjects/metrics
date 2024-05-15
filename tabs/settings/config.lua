local s = {}

s.Section = {}
s.Util = {}
s.Widget = {}

s.Enum = {}
s.Enum.File = {
    PARSE  = "parse",
    BLOG   = "blog",
    WINDOW = "window",
    DATABASE  = "database",
    REPORT = "report",
}

s.Slider_Width = 100

------------------------------------------------------------------------------------------------------
-- Loads the settings data to the screen.
------------------------------------------------------------------------------------------------------
s.Populate = function()
    local tab_flags = Window.Tabs.Flags

    if UI.BeginTabBar("Focus Tabs", tab_flags) then
        if UI.BeginTabItem("Help", tab_flags) then
            s.Section.Text_Commands()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Focus", tab_flags) then
            s.Section.Focus()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("GUI", tab_flags) then
            s.Section.Gui()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Revert", tab_flags) then
            s.Section.Revert()
            UI.EndTabItem()
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Revert and collapse setting buttons.
------------------------------------------------------------------------------------------------------
s.Section.Revert = function()
    local clicked = 0
    if UI.Button("Revert to Default Settings") then
        clicked = 1
        if clicked and 1 then
            Window.Reset_Settings()
            Parse.Config.Reset()
            Focus.Reset_Settings()
            Blog.Config.Reset()
            Metrics.Model.Running_Accuracy_Limit = DB.Defaults.Running_Accuracy_Limit
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Shows text commands the user can use.
------------------------------------------------------------------------------------------------------
s.Section.Text_Commands = function()
    UI.Text("Version: " .. tostring(addon.version))
    UI.Text("Base command: /metrics or /met")
    UI.Text("Arguments:")
    UI.BulletText("show  / s -- toggles window visibility.")
    UI.BulletText("mini  / m -- toggles mini mode.")
    UI.BulletText("nano  / n -- toggles nano mode.")
    UI.BulletText("full  / f -- toggles full mode.")
    UI.BulletText("pet   / p -- toggles pet columns in Team.")
    UI.BulletText("reset / r -- resets the parse data.")
    UI.BulletText("clock / c -- toggle parse run time duration clock.")
    UI.BulletText("total     -- publishes total damage for group.")
    UI.BulletText("acc       -- publishes total accuracy for group.")
    UI.BulletText("melee     -- publishes melee damage for group.")
    UI.BulletText("healing   -- publishes healing done for group.")
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Focus screen.
------------------------------------------------------------------------------------------------------
s.Section.Focus = function()
    local col_flags = Column.Flags.None
    UI.Text("Set max healing thresholds for overcure.")
    UI.BulletText("Otherwise Divine Seal will mess up the calculations.")
    UI.BulletText("Set each value to be about your max healing for each spell.")
    UI.BulletText("Values can also be a little more--just below Divine Seal values.")
    UI.BulletText("Curagas should amount healed per person--not in total.")
    if UI.BeginTable("Battle Log", 2) then
        UI.TableSetupColumn("Col 1", col_flags)
        UI.TableSetupColumn("Col 2", col_flags)
        UI.TableNextColumn()
        s.Widget.Healing("Cure")
        UI.TableNextColumn()
        s.Widget.Healing("Curaga")
        UI.TableNextColumn()
        s.Widget.Healing("Cure II")
        UI.TableNextColumn()
        s.Widget.Healing("Curaga II")
        UI.TableNextColumn()
        s.Widget.Healing("Cure III")
        UI.TableNextColumn()
        s.Widget.Healing("Curaga III")
        UI.TableNextColumn()
        s.Widget.Healing("Cure IV")
        UI.TableNextColumn()
        s.Widget.Healing("Curaga IV")
        UI.TableNextColumn()
        s.Widget.Healing("Cure V")
        UI.EndTable()
    end
end


------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
s.Section.Gui = function()
    if UI.Checkbox("Show Title Bar", {Metrics.Window.Show_Title}) then
        Metrics.Window.Show_Title = not Metrics.Window.Show_Title
    end
    Window.Theme.Choose()
    s.Widget.Alpha()
    s.Widget.Window_Scale()
end

------------------------------------------------------------------------------------------------------
-- Sets screen alpha.
------------------------------------------------------------------------------------------------------
s.Widget.Alpha = function()
    local alpha = {[1] = Metrics.Window.Alpha}
    if UI.DragFloat("Window Transparency", alpha, 0.005, 0.1, 1, "%.3f", ImGuiSliderFlags_None) then
        Metrics.Window.Alpha = alpha[1]
    end
    UI.SameLine() Window.Widgets.HelpMarker("Window transparency.")
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
s.Widget.Window_Scale = function()
    local window_scale = {[1] = Metrics.Window.Window_Scaling}
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.1, 3, "%.3f", ImGuiSliderFlags_None) then
        Metrics.Window.Window_Scaling = window_scale[1]
        Window.Scaling_Set = false
        Window.Set_Window_Scale()
    end
    UI.SameLine() Window.Widgets.HelpMarker("Adjust window element size.")
end

------------------------------------------------------------------------------------------------------
-- Sets the running accuracy buffer limit.
------------------------------------------------------------------------------------------------------
s.Widget.Acc_Limit = function()
    local acc_limit = {[1] = Metrics.Model.Running_Accuracy_Limit}
    if UI.DragInt("Running Accuracy Limit", acc_limit, 0.1, 10, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Model.Running_Accuracy_Limit = acc_limit[1]
        DB.Tracking.Running_Accuracy = {}
    end
    UI.SameLine() Window.Widgets.HelpMarker("Running accuracy calculates based off of {X} many attack attempts.")
end

------------------------------------------------------------------------------------------------------
-- Set the healing threshold defaults to prevent overcure with Divine Seal.
------------------------------------------------------------------------------------------------------
s.Widget.Healing = function(spell)
    local healing_threshold = {[1] = DB.Healing_Max[spell]}
    if UI.DragInt(spell, healing_threshold, 1, 0, 3000, "%d", ImGuiSliderFlags_None) then
        DB.Healing_Max[spell] = healing_threshold[1]
    end
end

return s