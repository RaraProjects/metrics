XP.Config = T{}

XP.Config.Defaults = T{
    X               = 100,
    Y               = 100,
    Visible         = {true},
    Show_Background = false,
    XP_Mini         = false,
    XP_Job          = true,
    Base_Rate       = false,
    Kill_Speed      = true,
    Average_XP      = false,
    Time_To_Level   = true,
    To_Next_Level   = true,
    Total_XP        = true,
    Max_Chain       = false,
    Zone_Time       = false,
    XP_Boost_Item   = false,
    XP_Boost_Rate   = false,
    XP_Boost_Max    = false,
    XP_Progress     = true,
    Boost_Progress  = true,
    Small_Bars      = true,
    Boost_Default   = false,
    Boost_Item_Default_Name = "Anniversary Ring",
    Boost_Item_Default_Index = 1,
    Boost_Item_Name = "None",
    Boost_Item_Rate = 0,
    Boost_Item_Max  = 0,
    Boost_EXP       = 0,
}

XP.Config.Total_Mode_List = T{
    [1] = "Combined",
    [2] = "Split",
}
XP.Config.Total_Mode_Index = 2
XP.Config.Total_Mode = XP.Config.Total_Mode_List[XP.Config.Total_Mode_Index]

XP.Config.Dropdown_Width = 250

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
        if UI.Checkbox("Show Background", {Metrics.XP.Show_Background}) then
            Metrics.XP.Show_Background = not Metrics.XP.Show_Background
            XP.Window.Set_Background(Metrics.XP.Show_Background)
        end
        UI.TableNextColumn()
        UI.TableNextColumn()

        UI.EndTable()
    end

    UI.Separator()
    UI.Text("Boost Item Defaulting")
    if UI.Checkbox("Enabled", {Metrics.XP.Boost_Default}) then
        Metrics.XP.Boost_Default = not Metrics.XP.Boost_Default
        XP.Dedication.Check()
        Window_Manager.Set_Bar_Delay()
    end
    UI.SameLine() Window_Manager.Widgets.HelpMarker("If Metrics is loaded when you already have the dedication buff it doesn't know which item you used."
                                .." you can use this setting as a backup. This allows Metrics to know the boost rate and boost max."
                                .." This only comes into play if the boost item is unknown.")

    if Metrics.XP.Boost_Default then
        local dropdown_flags = DB.Widgets.Dropdown.Flags
        local list = Res.Items.Get_Dedication_Selection()
        if list[1] then
            UI.SetNextItemWidth(XP.Config.Dropdown_Width)
            if UI.BeginCombo("Boost Item", list[Metrics.XP.Boost_Item_Default_Index], dropdown_flags) then
                for n = 1, #list, 1 do
                    local is_selected = Metrics.XP.Boost_Item_Default_Index == n
                    if UI.Selectable(list[n], is_selected) then
                        Metrics.XP.Boost_Item_Default_Index = n
                        Metrics.XP.Boost_Item_Default_Name = list[n]
                        XP.Dedication.Check()
                        Window_Manager.Set_Bar_Delay()
                    end
                    if is_selected then
                        UI.SetItemDefaultFocus()
                    end
                end
                UI.EndCombo()
            end
        end
    end

    UI.Separator()
    UI.Text("Progress Bars")
    if UI.BeginTable("XP Progress", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("XP Progress", {Metrics.XP.XP_Progress}) then
            Metrics.XP.XP_Progress = not Metrics.XP.XP_Progress
        end
        UI.TableNextColumn()
        if UI.Checkbox("Boost Progress", {Metrics.XP.Boost_Progress}) then
            Metrics.XP.Boost_Progress = not Metrics.XP.Boost_Progress
        end
        UI.TableNextColumn()
        if UI.Checkbox("Small Bars", {Metrics.XP.Small_Bars}) then
            Metrics.XP.Small_Bars = not Metrics.XP.Small_Bars
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("In order to see the percentage of progress bars, the bars need to be a certain height."
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
        if UI.Checkbox("Job", {Metrics.XP.XP_Job}) then
            Metrics.XP.XP_Job = not Metrics.XP.XP_Job
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Base XP Rate", {Metrics.XP.Base_Rate}) then
            Metrics.XP.Base_Rate = not Metrics.XP.Base_Rate
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Boosted and base XP are tracked separately. The default XP/hr columns includes boosted XP. This column"
                               .. " always shows the base XP--as if you did not have the XP boost buff--so you can always know how your"
                               .. " group is doing.")
        UI.TableNextColumn()
        if UI.Checkbox("Kill Speed", {Metrics.XP.Kill_Speed}) then
            Metrics.XP.Kill_Speed = not Metrics.XP.Kill_Speed
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Seconds per kill for mobs that grant XP.")
        UI.TableNextColumn()
        if UI.Checkbox("Average XP", {Metrics.XP.Average_XP}) then
            Metrics.XP.Average_XP = not Metrics.XP.Average_XP
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Time to Level", {Metrics.XP.Time_To_Level}) then
            Metrics.XP.Time_To_Level = not Metrics.XP.Time_To_Level
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("An estimation on how long it will be until you level.")
        UI.TableNextColumn()
        if UI.Checkbox("TNL/TNM", {Metrics.XP.To_Next_Level}) then
            Metrics.XP.To_Next_Level = not Metrics.XP.To_Next_Level
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Total XP", {Metrics.XP.Total_XP}) then
            Metrics.XP.Total_XP = not Metrics.XP.Total_XP
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("How much XP you've gained this session.")
        UI.TableNextColumn()
        if UI.Checkbox("Max Chain", {Metrics.XP.Max_Chain}) then
            Metrics.XP.Max_Chain = not Metrics.XP.Max_Chain
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Time in Zone", {Metrics.XP.Zone_Time}) then
            Metrics.XP.Zone_Time = not Metrics.XP.Zone_Time
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Boost Item", {Metrics.XP.XP_Boost_Item}) then
            Metrics.XP.XP_Boost_Item = not Metrics.XP.XP_Boost_Item
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Shows which boost item you used (if known). If you already had the dedication buff before loading"
                                .." then Metrics will not know which item was used or what the rate is.")
        UI.TableNextColumn()
        if UI.Checkbox("Boost Rate", {Metrics.XP.XP_Boost_Rate}) then
            Metrics.XP.XP_Boost_Rate = not Metrics.XP.XP_Boost_Rate
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("The XP boost rate that is currently active (if known).")
        UI.TableNextColumn()
        if UI.Checkbox("Boost Max", {Metrics.XP.XP_Boost_Max}) then
            Metrics.XP.XP_Boost_Max = not Metrics.XP.XP_Boost_Max
            XP.Columns.Count()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("The maximum XP boost you can get from your current dedication buff (if known).")
        UI.TableNextColumn()
        UI.TableNextColumn()

        UI.EndTable()
    end

    if Metrics.XP.Total_XP then
        UI.Separator()
        local dropdown_flags = DB.Widgets.Dropdown.Flags
        local list = XP.Config.Total_Mode_List
        if list[1] then
            UI.SetNextItemWidth(XP.Config.Dropdown_Width)
            if UI.BeginCombo("Total XP Mode", list[XP.Config.Total_Mode_Index], dropdown_flags) then
                for n = 1, #list, 1 do
                    local is_selected = XP.Config.Total_Mode_Index == n
                    if UI.Selectable(list[n], is_selected) then
                        XP.Config.Total_Mode_Index = n
                        XP.Config.Total_Mode = list[n]
                        Window_Manager.Set_Bar_Delay()
                    end
                    if is_selected then
                        UI.SetItemDefaultFocus()
                    end
                end
                UI.EndCombo()
            end
            UI.SameLine()
            Window_Manager.Widgets.HelpMarker("Choose whether you want to base and boosted XP combined in the Total XP column or if you"
                                    .." want them separated out.")
        end
    end

end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the exp window.
------------------------------------------------------------------------------------------------------
XP.Config.Settings_Button = function()
    if UI.SmallButton("Settings") then
        Config.Button_Toggle(Config.Enum.File.EXP)
    end
end