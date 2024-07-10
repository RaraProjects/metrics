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

        UI.EndTable()
    end

    UI.Separator()
    UI.Text("Columns")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Base Rate", {Metrics.Parse.Base_Rate}) then
            Metrics.Parse.Base_Rate = not Metrics.Parse.Base_Rate
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Time to Level", {Metrics.Parse.Time_To_Level}) then
            Metrics.Parse.Time_To_Level = not Metrics.Parse.Time_To_Level
            XP.Columns.Count()
        end
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
        UI.TableNextColumn()
        if UI.Checkbox("Boost Item", {Metrics.Parse.XP_Boost_Item}) then
            Metrics.Parse.XP_Boost_Item = not Metrics.Parse.XP_Boost_Item
            XP.Columns.Count()
        end
        UI.TableNextColumn()
        if UI.Checkbox("Boost Rate", {Metrics.Parse.XP_Boost_Rate}) then
            Metrics.Parse.XP_Boost_Rate = not Metrics.Parse.XP_Boost_Rate
            XP.Columns.Count()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Boost Max", {Metrics.Parse.XP_Boost_Max}) then
            Metrics.Parse.XP_Boost_Max = not Metrics.Parse.XP_Boost_Max
            XP.Columns.Count()
        end
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
                    end
                    if is_selected then
                        UI.SetItemDefaultFocus()
                    end
                end
                UI.EndCombo()
            end
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