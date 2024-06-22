Blog.Config = T{}

Blog.Config.Defaults = T{}
Blog.Config.Defaults.Flags = T{
    Timestamp = false,
    Melee     = false,
    Ranged    = false,
    WS        = true,
    SC        = true,
    Magic     = true,
    Ability   = true,
    Pet       = true,
    Healing   = true,
    Deaths    = false,
    Mob_Death = true,
    Paging    = false,
    Streaming = true,
}
Blog.Config.Defaults.Thresholds = T{
    WS    = 600,
    MAGIC = 1000,
    MAX   = 99999,
}
Blog.Config.Defaults.Visible_Length = 8
Blog.Config.Defaults.Line_Height = 20

Blog.Settings = {
    Line_Size_Default = 20,
    Max_Length = 100000,
    Truncate_Length = 6,
    Visible_Length = 8,
}

Blog.Config.Show_Settings = false
Blog.Config.Slider_Width = 100
Blog.Config.Page_Slider_Width = 60

------------------------------------------------------------------------------------------------------
-- Resets the battle log settings.
------------------------------------------------------------------------------------------------------
Blog.Config.Reset = function()
    Metrics.Blog.Flags.Damage_Highlighting = true
    Metrics.Blog.Line_Height = Blog.Settings.Line_Size_Default
    Metrics.Blog.Visible_Length = Blog.Settings.Visible_Length

    for flag, value in pairs(Blog.Config.Defaults.Flags) do
        Metrics.Blog.Flags[flag] = value
    end

    for type, threshold in pairs(Blog.Config.Defaults.Thresholds) do
        Metrics.Blog.Thresholds[type] = threshold
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Display = function()
    UI.Separator() Blog.Config.General_Settings()
    UI.Separator() if Metrics.Blog.Flags.Damage_Highlighting then Blog.Config.Damage_Sliders() UI.Separator() end
    Blog.Config.Column_Settings()
    UI.Separator() Blog.Config.Length()
    UI.Separator()
end

------------------------------------------------------------------------------------------------------
-- Shows general settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.General_Settings = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Settings

    UI.Text("Which actions should populate the battle log?")
    if UI.BeginTable("Battle Log", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Show Timestamps", {Metrics.Blog.Flags.Timestamp}) then
            Metrics.Blog.Flags.Timestamp = not Metrics.Blog.Flags.Timestamp
        end

        UI.TableNextColumn()
        Blog.Widgets.Damage_Highlighting()

        UI.TableNextColumn()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows column settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Column_Settings = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Settings

    UI.Text("Which actions should populate the battle log?")
    if UI.BeginTable("Battle Log", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        -- Row 1
        UI.TableNextColumn()
        if UI.Checkbox("Show Melee", {Metrics.Blog.Flags.Melee}) then
            Metrics.Blog.Flags.Melee = not Metrics.Blog.Flags.Melee
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Ranged", {Metrics.Blog.Flags.Ranged}) then
            Metrics.Blog.Flags.Ranged = not Metrics.Blog.Flags.Ranged
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show WS", {Metrics.Blog.Flags.WS}) then
            Metrics.Blog.Flags.WS = not Metrics.Blog.Flags.WS
        end

        -- Row 2
        UI.TableNextColumn()
        if UI.Checkbox("Show SC", {Metrics.Blog.Flags.SC}) then
            Metrics.Blog.Flags.SC = not Metrics.Blog.Flags.SC
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Magic", {Metrics.Blog.Flags.Magic}) then
            Metrics.Blog.Flags.Magic = not Metrics.Blog.Flags.Magic
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Ability", {Metrics.Blog.Flags.Ability}) then
            Metrics.Blog.Flags.Ability = not Metrics.Blog.Flags.Ability
        end

        -- Row 3
        UI.TableNextColumn()
        if UI.Checkbox("Show Pet", {Metrics.Blog.Flags.Pet}) then
            Metrics.Blog.Flags.Pet = not Metrics.Blog.Flags.Pet
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Healing", {Metrics.Blog.Flags.Healing}) then
            Metrics.Blog.Flags.Healing = not Metrics.Blog.Flags.Healing
        end
        UI.TableNextColumn()
        if UI.Checkbox("Show Deaths", {Metrics.Blog.Flags.Deaths}) then
            Metrics.Blog.Flags.Deaths = not Metrics.Blog.Flags.Deaths
        end

        -- Row 4
        UI.TableNextColumn()
        if UI.Checkbox("Show Mob Deaths", {Metrics.Blog.Flags.Mob_Death}) then
            Metrics.Blog.Flags.Mob_Death = not Metrics.Blog.Flags.Mob_Death
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows general settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Damage_Sliders = function()
    local col_flags = Column.Flags.None
    local width = 220

    UI.Text("Use Ctrl+Click on the component to set the number directly." )
    if UI.BeginTable("Battle Log", 2) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)

        UI.TableNextColumn() Blog.Widgets.WS_Threshold()
        UI.TableNextColumn() Blog.Widgets.Magic_Threshold()
        UI.TableNextColumn()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows blog length settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Length = function()
    if UI.Button("Default") then
        Metrics.Blog.Visible_Length = Blog.Settings.Visible_Length
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()

    local length = {[1] = Metrics.Blog.Visible_Length}
    UI.SetNextItemWidth(50)
    if UI.DragInt("Length", length, 0.1, Blog.Settings.Visible_Length, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Visible_Length = length[1]
        local last_page = Blog.Max_Page()
        if Blog.Page > last_page then Blog.Page = last_page end
    end
end