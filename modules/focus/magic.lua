Focus.Magic = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the magic tab inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.Display = function(player_name, hide_publish)
    local nuke_total     = DB.Data.Get(player_name, DB.Trackable.SPELLS_NUKING,         DB.Metric.ATTEMPTS_ON_USE)
    local burst_total    = DB.Data.Get(player_name, DB.Trackable.SPELLS_NUKING,         DB.Metric.CRITICAL_DAMAGE)
    local melee_endamage = DB.Data.Get(player_name, DB.Trackable.MELEE_ENDAMAGE,        DB.Metric.TOTAL)
    local range_endamage = DB.Data.Get(player_name, DB.Trackable.RANGED_ENDAMAGE,       DB.Metric.TOTAL)
    local endrain        = DB.Data.Get(player_name, DB.Trackable.RANGED_ENDRAIN,        DB.Metric.TOTAL)
    local mp_drain       = DB.Data.Get(player_name, DB.Trackable.SPELLS_MP_DRAIN,       DB.Metric.TOTAL)
    local healing_total  = DB.Data.Get(player_name, DB.Trackable.SPELLS_HEALING,        DB.Metric.TOTAL)
    local debuff_removal = DB.Data.Get(player_name, DB.Trackable.SPELLS_DEBUFF_REMOVAL, DB.Metric.ATTEMPTS_ON_USE)
    local buff           = DB.Data.Get(player_name, DB.Trackable.SPELLS_BUFFS,          DB.Metric.ATTEMPTS_ON_USE)
    local enspell_count  = DB.Data.Get(player_name, DB.Trackable.MELEE_ENSPELL,         DB.Metric.ATTEMPTS_ON_TARGET)
    local enfeeble_count = DB.Data.Get(player_name, DB.Trackable.SPELLS_ENFEEBLING,     DB.Metric.ATTEMPTS_ON_USE)
    local spike_damage   = DB.Data.Get(player_name, DB.Trackable.SPELLS_SPIKE_DAMAGE,   DB.Metric.TOTAL)
    local buff_songs     = DB.Data.Get(player_name, DB.Trackable.SPELLS_BUFF_SONG,      DB.Metric.ATTEMPTS_ON_USE)
    local dot            = DB.Data.Get(player_name, DB.Trackable.SPELLS_DOT,            DB.Metric.ATTEMPTS_ON_USE)
    local misc_count     = DB.Data.Get(player_name, DB.Trackable.SPELLS_OVERALL,        DB.Metric.ATTEMPTS_ON_USE)
    local paralyzed      = DB.Data.Get(player_name, DB.Trackable.ALL_PARALYZE,          DB.Metric.HITS_ON_USE)
    local intimidated    = DB.Data.Get(player_name, DB.Trackable.ALL_INTIMIDATE,        DB.Metric.HITS_ON_USE)

    Focus.Magic.Total(player_name, nuke_total, melee_endamage, range_endamage, enspell_count, endrain, spike_damage, dot, burst_total)
    if paralyzed > 0 or intimidated > 0 then Focus.Melee.Action_Blocked(player_name, paralyzed, intimidated) end

    if nuke_total > 0     then Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING,       "Nuke (All)") end
    if burst_total > 0    then Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING,       "Nuke (Bursts)", false, false, true) end
    if dot > 0            then Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_DOT,          "DoTs") end
    if enspell_count > 0  then Focus.Magic.Damaging_Spell(player_name, DB.Trackable.MELEE_ENSPELL,       "Enspell") end
    if spike_damage > 0   then Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_SPIKE_DAMAGE, "Spikes") end
    if melee_endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Trackable.MELEE_ENDAMAGE,          " (M)") end
    if range_endamage > 0 then Focus.Catalog.Endamage(player_name, DB.Trackable.RANGED_ENDAMAGE,         " (R)") end
    if mp_drain > 0       then Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_MP_DRAIN,    "MP Drain") end
    if healing_total > 0  then Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING,     "Healing") end
    if debuff_removal > 0 then Focus.Magic.Basic_Spell(player_name, DB.Trackable.SPELLS_DEBUFF_REMOVAL,  "Debuff Removal") end
    if buff > 0           then Focus.Magic.Basic_Spell(player_name, DB.Trackable.SPELLS_BUFFS,           "Buff Spell") end
    if enfeeble_count > 0 then Focus.Magic.Debuff(player_name) end
    if buff_songs > 0     then Focus.Magic.Basic_Spell(player_name, DB.Trackable.SPELLS_BUFF_SONG,       "Buff Songs", true) end
    if misc_count > 0 and Focus.Settings.Show_Misc_Actions then Focus.Magic.Basic_Spell(player_name, DB.Trackable.SPELLS_OVERALL, "Misc. Spell") end

    if not hide_publish then Focus.Magic.Publish(player_name, nuke_total, healing_total) end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the total magic table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param nuke_total integer
