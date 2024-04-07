local w = {}

w.Window = {
    Name = "Metrics",
    Alpha = 0.85,
    Font_Scaling = 0.85,
    Style = 1,
    Visible = true,
    Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav
    ),
    -- Throttle_Count = 0, -- I tried throttling the window, but I couldn't stop it from flickering.
    -- Throttle_Level = 5, -- Probably need to stop data collection instead of preventing rendering.
}

w.Defaults = {}
w.Defaults.Window = {
    Alpha = 0.85,
    Font_Scaling = 0.85,
    Style = 0,
}

w.Util = {}
w.Widget = {}

-- Tables ////////////////////////
w.Table = {}
w.Table.Flags = {
    None = bit.bor(ImGuiTableFlags_None),
    Resizable = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Borders = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    Team = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders, ImGuiTableFlags_Reorderable)
}

-- Columns ///////////////////////
w.Columns = {}
w.Columns.Flags = {
    None = bit.bor(ImGuiTableColumnFlags_None),
    Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch)
}
w.Columns.Widths = {
    Name = 200,
    Damage = 80,
    Percent = 60,
    Single = 40,
    Standard = 100,
    Settings = 175,
}

-- Tabs //////////////////////////
w.Tabs = {}
w.Tabs.Names = {
    PARENT    = "Tabs",
    TEAM      = "Team",
    FOCUS     = "Focus",
    BATTLELOG = "Battle Log",
    SETTINGS  = "Settings",
}
w.Tabs.Flags = ImGuiTabBarFlags_None

-- Dropdowns /////////////////////
w.Dropdown = {}
w.Dropdown.Enum = {
    MOB   = "Mob Filter",
    FOCUS = "Focused Entity",
    NONE  = "!NONE",
}
w.Dropdown.Flags = ImGuiComboFlags_None
w.Dropdown.Player = {}
w.Dropdown.Player.Focus = w.Dropdown.Enum.NONE
w.Dropdown.Player.Index = 1
w.Dropdown.Mob = {}
w.Dropdown.Mob.Focus = w.Dropdown.Enum.NONE
w.Dropdown.Mob.Index = 1

-- Colors ////////////////////////
w.Colors = {
    -- Base Colors
    White  = {1.0, 1.0, 1.0, 1.0},
    Red    = {1.0, 0.0, 0.0, 1.0},
    Green  = {0.0, 1.0, 0.0, 1.0},
    Blue   = {0.0, 0.0, 1.0, 1.0},
    Orange = {0.9, 0.6, 0.0, 1.0},
    Yellow = {0.9, 1.0, 0.0, 1.0},
    Bright_Green = {0.2, 1.0, 0.0, 1.0},
    Purple = {0.7, 0.2, 1.0, 1.0},
    Dim    = {0.2, 0.2, 0.2, 1.0},
    -- Elements
    Light   = {1.0, 1.0, 1.0, 1.0},
    Dark    = {0.9, 0.0, 1.0, 1.0},
    Fire    = {1.0, 0.0, 0.0, 1.0},
    Ice     = {0.0, 0.7, 1.0, 1.0},
    Wind    = {0.0, 1.0, 0.0, 1.0},
    Earth   = {0.7, 0.5, 0.0, 1.0},
    Thunder = {0.7, 0.2, 1.0, 1.0},
    Water   = {0.3, 0.3, 1.0, 1.0},
}
w.Colors.Elements = {
    [0] = w.Colors.Fire,
    [1] = w.Colors.Ice,
    [2] = w.Colors.Wind,
    [3] = w.Colors.Earth,
    [4] = w.Colors.Thunder,
    [5] = w.Colors.Water,
    [6] = w.Colors.Light,
    [7] = w.Colors.Dark,
}

------------------------------------------------------------------------------------------------------
-- Found the font scaling code here:
-- https://skia.googlesource.com/external/github.com/ocornut/imgui/+/v1.51/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
w.Initialize = function()
    -- Adjust font size.
    local atlas = UI.GetIO().Fonts
    local font = atlas.Fonts[1]
    font.Scale = w.Window.Font_Scaling

    -- Set color theme.
    UI.StyleColorsDark()

    UI.PushStyleVar(ImGuiStyleVar_Alpha, w.Window.Alpha)
    UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
    UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
    UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
    UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

    -- Reset dropdown selections.
    w.Dropdown.Player.Focus = w.Dropdown.Enum.NONE
    w.Dropdown.Player.Index = 1
    w.Dropdown.Mob.Focus = w.Dropdown.Enum.NONE
    w.Dropdown.Mob.Index = 1
end

------------------------------------------------------------------------------------------------------
-- Resets visual settings in the window.
------------------------------------------------------------------------------------------------------
w.Reset_Settings = function()
    w.Window.Alpha = w.Defaults.Window.Alpha
    w.Window.Font_Scaling = w.Defaults.Window.Font_Scaling
    w.Initialize()
end

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
w.Populate = function()
    if not A.States.Zoning then
        if UI.Begin(w.Window.Name, w.Window.Visible, w.Window.Flags) then
            if UI.BeginTabBar(w.Tabs.Names.PARENT, w.Tabs.Flags) then
                if UI.BeginTabItem(w.Tabs.Names.TEAM) then
                    Team.Populate()
                    UI.EndTabItem()
                end
                if UI.BeginTabItem(w.Tabs.Names.FOCUS) then
                    Focus.Populate()
                    UI.EndTabItem()
                end
                if UI.BeginTabItem(w.Tabs.Names.BATTLELOG) then
                    Blog.Populate()
                    UI.EndTabItem()
                end
                if UI.BeginTabItem(w.Tabs.Names.SETTINGS) then
                    Settings.Populate()
                    UI.EndTabItem()
                end
                UI.EndTabBar()
            end
            UI.End()
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
    if UI.RadioButton("Dark ", {w.Window.Style}, 1) then
        w.Window.Style = 1
        UI.StyleColorsDark()
    end
    UI.SameLine()
    if UI.RadioButton("Light ", {w.Window.Style}, 2) then
        w.Window.Style = 2
        UI.StyleColorsLight()
    end
    UI.SameLine()
    if UI.RadioButton("Classic ", {w.Window.Style}, 3) then
        w.Window.Style = 3
        UI.StyleColorsClassic()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets the screen transparency.
------------------------------------------------------------------------------------------------------
w.Util.Set_Alpha = function()
    UI.PushStyleVar(ImGuiStyleVar_Alpha, w.Window.Alpha)
end

------------------------------------------------------------------------------------------------------
-- Sets the screen font size.
------------------------------------------------------------------------------------------------------
w.Util.Set_Font_Size = function()
    local atlas = UI.GetIO().Fonts
    local font = atlas.Fonts[1]
    font.Scale = w.Window.Font_Scaling
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
    local list = Model.Get.Mob_List_Sorted()
    local flags = w.Dropdown.Flags
    if list[1] then
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
end

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to show only damage done by a certain entity.
------------------------------------------------------------------------------------------------------
w.Widget.Player_Filter = function()
    local list = Model.Get.Player_List_Sorted()
    local flags = w.Dropdown.Flags
    if list[1] then
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
end

return w