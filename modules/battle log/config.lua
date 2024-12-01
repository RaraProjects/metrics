Blog.Config = T{}

Blog.Config.Defaults = {                -- Default values that populate the Metrics settings global.
    X         = 100,                    -- Window settings. The names need to match what the Window Manager is expecting.
    Y         = 100,
    Visible   = {true},
    Show_Timestamp        = false,      -- Battle Log component visibility flags.
    Show_Melee            = false,      -- REMEMBER TO CHANGE THE STRING REFERENCES IN THE CONFIG SCREEN IF CHANGING THESE!!!
    Show_Ranged           = false,      -- I didn't want to use strings, but it's how I chose to get around pass by reference limitations.
    Show_Weaponskill      = true,
    Show_Skillchain       = true,
    Show_Spells           = true,
    Show_Song_Buffs       = false,
    Show_Phantom_Roll     = false,
    Show_Enfeebling       = true,
    Show_Ability          = true,
    Show_Pet_TP           = true,
    Show_Pet_Melee        = true,
    Show_Pet_Command      = false,
    Show_Healing          = true,
    Show_Player_Deaths    = false,
    Show_Mob_Melee        = false,
    Show_Mob_TP           = false,
    Show_Mob_Spells       = false,
    Show_Mob_Deaths       = true,
    Is_Paging_Enabled     = false,
    Visible_Length        = 8,
    Line_Height           = 20,
}

------------------------------------------------------------------------------------------------------
-- Resets the battle log settings.
------------------------------------------------------------------------------------------------------
Blog.Config.Reset = function()
    for setting, value in pairs(Blog.Config.Defaults) do
        Metrics.Blog[setting] = value
    end
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Display = function()
    Blog.Config.General_Settings()
    UI.Separator() Blog.Config.Filters()
    UI.Separator() Blog.Config.Length()
    UI.Separator() Blog.Config.Column_Settings()
end

------------------------------------------------------------------------------------------------------
-- Shows general settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.General_Settings = function()
    local col_flags = Column.Flags.None
    local width = Column.Widths.Settings

    UI.Text("Additional Columns")
    if UI.BeginTable("Battle Log", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Show Timestamps", Metrics.Blog, "Show_Timestamp")
        UI.TableNextColumn()
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
    local column_count = 3

    UI.Text("General")
    if UI.BeginTable("Battle Log - General", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Enfeebles", Metrics.Blog, "Show_Enfeebling")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Healing",   Metrics.Blog, "Show_Healing")
        UI.EndTable()
    end

    UI.Separator() UI.Text("Player")
    if UI.BeginTable("Battle Log - Player", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Melee",        Metrics.Blog, "Show_Melee")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Ranged",       Metrics.Blog, "Show_Ranged")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Weaponskills", Metrics.Blog, "Show_Weaponskill")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Skillchains",  Metrics.Blog, "Show_Skillchain")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Nukes",        Metrics.Blog, "Show_Spells")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Song Buffs",   Metrics.Blog, "Show_Song_Buffs")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Phantom Roll", Metrics.Blog, "Show_Phantom_Roll")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Abilities",    Metrics.Blog, "Show_Ability")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Deaths",       Metrics.Blog, "Show_Player_Deaths")
        UI.EndTable()
    end

    UI.Separator() UI.Text("Pets")
    if UI.BeginTable("Battle Log - Pets", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Melee",        Metrics.Blog, "Show_Pet_Melee")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TP/Abilities", Metrics.Blog, "Show_Pet_TP")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Commands",     Metrics.Blog, "Show_Pet_Command")
        UI.EndTable()
    end

    UI.Separator() UI.Text("Mobs")
    if UI.BeginTable("Battle Log - Mobs", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Melee",        Metrics.Blog, "Show_Mob_Melee")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TP/Abilities", Metrics.Blog, "Show_Mob_TP")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Spells",       Metrics.Blog, "Show_Mob_Spells")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Deaths",       Metrics.Blog, "Show_Mob_Deaths")
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows filters that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Filters = function()
    UI.Text("Log Filters")
    if UI.BeginTable("Battle Log - Filters", 2) then
        UI.TableSetupColumn("Col 1")
        UI.TableSetupColumn("Col 2")

        UI.TableNextColumn() Blog.Widgets.Player_Filter()
        UI.TableNextColumn() Blog.Widgets.Action_Filter_Input()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows blog length settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Length = function()
    UI.Text("Battle Log Length")
    if UI.Button("Default") then
        Metrics.Blog.Visible_Length = Blog.Config.Defaults.Visible_Length
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()

    local length = {[1] = Metrics.Blog.Visible_Length}
    UI.SetNextItemWidth(50)
    if UI.DragInt("Lines", length, 0.1, Blog.Config.Defaults.Visible_Length, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Visible_Length = length[1]
        local last_page = Blog.Max_Page()
        if Blog.Page > last_page then Blog.Page = last_page end
    end
end