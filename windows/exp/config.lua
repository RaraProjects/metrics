XP.Config = T{}

XP.Config.Total_Mode_List = T{
    [1] = "Combined",
    [2] = "Split",
}
XP.Config.Total_Mode_Index = 2
XP.Config.Total_Mode = XP.Config.Total_Mode_List[XP.Config.Total_Mode_Index]

------------------------------------------------------------------------------------------------------
-- Populates the exp configuration window.
------------------------------------------------------------------------------------------------------
XP.Config.Populate = function()
    local col_flags = Parse.Config.Column_Flags
    local width = Parse.Config.Column_Width

    UI.Text("GUI")
    if UI.BeginTable("XP GUI", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Show Background", {Metrics.Parse.Show_Background}) then
            Metrics.Parse.Show_Background = not Metrics.Parse.Show_Background
        end
        UI.TableNextColumn()
        UI.TableNextColumn()

        UI.EndTable()
    end

    UI.Separator()
    UI.Text("Progress Bars")
    if UI.BeginTable("XP Progress", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("XP Progress", {Metrics.Parse.XP_Progress}) then
            Metrics.Parse.XP_Progress = not Metrics.Parse.XP_Progress
        end
        UI.TableNextColumn()
        if UI.Checkbox("Boost Progress", {Metrics.Parse.Boost_Progress}) then
            Metrics.Parse.Boost_Progress = not Metrics.Parse.Boost_Progress
        end
        UI.TableNextColumn()
        if UI.Checkbox("Small Bars", {Metrics.Parse.Small_Bars}) then
            Metrics.Parse.Small_Bars = not Metrics.Parse.Small_Bars
        end
        UI.SameLine() Window.Widgets.HelpMarker("In order to see the percentage of progress bars, the bars need to be a certain height."
                               .. " If you don't need to see the percentage and want more compact progress bars then turn this on.")

        UI.EndTable()
    end

    UI.Separator()
    UI.Text("Columns")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Job", {Metrics.Parse.XP_Job}) then
            Metrics.Parse.XP_Job = not Metrics.Parse.XP_Job
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Base XP Rate", {Metrics.Parse.Base_Rate}) then
            Metrics.Parse.Base_Rate = not Metrics.Parse.Base_Rate
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("Boosted and base XP are tracked separately. The default XP/hr columns includes boosted XP. This column"
                               .. " always shows the base XP--as if you did not have the XP boost buff--so you can always know how your"
                               .. " group is doing.")
        UI.TableNextColumn()
        if UI.Checkbox("Kill Speed", {Metrics.Parse.Kill_Speed}) then
            Metrics.Parse.Kill_Speed = not Metrics.Parse.Kill_Speed
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("Seconds per kill for mobs that grant XP.")
        UI.TableNextColumn()
        if UI.Checkbox("Average XP", {Metrics.Parse.Average_XP}) then
            Metrics.Parse.Average_XP = not Metrics.Parse.Average_XP
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Time to Level", {Metrics.Parse.Time_To_Level}) then
            Metrics.Parse.Time_To_Level = not Metrics.Parse.Time_To_Level
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("An estimation on how long it will be until you level.")
        UI.TableNextColumn()
        if UI.Checkbox("TNL/TNM", {Metrics.Parse.To_Next_Level}) then
            Metrics.Parse.To_Next_Level = not Metrics.Parse.To_Next_Level
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Total XP", {Metrics.Parse.Total_XP}) then
            Metrics.Parse.Total_XP = not Metrics.Parse.Total_XP
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("How much XP you've gained this session.")
        UI.TableNextColumn()
        if UI.Checkbox("Max Chain", {Metrics.Parse.Max_Chain}) then
            Metrics.Parse.Max_Chain = not Metrics.Parse.Max_Chain
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Time in Zone", {Metrics.Parse.Zone_Time}) then
            Metrics.Parse.Zone_Time = not Metrics.Parse.Zone_Time
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Boost Item", {Metrics.Parse.XP_Boost_Item}) then
            Metrics.Parse.XP_Boost_Item = not Metrics.Parse.XP_Boost_Item
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("Shows which boost item you used (if known). If you already had the dedication buff before loading"
                                .." then Metrics will not know which item was used or what the rate is.")
        UI.TableNextColumn()
        if UI.Checkbox("Boost Rate", {Metrics.Parse.XP_Boost_Rate}) then
            Metrics.Parse.XP_Boost_Rate = not Metrics.Parse.XP_Boost_Rate
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("The XP boost rate that is currently active (if known).")
        UI.TableNextColumn()
        if UI.Checkbox("Boost Max", {Metrics.Parse.XP_Boost_Max}) then
            Metrics.Parse.XP_Boost_Max = not Metrics.Parse.XP_Boost_Max
            XP.Columns.Count()
        end
        UI.SameLine() Window.Widgets.HelpMarker("The maximum XP boost you can get from your current dedication buff (if known).")
        UI.TableNextColumn()
        UI.TableNextColumn()

        UI.EndTable()
    end

    if Metrics.Parse.Total_XP then
        UI.Separator()
        local dropdown_flags = DB.Widgets.Dropdown.Flags
        local list = XP.Config.Total_Mode_List
        if list[1] then
            UI.SetNextItemWidth(DB.Widgets.Dropdown.Width)
            if UI.BeginCombo("Total XP Mode", list[XP.Config.Total_Mode_Index], dropdown_flags) then
                for n = 1, #list, 1 do
                    local is_selected = XP.Config.Total_Mode_Index == n
                    if UI.Selectable(list[n], is_selected) then
                        XP.Config.Total_Mode_Index = n
                        XP.Config.Total_Mode = list[n]
                        Window.Set_Bar_Delay()
                    end
                    if is_selected then
                        UI.SetItemDefaultFocus()
                    end
                end
                UI.EndCombo()
            end
            UI.SameLine()
            Window.Widgets.HelpMarker("Choose whether you want to base and boosted XP combined in the Total XP column or if you"
                                    .." want them separated out.")
        end
    end

end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the exp window.
------------------------------------------------------------------------------------------------------
XP.Config.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Config.Window.Button_Toggle(Config.Enum.File.EXP)
    end
end