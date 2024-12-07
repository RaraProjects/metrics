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
    Is_Lurking_Enabled    = false,      -- This is linked with the settings of other modules.
    Mask_Names            = false,      -- This is linked with the settings of other modules.
    Hide_Subjobs          = false,      -- This is linked with the settings of other modules.
    Show_Job_Colors       = true,       -- This is linked with the settings of other modules.
    Visible_Length        = 8,
    Line_Height           = 20,
}

------------------------------------------------------------------------------------------------------
-- Resets the battle log settings.
------------------------------------------------------------------------------------------------------
Blog.Config.Reset = function()
    for setting, value in pairs(Blog.Config.Defaults) do
        Blog.Settings[setting] = value
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
    local col_flags = Blog.Tables.Column_Flags_None
    local width = Blog.Tables.Width_Settings

    UI.Text("Additional Columns")
    if UI.BeginTable("Battle Log", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Show Timestamps", Blog.Settings, "Show_Timestamp")
        UI.TableNextColumn()
        UI.TableNextColumn()
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows column settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Column_Settings = function()
    local col_flags = Blog.Tables.Column_Flags_None
    local width = Blog.Tables.Width_Settings
    local column_count = 3

    UI.Text("General")
    if UI.BeginTable("Battle Log - General", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Enfeebles", Blog.Settings, "Show_Enfeebling")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Healing",   Blog.Settings, "Show_Healing")
        UI.EndTable()
    end

    UI.Separator() UI.Text("Player")
    if UI.BeginTable("Battle Log - Player", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Melee",        Blog.Settings, "Show_Melee")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Ranged",       Blog.Settings, "Show_Ranged")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Weaponskills", Blog.Settings, "Show_Weaponskill")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Skillchains",  Blog.Settings, "Show_Skillchain")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Nukes",        Blog.Settings, "Show_Spells")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Song Buffs",   Blog.Settings, "Show_Song_Buffs")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Phantom Roll", Blog.Settings, "Show_Phantom_Roll")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Abilities",    Blog.Settings, "Show_Ability")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Deaths",       Blog.Settings, "Show_Player_Deaths")
        UI.EndTable()
    end

    UI.Separator() UI.Text("Pets")
    if UI.BeginTable("Battle Log - Pets", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Melee",        Blog.Settings, "Show_Pet_Melee")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TP/Abilities", Blog.Settings, "Show_Pet_TP")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Commands",     Blog.Settings, "Show_Pet_Command")
        UI.EndTable()
    end

    UI.Separator() UI.Text("Mobs")
    if UI.BeginTable("Battle Log - Mobs", column_count) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Melee",        Blog.Settings, "Show_Mob_Melee")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("TP/Abilities", Blog.Settings, "Show_Mob_TP")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Spells",       Blog.Settings, "Show_Mob_Spells")
        UI.TableNextColumn() Window_Manager.Widgets.Toggle_Checkbox("Deaths",       Blog.Settings, "Show_Mob_Deaths")
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
        Blog.Settings.Visible_Length = Blog.Config.Defaults.Visible_Length
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()

    local length = {[1] = Blog.Settings.Visible_Length}
    UI.SetNextItemWidth(50)
    if UI.DragInt("Lines", length, 0.1, Blog.Config.Defaults.Visible_Length, 50, "%d", ImGuiSliderFlags_None) then
        Blog.Settings.Visible_Length = length[1]
        local last_page = Blog.Max_Page()
        if Blog.Page > last_page then Blog.Page = last_page end
    end
end