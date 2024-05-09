local s = {}

s.Section = {}
s.Util = {}
s.Widget = {}
s.Widget.Open_Action = -1

s.Enum = {}
s.Enum.File = {
    TEAM   = "team",
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
    if UI.BeginTabBar("Focus Tabs", Window.Tabs.Flags) then
        if UI.BeginTabItem("Help", Window.Tabs.Flags) then
            s.Section.Text_Commands()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Overall", Window.Tabs.Flags) then
            s.Section.Overall()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Team", Window.Tabs.Flags) then
            s.Section.Team()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Focus", Window.Tabs.Flags) then
            s.Section.Focus()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Battle Log", Window.Tabs.Flags) then
            s.Section.Battle_Log()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Report", Window.Tabs.Flags) then
            s.Section.Report()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("GUI", Window.Tabs.Flags) then
            s.Section.Gui()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Revert", Window.Tabs.Flags) then
            s.Section.Revert()
            UI.EndTabItem()
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Collapse setting buttons.
------------------------------------------------------------------------------------------------------
s.Section.Collapse = function()
    s.Widget.Open_Action = -1
    if UI.Button("Expand all") then
        s.Widget.Open_Action = 1
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    if UI.Button("Collapse all") then
        s.Widget.Open_Action = 0
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
            Team.Reset_Settings()
            Focus.Reset_Settings()
            Blog.Reset_Settings()
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
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
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
-- Shows settings that affect the Team screen.
------------------------------------------------------------------------------------------------------
s.Section.Team = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
    UI.Text("Which extra columns should show in the Team tab?")
    if UI.BeginTable("Team", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Total Damage Only", {Metrics.Team.Flags.Total_Damage_Only}) then
            Metrics.Team.Flags.Total_Damage_Only = not Metrics.Team.Flags.Total_Damage_Only
            Team.Util.Calculate_Column_Flags()
        end
        UI.SameLine() Window.Widget.HelpMarker("Reduces the amount of columns on Team table to just "
                                                .."the most essential: Name, %T, Total, and Running Accuracy.")

        UI.TableNextColumn()
        if UI.Checkbox("Show Run Time", {Metrics.Team.Settings.Show_Clock}) then
            Metrics.Team.Settings.Show_Clock = not Metrics.Team.Settings.Show_Clock
        end
        UI.SameLine() Window.Widget.HelpMarker("Show a timer of how long the parse has been running on the Team tab.")
        UI.TableNextColumn()
        ---
        UI.TableNextColumn()
        if UI.Checkbox("Show Crits", {Metrics.Team.Flags.Crit}) then
            Metrics.Team.Flags.Crit = not Metrics.Team.Flags.Crit
            Team.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Pets", {Metrics.Team.Flags.Pet}) then
            Metrics.Team.Flags.Pet = not Metrics.Team.Flags.Pet
            Team.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Healing", {Metrics.Team.Flags.Healing}) then
            Metrics.Team.Flags.Healing = not Metrics.Team.Flags.Healing
            Team.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Deaths", {Metrics.Team.Flags.Deaths}) then
            Metrics.Team.Flags.Deaths = not Metrics.Team.Flags.Deaths
            Team.Util.Calculate_Column_Flags()
        end
        UI.EndTable()
    end

    UI.Text("Use Ctrl+Click on the component to set the number directly.")
    s.Widget.Player_Limit()
    s.Widget.Acc_Limit()
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Focus screen.
------------------------------------------------------------------------------------------------------
s.Section.Focus = function()
    local col_flags = Window.Columns.Flags.None
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
-- Shows settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
s.Section.Battle_Log = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
    UI.Text("Which columns should show in the battle log?")
    if UI.Checkbox("Show Timestamps", {Metrics.Blog.Flags.Timestamp}) then
        Metrics.Blog.Flags.Timestamp = not Metrics.Blog.Flags.Timestamp
    end

    UI.Text("Which actions should populate the battle log?")
    if UI.BeginTable("Battle Log", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Show Melee", {Metrics.Blog.Flags.Melee}) then
            Metrics.Blog.Flags.Melee = not Metrics.Blog.Flags.Melee
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Ranged", {Metrics.Blog.Flags.Ranged}) then
            Metrics.Blog.Flags.Ranged = not Metrics.Blog.Flags.Ranged
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show WS", {Metrics.Blog.Flags.WS}) then
            Metrics.Blog.Flags.WS = not Metrics.Blog.Flags.WS
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show SC", {Metrics.Blog.Flags.SC}) then
            Metrics.Blog.Flags.SC = not Metrics.Blog.Flags.SC
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Magic", {Metrics.Blog.Flags.Magic}) then
            Metrics.Blog.Flags.Magic = not Metrics.Blog.Flags.Magic
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Ability", {Metrics.Blog.Flags.Ability}) then
            Metrics.Blog.Flags.Ability = not Metrics.Blog.Flags.Ability
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Pet", {Metrics.Blog.Flags.Pet}) then
            Metrics.Blog.Flags.Pet = not Metrics.Blog.Flags.Pet
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Healing", {Metrics.Blog.Flags.Healing}) then
            Metrics.Blog.Flags.Healing = not Metrics.Blog.Flags.Healing
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Deaths", {Metrics.Blog.Flags.Deaths}) then
            Metrics.Blog.Flags.Deaths = not Metrics.Blog.Flags.Deaths
        end

        UI.TableNextColumn()
        if UI.Checkbox("Show Mob Deaths", {Metrics.Blog.Flags.Mob_Death}) then
            Metrics.Blog.Flags.Mob_Death = not Metrics.Blog.Flags.Mob_Death
        end

        UI.EndTable()
    end

    UI.Text("Should especially high damage be highlited in the battle log?")
    s.Widget.Damage_Highlighting()
    UI.Text("Use Ctrl+Click on the component to set the number directly." )
    s.Widget.WS_Threshold()
    s.Widget.Magic_Threshold()
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Report tab.
------------------------------------------------------------------------------------------------------
s.Section.Report = function()
    local damage_threshold = {[1] = Metrics.Report.Damage_Threshold}
    UI.Text("This does not affect the Publish button on the focus tab.")
    if UI.DragInt("Chat Report % Threshold", damage_threshold, 0.1, 0, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Report.Damage_Threshold = damage_threshold[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
s.Section.Gui = function()
    if UI.Checkbox("Show Title Bar", {Metrics.Window.Show_Title}) then
        Metrics.Window.Show_Title = not Metrics.Window.Show_Title
    end
    Window.Util.Set_Theme()
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
    UI.SameLine() Window.Widget.HelpMarker("Window transparency.")
end

------------------------------------------------------------------------------------------------------
-- Sets window scaling.
------------------------------------------------------------------------------------------------------
s.Widget.Window_Scale = function()
    local window_scale = {[1] = Metrics.Window.Window_Scaling}
    if UI.DragFloat("Window Scaling", window_scale, 0.005, 0.1, 3, "%.3f", ImGuiSliderFlags_None) then
        Metrics.Window.Window_Scaling = window_scale[1]
        Window.Util.Set_Window_Scale()
    end
    UI.SameLine() Window.Widget.HelpMarker("Adjust window element size.")
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
    UI.SameLine() Window.Widget.HelpMarker("Running accuracy calculates based off of {X} many attack attempts.")
end

------------------------------------------------------------------------------------------------------
-- Sets how many players can be shown on the Team screen.
------------------------------------------------------------------------------------------------------
s.Widget.Player_Limit = function()
    local cutoff = {[1] = Metrics.Team.Settings.Rank_Cutoff}
    if UI.DragInt("Player Limit", cutoff, 0.1, 0, 18, "%d", ImGuiSliderFlags_None) then
        Metrics.Team.Settings.Rank_Cutoff = cutoff[1]
    end
    UI.SameLine() Window.Widget.HelpMarker("How many players are listed on the Team table.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether skillchain damage is included in damage displays.
------------------------------------------------------------------------------------------------------
s.Widget.SC_Damage = function()
    if UI.Checkbox("Include SC Damage", {Metrics.Team.Settings.Include_SC_Damage}) then
        Metrics.Team.Settings.Include_SC_Damage = not Metrics.Team.Settings.Include_SC_Damage
        Team.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widget.HelpMarker("The player that closes the skill chain gets the damage credit. "
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
        Team.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widget.HelpMarker("Condensed is 1.2K instead of 1,200.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether damage highlighting takes place in the battle log.
------------------------------------------------------------------------------------------------------
s.Widget.Damage_Highlighting = function()
    if UI.Checkbox("Damage Highlighting", {Metrics.Blog.Flags.Damage_Highlighting}) then
        Metrics.Blog.Flags.Damage_Highlighting = not Metrics.Blog.Flags.Damage_Highlighting
    end
    UI.SameLine() Window.Widget.HelpMarker("Damage over certain limits causes the text to highlight. "
                                    .. "It's a way for you to easily see if you or others are meeting your damage goals. "
                                    .. "Set the bar high and strive to win.")
end

------------------------------------------------------------------------------------------------------
-- Set the battle log damage highlighting threshold for weaponskills.
------------------------------------------------------------------------------------------------------
s.Widget.WS_Threshold = function()
    local ws_threshold = {[1] = Metrics.Blog.Thresholds.WS}
    if UI.DragInt("Weaponskill", ws_threshold, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Thresholds.WS = ws_threshold[1]
    end
    UI.SameLine() Window.Widget.HelpMarker("Weaponskill damage over this amount will be highlighted "
                                    .. "in the battle log.")
end

------------------------------------------------------------------------------------------------------
-- Set the battle log damage highlighting threshold for magic.
------------------------------------------------------------------------------------------------------
s.Widget.Magic_Threshold = function()
    local magic_threshold = {[1] = Metrics.Blog.Thresholds.MAGIC}
    if UI.DragInt("Spell", magic_threshold, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Thresholds.MAGIC = magic_threshold[1]
    end
    UI.SameLine() Window.Widget.HelpMarker("Magic damage over this amount will be highlighted "
                                    .. "in the battle log.")
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

------------------------------------------------------------------------------------------------------
-- Works in conjunction with collapse all or expand all.
------------------------------------------------------------------------------------------------------
s.Util.Check_Collapse = function()
    if s.Widget.Open_Action ~= -1 then UI.SetNextItemOpen(s.Widget.Open_Action ~= 0) end
end

return s