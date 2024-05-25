Focus.Magic = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the magic drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Magic.Display = function(player_name)
    -- GUI configuration
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard
    local damage_width = Column.Widths.Damage
    local percent_width = Column.Widths.Percent

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
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, true)
        UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.MAGIC)
        UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.MAGIC)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Nuking")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.NUKE)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.NUKE, true)
        UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.NUKE)
        UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.NUKE)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Healing")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.HEALING)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.HEALING, true)
        UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.HEALING)
        UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.HEALING)

        if mp_drain > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("MP Drain")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MP_DRAIN)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.MP_DRAIN)
            UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.MP_DRAIN)
        end

        if enspell_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Enspell")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENSPELL)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENSPELL, true)
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.ENSPELL)
            UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.ENSPELL)
        end

        if spike_damage > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, true)
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
            UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
        end

        if enfeeble_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Enfeebling")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.ENFEEBLE)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if misc_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Other")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() Column.Spell.MP(player_name, "Other")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
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
            UI.TableNextColumn() Column.Damage.Burst(player_name)
            UI.TableNextColumn() Column.Damage.Burst(player_name, true)
            UI.TableNextColumn() Column.Damage.Burst(player_name, true, true)
            UI.EndTable()
        end
    end

    -- Healing
    if healing_total > 0 then
        if UI.BeginTable("Overcure", 1, table_flags) then
            UI.TableSetupColumn("Overcure", col_flags, damage_width)
            UI.TableHeadersRow()

            UI.TableNextColumn() Column.Healing.Overcure(player_name)
            UI.EndTable()
        end
    end

    -- Cataloged data
    if nuke_total > 0 then Focus.Magic.Single(player_name, DB.Enum.Trackable.NUKE) end
    if healing_total > 0 then Focus.Magic.Single(player_name, DB.Enum.Trackable.HEALING) end
    if enfeeble_count > 0 then Focus.Magic.Single(player_name, DB.Enum.Trackable.ENFEEBLE) end
    if enspell_count > 0 then Focus.Magic.Single(player_name, DB.Enum.Trackable.ENSPELL) end
    if spike_damage > 0 then Focus.Magic.Single(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG) end
    if misc_count > 0 and Metrics.Focus.Show_Misc_Actions then Focus.Magic.Single(player_name, DB.Enum.Trackable.MAGIC) end

    -- Publish buttons
    if nuke_total > 0 then
        Report.Widgets.Button(player_name, DB.Enum.Trackable.NUKE, "Publish Nuking")
    end
    if healing_total > 0 then
        if nuke_total > 0 then UI.SameLine() UI.Text(" ") UI.SameLine() end
        Report.Widgets.Button(player_name, DB.Enum.Trackable.HEALING, "Publish Healing")
    end
end

------------------------------------------------------------------------------------------------------
-- Show healing spell breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Magic.Single = function(player_name, focus_type)
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Column.Flags.None
    local name_width = Column.Widths.Standard
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
            Focus.Magic.Single_Row(player_name, action_name, focus_type)
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
Focus.Magic.Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.TOTAL)
    UI.TableNextColumn() Column.Single.MP_Used(player_name, action_name, focus_type)
    UI.TableNextColumn() Column.Single.Damage_Per_MP(player_name, action_name, focus_type)
    UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, focus_type)

    -- Accuracy changes between what the trackable is. Accuracy for spells isn't useful.
    if focus_type == DB.Enum.Trackable.NUKE then
        UI.TableNextColumn() Column.Single.Bursts(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.HEALING then
        UI.TableNextColumn() Column.Single.Overcure(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.ENSPELL then
        UI.TableNextColumn() Column.Single.Hit_Count(player_name, DB.Enum.Trackable.ENSPELL, action_name)
    elseif focus_type == DB.Enum.Trackable.OUTGOING_SPIKE_DMG then
        UI.TableNextColumn() Column.Single.Hit_Count(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, action_name)
    else
        UI.TableNextColumn() Column.Single.Acc(player_name, action_name, focus_type)
    end

    UI.TableNextColumn() Column.Single.Average(player_name, action_name, focus_type)
    local min = DB.Catalog.Get(player_name, focus_type, action_name, DB.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Values.IGNORE)
    else
        UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Column.Single.Damage(player_name, action_name, focus_type, DB.Enum.Metric.MAX)
end