---@param melee_endamage integer
---@param range_endamage integer
---@param enspell_count integer
---@param endrain integer
---@param spike_damage integer
---@param dot integer
---@param burst integer
------------------------------------------------------------------------------------------------------
Focus.Magic.Total = function(player_name, nuke_total, melee_endamage, range_endamage, enspell_count, endrain, spike_damage, dot, burst)
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    if UI.BeginTable("Magic", 5, table_flags) then
        UI.TableSetupColumn("Magic Overall", col_flags, name_width)
        UI.TableSetupColumn("Damage",  col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("MP-",     col_flags, width)
        UI.TableSetupColumn("DMG/MP",  col_flags, width)
        UI.TableHeadersRow()

        -- Totals row always shows.
        local trackable = DB.Trackable.SPELLS_OVERALL
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.By_Type(player_name,  trackable)
        UI.TableNextColumn() Column.Damage.By_Type(player_name,  trackable, nil, nil, true)
        UI.TableNextColumn() Column.Spell.MP_Used(player_name,   trackable)
        UI.TableNextColumn() Column.Damage.Per_Unit(player_name, trackable, DB.Metric.MP_SPENT)
        Window_Manager.Table_Row_Color(1)

        -- Show damage types that contribute to total damage.
        local damage_types = {}
        table.insert(damage_types, {header = "Nuking",       trackable = DB.Trackable.SPELLS_NUKING,       damage = nuke_total})
        table.insert(damage_types, {header = "DoT",          trackable = DB.Trackable.SPELLS_DOT,          damage = dot})
        table.insert(damage_types, {header = "Enspell",      trackable = DB.Trackable.MELEE_ENSPELL,       damage = enspell_count})
        table.insert(damage_types, {header = "Spikes",       trackable = DB.Trackable.SPELLS_SPIKE_DAMAGE, damage = spike_damage})
        table.insert(damage_types, {header = "En-DMG (M)",   trackable = DB.Trackable.MELEE_ENDAMAGE,      damage = melee_endamage})
        table.insert(damage_types, {header = "En-DMG (R)",   trackable = DB.Trackable.RANGED_ENDAMAGE,     damage = range_endamage})
        table.insert(damage_types, {header = "En-Drain (R)", trackable = DB.Trackable.RANGED_ENDRAIN,      damage = endrain})

        for _, data in ipairs(damage_types) do
            if data.damage > 0 then
                UI.TableNextColumn() UI.Text("- " .. data.header)
                UI.TableNextColumn() Column.Damage.By_Type(player_name,  data.trackable)
                UI.TableNextColumn() Column.Damage.By_Type(player_name,  data.trackable, nil, nil, true)
                UI.TableNextColumn() Column.Spell.MP_Used(player_name,   data.trackable)
                UI.TableNextColumn() Column.Damage.Per_Unit(player_name, data.trackable, DB.Metric.MP_SPENT)
                Window_Manager.Table_Row_Color(0)
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Show magic burst breakdown by spell.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param header string
---@param make_brief? boolean
---@param hide_mp? boolean
---@param burst? boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.Damaging_Spell = function(player_name, trackable, header, make_brief, hide_mp, burst)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] then return nil end
    if not DB.Tracking.Trackables[trackable][player_name] then return nil end

    -- Default nuking.
    local metric_total = DB.Metric.TOTAL
    local metric_count = DB.Metric.ATTEMPTS_ON_USE
    local metric_min   = DB.Metric.MIN
    local metric_max   = DB.Metric.MAX

    -- Magic burst.
    if burst then
        metric_total = DB.Metric.CRITICAL_DAMAGE
        metric_count = DB.Metric.CRITICAL_COUNT
        metric_min   = DB.Metric.CRITICAL_MIN
        metric_max   = DB.Metric.CRITICAL_MAX
    end

    local columns = 9
    if make_brief then columns = 5 end
    if hide_mp then columns = columns - 2 end

    if UI.BeginTable("Damaging Spells", columns, table_flags) then
        UI.TableSetupColumn(header,    col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        if not make_brief then UI.TableSetupColumn("%Player", col_flags, width) end
        UI.TableSetupColumn("Casts",   col_flags, width)
        if not make_brief then UI.TableSetupColumn("Total",   col_flags, width) end
        if not hide_mp    then UI.TableSetupColumn("MP-",     col_flags, width) end
        if not hide_mp    then UI.TableSetupColumn("DMG/MP",  col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Minimum", col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Maximum", col_flags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name, trackable, metric_total)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_total, nil, true) end
        UI.TableNextColumn()                        Column.Damage.Attempts(player_name,        trackable, metric_count)
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_total) end
        if not hide_mp    then UI.TableNextColumn() Column.Spell.MP_Used(player_name,          trackable, nil, burst) end
        if not hide_mp    then UI.TableNextColumn() Column.Damage.Per_Unit(player_name,        trackable, DB.Metric.MP_SPENT, nil, burst) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_min) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_max) end
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.GetSortedCatalogDamage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]

            -- Enspell doesn't have ATTEMPTS_ON_USE
            local attempts = DB.Catalog.Get(player_name, trackable, action_name, metric_count)
            if trackable == DB.Trackable.MELEE_ENSPELL then attempts = DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.ATTEMPTS_ON_TARGET) end

            if attempts > 0 then
                UI.TableNextColumn() UI.Text("- " .. action_name)
                UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name, trackable, metric_total, action_name)
                if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_total, action_name, true) end
                UI.TableNextColumn()                        Column.Damage.Attempts(player_name,        trackable, metric_count, action_name)
                if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_total, action_name) end
                if not hide_mp    then UI.TableNextColumn() Column.Spell.MP_Used(player_name,          trackable, action_name, burst) end
                if not hide_mp    then UI.TableNextColumn() Column.Damage.Per_Unit(player_name,        trackable, DB.Metric.MP_SPENT, action_name, burst) end
                if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_min, action_name) end
                if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, metric_max, action_name) end
                Window_Manager.Table_Row_Color(0)
            end

        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a list of buff spells for the player in the focus magic section.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param header string
