local s = {}

s.Section = {}
s.Util = {}
s.Widget = {}
s.Widget.Open_Action = -1

------------------------------------------------------------------------------------------------------
-- Loads the settings data to the screen.
------------------------------------------------------------------------------------------------------
s.Populate = function()
    s.Section.Collapse()
    s.Section.Revert()
    s.Section.Text_Commands()
    s.Section.Overall()
    s.Section.Team()
    s.Section.Focus()
    s.Section.Battle_Log()
    s.Section.Gui()
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
    s.Util.Check_Collapse()
    if UI.CollapsingHeader("Revert to Default Inside") then
        local clicked = 0
        if UI.Button("Revert to Default Settings") then
            clicked = 1
            if clicked and 1 then
                Window.Reset_Settings()
                Team.Reset_Settings()
                Focus.Reset_Settings()
                Blog.Reset_Settings()
                Model.Settings.Running_Accuracy_Limit = Model.Settings.Default.Running_Accuracy_Limit
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Shows text commands the user can use.
------------------------------------------------------------------------------------------------------
s.Section.Text_Commands = function()
    if UI.CollapsingHeader("Text Commands") then
        UI.Text("Base command: /metrics or /met")
        UI.Text("Arguments:")
        UI.BulletText("show  / s -- toggles window visibility.")
        UI.BulletText("mini  / m -- toggles mini mode.")
        UI.BulletText("nano  / n -- toggles nano mode.")
        UI.BulletText("full  / f -- toggles full mode.")
        UI.BulletText("pet   / p -- toggles pet columns in Team.")
        UI.BulletText("reset / r -- resets the parse data.")
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect multiple components.
------------------------------------------------------------------------------------------------------
s.Section.Overall = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
    s.Util.Check_Collapse()
    if UI.CollapsingHeader("Overall: Affects Multiple Tabs") then
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
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Team screen.
------------------------------------------------------------------------------------------------------
s.Section.Team = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
    s.Util.Check_Collapse()
    if UI.CollapsingHeader("Tab: Team") then
        UI.Text("Which extra columns should show in the Team tab?")
        if UI.BeginTable("Team", 3) then
            UI.TableSetupColumn("Col 1", col_flags, width)
            UI.TableSetupColumn("Col 2", col_flags, width)
            UI.TableSetupColumn("Col 3", col_flags, width)

            UI.TableNextColumn()
            if UI.Checkbox("Total Damage Only", {Team.Display.Flags.Total_Damage_Only}) then
                Team.Display.Flags.Total_Damage_Only = not Team.Display.Flags.Total_Damage_Only
                Team.Util.Calculate_Column_Flags()
            end
            UI.SameLine() Window.Widget.HelpMarker("Reduces the amount of columns on Team table to just "
                                                 .."the most essential: Name, %T, Total, and Running Accuracy.")

            UI.TableNextColumn()
            UI.TableNextColumn()
            UI.TableNextColumn()
            if UI.Checkbox("Show Crits", {Team.Display.Flags.Crit}) then
                Team.Display.Flags.Crit = not Team.Display.Flags.Crit
                Team.Util.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Pets", {Team.Display.Flags.Pet}) then
                Team.Display.Flags.Pet = not Team.Display.Flags.Pet
                Team.Util.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Healing", {Team.Display.Flags.Healing}) then
                Team.Display.Flags.Healing = not Team.Display.Flags.Healing
                Team.Util.Calculate_Column_Flags()
            end

            UI.TableNextColumn()
            -- if UI.Checkbox("Show Deaths", {Team.Display.Flags.Deaths}) then
            --     Team.Display.Flags.Deaths = not Team.Display.Flags.Deaths
            --     Team.Util.Calculate_Column_Flags()
            -- end
        UI.EndTable()
        end

        UI.Text("Use Ctrl+Click on the component to set the number directly.")
        s.Widget.Player_Limit()
        s.Widget.Acc_Limit()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Focus screen.
