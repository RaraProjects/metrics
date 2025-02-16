XP.Config = { }

XP.Config.Defaults = T{
    X                        = 100,
    Y                        = 100,
    Visible                  = { false },

    -- GUI
    Show_Background          = false,
    Mini_Mode_Enabled        = false,
    Small_Progress_Bars      = true,
    Show_Level_Max           = false,   -- Makes the TNL column be Current/Max.

    -- Progress Bars
    Show_XP_Progress_Bar     = true,
    Show_Boost_Progress_Bar  = true,

    -- Columns Flags
    Show_Job                 = true,
    Show_Base_Rate           = true,
    Show_Time_To_Level       = true,
    Show_Boost_Time_To_Level = true,
    Show_TNL                 = true,
    Show_Capacity_Base_Rate  = false,
    Show_Time_To_Job_Point   = false,
    Show_TNJP                = false,
    Show_Exemplar_Base_Rate  = false,
    Show_Time_To_Mastery     = false,
    Show_TNML                = false,
    Show_Kill_Rate           = false,
    Show_Average_XP          = false,
    Show_Total_XP_Gained     = false,
    Show_Max_Chain           = false,
    Show_Zone_Time           = true,
    Show_Boost_Item          = false,
    Show_Boost_Rate          = false,   -- These are based on the item used.
    Show_Boost_Max           = false,   -- These are based on the item used.

    -- Dedication
    Boost_Defaulting_Enabled = false,
    Boost_Item_Default_Name  = "Anniversary Ring",
    Boost_Item_Default_Index = 1,
    Boost_Item_Name          = "None",
    Boost_Item_Rate          = 0,
    Boost_Item_Max           = 0,
    Boost_XP_Acquired        = 0,       -- This is the amount of boost XP aquired. Need to save between sessions.
}

XP.Config.Total_Mode_List =
{
    "Combined",
    "Split",
}
XP.Config.Total_Mode_Index = 2
XP.Config.Total_Mode = XP.Config.Total_Mode_List[XP.Config.Total_Mode_Index]

XP.Config.Dropdown_Width = 250

