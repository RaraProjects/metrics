Focus.Magic = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the magic tab inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Magic.Display = function(player_name)
    local nuke_total     = DB.Data.Get(player_name, DB.Enum.Trackable.NUKE,       DB.Enum.Metric.TOTAL)
    local burst_total    = DB.Data.Get(player_name, DB.Enum.Trackable.MAGIC,      DB.Enum.Metric.BURST_DAMAGE)
    local melee_endamage = DB.Data.Get(player_name, DB.Enum.Trackable.ENDAMAGE,   DB.Enum.Metric.TOTAL)
    local range_endamage = DB.Data.Get(player_name, DB.Enum.Trackable.ENDAMAGE_R, DB.Enum.Metric.TOTAL)
    local endrain        = DB.Data.Get(player_name, DB.Enum.Trackable.ENDRAIN_R,  DB.Enum.Metric.TOTAL)
    local mp_drain       = DB.Data.Get(player_name, DB.Enum.Trackable.MP_DRAIN,   DB.Enum.Metric.TOTAL)
    local healing_total  = DB.Data.Get(player_name, DB.Enum.Trackable.HEALING,    DB.Enum.Metric.TOTAL)
    local enspell_count  = DB.Data.Get(player_name, DB.Enum.Trackable.ENSPELL,    DB.Enum.Metric.COUNT)
    local enfeeble_count = DB.Data.Get(player_name, DB.Enum.Trackable.ENFEEBLE,   DB.Enum.Metric.COUNT)
    local spike_damage   = DB.Data.Get(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, DB.Enum.Metric.TOTAL)
    local misc_count     = DB.Data.Get(player_name, DB.Enum.Trackable.MAGIC,      DB.Enum.Metric.COUNT)

    Focus.Magic.Total(player_name, nuke_total, melee_endamage, range_endamage, enspell_count, endrain, spike_damage)
    Focus.Magic.Auxiliary(player_name, healing_total, burst_total, mp_drain, enfeeble_count, misc_count)
    UI.Separator()
    Focus.Magic.Overcure(player_name, healing_total)
    if healing_total > 0 then UI.Separator() end

    if nuke_total > 0     then Focus.Magic.Single(player_name, DB.Enum.Trackable.NUKE) end
    if healing_total > 0  then Focus.Magic.Single(player_name, DB.Enum.Trackable.HEALING) end
    if enfeeble_count > 0 then Focus.Magic.Single(player_name, DB.Enum.Trackable.ENFEEBLE) end
    if enspell_count > 0  then Focus.Magic.Single(player_name, DB.Enum.Trackable.ENSPELL) end
    if spike_damage > 0   then Focus.Magic.Single(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG) end
    if melee_endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Enum.Trackable.ENDAMAGE, " (M)") end
    if range_endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Enum.Trackable.ENDAMAGE_R, " (R)") end
    if misc_count > 0 and Metrics.Focus.Show_Misc_Actions then Focus.Magic.Single(player_name, DB.Enum.Trackable.MAGIC) end

    Focus.Magic.Publish(player_name, nuke_total, healing_total)
end

------------------------------------------------------------------------------------------------------
-- Loads data to the total magic table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param nuke_total number
---@param melee_endamage number
---@param range_endamage number
---@param enspell_count number
---@param endrain number
---@param spike_damage number
------------------------------------------------------------------------------------------------------
Focus.Magic.Total = function(player_name, nuke_total, melee_endamage, range_endamage, enspell_count, endrain, spike_damage)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Magic", 5, table_flags) then
        UI.TableSetupColumn("Magic", col_flags, name_width)
        UI.TableSetupColumn("Damage", col_flags, width)
        UI.TableSetupColumn("Damage %", col_flags, width)
        UI.TableSetupColumn("MP Used", col_flags, width)
        UI.TableSetupColumn("Efficacy", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, true)
        UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.MAGIC)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")

        if nuke_total > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Nuking")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.NUKE)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.NUKE, true)
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.NUKE)
            UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.NUKE)
        end

        if melee_endamage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-DMG (M)")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENDAMAGE)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENDAMAGE, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if range_endamage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-DMG (R)")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENDAMAGE_R)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENDAMAGE_R, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if enspell_count > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Enspell")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENSPELL)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENSPELL, true)
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.ENSPELL)
            UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.ENSPELL)
        end

        if endrain > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("En-Drain (R)")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENDRAIN_R)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ENDRAIN_R, true)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        if spike_damage > 0 then
            UI.TableNextColumn() UI.Text("Spikes")
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, true)
            UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
            UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the auxiliary magic table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param healing_total number
