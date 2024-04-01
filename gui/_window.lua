local w = {}

w.Window = {
    Name = "Metrics",
    X = 600,
    Y = 120,
    Alpha = 225,
    Throttle = 10,
    Font_Scaling = 0.85,
    
    Flags = bit.bor(
    -- ImGuiWindowFlags_None
    -- ImGuiWindowFlags_NoDecoration,
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoFocusOnAppearing,
    ImGuiWindowFlags_NoNav,
    ImGuiWindowFlags_HorizontalScrollbar
    )
}

w.Defaults = {
    Alpha = 225,
    Font_Scaling = 0.85,
}

w.Table = {
    Flags = {
        None = bit.bor(ImGuiTableFlags_None),
        Resizable = bit.bor(ImGuiTableFlags_NoSavedSettings, ImGuiTableFlags_Resizable, ImGuiTableFlags_SizingStretchProp, ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders),
    }
}

w.Columns = {
    Flags = {
        None = bit.bor(ImGuiTableColumnFlags_None),
        Expandable = bit.bor(ImGuiTableColumnFlags_WidthStretch)
    },
    Widths = {
        Name = 100,
        Damage = 80,
    }
}

w.Tabs = {
    Name = "Tabs",
    Flags = ImGuiTabBarFlags_None
}

w.Screen = {}

------------------------------------------------------------------------------------------------------
-- Populate the data in the monitor window.
------------------------------------------------------------------------------------------------------
w.Populate = function()
    w.Set_Style()
    if UI.Begin(w.Window.Name, false, w.Window.Flags) then
        if UI.BeginTabBar("Tabs", w.Tabs.Flags) then
            -- Tab 1
            if UI.BeginTabItem("Table") then
                Monitor.Display.Screen.Table()
                UI.EndTabItem()
            end
            -- Tab 2
            if UI.BeginTabItem("Focus") then
                Focus.Populate()
                UI.EndTabItem()
            end
            -- Tab 3
            if UI.BeginTabItem("Battle Log") then
                Blog.Populate()
                UI.EndTabItem()
            end
            -- Tab 4
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
--
-- Found the font scaling code here:
-- https://skia.googlesource.com/external/github.com/ocornut/imgui/+/v1.51/imgui_demo.cpp
------------------------------------------------------------------------------------------------------
w.Set_Style = function()
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

    UI.PushStyleVar(ImGuiStyleVar_Alpha, 0.85)
    UI.PushStyleVar(ImGuiStyleVar_CellPadding, {10, 1})
    UI.PushStyleVar(ImGuiStyleVar_WindowPadding, {7, 3})
    UI.PushStyleVar(ImGuiStyleVar_ItemSpacing, {0, 5})
    UI.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, {5, 0})

    --UI.SetNextWindowBgAlpha(0.80)
    --UI.SetNextWindowSize({800, 500}, ImGuiCond_Always)
end

return w