------------------------------------------------------------------------------------------------------
-- Populates the exp configuration window.
------------------------------------------------------------------------------------------------------
XP.Config.Populate = function()
    local colFlags = Parse.Config.Column_Flags
    local width    = Parse.Config.Column_Width

    -- General Settings
    UI.Text("General")
    if UI.BeginTable("XP General", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Show Background", {XP.Settings.Show_Background}) then
            XP.Settings.Show_Background = not XP.Settings.Show_Background
            XP.Window.Set_Background(XP.Settings.Show_Background)
        end

        UI.TableNextColumn()
        Window_Manager.Widgets.Toggle_Checkbox("Show XP Max", XP.Settings, "Show_Level_Max")
        Window_Manager.Widgets.HelpMarker
        (
            "Makes the TNL column Current/Max."
        )

        UI.TableNextColumn()
        if UI.Checkbox("Boost Defaults", {XP.Settings.Boost_Defaulting_Enabled}) then
            XP.Settings.Boost_Defaulting_Enabled = not XP.Settings.Boost_Defaulting_Enabled
            XP.Dedication.Refresh()
            Window_Manager.SetBarDelay()
        end
        Window_Manager.Widgets.HelpMarker
        (
            "If Metrics is loaded when you already have the dedication buff it doesn't know which item you used." ..
            " you can use this setting as a backup. This allows Metrics to know the boost rate and boost max." ..
            " This only comes into play if the boost item is unknown."
        )

        UI.EndTable()
    end

    -- Boost Default Item Dropdown
    if XP.Settings.Boost_Defaulting_Enabled then
        local dropFlags = DB.Widgets.DropdownFlags
        local list      = Res.Items.Dedication_Selection

        UI.SetNextItemWidth(XP.Config.Dropdown_Width)

        if UI.BeginCombo("Boost Item", list[XP.Settings.Boost_Item_Default_Index], dropFlags) then
            for index, mode in ipairs(list) do
                local isSelected = XP.Settings.Boost_Item_Default_Index == index

                if UI.Selectable(mode, isSelected) then
                    XP.Settings.Boost_Item_Default_Index = index
                    XP.Settings.Boost_Item_Default_Name  = mode
                    XP.Dedication.Refresh()
                    Window_Manager.SetBarDelay()
                end

                if isSelected then
                    UI.SetItemDefaultFocus()
                end
            end

            UI.EndCombo()
        end
    end

    UI.Separator()

    -- Progress Bars
    UI.Text("Progress Bars")
    if UI.BeginTable("XP Progress", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("XP Progress",    XP.Settings, "Show_XP_Progress_Bar")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Boost Progress", XP.Settings, "Show_Boost_Progress_Bar")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Small Bars",     XP.Settings, "Small_Progress_Bars")
        Window_Manager.Widgets.HelpMarker
        (
            "In order to see the percentage of progress bars, the bars need to be a certain height." ..
            " If you don't need to see the percentage and want more compact progress bars then turn this on."
        )

        UI.EndTable()
    end

    UI.Separator()

    -- General Columns
    UI.Text("General Columns")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Job",           XP.Settings, "Show_Job")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Kill Speed",    XP.Settings, "Show_Kill_Rate")
        Window_Manager.Widgets.HelpMarker
        (
            "Seconds per kill for mobs that grant XP."
        )
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Average XP",    XP.Settings, "Show_Average_XP")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Time in Zone",  XP.Settings, "Show_Zone_Time")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Max Chain",     XP.Settings, "Show_Max_Chain")
        XP.Columns.Count()

        UI.EndTable()
    end

    UI.Separator()

    -- Boost Columns
    UI.Text("EXP Boost")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Time to Boost", XP.Settings, "Show_Boost_Time_To_Level")
        Window_Manager.Widgets.HelpMarker
        (
            "An estimation on how long it will be until your boost effect wears off."
        )
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Boost Item",    XP.Settings, "Show_Boost_Item")
        Window_Manager.Widgets.HelpMarker
        (
            "Shows which boost item you used (if known). If you already had the dedication buff before loading" ..
            " then Metrics will not know which item was used or what the rate is."
        )
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Boost Rate",    XP.Settings, "Show_Boost_Rate")
        Window_Manager.Widgets.HelpMarker
        (
            "The XP boost rate that is currently active (if known)."
        )
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Boost Max",     XP.Settings, "Show_Boost_Max")
        Window_Manager.Widgets.HelpMarker
        (
            "The maximum XP boost you can get from your current dedication buff (if known)."
        )
        XP.Columns.Count()

        UI.EndTable()
    end

    UI.Separator()

    -- XP Columns
    UI.Text("EXP and Merits")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Time to Level", XP.Settings, "Show_Time_To_Level")
        Window_Manager.Widgets.HelpMarker
        (
            "An estimation on how long it will be until you level."
        )
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Base XP Rate",  XP.Settings, "Show_Base_Rate")
        Window_Manager.Widgets.HelpMarker
        (
            "Boosted and base XP are tracked separately. The default XP/hr columns includes boosted XP. This column" ..
            " always shows the base XP--as if you did not have the XP boost buff--so you can always know how your" ..
            " group is doing."
        )
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TNL",           XP.Settings, "Show_TNL")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Total XP",      XP.Settings, "Show_Total_XP_Gained")
        Window_Manager.Widgets.HelpMarker
        (
            "How much XP you've gained this session."
        )
        XP.Columns.Count()

        UI.EndTable()
    end

    if XP.Settings.Show_Total_XP_Gained then
        local dropFlags = DB.Widgets.DropdownFlags
        local list      = XP.Config.Total_Mode_List

        UI.SetNextItemWidth(XP.Config.Dropdown_Width)

        if UI.BeginCombo("Total XP Mode", list[XP.Config.Total_Mode_Index], dropFlags) then
            for index, mode in ipairs(list) do
                local isSelected = XP.Config.Total_Mode_Index == index

                if UI.Selectable(mode, isSelected) then
                    XP.Config.Total_Mode_Index = index
                    XP.Config.Total_Mode       = mode
                    Window_Manager.SetBarDelay()
                end

                if isSelected then
                    UI.SetItemDefaultFocus()
                end
            end

            UI.EndCombo()
        end
        Window_Manager.Widgets.HelpMarker
        (
            "Choose whether you want to base and boosted XP combined in the Total XP column or if you" ..
            " want them separated out."
        )
    end

    UI.Separator()

    -- Capacity Columns
    UI.Text("Capacity Points")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Base CP Rate",  XP.Settings, "Show_Capacity_Base_Rate")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Time to JP",    XP.Settings, "Show_Time_To_Job_Point")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TNJP",          XP.Settings, "Show_TNJP")
        XP.Columns.Count()

        UI.EndTable()
    end

    UI.Separator()

    -- Exemplar Columns
    UI.Text("Exemplar Points")
    if UI.BeginTable("XP Columns", 3) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Base EP Rate",  XP.Settings, "Show_Exemplar_Base_Rate")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Time to ML",    XP.Settings, "Show_Time_To_Mastery")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TNML",          XP.Settings, "Show_TNML")
        XP.Columns.Count()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles the settings showing for the exp window.
------------------------------------------------------------------------------------------------------
XP.Config.SettingsButton = function()
    if UI.SmallButton("Settings") then
        Config.ButtonToggle(Config.ModuleFile.EXP)
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles mini mode.
------------------------------------------------------------------------------------------------------
XP.Config.Toggle_Mini_Mode = function()
    XP.Settings.Mini_Mode_Enabled = not XP.Settings.Mini_Mode_Enabled
end