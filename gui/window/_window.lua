Window = T{}

Window.Name = "Metrics (Beta)"
Window.Visible = {true}
Window.Scaling_Set = false

Window.Defaults = T{
    Alpha = 1.0,
    Window_Scaling = 1.0,
    Style = 0,
    X_Pos = 100,
    Y_Pos = 100,
    Show_Title = false,
}

Window.Flags = bit.bor(
        ImGuiWindowFlags_AlwaysAutoResize,  -- This prevents manual resizing, but without it things look messed up.
        ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoFocusOnAppearing,
        ImGuiWindowFlags_NoNav)

Window.Screenshot_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoNav)

Window.Tabs = {}
Window.Tabs.Flags = ImGuiTabBarFlags_None
Window.Tabs.Names = {
    PARENT    = "Tabs",
    PARSE     = "Parse",
    FOCUS     = "Focus",
    BATTLELOG = "Battle Log",
    REPORT    = "Report",
    SETTINGS  = "Settings",
    DEBUG     = "Debug",
    MOBVIEW   = "Mob Viewer",
    ACTIONS   = "Action Packet",
    MESSAGES  = "Message Packet",
    ITEMS     = "Item Packet",
    ERRORS    = "Error Log",
    DATAVIEW  = "Data Viewer",
}
Window.Tabs.Switch = {
    [Window.Tabs.Names.PARSE]      = nil,
    [Window.Tabs.Names.FOCUS]     = nil,
    [Window.Tabs.Names.BATTLELOG] = nil,
    [Window.Tabs.Names.REPORT]    = nil,
}
Window.Tabs.Active = nil

Window.Table = {}
Window.Table.Flags = {
    None = bit.bor(ImGuiTableFlags_None),
    Resizable = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Borders = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Fixed_Borders = bit.bor(ImGuiTableFlags_SizingFixedFit, ImGuiTableFlags_Resizable, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_NoHostExtendX),
    Team = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Scrollable = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_ScrollY),
}

Window.Reset_Position = true

require("gui.window.themes")
require("gui.window.widgets")
require("gui.window.config")

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
Window.Populate = function()
    if not Ashita.States.Zoning and Window.Visible[1] then

        UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
        UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
        UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
        UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
        UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

        local window_flags = Window.Flags
        if not Metrics.Window.Show_Title then window_flags = bit.bor(window_flags, ImGuiWindowFlags_NoTitleBar) end

        -- Handle resetting the window position between characters.
        if Window.Reset_Position then
            UI.SetNextWindowPos({Metrics.Window.X_Pos, Metrics.Window.Y_Pos}, ImGuiCond_Always)
            Window.Reset_Position = false
        end

        if UI.Begin(Window.Name, Window.Visible, window_flags) then
            Metrics.Window.X_Pos, Metrics.Window.Y_Pos = UI.GetWindowPos()
            Window.Set_Window_Scale()
            Window.Theme.Set()

            if Parse.Nano.Is_Enabled() then
                Parse.Nano.Populate()
            elseif Parse.Mini.Is_Enabled() then
                Parse.Mini.Populate()
            else
                if _Debug.Is_Enabled() then UI.Text("Error Count: " .. tostring(_Debug.Error.Util.Error_Count())) end
                if UI.BeginTabBar(Window.Tabs.Names.PARENT, Window.Tabs.Flags) then
                    if UI.BeginTabItem(Parse.Tab_Name, false, Window.Tabs.Switch[Window.Tabs.Names.PARSE]) then
                        Window.Tabs.Switch[Window.Tabs.Names.PARSE] = nil
                        Window.Tabs.Active = Window.Tabs.Names.PARSE
                        Parse.Full.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(Focus.Tab_Name, false, Window.Tabs.Switch[Window.Tabs.Names.FOCUS]) then
                        Window.Tabs.Switch[Window.Tabs.Names.FOCUS] = nil
                        Window.Tabs.Active = Window.Tabs.Names.FOCUS
                        Focus.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(Window.Tabs.Names.BATTLELOG, false, Window.Tabs.Switch[Window.Tabs.Names.BATTLELOG]) then
                        Window.Tabs.Switch[Window.Tabs.Names.BATTLELOG] = nil
                        Window.Tabs.Active = Window.Tabs.Names.BATTLELOG
                        Blog.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(Window.Tabs.Names.REPORT, false, Window.Tabs.Switch[Window.Tabs.Names.REPORT]) then
                        Window.Tabs.Switch[Window.Tabs.Names.REPORT] = nil
                        Window.Tabs.Active = Window.Tabs.Names.REPORT
                        Report.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(Window.Tabs.Names.SETTINGS, false, Window.Tabs.Switch[Window.Tabs.Names.SETTINGS]) then
                        Window.Tabs.Switch[Window.Tabs.Names.SETTINGS] = nil
                        Window.Tabs.Active = Window.Tabs.Names.SETTINGS
                        Config.Populate()
                        UI.EndTabItem()
                    end
                    if _Debug.Is_Enabled() then
                        if UI.BeginTabItem(Window.Tabs.Names.DEBUG) then
                            _Debug.Populate()
                            UI.EndTabItem()
                        end
                    end
                    UI.EndTabBar()
                end
                UI.End()
            end
        end

        local player = Ashita.Player.My_Mob()
        if player and Parse.Config.Show_DPS_Graph() then
            if UI.Begin("DPS Graph", Window.Visible, Parse.Config.DPS_Graph_Window_Flags) then
                UI.Text("Click this to Drag")
                Parse.Widgets.DPS_Graph(player.name)
                UI.End()
            end
        end

        if Config.Show_Window[1] then
            if UI.Begin("Help", Config.Show_Window, Window.Flags) then
                Config.Section.Text_Commands()
                UI.End()
            end
        end

        if Focus.Screenshot_Mode[1] then
            UI.PushStyleVar(ImGuiStyleVar_Alpha, 1)
            if UI.Begin("Screenshot Mode", Focus.Screenshot_Mode, Window.Screenshot_Flags) then
                Focus.Screenshot()
                UI.End()
            end
            UI.PopStyleVar(1)
        end

        if _Debug.Is_Enabled() and _Debug.Config.Show_Unit_Tests[1] then
            if UI.Begin("Unit Tests", _Debug.Config.Show_Unit_Tests, Window.Flags) then
                _Debug.Unit.Populate()
                UI.End()
            end
        end

        UI.PopStyleVar(5)
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
Window.Set_Window_Scale = function()
    if not Window.Scaling_Set then
        UI.SetWindowFontScale(Metrics.Window.Window_Scaling)
        Window.Scaling_Set = true
        Metrics.Blog.Line_Height = UI.GetFontSize() + 2
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles window visibility.
------------------------------------------------------------------------------------------------------
Window.Toggle_Visibility = function()
    Window.Visible[1] = not Window.Visible[1]
end