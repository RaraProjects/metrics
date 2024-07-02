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
    Show_Mouse = false,
    Multi_Window = false,
    Active_Window = "Parse",
    Hub_X = 100,
    Hub_Y = 100,
    Parse_Window_Visible = {true},
    Parse_X = 100,
    Parse_Y = 100,
    Focus_Window_Visible = {false},
    Focus_X = 100,
    Focus_Y = 100,
    Blog_Window_Visible = {false},
    Blog_X = 100,
    Blog_Y = 100,
    Report_Window_Visible = {false},
    Report_X = 100,
    Report_Y = 100,
    Config_Window_Visible = {false},
    Config_X = 100,
    Config_Y = 100,
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
    [Window.Tabs.Names.PARSE]     = nil,
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
Window.Set_Mouse = true

Window.IO = UI.GetIO()
Window.IO.MouseDrawCursor = false

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
            UI.SetNextWindowPos({Metrics.Window.Parse_X, Metrics.Window.Parse_Y}, ImGuiCond_Always)
            Window.Reset_Position = false
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
            if UI.Begin("Metrics - Commands", Config.Show_Window, Window.Flags) then
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
-- Returns the window scaling.
------------------------------------------------------------------------------------------------------
Window.Get_Scaling = function()
    return Metrics.Window.Window_Scaling
end

------------------------------------------------------------------------------------------------------
-- Toggles window visibility.
------------------------------------------------------------------------------------------------------
Window.Toggle_Visibility = function()
    Window.Visible[1] = not Window.Visible[1]
end