---@param make_brief? boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.No_Damage_Spell = function(player_name, trackable, header, make_brief)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    -- MP Drain case.
    local total_string = "MP+"
    local unit_string = "MP+/MP-"
    local show_overcure = false
    local columns = 8
    if make_brief then columns = 4 end

    -- Healing case.
    if trackable == DB.Trackable.SPELLS_HEALING then
        total_string = "HP+"
        unit_string = "HP+/MP-"
        show_overcure = true
        columns = columns + 1
    end

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] then return nil end
    if not DB.Tracking.Trackables[trackable][player_name] then return nil end

    if UI.BeginTable("No damage spells", columns, table_flags) then
        UI.TableSetupColumn(header,       col_flags, name_width)
        UI.TableSetupColumn("Average",    col_flags, width)
        if show_overcure  then UI.TableSetupColumn("Overcure",  col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Casts",     col_flags, width) end
        UI.TableSetupColumn(total_string, col_flags, width)
        UI.TableSetupColumn("MP-",        col_flags, width)
        if not make_brief then UI.TableSetupColumn(unit_string, col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Minimum",   col_flags, width) end
        if not make_brief then UI.TableSetupColumn("Maximum",   col_flags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name, trackable)
        if show_overcure  then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.OVERCURE) end
        if not make_brief then UI.TableNextColumn() Column.Damage.Attempts(player_name,        trackable) end
        UI.TableNextColumn()                        Column.Damage.By_Type(player_name,         trackable)
        UI.TableNextColumn()                        Column.Spell.MP_Used(player_name,          trackable)
        if not make_brief then UI.TableNextColumn() Column.Damage.Per_Unit(player_name,        trackable, DB.Metric.MP_SPENT) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MIN) end
        if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MAX) end
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.GetSortedCatalogDamage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn()                        Column.Damage.By_Type_Average(player_name, trackable, nil, action_name)
            if show_overcure  then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.OVERCURE, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.Attempts(player_name,        trackable, nil, action_name) end
            UI.TableNextColumn()                        Column.Damage.By_Type(player_name,         trackable, nil, action_name)
            UI.TableNextColumn()                        Column.Spell.MP_Used(player_name,          trackable, action_name)
            if not make_brief then UI.TableNextColumn() Column.Damage.Per_Unit(player_name,        trackable, DB.Metric.MP_SPENT, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MIN, action_name) end
            if not make_brief then UI.TableNextColumn() Column.Damage.By_Type(player_name,         trackable, DB.Metric.MAX, action_name) end
            Window_Manager.Table_Row_Color(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows debuff overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_mp? boolean hide MP for things like NIN debuffs.
------------------------------------------------------------------------------------------------------
Focus.Magic.Debuff = function(player_name, hide_mp)
    if not player_name then return nil end

    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local trackable = DB.Trackable.SPELLS_ENFEEBLING
    if not DB.Tracking.Trackables[trackable] then return nil end
    if not DB.Tracking.Trackables[trackable][player_name] then return nil end

    local columns = 4
    if hide_mp then columns = columns - 1 end

    if UI.BeginTable("Debuffs", columns, table_flags) then
        UI.TableSetupColumn("Debuff", col_flags, name_width)
        UI.TableSetupColumn("%Land",  col_flags, width)
        UI.TableSetupColumn("Casts",  col_flags, width)
        if not hide_mp then UI.TableSetupColumn("MP-", col_flags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable)
        UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable)
        if not hide_mp then UI.TableNextColumn() Column.Spell.MP_Used(player_name, trackable) end
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.GetSortedCatalogDamage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, trackable, nil, false, action_name)
            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
            if not hide_mp then UI.TableNextColumn() Column.Spell.MP_Used(player_name, trackable, action_name) end
            Window_Manager.Table_Row_Color(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a list of buff spells for the player in the focus magic section.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param header string
---@param no_mp? boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.Basic_Spell = function(player_name, trackable, header, no_mp)
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local col_flags   = Column.Flags.None
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] then return nil end
    if not DB.Tracking.Trackables[trackable][player_name] then return nil end

    local columns = 3
    if no_mp then columns = columns - 1 end

    if UI.BeginTable(trackable, columns, table_flags) then
        UI.TableSetupColumn(header,  col_flags, name_width)
        if not no_mp then UI.TableSetupColumn("MP-",   col_flags, width) end
        UI.TableSetupColumn("Casts", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        if not no_mp then UI.TableNextColumn() Column.Spell.MP_Used(player_name, trackable) end
        UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable)
        Window_Manager.Table_Row_Color(1)

        local sorted_damage = DB.Lists.GetSortedCatalogDamage(player_name, trackable)
        local action_name
        for _, data in ipairs(sorted_damage) do
            action_name = data[1]
            UI.TableNextColumn() UI.Text("- " .. action_name)
            if not no_mp then UI.TableNextColumn() Column.Spell.MP_Used(player_name, trackable, action_name) end
            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, action_name)
            Window_Manager.Table_Row_Color(0)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows buff overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param spell_list table
