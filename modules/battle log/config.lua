Blog.Config = T{}

Blog.Config.Defaults = T{
    X         = 100,
    Y         = 100,
    Visible   = {true},
    Timestamp = false,
    Melee     = false,
    Ranged    = false,
    WS        = true,
    SC        = true,
    Magic     = true,
    BRD_Buff  = false,
    COR_Rolls = false,
    Enfeeble  = true,
    Ability   = true,
    Pet_TP    = true,
    Pet_Melee = true,
    Pet_Heal  = true,
    Pet       = true,
    Healing   = true,
    Deaths    = false,
    Mob_Melee = false,
    Mob_TP    = false,
    Mob_Spell = false,
    Mob_Death = true,
    Paging    = false,
    Streaming = true,
    Pet_Command = false,
    WS_THRESHOLD    = 600,
    MAGIC_THRESHOLD = 1000,
    MAX_THRESHOLD   = 99999,
    Visible_Length  = 8,
    Line_Height     = 20,
}

Blog.Settings = {
    Line_Size_Default = 20,
    Max_Length = 100000,
    Truncate_Length = 15,               -- Max length for player name is 15 characters.
    Pet_Name_Truncate_Length = 3,
    Player_Name_Truncate_Length = 11,   -- Length needed to show the JOB##/JOB## string.
    Action_Truncate_Length = 16,
    Damage_Truncate_Length = 5,
    Visible_Length = 8,
}

Blog.Config.Slider_Width = 100
Blog.Config.Page_Slider_Width = 60

------------------------------------------------------------------------------------------------------
-- Resets the battle log settings.
------------------------------------------------------------------------------------------------------
Blog.Config.Reset = function()
    Metrics.Blog.Line_Height = Blog.Settings.Line_Size_Default
    Metrics.Blog.Visible_Length = Blog.Settings.Visible_Length

    for flag, value in pairs(Blog.Config.Defaults.Flags) do
        Metrics.Blog[flag] = value
    end

    for type, threshold in pairs(Blog.Config.Defaults.Thresholds) do
        Metrics.Blog[type] = threshold
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
    UI.Separator() Blog.Config.Damage_Sliders()
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

        UI.TableNextColumn()
        if UI.Checkbox("Show Timestamps", {Metrics.Blog.Timestamp}) then
            Metrics.Blog.Timestamp = not Metrics.Blog.Timestamp
        end
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

    UI.Text("General")
    if UI.BeginTable("Battle Log - General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Enfeeble", {Metrics.Blog.Enfeeble}) then
            Metrics.Blog.Enfeeble = not Metrics.Blog.Enfeeble
        end
        UI.EndTable()
    end

    UI.Separator() UI.Text("Player")
    if UI.BeginTable("Battle Log - Player", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Melee", {Metrics.Blog.Melee}) then
            Metrics.Blog.Melee = not Metrics.Blog.Melee
        end
        UI.TableNextColumn()
        if UI.Checkbox("Ranged", {Metrics.Blog.Ranged}) then
            Metrics.Blog.Ranged = not Metrics.Blog.Ranged
        end
        UI.TableNextColumn()
        if UI.Checkbox("Weaponskills", {Metrics.Blog.WS}) then
            Metrics.Blog.WS = not Metrics.Blog.WS
        end
        UI.TableNextColumn()
        if UI.Checkbox("Skillchains", {Metrics.Blog.SC}) then
            Metrics.Blog.SC = not Metrics.Blog.SC
        end
        UI.TableNextColumn()
        if UI.Checkbox("Nukes", {Metrics.Blog.Magic}) then
            Metrics.Blog.Magic = not Metrics.Blog.Magic
        end
        UI.TableNextColumn()
        if UI.Checkbox("Healing", {Metrics.Blog.Healing}) then
            Metrics.Blog.Healing = not Metrics.Blog.Healing
        end
        UI.TableNextColumn()
        if UI.Checkbox("Song Buffs", {Metrics.Blog.BRD_Buffs}) then
            Metrics.Blog.BRD_Buffs = not Metrics.Blog.BRD_Buffs
        end
        UI.TableNextColumn()
        if UI.Checkbox("Phantom Roll", {Metrics.Blog.COR_Rolls}) then
            Metrics.Blog.COR_Rolls = not Metrics.Blog.COR_Rolls
        end
        UI.TableNextColumn()
        if UI.Checkbox("Abilities", {Metrics.Blog.Ability}) then
            Metrics.Blog.Ability = not Metrics.Blog.Ability
        end
        UI.TableNextColumn()
        if UI.Checkbox("Deaths", {Metrics.Blog.Deaths}) then
            Metrics.Blog.Deaths = not Metrics.Blog.Deaths
        end
        UI.EndTable()
    end

    UI.Separator() UI.Text("Pets")
    if UI.BeginTable("Battle Log - Pets", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Melee", {Metrics.Blog.Pet_Melee}) then
            Metrics.Blog.Pet_Melee = not Metrics.Blog.Pet_Melee
        end
        UI.TableNextColumn()
        if UI.Checkbox("TP/Abilities", {Metrics.Blog.Pet_TP}) then
            Metrics.Blog.Pet_TP = not Metrics.Blog.Pet_TP
        end
        UI.TableNextColumn()
        if UI.Checkbox("Healing", {Metrics.Blog.Pet_Heal}) then
            Metrics.Blog.Pet_Heal = not Metrics.Blog.Pet_Heal
        end
        UI.TableNextColumn()
        if UI.Checkbox("Commands", {Metrics.Blog.Pet_Command}) then
            Metrics.Blog.Pet_Command = not Metrics.Blog.Pet_Command
        end
        UI.EndTable()
    end

    UI.Separator() UI.Text("Mobs")
    if UI.BeginTable("Battle Log - Mobs", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Melee", {Metrics.Blog.Mob_Melee}) then
            Metrics.Blog.Mob_Melee = not Metrics.Blog.Mob_Melee
        end
        UI.TableNextColumn()
        if UI.Checkbox("TP/Abilities", {Metrics.Blog.Mob_TP}) then
            Metrics.Blog.Mob_TP = not Metrics.Blog.Mob_TP
        end
        UI.TableNextColumn()
        if UI.Checkbox("Spells", {Metrics.Blog.Mob_Spell}) then
            Metrics.Blog.Mob_Spell = not Metrics.Blog.Mob_Spell
        end
        UI.TableNextColumn()
        if UI.Checkbox("Deaths", {Metrics.Blog.Mob_Death}) then
            Metrics.Blog.Mob_Death = not Metrics.Blog.Mob_Death
        end
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
-- Shows general settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Damage_Sliders = function()
    local col_flags = Column.Flags.None
    local width = 220

    UI.Text("Damage Threshold Highlighting")
    if UI.BeginTable("Battle Log - Thresholds", 2) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)

        UI.TableNextColumn() Blog.Widgets.WS_Threshold()
        UI.TableNextColumn() Blog.Widgets.Magic_Threshold()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows blog length settings that affect the Battle Log screen.
------------------------------------------------------------------------------------------------------
Blog.Config.Length = function()
    UI.Text("Battle Log Length")
    if UI.Button("Default") then
        Metrics.Blog.Visible_Length = Blog.Settings.Visible_Length
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()

    local length = {[1] = Metrics.Blog.Visible_Length}
    UI.SetNextItemWidth(50)
    if UI.DragInt("Lines", length, 0.1, Blog.Settings.Visible_Length, 50, "%d", ImGuiSliderFlags_None) then
        Metrics.Blog.Visible_Length = length[1]
        local last_page = Blog.Max_Page()
        if Blog.Page > last_page then Blog.Page = last_page end
    end
end