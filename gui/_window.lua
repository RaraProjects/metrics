local w = T{}

w.Window = {
    Name = "Metrics (Beta)",
    Visible = true,
    Nano = false,
    Mini = false,
    Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav,
    ImGuiWindowFlags_NoTitleBar
    ),
    -- Throttle_Count = 0, -- I tried throttling the window, but I couldn't stop it from flickering.
    -- Throttle_Level = 5, -- Probably need to stop data collection instead of preventing rendering.
}

w.Defaults = T{
    Alpha = 0.85,
    Font_Scaling = 1.0,
    Window_Scaling = 1.0,
    Style = 0,
    X_Pos = 100,
    Y_Pos = 100,
}

w.Util = {}
w.Widget = {}

-- Tables ////////////////////////
w.Table = {}
w.Table.Flags = {
    None = bit.bor(ImGuiTableFlags_None),
    Resizable = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Borders = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Fixed_Borders = bit.bor(ImGuiTableFlags_SizingFixedFit, ImGuiTableFlags_Resizable, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_NoHostExtendX),
    Team = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Scrollable = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_ScrollY)
}

-- Columns ///////////////////////
w.Columns = {}
w.Columns.Flags = {
    None = bit.bor(ImGuiTableColumnFlags_None),
    Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch)
}
w.Columns.Widths = {
    Name = 150,
    Damage = 80,
    Percent = 60,
    Single = 40,
    Standard = 100,
    Settings = 175,
    Report = 100,
}

-- Trees /////////////////////////
w.Trees = {}
w.Trees.Flags = {
    SpanFullWidth = bit.bor(ImGuiTreeNodeFlags_SpanAvailWidth)
}