------------------------------------------------------------------------------------------------------
s.Section.Focus = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
    s.Util.Check_Collapse()
    if UI.CollapsingHeader("Tab: Focus") then
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
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
s.Section.Battle_Log = function()
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Settings
    s.Util.Check_Collapse()
    if UI.CollapsingHeader("Tab: Battle Log") then

        UI.Text("Which columns should show in the battle log?")
        if UI.Checkbox("Show Timestamps", {Blog.Flags.Timestamp}) then
            Blog.Flags.Timestamp = not Blog.Flags.Timestamp
        end

        UI.Text("Which actions should populate the battle log?")
        if UI.BeginTable("Battle Log", 3) then
            UI.TableSetupColumn("Col 1", col_flags, width)
            UI.TableSetupColumn("Col 2", col_flags, width)
            UI.TableSetupColumn("Col 3", col_flags, width)

            UI.TableNextColumn()
            if UI.Checkbox("Show Melee", {Blog.Flags.Melee}) then
                Blog.Flags.Melee = not Blog.Flags.Melee
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Ranged", {Blog.Flags.Ranged}) then
                Blog.Flags.Ranged = not Blog.Flags.Ranged
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show WS", {Blog.Flags.WS}) then
                Blog.Flags.WS = not Blog.Flags.WS
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show SC", {Blog.Flags.SC}) then
                Blog.Flags.SC = not Blog.Flags.SC
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Magic", {Blog.Flags.Magic}) then
                Blog.Flags.Magic = not Blog.Flags.Magic
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Ability", {Blog.Flags.Ability}) then
                Blog.Flags.Ability = not Blog.Flags.Ability
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Pet", {Blog.Flags.Pet}) then
                Blog.Flags.Pet = not Blog.Flags.Pet
            end

            UI.TableNextColumn()
            if UI.Checkbox("Show Healing", {Blog.Flags.Healing}) then
                Blog.Flags.Healing = not Blog.Flags.Healing
            end

            UI.TableNextColumn()
            -- if UI.Checkbox("Show Deaths", {Blog.Flags.Deaths}) then
            --     Blog.Flags.Deaths = not Blog.Flags.Deaths
            -- end
            UI.EndTable()
        end

        UI.Text("Should especially high damage be highlited in the battle log?")
        s.Widget.Damage_Highlighting()
        UI.Text("Use Ctrl+Click on the component to set the number directly." )
        s.Widget.WS_Threshold()
        s.Widget.Magic_Threshold()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the GUI.
------------------------------------------------------------------------------------------------------
s.Section.Gui = function()
    s.Util.Check_Collapse()
    if UI.CollapsingHeader("GUI: Window Visuals") then
        UI.Text("*** These settings will affect all ImGui-based addon visuals. ***")
        Window.Util.Set_Theme()
        s.Widget.Alpha()
        s.Widget.Font_Size()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets screen alpha.
------------------------------------------------------------------------------------------------------
s.Widget.Alpha = function()
    local alpha = {[1] = Window.Window.Alpha}
    if UI.DragFloat("Window Transparency", alpha, 0.005, 0.1, 1, "%.3f", ImGuiSliderFlags_None) then
        Window.Window.Alpha = alpha[1]
        Window.Util.Set_Alpha()
    end
    UI.SameLine() Window.Widget.HelpMarker("Window transparency.")
end

------------------------------------------------------------------------------------------------------
-- Sets screen font size.
------------------------------------------------------------------------------------------------------
s.Widget.Font_Size = function()
    local text_size = {[1] = Window.Window.Font_Scaling}
    if UI.DragFloat("Font Size", text_size, 0.005, 0.1, 3, "%.3f", ImGuiSliderFlags_None) then
        Window.Window.Font_Scaling = text_size[1]
        Window.Util.Set_Font_Size()
    end
    UI.SameLine() Window.Widget.HelpMarker("Font size.")
end

------------------------------------------------------------------------------------------------------
-- Sets the running accuracy buffer limit.
------------------------------------------------------------------------------------------------------
s.Widget.Acc_Limit = function()
    local acc_limit = {[1] = Model.Settings.Running_Accuracy_Limit}
    if UI.DragInt("Running Accuracy Limit", acc_limit, 0.1, 10, 50, "%d", ImGuiSliderFlags_None) then
        Model.Settings.Running_Accuracy_Limit = acc_limit[1]
        Model.Data.Running_Accuracy = {}
    end
    UI.SameLine() Window.Widget.HelpMarker("Running accuracy calculates based off of {X} many attack attempts.")
