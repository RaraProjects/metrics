local s = {}

s.Section = {}
s.Widget = {}

s.Enum = {}
s.Enum.File = {
    PARSE    = "parse",
    FOCUS    = "focus",
    BLOG     = "blog",
    WINDOW   = "window",
    DATABASE = "database",
    REPORT   = "report",
}

s.Show_Window = {false}

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
            Window.Config.Display()
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Revert", tab_flags) then
            s.Section.Revert()
            UI.EndTabItem()
        end
        if _Debug.Is_Enabled() then
            if UI.BeginTabItem("Debug", tab_flags) then
                _Debug.Config.Display()
                UI.EndTabItem()
            end
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
            Window.Config.Reset()
            Parse.Config.Reset()
            Focus.Reset_Settings()
            Blog.Config.Reset()
            Report.Config.Reset()
            Metrics.Model.Running_Accuracy_Limit = DB.Defaults.Running_Accuracy_Limit
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Shows text commands the user can use.
------------------------------------------------------------------------------------------------------
s.Section.Text_Commands = function()
    UI.Text("Read Me: https://github.com/RaraProjects/metrics")
    UI.Text("Version: " .. tostring(addon.version))
    UI.Text("Base command: /metrics or /met")

    UI.Text("Arguments:")
    if UI.BeginTable("Text Commands", 4, Window.Table.Flags.Borders) then
        UI.TableSetupColumn("Type")
        UI.TableSetupColumn("Full")
        UI.TableSetupColumn("Short")
        UI.TableSetupColumn("Description")
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn()
        UI.TableNextColumn() UI.Text("None")
        UI.TableNextColumn()
        UI.TableNextColumn() UI.Text("Toggles settings window.")

        UI.TableNextColumn()
        UI.TableNextColumn() UI.Text("reset")
        UI.TableNextColumn() UI.Text("r")
        UI.TableNextColumn() UI.Text("Clears the database.")

        UI.TableNextColumn()
        UI.TableNextColumn() UI.Text("show")
        UI.TableNextColumn() UI.Text("s")
        UI.TableNextColumn() UI.Text("Toggles window visibility.")

        UI.TableNextColumn() UI.Text("Switch")
        UI.TableNextColumn() UI.Text("parse")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Switch to the Parse tab.")

        UI.TableNextColumn() UI.Text("Switch")
        UI.TableNextColumn() UI.Text("focus")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Switch to the Focus tab.")

        UI.TableNextColumn() UI.Text("Switch")
        UI.TableNextColumn() UI.Text("log")
        UI.TableNextColumn() UI.Text("bl")
        UI.TableNextColumn() UI.Text("Switch to the Battle Log tab.")

        UI.TableNextColumn() UI.Text("Switch")
        UI.TableNextColumn() UI.Text("report")
        UI.TableNextColumn() UI.Text("rep")
        UI.TableNextColumn() UI.Text("Switch to the Report tab.")

        UI.TableNextColumn() UI.Text("Parse")
        UI.TableNextColumn() UI.Text("full")
        UI.TableNextColumn() UI.Text("f")
        UI.TableNextColumn() UI.Text("Shows Parse in full mode.")

        UI.TableNextColumn() UI.Text("Parse")
        UI.TableNextColumn() UI.Text("mini")
        UI.TableNextColumn() UI.Text("m")
        UI.TableNextColumn() UI.Text("Shows Parse in mini mode.")

        UI.TableNextColumn() UI.Text("Parse")
        UI.TableNextColumn() UI.Text("nano")
        UI.TableNextColumn() UI.Text("n")
        UI.TableNextColumn() UI.Text("Shows Parse in nano mode.")

        UI.TableNextColumn() UI.Text("Parse")
        UI.TableNextColumn() UI.Text("pet")
        UI.TableNextColumn() UI.Text("p")
        UI.TableNextColumn() UI.Text("Toggles pet columns in Parse (if not in Focus tab).")

        UI.TableNextColumn() UI.Text("Parse")
        UI.TableNextColumn() UI.Text("clock")
        UI.TableNextColumn() UI.Text("c")
        UI.TableNextColumn() UI.Text("Toggles the duration timer visibility.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("player name")
        UI.TableNextColumn() UI.Text("pl name")
        UI.TableNextColumn() UI.Text("Focus on a player in the Focus tab. Partial matching works.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("melee")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Switch to Melee tab in Focus tab.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("ranged")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Switch to Ranged tab in Focus tab.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("weaponskill")
        UI.TableNextColumn() UI.Text("ws")
        UI.TableNextColumn() UI.Text("Switch to Weaponskill tab in Focus tab.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("magic")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Switch to Magic tab in Focus tab.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("ability")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Switch to Ability tab in Focus tab.")

        UI.TableNextColumn() UI.Text("Focus")
        UI.TableNextColumn() UI.Text("pet")
        UI.TableNextColumn() UI.Text("p")
        UI.TableNextColumn() UI.Text("Switch to Pet tab in Focus tab.")

        UI.TableNextColumn() UI.Text("Report")
        UI.TableNextColumn() UI.Text("rep total")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Publishes total damage report in chat.")

        UI.TableNextColumn() UI.Text("Report")
        UI.TableNextColumn() UI.Text("rep acc")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Publishes accuracy report in chat.")

        UI.TableNextColumn() UI.Text("Report")
        UI.TableNextColumn() UI.Text("rep melee")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Publishes melee report in chat.")

        UI.TableNextColumn() UI.Text("Report")
        UI.TableNextColumn() UI.Text("rep ws")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Publishes weaponskill report in chat.")

        UI.TableNextColumn() UI.Text("Report")
        UI.TableNextColumn() UI.Text("rep healing")
        UI.TableNextColumn() UI.Text("")
        UI.TableNextColumn() UI.Text("Publishes healing report in chat.")

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
    UI.BulletText("Curagas should be amount healed per person--not in total.")

    if UI.BeginTable("Battle Log", 2) then
        UI.TableSetupColumn("Col 1", col_flags)
        UI.TableSetupColumn("Col 2", col_flags)

        UI.TableNextColumn() s.Widget.Healing("Cure")
        UI.TableNextColumn() s.Widget.Healing("Curaga")
        UI.TableNextColumn() s.Widget.Healing("Cure II")
        UI.TableNextColumn() s.Widget.Healing("Curaga II")
        UI.TableNextColumn() s.Widget.Healing("Cure III")
        UI.TableNextColumn() s.Widget.Healing("Curaga III")
        UI.TableNextColumn() s.Widget.Healing("Cure IV")
        UI.TableNextColumn() s.Widget.Healing("Curaga IV")
        UI.TableNextColumn() s.Widget.Healing("Cure V")
        UI.EndTable()
    end
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