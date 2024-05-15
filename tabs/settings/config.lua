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
        if UI.BeginTabItem("Overall", tab_flags) then
            s.Section.Overall()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Parse", tab_flags) then
            Parse.Config.Display()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Focus", tab_flags) then
            s.Section.Focus()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Battle Log", tab_flags) then
            Blog.Config.Display()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Report", tab_flags) then
            Report.Config.Display()
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
-- Shows settings that affect multiple components.
------------------------------------------------------------------------------------------------------
s.Section.Overall = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Settings
    if UI.BeginTable("Overall", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        s.Widget.Condensed_Numbers()

        UI.TableNextColumn()
        s.Widget.SC_Damage()

        UI.TableNextColumn()
        -- Nothing

        UI.EndTable()
    end
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
-- Sets how many players can be shown on the Team screen.
------------------------------------------------------------------------------------------------------
s.Widget.Player_Limit = function()
    local cutoff = {[1] = Metrics.Team.Settings.Rank_Cutoff}
    if UI.DragInt("Player Limit", cutoff, 0.1, 0, 18, "%d", ImGuiSliderFlags_None) then
        Metrics.Team.Settings.Rank_Cutoff = cutoff[1]
    end
    UI.SameLine() Window.Widgets.HelpMarker("How many players are listed on the Team table.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether skillchain damage is included in damage displays.
------------------------------------------------------------------------------------------------------
s.Widget.SC_Damage = function()
    if UI.Checkbox("Include SC Damage", {Metrics.Team.Settings.Include_SC_Damage}) then
        Metrics.Team.Settings.Include_SC_Damage = not Metrics.Team.Settings.Include_SC_Damage
        Parse.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widgets.HelpMarker("The player that closes the skill chain gets the damage credit. "
                                    .. "You can choose to exclude skillchain damage from the parse display. "
                                    .. "You won't lose any data by toggling this. There is a track where "
                                    .. "skillchains are included and one where they aren't. This just toggles "
                                    .. "between the two.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether or not numbers are shown in condensed format or not.
------------------------------------------------------------------------------------------------------
s.Widget.Condensed_Numbers = function()
    if UI.Checkbox("Condensed Numbers", {Metrics.Team.Settings.Condensed_Numbers}) then
        Metrics.Team.Settings.Condensed_Numbers = not Metrics.Team.Settings.Condensed_Numbers
        Parse.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widgets.HelpMarker("Condensed is 1.2K instead of 1,200.")
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