---@param header string
---@param hide_mp? boolean hide MP for things like NIN buffs.
------------------------------------------------------------------------------------------------------
Focus.Magic.From_List = function(player_name, trackable, spell_list, header, hide_mp)
    if not player_name or not spell_list then return nil end

    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local columns = 3
    if hide_mp then columns = columns - 1 end

    if UI.BeginTable("Buffs", columns, table_flags) then
        UI.TableSetupColumn(header,  col_flags, name_width)
        UI.TableSetupColumn("Casts", col_flags, width)
        if not hide_mp then UI.TableSetupColumn("MP-", col_flags, width) end
        UI.TableHeadersRow()

        local row = 1
        for _, buff_name in ipairs(spell_list) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(buff_name)
            UI.TableNextColumn() Column.Damage.Attempts(player_name, trackable, nil, buff_name)
            if not hide_mp then UI.TableNextColumn() Column.Spell.MP_Used(player_name, trackable, buff_name) end
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
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
        Report.Widgets.Button(player_name, DB.Trackable.SPELLS_NUKING, "Publish Nuking")
    end
    if healing_total > 0 then
        if nuke_total > 0 then UI.SameLine() UI.Text(" ") UI.SameLine() end
        Report.Widgets.Button(player_name, DB.Trackable.SPELLS_HEALING, "Publish Healing")
    end
end