end

------------------------------------------------------------------------------------------------------
-- Sets how many players can be shown on the Team screen.
------------------------------------------------------------------------------------------------------
s.Widget.Player_Limit = function()
    local cutoff = {[1] = Team.Settings.Rank_Cutoff}
    if UI.DragInt("Player Limit", cutoff, 0.1, 0, 18, "%d", ImGuiSliderFlags_None) then
        Team.Settings.Rank_Cutoff = cutoff[1]
    end
    UI.SameLine() Window.Widget.HelpMarker("How many players are listed on the Team table.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether skillchain damage is included in damage displays.
------------------------------------------------------------------------------------------------------
s.Widget.SC_Damage = function()
    if UI.Checkbox("Include SC Damage", {Team.Settings.Include_SC_Damage}) then
        Team.Settings.Include_SC_Damage = not Team.Settings.Include_SC_Damage
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
    if UI.Checkbox("Condensed Numbers", {Team.Settings.Condensed_Numbers}) then
        Team.Settings.Condensed_Numbers = not Team.Settings.Condensed_Numbers
        Team.Util.Calculate_Column_Flags()
    end
    UI.SameLine() Window.Widget.HelpMarker("Condensed is 1.2K instead of 1,200.")
end

------------------------------------------------------------------------------------------------------
-- Toggles whether damage highlighting takes place in the battle log.
------------------------------------------------------------------------------------------------------
s.Widget.Damage_Highlighting = function()
    if UI.Checkbox("Damage Highlighting", {Blog.Settings.Damage_Highlighting}) then
        Blog.Settings.Damage_Highlighting = not Blog.Settings.Damage_Highlighting
    end
    UI.SameLine() Window.Widget.HelpMarker("Damage over certain limits causes the text to highlight. "
                                    .. "It's a way for you to easily see if you or others are meeting your damage goals. "
                                    .. "Set the bar high and strive to win.")
end

------------------------------------------------------------------------------------------------------
-- Set the battle log damage highlighting threshold for weaponskills.
------------------------------------------------------------------------------------------------------
s.Widget.WS_Threshold = function()
    local ws_threshold = {[1] = Blog.Thresholds.WS}
    if UI.DragInt("Weaponskill", ws_threshold, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Blog.Thresholds.WS = ws_threshold[1]
    end
    UI.SameLine() Window.Widget.HelpMarker("Weaponskill damage over this amount will be highlighted "
                                    .. "in the battle log.")
end

------------------------------------------------------------------------------------------------------
-- Set the battle log damage highlighting threshold for magic.
------------------------------------------------------------------------------------------------------
s.Widget.Magic_Threshold = function()
    local magic_threshold = {[1] = Blog.Thresholds.MAGIC}
    if UI.DragInt("Spell", magic_threshold, 1, 0, 99999, "%d", ImGuiSliderFlags_None) then
        Blog.Thresholds.MAGIC = magic_threshold[1]
    end
    UI.SameLine() Window.Widget.HelpMarker("Magic damage over this amount will be highlighted "
                                    .. "in the battle log.")
end

------------------------------------------------------------------------------------------------------
-- Set the healing threshold defaults to prevent overcure with Divine Seal.
------------------------------------------------------------------------------------------------------
s.Widget.Healing = function(spell)
    local healing_threshold = {[1] = Model.Healing_Max[spell]}
    if UI.DragInt(spell, healing_threshold, 1, 0, 3000, "%d", ImGuiSliderFlags_None) then
        Model.Healing_Max[spell] = healing_threshold[1]
    end
end

------------------------------------------------------------------------------------------------------
-- Works in conjunction with collapse all or expand all.
------------------------------------------------------------------------------------------------------
s.Util.Check_Collapse = function()
    if s.Widget.Open_Action ~= -1 then UI.SetNextItemOpen(s.Widget.Open_Action ~= 0) end
end

return s