---@param burst_total number
---@param mp_drain number
---@param enfeeble_count number
---@param misc_count number
------------------------------------------------------------------------------------------------------
Focus.Magic.Auxiliary = function(player_name, healing_total, burst_total, mp_drain, enfeeble_count, misc_count)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if healing_total > 0 or mp_drain > 0 or enfeeble_count > 0 or misc_count > 0 then
        if UI.BeginTable("Aux. Magic", 5, table_flags) then
            UI.TableSetupColumn("Auxiliary", col_flags, name_width)
            UI.TableSetupColumn("Damage", col_flags, width)
            UI.TableSetupColumn("Damage %", col_flags, width)
            UI.TableSetupColumn("MP Used", col_flags, width)
            UI.TableSetupColumn("Efficacy", col_flags, width)
            UI.TableHeadersRow()

            if healing_total > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Healing")
                UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.HEALING)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.HEALING)
                UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.HEALING)

                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Overcure")
                UI.TableNextColumn() Column.Healing.Overcure(player_name)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            end

            if burst_total > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("Magic Burst")
                UI.TableNextColumn() Column.Damage.Burst(player_name)
                UI.TableNextColumn() Column.Damage.Burst(player_name, true)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            end

            if mp_drain > 0 then
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text("MP Drain")
                UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MP_DRAIN)
                UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                UI.TableNextColumn() Column.Spell.MP(player_name, DB.Enum.Trackable.MP_DRAIN)
                UI.TableNextColumn() Column.Spell.Unit_Per_MP(player_name, DB.Enum.Trackable.MP_DRAIN)
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
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up magic publishing buttons from within the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param nuke_total number
---@param healing_total number
------------------------------------------------------------------------------------------------------
Focus.Magic.Publish = function(player_name, nuke_total, healing_total)
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
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

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
    elseif focus_type == DB.Enum.Trackable.ENDAMAGE_R then
        action = "Endamage"
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
        UI.TableSetupColumn("Minimum", col_flags, width)
        UI.TableSetupColumn("Maximum", col_flags, width)
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
    if     focus_type == DB.Enum.Trackable.NUKE       then UI.TableNextColumn() Column.Single.Bursts(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.HEALING    then UI.TableNextColumn() Column.Single.Overcure(player_name, action_name)
    elseif focus_type == DB.Enum.Trackable.ENSPELL    then UI.TableNextColumn() Column.Single.Hit_Count(player_name, DB.Enum.Trackable.ENSPELL, action_name)
    elseif focus_type == DB.Enum.Trackable.ENDAMAGE_R then UI.TableNextColumn() Column.Single.Hit_Count(player_name, DB.Enum.Trackable.ENDAMAGE_R, action_name)
    elseif focus_type == DB.Enum.Trackable.OUTGOING_SPIKE_DMG then UI.TableNextColumn() Column.Single.Hit_Count(player_name, DB.Enum.Trackable.OUTGOING_SPIKE_DMG, action_name)
    else UI.TableNextColumn() Column.Single.Acc(player_name, action_name, focus_type)
    end

    Focus.Catalog.Avg_Min_Max(player_name, action_name, focus_type)
end

------------------------------------------------------------------------------------------------------
-- UNUSED
-- Loads data to the magic burst table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param nuke_total number
------------------------------------------------------------------------------------------------------
Focus.Magic.Burst = function(player_name, nuke_total)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if nuke_total > 0 then
        if UI.BeginTable("Bursts", 3, table_flags) then
            UI.TableSetupColumn("MB Damage", col_flags, name_width)
            UI.TableSetupColumn("Damage %", col_flags, width)
            UI.TableSetupColumn("Magic %", col_flags, width)
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() Column.Damage.Burst(player_name)
            UI.TableNextColumn() Column.Damage.Burst(player_name, true)
            UI.TableNextColumn() Column.Damage.Burst(player_name, true, true)
            UI.EndTable()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- UNUSED
-- Loads data to the overcure table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param healing_total number
------------------------------------------------------------------------------------------------------
Focus.Magic.Overcure = function(player_name, healing_total)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name

    if healing_total > 0 then
        if UI.BeginTable("Overcure", 1, table_flags) then
            UI.TableSetupColumn("Overcure", col_flags, name_width)
            UI.TableHeadersRow()

            UI.TableNextColumn() Column.Healing.Overcure(player_name)
            UI.EndTable()
        end
    end
end