-- Tabs //////////////////////////
w.Tabs = {}
w.Tabs.Names = {
    PARENT    = "Tabs",
    TEAM      = "Team",
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
w.Tabs.Flags = ImGuiTabBarFlags_None
w.Tabs.Switch = {
    [w.Tabs.Names.TEAM]      = nil,
    [w.Tabs.Names.FOCUS]     = nil,
    [w.Tabs.Names.BATTLELOG] = nil,
    [w.Tabs.Names.REPORT]    = nil,
}
w.Tabs.Active = nil

-- Dropdowns /////////////////////
w.Dropdown = {}
w.Dropdown.Enum = {
    MOB   = "Mob Filter",
    FOCUS = "Player",
    NONE  = "!NONE",
}
w.Dropdown.Flags = ImGuiComboFlags_None
w.Dropdown.Player = {}
w.Dropdown.Player.Focus = w.Dropdown.Enum.NONE
w.Dropdown.Player.Index = 1
w.Dropdown.Mob = {}
w.Dropdown.Mob.Focus = w.Dropdown.Enum.NONE
w.Dropdown.Mob.Index = 1
w.Dropdown.Width = 150

-- Colors ////////////////////////
w.Colors = {
    -- Base Colors
    WHITE    = {1.0, 1.0, 1.0, 1.0},
    RED      = {1.0, 0.0, 0.0, 1.0},
    GREEN    = {0.0, 1.0, 0.0, 1.0},
    BLUE     = {0.0, 0.0, 1.0, 1.0},
    ORANGE   = {0.9, 0.6, 0.0, 1.0},
    YELLOW   = {0.9, 1.0, 0.0, 1.0},
    BR_GREEN = {0.2, 1.0, 0.0, 1.0},
    PURPLE   = {0.7, 0.2, 1.0, 1.0},
    DIM      = {0.4, 0.4, 0.4, 1.0},
    -- Elements
    LIGHT    = {1.0, 1.0, 1.0, 1.0},
    DARK     = {0.9, 0.0, 1.0, 1.0},
    FIRE     = {1.0, 0.0, 0.0, 1.0},
    ICE      = {0.0, 0.7, 1.0, 1.0},
    WIND     = {0.0, 1.0, 0.0, 1.0},
    EARTH    = {0.7, 0.5, 0.0, 1.0},
    THUNDER  = {0.7, 0.2, 1.0, 1.0},
    WATER    = {0.3, 0.5, 0.8, 1.0},
}
w.Colors.Elements = {
    [0] = w.Colors.FIRE,
    [1] = w.Colors.ICE,
    [2] = w.Colors.WIND,
    [3] = w.Colors.EARTH,
    [4] = w.Colors.THUNDER,
    [5] = w.Colors.WATER,
    [6] = w.Colors.LIGHT,
    [7] = w.Colors.DARK,
}
w.Colors.Avatars = {
    Carbuncle = w.Colors.LIGHT,
    Fenrir    = w.Colors.DARK,
    Diabolos  = w.Colors.DARK,
    Ifrit     = w.Colors.FIRE,
    Shiva     = w.Colors.ICE,
    Garuda    = w.Colors.WIND,
    Titan     = w.Colors.EARTH,
    Ramuh     = w.Colors.THUNDER,
    Leviathan = w.Colors.WATER,
}

------------------------------------------------------------------------------------------------------
-- Found the font scaling code here:
-- https://skia.googlesource.com/external/github.com/ocornut/imgui/+/v1.51/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
w.Initialize = function()
    -- Adjust font size.
    local atlas = UI.GetIO().Fonts
    local font = atlas.Fonts[1]
    font.Scale = Metrics.Window.Font_Scaling

    -- Window Scaling
    UI.SetWindowFontScale(Metrics.Window.Window_Scaling)

    -- Set color theme.
    w.Util.Set_Theme()

    -- Style
    UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
    UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
    UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
    UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
    UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

    -- Position
    UI.SetNextWindowPos({Metrics.Window.X_Pos, Metrics.Window.Y_Pos}, ImGuiCond_Always)

    -- Reset dropdown selections.
    w.Dropdown.Player.Focus = w.Dropdown.Enum.NONE
    w.Dropdown.Player.Index = 1
    w.Dropdown.Mob.Focus = w.Dropdown.Enum.NONE
    w.Dropdown.Mob.Index = 1

    w.Populate()
end

------------------------------------------------------------------------------------------------------
-- Resets visual settings in the window.
------------------------------------------------------------------------------------------------------
w.Reset_Settings = function()
    Metrics.Window.Alpha = w.Defaults.Alpha
    Metrics.Window.Font_Scaling = w.Defaults.Font_Scaling
    Metrics.Window.Window_Scaling = w.Defaults.Window_Scaling
    w.Initialize()
end

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
w.Populate = function()
    if not Ashita.States.Zoning and w.Window.Visible then
        if UI.Begin(w.Window.Name, {w.Window.Visible}, w.Window.Flags) then
            w.Window.Visible = -1
            Metrics.Window.X_Pos, Metrics.Window.Y_Pos = UI.GetWindowPos()
            if w.Window.Nano then Team.Nano_Mode()
            elseif w.Window.Mini then Team.Mini_Mode()
            else
                if _Debug.Is_Enabled() then UI.Text("Error Count: " .. tostring(_Debug.Error.Util.Error_Count())) end
                if UI.BeginTabBar(w.Tabs.Names.PARENT, w.Tabs.Flags) then
                    if UI.BeginTabItem(w.Tabs.Names.TEAM, false, w.Tabs.Switch[w.Tabs.Names.TEAM]) then
                        w.Tabs.Switch[w.Tabs.Names.TEAM] = nil
                        w.Tabs.Active = w.Tabs.Names.TEAM
                        Team.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(w.Tabs.Names.FOCUS, false, w.Tabs.Switch[w.Tabs.Names.FOCUS]) then
                        w.Tabs.Switch[w.Tabs.Names.FOCUS] = nil
                        w.Tabs.Active = w.Tabs.Names.FOCUS
                        Focus.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(w.Tabs.Names.BATTLELOG, false, w.Tabs.Switch[w.Tabs.Names.BATTLELOG]) then
                        w.Tabs.Switch[w.Tabs.Names.BATTLELOG] = nil
                        w.Tabs.Active = w.Tabs.Names.BATTLELOG
                        Blog.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(w.Tabs.Names.REPORT, false, w.Tabs.Switch[w.Tabs.Names.REPORT]) then
                        w.Tabs.Switch[w.Tabs.Names.REPORT] = nil
                        w.Tabs.Active = w.Tabs.Names.REPORT
                        Report.Populate()
                        UI.EndTabItem()
                    end
                    if UI.BeginTabItem(w.Tabs.Names.SETTINGS, false, w.Tabs.Switch[w.Tabs.Names.SETTINGS]) then
                        w.Tabs.Switch[w.Tabs.Names.SETTINGS] = nil
                        w.Tabs.Active = w.Tabs.Names.SETTINGS
                        Config.Populate()
                        UI.EndTabItem()
                    end
                    if _Debug.Is_Enabled() then
                        if UI.BeginTabItem(w.Tabs.Names.DEBUG) then
                            _Debug.Populate()
                            UI.EndTabItem()
                        end
                    end
                    UI.EndTabBar()
                end
                UI.End()
            end
        end

        if _Debug.Is_Enabled() and _Debug.Unit.Active then
            if UI.Begin("Unit Tests", {w.Window.Visible}, w.Window.Flags) then
                w.Window.Visible = -1
                _Debug.Unit.Populate()
                UI.End()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Change the window themes.
-- Modeled from the ImGui demo.
-- https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
w.Util.Set_Theme = function()
    UI.Text("Theme")
    if UI.RadioButton("Default ", {Metrics.Window.Style}, 0) then
        Metrics.Window.Style = 0
        w.Util.Apply_Custom_Theme(Themes.Default)
    end
    UI.SameLine()
    if UI.RadioButton("Dark ", {Metrics.Window.Style}, 1) then
        Metrics.Window.Style = 1
        UI.StyleColorsDark()
    end
    UI.SameLine()
    if UI.RadioButton("Light ", {Metrics.Window.Style}, 2) then
        Metrics.Window.Style = 2
        UI.StyleColorsLight()
    end
    UI.SameLine()
    if UI.RadioButton("Classic ", {Metrics.Window.Style}, 3) then
        Metrics.Window.Style = 3
        UI.StyleColorsClassic()
    end
end

------------------------------------------------------------------------------------------------------
-- Applies a custom theme.
------------------------------------------------------------------------------------------------------
---@param theme table defined in resources.themes.
------------------------------------------------------------------------------------------------------
w.Util.Apply_Custom_Theme = function(theme)
    for flag_name, flag_value in pairs(Themes.Elements) do
        if theme[flag_name] then
            UI.PushStyleColor(flag_value, theme[flag_name])
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the screen transparency.
------------------------------------------------------------------------------------------------------
w.Util.Set_Alpha = function()
    UI.PushStyleVar(ImGuiStyleVar_Alpha, Metrics.Window.Alpha)
end

------------------------------------------------------------------------------------------------------
-- Sets the screen font size.
------------------------------------------------------------------------------------------------------
w.Util.Set_Font_Size = function()
    local atlas = UI.GetIO().Fonts
    local font = atlas.Fonts[1]
    font.Scale = Metrics.Window.Font_Scaling
end

------------------------------------------------------------------------------------------------------
-- Sets the window scaling.
------------------------------------------------------------------------------------------------------
w.Util.Set_Window_Scale = function()
    UI.SetWindowFontScale(Metrics.Window.Window_Scaling)
end

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the currently focused entity.
------------------------------------------------------------------------------------------------------
w.Util.Get_Player_Focus = function()
    return w.Dropdown.Player.Focus
end

------------------------------------------------------------------------------------------------------
-- Utility function for accessing the name of the currently focused mob.
------------------------------------------------------------------------------------------------------
w.Util.Get_Mob_Focus = function()
    return w.Dropdown.Mob.Focus
end

------------------------------------------------------------------------------------------------------
-- Toggles window visibility.
------------------------------------------------------------------------------------------------------
w.Util.Toggle_Visibility = function()
    w.Window.Visible = not w.Window.Visible
end

------------------------------------------------------------------------------------------------------
-- Toggles mini mode.
------------------------------------------------------------------------------------------------------
w.Util.Toggle_Mini = function()
    w.Window.Mini = not w.Window.Mini
    if w.Window.Mini then w.Window.Nano = false end
end

------------------------------------------------------------------------------------------------------
-- Toggles nano mode.
------------------------------------------------------------------------------------------------------
w.Util.Toggle_Nano = function()
    w.Window.Nano = not w.Window.Nano
    if w.Window.Nano then w.Window.Mini = false end
end

------------------------------------------------------------------------------------------------------
-- Toggles full mode.
------------------------------------------------------------------------------------------------------
w.Util.Enable_Full = function()
    w.Window.Mini = false
    w.Window.Nano = false
end

------------------------------------------------------------------------------------------------------
-- Creates a help text marker.
------------------------------------------------------------------------------------------------------
w.Widget.HelpMarker = function(text)
    UI.TextDisabled("(?)")
    if UI.IsItemHovered() then
        UI.BeginTooltip()
        UI.PushTextWrapPos(UI.GetFontSize() * 25)
        UI.TextUnformatted(text)
        UI.PopTextWrapPos()
        UI.EndTooltip()
    end
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done to a certain mob.
------------------------------------------------------------------------------------------------------
w.Widget.Mob_Filter = function()
    local list = DB.Lists.Get.Mob()
    local flags = w.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(w.Dropdown.Width)
        if UI.BeginCombo(w.Dropdown.Enum.MOB, list[w.Dropdown.Mob.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = w.Dropdown.Mob.Index == n
                if UI.Selectable(list[n], is_selected) then
                    w.Dropdown.Mob.Index = n
                    w.Dropdown.Mob.Focus = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(w.Dropdown.Enum.MOB, w.Dropdown.Enum.NONE, flags) then
            UI.EndCombo()
        end
    end
    w.Widget.Mob_Filter_Help_Text()
end

------------------------------------------------------------------------------------------------------
-- Shows the help text for the mob filter.
------------------------------------------------------------------------------------------------------
w.Widget.Mob_Filter_Help_Text = function()
    UI.SameLine() Window.Widget.HelpMarker("You can filter to show only data for actions taken against mobs with a specific name.\n"
                                        .. "Notes:\n"
                                        .. "1. The filter may not be for individual mobs. It is for mobs with that name collectively.\n"
                                        .. "2. If the mob has a unique name (like an NM) then the data will be mob specific.\n"
                                        .. "3. The filter only affects actions taken against mobs with that name.\n"
                                        .. "4. The filter does not work for healing because those actions are taken on other players.\n"
                                        .. "5. The filter does not work for abilities that are used on yourself or other players.\n")
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
w.Widget.Player_Filter = function()
    local list = DB.Lists.Get.Players()
    local flags = w.Dropdown.Flags
    if list[1] then
        UI.SetNextItemWidth(w.Dropdown.Width)
        if UI.BeginCombo(w.Dropdown.Enum.FOCUS, list[w.Dropdown.Player.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = w.Dropdown.Player.Index == n
                if UI.Selectable(list[n], is_selected) then
                    w.Dropdown.Player.Index = n
                    w.Dropdown.Player.Focus = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(w.Dropdown.Enum.FOCUS, w.Dropdown.Enum.NONE, flags) then
            UI.EndCombo()
        end
    end
    w.Widget.Player_Filter_Help_Text()
end

------------------------------------------------------------------------------------------------------
-- Shows the help text for the player filter.
------------------------------------------------------------------------------------------------------
w.Widget.Player_Filter_Help_Text = function()
    UI.SameLine() Window.Widget.HelpMarker("Pick a player that you would like to see more detailed stats for.\n")
end

------------------------------------------------------------------------------------------------------
-- Switches to a player in the player filter based on partial matching.
------------------------------------------------------------------------------------------------------
w.Util.Player_Switch = function(player_string)
    local list = DB.Lists.Get.Players()
    local found = false
    for n, player_name in pairs(list) do
        if not found then
            if string.find(string.lower(player_name), player_string) then
                w.Dropdown.Player.Index = n
                w.Dropdown.Player.Focus = list[n]
                found = true
            end
        end
    end
end

return w