local w = {}

w.Window = {
    Name = "Metrics",
    Alpha = 0.85,
    Throttle_Count = 0,
    Throttle_Level = 10,
    Font_Scaling = 0.85,
    Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav
    )
}
w.Window.Defaults = {
    Alpha = 225,
    Font_Scaling = 0.85,
}

w.Table = {}
w.Table.Flags = {
    None = bit.bor(ImGuiTableFlags_None),
    Resizable = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
}

w.Columns = {}
w.Columns.Flags = {
    None = bit.bor(ImGuiTableColumnFlags_None),
    Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch)
}
w.Columns.Widths = {
    Name = 100,
    Damage = 80,
}

w.Tabs = {
    Name = "Tabs",
    Flags = ImGuiTabBarFlags_None
}

w.Dropdown = {}

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
w.Populate = function()
    if UI.Begin(w.Window.Name, false, w.Window.Flags) then
        if UI.BeginTabBar("Tabs", w.Tabs.Flags) then
            if UI.BeginTabItem("Team") then
                Monitor.Display.Screen.Table()
                UI.EndTabItem()
            end
            if UI.BeginTabItem("Focus") then
                Focus.Populate()
                UI.EndTabItem()
            end
            if UI.BeginTabItem("Battle Log") then
                Blog.Populate()
                UI.EndTabItem()
            end
            if UI.BeginTabItem("Settings") then
                Settings.Screen.Settings()
                UI.EndTabItem()
            end
            UI.EndTabBar()
        end
        UI.End()
    end
end

------------------------------------------------------------------------------------------------------
-- Found the font scaling code here:
-- https://skia.googlesource.com/external/github.com/ocornut/imgui/+/v1.51/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
w.Initialize = function()
    local style = UI.GetStyle()
    -- style:ScaleAllSizes(1.0)
    -- style.Colors[ImGuiCol_TableHeaderBg] =

    local atlas = UI.GetIO().Fonts
    local font = atlas.Fonts[1]
    font.Scale = w.Window.Font_Scaling

    -- case 0: ImGui::StyleColorsDark(); break;
    -- case 1: ImGui::StyleColorsLight(); break;
    -- case 2: ImGui::StyleColorsClassic(); break;

    UI.StyleColorsDark()

    -- TitlebgActive

    UI.PushStyleVar(ImGuiStyleVar_Alpha, w.Window.Alpha)
    UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
    UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
    UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
    UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

    --UI.SetNextWindowBgAlpha(0.80)
    --UI.SetNextWindowSize({800, 500}, ImGuiCond_Always)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
w.Dropdown.Mob_Filter = function()
    local list = Model.Data.Mob_List_Sorted
    local flags = ImGuiComboFlags_None
    if list[1] then
        if UI.BeginCombo("Mob Filter", list[Monitor.Display.Dropdown.Mob.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = Monitor.Display.Dropdown.Mob.Index == n
                if UI.Selectable(list[n], is_selected) then
                    Monitor.Display.Dropdown.Mob.Index = n
                    Model.Mob_Filter = list[n]
                end
                -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo("Mob Filter", "!NONE", flags) then
            UI.EndCombo()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
w.Dropdown.Player_Filter = function()
    local list = Model.Data.Player_List_Sorted
    local flags = ImGuiComboFlags_None
    if list[1] then
        if UI.BeginCombo("Focused Entity", list[Focus.Display.Dropdown.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = Focus.Display.Dropdown.Index == n
                if UI.Selectable(list[n], is_selected) then
                    Focus.Display.Dropdown.Index = n
                    Focus.Display.Dropdown.Focus = list[n]
                end
                -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo("Focused Entity", "!NONE", flags) then
            UI.EndCombo()
        end
    end
end

return w