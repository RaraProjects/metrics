local f = {}

f.Display = {}
f.Display.Util = {}
f.Display.Flags = {
    Open_Action = -1,
}

f.Tabs = {}
f.Tabs.Names = {
    MELEE     = "Melee",
    RANGED    = "Ranged",
    WS        = "Weaponskills",
    MAGIC     = "Magic",
    ABILITIES = "Abilities",
    PETS      = "Pets",
}
f.Tabs.Switch = {
    [f.Tabs.Names.MELEE]     = nil,
    [f.Tabs.Names.RANGED]    = nil,
    [f.Tabs.Names.WS]        = nil,
    [f.Tabs.Names.MAGIC]     = nil,
    [f.Tabs.Names.ABILITIES] = nil,
    [f.Tabs.Names.PETS]      = nil,
}

f.Enum = {
    OVERFLOW = 100000,
}

------------------------------------------------------------------------------------------------------
-- Resets the focus settings.
------------------------------------------------------------------------------------------------------
f.Reset_Settings = function()
    for index, _ in pairs(DB.Healing_Max) do
        DB.Healing_Max[index] = DB.Enum.HEALING[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the focus data to the screen.
------------------------------------------------------------------------------------------------------
f.Populate = function()
    Window.Widget.Player_Filter()
    UI.SameLine() UI.Text("  ") UI.SameLine()
    Window.Widget.Mob_Filter()
    local player_name = Window.Util.Get_Player_Focus()
    if player_name == Window.Dropdown.Enum.NONE then return nil end

    UI.Separator()
    UI.Text(" Player Total: ") UI.SameLine() Col.Damage.Total(player_name)
    f.Display.Overall(player_name)
    UI.Separator()

    if UI.BeginTabBar("Focus Tabs", Window.Tabs.Flags) then
        if UI.BeginTabItem("Melee", false, f.Tabs.Switch[f.Tabs.Names.MELEE]) then
            f.Tabs.Switch[f.Tabs.Names.MELEE] = nil
            f.Display.Melee(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Ranged", false, f.Tabs.Switch[f.Tabs.Names.RANGED]) then
            f.Tabs.Switch[f.Tabs.Names.RANGED] = nil
            f.Display.Ranged(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Weaponskills", false, f.Tabs.Switch[f.Tabs.Names.WS]) then
            f.Tabs.Switch[f.Tabs.Names.WS] = nil
            f.Display.WS_and_SC(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Magic", false, f.Tabs.Switch[f.Tabs.Names.MAGIC]) then
            f.Tabs.Switch[f.Tabs.Names.MAGIC] = nil
            f.Display.Magic(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Abilities", false, f.Tabs.Switch[f.Tabs.Names.ABILITIES]) then
            f.Tabs.Switch[f.Tabs.Names.ABILITIES] = nil
            f.Display.Ability(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Pets", false, f.Tabs.Switch[f.Tabs.Names.PETS]) then
            f.Tabs.Switch[f.Tabs.Names.PETS] = nil
            f.Display.Pet(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem("Defense", false) then
            f.Display.Defense(player_name)
            UI.EndTabItem()
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a breakdown of overall player damage by type.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Overall = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Percent
    local columns = 6
    if Metrics.Team.Settings.Include_SC_Damage then columns = columns + 1 end

    if UI.BeginTable("Overall", columns, table_flags) then
        -- Headers
        UI.TableSetupColumn("Melee %", col_flags, width)
        UI.TableSetupColumn("Ranged %", col_flags, width)
        UI.TableSetupColumn("WS %", col_flags, width)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableSetupColumn("SC %", col_flags, width) end
        UI.TableSetupColumn("Magic %", col_flags, width)
        UI.TableSetupColumn("JA %", col_flags, width)
        UI.TableSetupColumn("Pet %", col_flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.RANGED, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.WS, true)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.SC, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET, true)
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Melee = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent

    local off_hand = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.TOTAL)
    local kick_damage = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.TOTAL)
    local counter_damage = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_COUNTER, DB.Enum.Metric.TOTAL)

    if UI.BeginTable("Melee Primary", 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableSetupColumn("Rate", col_flags, percent_width)
        UI.TableHeadersRow()

        -- Total
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Melee Total")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        -- Main-Hand
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_MAIN)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        -- Off-Hand
        if off_hand > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_OFFHAND)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        -- Kick Attacks
        if kick_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.MELEE_KICK)
            UI.TableNextColumn() Col.Kick.Rate(player_name)
        end

        -- Counter
        if counter_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
        end

        -- Critical Hits
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Col.Crit.Damage(player_name, DB.Enum.Trackable.MELEE)
        UI.TableNextColumn() Col.Crit.Damage(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Crit.Rate(player_name, DB.Enum.Trackable.MELEE)

        UI.EndTable()
    end

    local mob_heal = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE, DB.Enum.Metric.MOB_HEAL)
    local shadows  = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE, DB.Enum.Metric.SHADOWS)
    local enspell  = DB.Data.Get(player_name, DB.Enum.Trackable.ENSPELL, DB.Enum.Metric.TOTAL)
    local endrain  = DB.Data.Get(player_name, DB.Enum.Trackable.ENDRAIN, DB.Enum.Metric.TOTAL)
    local enaspir  = DB.Data.Get(player_name, DB.Enum.Trackable.ENASPIR, DB.Enum.Metric.TOTAL)

    if mob_heal > 0 or shadows > 0 or enspell > 0 or endrain > 0 or enaspir > 0 then
        if UI.BeginTable("Melee Misc.", 2, table_flags) then
            UI.TableSetupColumn("Type", col_flags, name_width)
            UI.TableSetupColumn("Damage", col_flags, damage_width)
            UI.TableHeadersRow()

            if mob_heal > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Mob Heal")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(mob_heal))
            end

            if shadows > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Shadows")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(shadows))
            end

            if enspell > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Spell")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(enspell))
            end

            if endrain > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Drain")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(endrain))
            end

            if enaspir > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("En-Aspir")
                UI.TableNextColumn() UI.Text(Col.String.Format_Number(enaspir))
            end
            UI.EndTable()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the ranged drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Ranged = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent
    local trackable = DB.Enum.Trackable.RANGED

    if UI.BeginTable("Ranged", 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableSetupColumn("Rate", col_flags, percent_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Ranged Total")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Square Hit")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable, nil, DB.Enum.Metric.SQUARE_COUNT)


        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Truestrike")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable, nil, DB.Enum.Metric.TRUE_COUNT)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Critical Hits")
        UI.TableNextColumn() Col.Crit.Damage(player_name, trackable)
        UI.TableNextColumn() Col.Crit.Damage(player_name, trackable, true)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() Col.Crit.Rate(player_name, trackable)
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.WS_and_SC = function(player_name)
    -- GUI configuration
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent

    -- Data setup
    local trackable_ws = DB.Enum.Trackable.WS
    local trackable_sc = DB.Enum.Trackable.SC

    -- Basic stats
    if UI.BeginTable("WS and SC", 4, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Weaponskills")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable_ws)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable_ws, true)
        UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable_ws)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Skillchains")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable_sc)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable_sc, true)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.EndTable()
    end

    -- Cataloged data
    local show_ws_publish = false
    local show_sc_publish = false
    if DB.Tracking.Trackable[DB.Enum.Trackable.WS] and DB.Tracking.Trackable[DB.Enum.Trackable.WS][player_name] then
        f.Display.Single_Data(player_name, DB.Enum.Trackable.WS)
        show_ws_publish = true
    end

    if DB.Tracking.Trackable[DB.Enum.Trackable.SC] and DB.Tracking.Trackable[DB.Enum.Trackable.SC][player_name] then
        f.Display.Single_Data(player_name, DB.Enum.Trackable.SC)
        show_sc_publish = true
    end

    -- Publish buttons
    if show_ws_publish then
        Report.Publish.Button(player_name, trackable_ws, "Publish Weaponskills")
    end
    if show_sc_publish then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        Report.Publish.Button(player_name, trackable_sc, "Publish Skillchains")
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the magic drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Magic = function(player_name)
    -- GUI configuration
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent

    -- Data setup
    local nuke_total = DB.Data.Get(player_name, DB.Enum.Trackable.NUKE, DB.Enum.Metric.TOTAL)
    local mp_drain = DB.Data.Get(player_name, DB.Enum.Trackable.MP_DRAIN, DB.Enum.Metric.TOTAL)
    local healing_total = DB.Data.Get(player_name, DB.Enum.Trackable.HEALING, DB.Enum.Metric.TOTAL)
    local enspell_count = DB.Data.Get(player_name, DB.Enum.Trackable.ENSPELL, DB.Enum.Metric.COUNT)
    local enfeeble_count = DB.Data.Get(player_name, DB.Enum.Trackable.ENFEEBLE, DB.Enum.Metric.COUNT)
    local spike_damage = DB.Data.Get(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, DB.Enum.Metric.TOTAL)
    local misc_count = DB.Data.Get(player_name, DB.Enum.Trackable.MAGIC, DB.Enum.Metric.COUNT)

    -- Basic stats
    if UI.BeginTable("Magic", 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, percent_width)
        UI.TableSetupColumn("MP Used", col_flags, damage_width)
        UI.TableSetupColumn("Efficacy", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Magic Total")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, true)
        UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.MAGIC)
        UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.MAGIC)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Nuking")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.NUKE)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.NUKE, true)
        UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.NUKE)
        UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.NUKE)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Healing")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.HEALING)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.HEALING, true)
        UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.HEALING)
        UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.HEALING)

        if mp_drain > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("MP Drain")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MP_DRAIN)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.MP_DRAIN)
            UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.MP_DRAIN)
        end

        if enspell_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Enspell")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.ENSPELL)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.ENSPELL, true)
            UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.ENSPELL)
            UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.ENSPELL)
        end

        if spike_damage > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, true)
            UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
            UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
        end

        if enfeeble_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Enfeebling")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Spell.MP(player_name, DB.Enum.Trackable.ENFEEBLE)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        if misc_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Other")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Spell.MP(player_name, "Other")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end
        UI.EndTable()
    end

    -- Magic bursts
    if nuke_total > 0 then
        if UI.BeginTable("Bursts", 3, table_flags) then
            UI.TableSetupColumn("Burst Damage", col_flags, name_width)
            UI.TableSetupColumn("Damage %", col_flags, percent_width)
            UI.TableSetupColumn("Magic %", col_flags, percent_width)
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() Col.Damage.Burst(player_name)
            UI.TableNextColumn() Col.Damage.Burst(player_name, true)
            UI.TableNextColumn() Col.Damage.Burst(player_name, true, true)
            UI.EndTable()
        end
    end

    -- Healing
    if healing_total > 0 then
        if UI.BeginTable("Overcure", 1, table_flags) then
            UI.TableSetupColumn("Overcure", col_flags, damage_width)
            UI.TableHeadersRow()

            UI.TableNextColumn() Col.Healing.Overcure(player_name)
            UI.EndTable()
        end
    end

    -- Cataloged data
    if nuke_total > 0 then f.Display.Spell_Single(player_name, DB.Enum.Trackable.NUKE) end
    if healing_total > 0 then f.Display.Spell_Single(player_name, DB.Enum.Trackable.HEALING) end
    if enfeeble_count > 0 then f.Display.Spell_Single(player_name, DB.Enum.Trackable.ENFEEBLE) end
    if enspell_count > 0 then f.Display.Spell_Single(player_name, DB.Enum.Trackable.ENSPELL) end
    if spike_damage > 0 then f.Display.Spell_Single(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG) end
    if misc_count > 0 then f.Display.Spell_Single(player_name, DB.Enum.Trackable.MAGIC) end

    -- Publish buttons
    if nuke_total > 0 then
        Report.Publish.Button(player_name, DB.Enum.Trackable.NUKE, "Publish Nuking")
    end
    if healing_total > 0 then
        if nuke_total > 0 then UI.SameLine() UI.Text(" ") UI.SameLine() end
        Report.Publish.Button(player_name, DB.Enum.Trackable.HEALING, "Publish Healing")
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Ability = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local trackable = DB.Enum.Trackable.ABILITY

    local ability_total = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY, DB.Enum.Metric.COUNT)

    if UI.BeginTable("Ability", 1, table_flags) then
        UI.TableSetupColumn("Ability Damage", col_flags, name_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
        UI.EndTable()
    end

    if ability_total > 0 then
        f.Display.Single_Data(player_name, DB.Enum.Trackable.ABILITY)
    end

    -- Publish buttons
    if ability_total > 0 then
        Report.Publish.Button(player_name, DB.Enum.Trackable.ABILITY, "Publish Abilities")
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the pet drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Pet = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent

    local pet_total = DB.Data.Get(player_name, DB.Enum.Trackable.PET, DB.Enum.Metric.TOTAL)

    if UI.BeginTable("Pets Melee", 4, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableSetupColumn("Accuracy", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        local melee = DB.Data.Get(player_name, DB.Enum.Trackable.PET_MELEE, DB.Enum.Metric.TOTAL)
        if melee > 0 then
            UI.TableNextColumn() UI.Text("Melee")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_MELEE, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
        end

        local ranged = DB.Data.Get(player_name, DB.Enum.Trackable.PET_RANGED, DB.Enum.Metric.TOTAL)
        if ranged > 0 then
            UI.TableNextColumn() UI.Text("Ranged")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_RANGED)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_RANGED, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local nuke = DB.Data.Get(player_name, DB.Enum.Trackable.PET_NUKE, DB.Enum.Metric.TOTAL)
        if nuke > 0 then
            UI.TableNextColumn() UI.Text("Magic")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_NUKE)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_NUKE, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local healing = DB.Data.Get(player_name, DB.Enum.Trackable.PET_HEAL, DB.Enum.Metric.TOTAL)
        if healing > 0 then
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_HEAL)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_HEAL, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local ws = DB.Data.Get(player_name, DB.Enum.Trackable.PET_WS, DB.Enum.Metric.TOTAL)
        if ws > 0 then
            UI.TableNextColumn() UI.Text("Weaponskill")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_WS, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.PET_WS)
        end

        local ability = DB.Data.Get(player_name, DB.Enum.Trackable.PET_ABILITY, DB.Enum.Metric.TOTAL)
        if ability > 0 then
            UI.TableNextColumn() UI.Text("Ability")
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY)
            UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY, true)
            UI.TableNextColumn() Col.Acc.By_Type(player_name, DB.Enum.Trackable.PET_ABILITY)
        end

        UI.EndTable()
    end

    if pet_total > 0 then
        if UI.BeginTabBar("Pet Tabs", Window.Tabs.Flags) then
            for pet_name, _ in pairs(DB.Tracking.Initialized_Pets[player_name]) do
                if UI.BeginTabItem(pet_name) then
                    f.Display.Pet_Single_Data(player_name, pet_name)
                    UI.EndTabItem()
                end
            end
            UI.EndTabBar()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the defense drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Defense = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage

    if UI.BeginTable("Damage Taken", 3, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DAMAGE_TAKEN_TOTAL)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        UI.TableNextColumn() UI.Text("Melee")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN)
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.MELEE_DMG_TAKEN, true)

        UI.TableNextColumn() UI.Text("Magic")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN)
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.SPELL_DMG_TAKEN, true)

        UI.TableNextColumn() UI.Text("Mob TP")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN)
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.TP_DMG_TAKEN, true)

        UI.EndTable()
    end

    if UI.BeginTable("Other Damage", 3, table_flags) then
        UI.TableSetupColumn("Misc. Defense", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, damage_width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Crits")
        UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DEF_CRIT)
        UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_CRIT)

        local pet = DB.Data.Get(player_name, DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET, DB.Enum.Metric.TOTAL)
        if pet > 0 then
            UI.TableNextColumn() UI.Text("Pet")
            UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DMG_TAKEN_TOTAL_PET)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local spikes = DB.Data.Get(player_name, DB.Enum.Trackable.INCOMING_SPIKE_DMG, DB.Enum.Metric.TOTAL)
        if spikes > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.INCOMING_SPIKE_DMG)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        UI.EndTable()
    end

    if UI.BeginTable("Defense", 3, table_flags) then
        UI.TableSetupColumn("Mitigation", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Rate (%)", col_flags, damage_width)
        UI.TableHeadersRow()

        local evade = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_EVASION, DB.Enum.Metric.HIT_COUNT)
        if evade > 0 then
            UI.TableNextColumn() UI.Text("Evasion")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_EVASION)
        end

        local parry = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_PARRY, DB.Enum.Metric.HIT_COUNT)
        if parry > 0 then
            UI.TableNextColumn() UI.Text("Parry")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_PARRY)
        end

        local shadows = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_SHADOWS, DB.Enum.Metric.HIT_COUNT)
        if shadows > 0 then
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_SHADOWS)
        end

        local counter = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_COUNTER, DB.Enum.Metric.HIT_COUNT)
        if counter > 0 then
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Col.Defense.Damage_Taken_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_COUNTER)
        end

        local guard = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_GUARD, DB.Enum.Metric.HIT_COUNT)
        if guard > 0 then
            UI.TableNextColumn() UI.Text("Guard")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_GUARD)
        end

        local shield = DB.Data.Get(player_name, DB.Enum.Trackable.DEF_BLOCK, DB.Enum.Metric.HIT_COUNT)
        if shield > 0 then
            UI.TableNextColumn() UI.Text("Shield Block")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() Col.Defense.Proc_Rate_By_Type(player_name, DB.Enum.Trackable.DEF_BLOCK)
        end

        if (evade + parry + shadows + counter + guard + shield) == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Single_Data = function(player_name, focus_type)
    if not focus_type then return nil end
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local acc_string = "Accuracy %"
    local damage_string = "Damage"
    local action_string = "Action"
    local attempt_string = "Attempts"
    if focus_type == DB.Enum.Trackable.MAGIC then
        action_string = "Spell"
        acc_string = "Bursts"
        attempt_string = "Casts (MP)"
    elseif focus_type == DB.Enum.Trackable.HEALING then
        action_string = "Spell"
        acc_string = "Overcure"
        damage_string = "Healing"
        attempt_string = "Casts (MP)"
    elseif focus_type == DB.Enum.Trackable.ABILITY or focus_type == DB.Enum.Trackable.PET_ABILITY or focus_type == DB.Enum.Trackable.PET_WS then
        action_string = "Ability"
    elseif focus_type == DB.Enum.Trackable.WS then
        action_string = "Weaponskill"
    elseif focus_type == DB.Enum.Trackable.SC then
        action_string = "Skillchain"
    end

    if UI.BeginTable(focus_type, 7, table_flags) then
        UI.TableSetupColumn(action_string, col_flags, width)
        UI.TableSetupColumn("Total " .. damage_string, col_flags, width)
        UI.TableSetupColumn(attempt_string, col_flags, width)
        UI.TableSetupColumn(acc_string, col_flags, width)
        UI.TableSetupColumn("Avg. " .. damage_string, col_flags, width)
        UI.TableSetupColumn("Min. " .. damage_string, col_flags, width)
        UI.TableSetupColumn("Max. " .. damage_string, col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)
        local action_name
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            f.Display.Util.Single_Row(player_name, action_name, focus_type)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Util.Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.Attempts(player_name, action_name, focus_type)

    -- Accuracy changes between what the trackable is. Accuracy for spells isn't useful.
    if focus_type == DB.Enum.Trackable.NUKE then
        UI.TableNextColumn() Col.Single.Bursts(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.HEALING then
        UI.TableNextColumn() Col.Single.Overcure(player_name, action_name)
    else
        UI.TableNextColumn() Col.Single.Acc(player_name, action_name, focus_type)
    end

    UI.TableNextColumn() Col.Single.Average(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Show healing spell breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Spell_Single = function(player_name, focus_type)
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local name_width = Window.Columns.Widths.Standard
    local width = 65

    -- Error Protection
    if not DB.Tracking.Trackable[focus_type] then return nil end
    if not DB.Tracking.Trackable[focus_type][player_name] then return nil end

    local acc_string = "Acc. %"
    local action = "Spell"
    local damage_string = "Damage"
    if focus_type == DB.Enum.Trackable.NUKE then
        action = "Nuke"
        acc_string = "Bursts"
    elseif focus_type == DB.Enum.Trackable.HEALING then
        action = "Heal"
        acc_string = "Overcure"
        damage_string = "Healing"
    elseif focus_type == DB.Enum.Trackable.ENFEEBLE then
        action = "Enfeeble"
        acc_string = "Land Rate"
    elseif focus_type == DB.Enum.Trackable.ENSPELL then
        action = "Enspell"
        acc_string = "Hits"
    elseif focus_type == DB.Enum.Trackable.OUTGOING_SPIKE_DMG then
        action = "Spikes"
        acc_string = "Procs"
    elseif focus_type == DB.Enum.Trackable.MP_DRAIN then
        action = "MP Drain"
    end

    if UI.BeginTable(focus_type, 9, table_flags) then
        UI.TableSetupColumn(action, col_flags, name_width)
        UI.TableSetupColumn(damage_string, col_flags, width)
        UI.TableSetupColumn("MP Used", col_flags, width)
        UI.TableSetupColumn("Efficacy", col_flags, width)
        UI.TableSetupColumn("Casts", col_flags, width)
        UI.TableSetupColumn(acc_string, col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Min.", col_flags, width)
        UI.TableSetupColumn("Max.", col_flags, width)
        UI.TableHeadersRow()

        DB.Lists.Sort.Catalog_Damage(player_name, focus_type)

        -- Data
        local action_name
        for _, data in ipairs(DB.Sorted.Catalog_Damage) do
            action_name = data[1]
            f.Display.Util.Spell_Single_Row(player_name, action_name, focus_type)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a spell based trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Util.Spell_Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.MP_Used(player_name, action_name, focus_type)
    UI.TableNextColumn() Col.Single.Damage_Per_MP(player_name, action_name, focus_type)
    UI.TableNextColumn() Col.Single.Attempts(player_name, action_name, focus_type)

    -- Accuracy changes between what the trackable is. Accuracy for spells isn't useful.
    if focus_type == DB.Enum.Trackable.NUKE then
        UI.TableNextColumn() Col.Single.Bursts(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.HEALING then
        UI.TableNextColumn() Col.Single.Overcure(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.ENSPELL then
        UI.TableNextColumn() Col.Single.Hit_Count(player_name, DB.Enum.Trackable.ENSPELL, action_name)
    elseif focus_type == DB.Enum.Trackable.OUTGOING_SPIKE_DMG then
        UI.TableNextColumn() Col.Single.Hit_Count(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, action_name)
    else
        UI.TableNextColumn() Col.Single.Acc(player_name, action_name, focus_type)
    end

    UI.TableNextColumn() Col.Single.Average(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
------------------------------------------------------------------------------------------------------
f.Display.Pet_Single_Data = function(player_name, pet_name)
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local damage = Window.Columns.Widths.Standard
    local name_width = Window.Columns.Widths.Standard
    local damage_width = Window.Columns.Widths.Damage
    local percent_width = Window.Columns.Widths.Percent

    if not DB.Tracking.Initialized_Pets[player_name] then
        _Debug.Error.Add("Display.Pet_Single_Data: Tried to loop through pets of unitialized player in the focus window.")
        return nil
    end

    if UI.BeginTable(pet_name, 5, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Damage %", col_flags, percent_width)
        UI.TableSetupColumn("Pet %", col_flags, percent_width)
        UI.TableSetupColumn("Accuracy", col_flags, percent_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET)
        UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET, true, nil, true)
        UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET, true)
        UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")

        local pet_melee = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, DB.Enum.Metric.TOTAL)
        if pet_melee > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Melee")
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET, true, nil, true)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET, true)
            UI.TableNextColumn() Col.Acc.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
        end

        local pet_ranged = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, DB.Enum.Metric.TOTAL)
        if pet_ranged > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Ranged")
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_RANGED)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, true, nil, true)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_RANGED, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local pet_ws = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_WS, DB.Enum.Metric.TOTAL)
        if pet_ws > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Weaponskill")
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS, true, nil, true)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_WS, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local pet_ability = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, DB.Enum.Metric.TOTAL)
        if pet_ability > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Ability")
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, true, nil, true)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_ABILITY, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local pet_magic = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_NUKE, DB.Enum.Metric.TOTAL)
        if pet_magic > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Magic")
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_NUKE)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_NUKE, true, nil, true)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_NUKE, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end

        local pet_healing = DB.Pet_Data.Get(player_name, pet_name, DB.Enum.Trackable.PET_HEAL, DB.Enum.Metric.TOTAL)
        if pet_healing > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_HEAL)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_HEAL, true, nil, true)
            UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, DB.Enum.Trackable.PET_HEAL, true)
            UI.TableNextColumn() UI.TextColored(Window.Colors.DIM, "---")
        end
        UI.EndTable()
    end

    if UI.BeginTable(pet_name.." single", 7, table_flags) then
        UI.TableSetupColumn("Action Name", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, damage_width)
        UI.TableSetupColumn("Attempts", col_flags, percent_width)
        UI.TableSetupColumn("Accuracy", col_flags, percent_width)
        UI.TableSetupColumn("Average", col_flags, damage_width)
        UI.TableSetupColumn("Min.", col_flags, damage_width)
        UI.TableSetupColumn("Max.", col_flags, damage_width)
        UI.TableHeadersRow()

        local has_data = false
        DB.Lists.Sort.Pet_Catalog_Damage(player_name, pet_name)
        for _, data in ipairs(DB.Sorted.Pet_Catalog_Damage) do
            has_data = true
            local action_name = data[1]
            local trackable = data[3]
            f.Display.Util.Pet_Single_Row(player_name, pet_name, action_name, trackable)
        end
        if not has_data then
            f.Display.Util.Pet_Blank_Row()
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Util.Pet_Single_Row = function(player_name, pet_name, action_name, trackable)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.Pet_Attempts(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Col.Single.Pet_Acc(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Col.Single.Pet_Average(player_name, pet_name, action_name, trackable)

    local min = DB.Pet_Catalog.Get(player_name, pet_name, trackable, action_name, DB.Enum.Metric.MIN)
    if min == f.Enum.OVERFLOW then
        UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Metric.MIN)
    end

    UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, DB.Enum.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Creates a blank table row for when pets haven't done ability yet, but you can still see their data.
------------------------------------------------------------------------------------------------------
f.Display.Util.Pet_Blank_Row = function()
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("None")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
end

------------------------------------------------------------------------------------------------------
-- Display a graph of damage types.
-- NOT IMPLEMENTED due to lack of labels on the bar graphs. :(
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Graph = function(player_name)
    local total = Col.Util.Total_Damage(player_name)
    if total <= 0 then return nil end
    local melee = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.MELEE) / total
    local ranged = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.RANGED) / total
    local ws = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.WS) / total
    local sc = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.SC) / total
    local magic = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.MAGIC) / total
    local ability = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.ABILITY) / total
    local pet = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.PET) / total
    local graph_data = {melee, ranged, ws, sc, magic, ability, pet}
    UI.PlotHistogram("Damage Distribution", graph_data, #graph_data, 0, nil, 0, nil, {0, 30})
end

------------------------------------------------------------------------------------------------------
-- Collapse header buttons.
------------------------------------------------------------------------------------------------------
f.Display.Util.Buttons = function()
    f.Display.Flags.Open_Action = -1
    if UI.Button("Expand all") then
        f.Display.Flags.Open_Action = 1
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    if UI.Button("Collapse all") then
        f.Display.Flags.Open_Action = 0
    end
end

------------------------------------------------------------------------------------------------------
-- Works in conjunction with collapse all or expand all.
------------------------------------------------------------------------------------------------------
f.Display.Util.Check_Collapse = function()
    if f.Display.Flags.Open_Action ~= -1 then UI.SetNextItemOpen(f.Display.Flags.Open_Action ~= 0) end
end

return f