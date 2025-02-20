Focus.Magic = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the magic tab inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName   string
---@param hidePublish? boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.Display = function(playerName, hidePublish)
    local nukeTotal     = DB.Data.Get(playerName, DB.Trackable.SPELLS_NUKING,         DB.Metric.ATTEMPTS_ON_USE)
    local burstTotal    = DB.Data.Get(playerName, DB.Trackable.SPELLS_NUKING,         DB.Metric.CRITICAL_DAMAGE)
    local meleeEndamage = DB.Data.Get(playerName, DB.Trackable.MELEE_ENDAMAGE,        DB.Metric.TOTAL)
    local rangeEndamage = DB.Data.Get(playerName, DB.Trackable.RANGED_ENDAMAGE,       DB.Metric.TOTAL)
    local endrain       = DB.Data.Get(playerName, DB.Trackable.RANGED_ENDRAIN,        DB.Metric.TOTAL)
    local mpDrain       = DB.Data.Get(playerName, DB.Trackable.SPELLS_MP_DRAIN,       DB.Metric.TOTAL)
    local healingTotal  = DB.Data.Get(playerName, DB.Trackable.SPELLS_HEALING,        DB.Metric.TOTAL)
    local debuffRemoval = DB.Data.Get(playerName, DB.Trackable.SPELLS_DEBUFF_REMOVAL, DB.Metric.ATTEMPTS_ON_USE)
    local buff          = DB.Data.Get(playerName, DB.Trackable.SPELLS_BUFFS,          DB.Metric.ATTEMPTS_ON_USE)
    local enspellCount  = DB.Data.Get(playerName, DB.Trackable.MELEE_ENSPELL,         DB.Metric.ATTEMPTS_ON_TARGET)
    local enfeebleCount = DB.Data.Get(playerName, DB.Trackable.SPELLS_ENFEEBLING,     DB.Metric.ATTEMPTS_ON_USE)
    local spikeDamage   = DB.Data.Get(playerName, DB.Trackable.SPELLS_SPIKE_DAMAGE,   DB.Metric.TOTAL)
    local buffSongs     = DB.Data.Get(playerName, DB.Trackable.SPELLS_BUFF_SONG,      DB.Metric.ATTEMPTS_ON_USE)
    local dot           = DB.Data.Get(playerName, DB.Trackable.SPELLS_DOT,            DB.Metric.ATTEMPTS_ON_USE)
    local miscCount     = DB.Data.Get(playerName, DB.Trackable.SPELLS_OVERALL,        DB.Metric.ATTEMPTS_ON_USE)
    local paralyzed     = DB.Data.Get(playerName, DB.Trackable.ALL_PARALYZE,          DB.Metric.HITS_ON_USE)
    local intimidated   = DB.Data.Get(playerName, DB.Trackable.ALL_INTIMIDATE,        DB.Metric.HITS_ON_USE)

    Focus.Magic.Total(playerName, nukeTotal, meleeEndamage, rangeEndamage, enspellCount, endrain, spikeDamage, dot)

    if paralyzed > 0 or intimidated > 0 then
        Focus.Melee.ActionBlocked(playerName, paralyzed, intimidated)
    end

    if nukeTotal > 0     then Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING,       "Nuke (All)") end
    if burstTotal > 0    then Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING,       "Nuke (Bursts)", false, false, true) end
    if dot > 0           then Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_DOT,          "DoTs") end
    if enspellCount > 0  then Focus.Magic.DamagingSpell(playerName, DB.Trackable.MELEE_ENSPELL,       "Enspell") end
    if spikeDamage > 0   then Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_SPIKE_DAMAGE, "Spikes") end
    if meleeEndamage > 0 then Focus.Catalog.Endamage(playerName, DB.Trackable.MELEE_ENDAMAGE,         " (M)") end
    if rangeEndamage > 0 then Focus.Catalog.Endamage(playerName, DB.Trackable.RANGED_ENDAMAGE,        " (R)") end
    if mpDrain > 0       then Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_MP_DRAIN,     "MP Drain") end
    if healingTotal > 0  then Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING,      "Healing") end
    if debuffRemoval > 0 then Focus.Magic.BasicSpell(playerName, DB.Trackable.SPELLS_DEBUFF_REMOVAL,  "Debuff Removal") end
    if buff > 0          then Focus.Magic.BasicSpell(playerName, DB.Trackable.SPELLS_BUFFS,           "Buff Spell") end
    if enfeebleCount > 0 then Focus.Magic.Debuff(playerName) end
    if buffSongs > 0     then Focus.Magic.BasicSpell(playerName, DB.Trackable.SPELLS_BUFF_SONG,       "Buff Songs", true) end
    if miscCount > 0 and Focus.Settings.Show_Misc_Actions then Focus.Magic.BasicSpell(playerName, DB.Trackable.SPELLS_OVERALL, "Misc. Spell") end

    if not hidePublish then
        Focus.Magic.Publish(playerName, nukeTotal, healingTotal)
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the total magic table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName    string
---@param nukeTotal     integer
---@param meleeEndamage integer
---@param rangeEndamage integer
---@param enspellCount  integer
---@param endrain       integer
---@param spikeDamage   integer
---@param dot           integer
------------------------------------------------------------------------------------------------------
Focus.Magic.Total = function(playerName, nukeTotal, meleeEndamage, rangeEndamage, enspellCount, endrain, spikeDamage, dot)
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    if UI.BeginTable("Magic", 5, tableFlags) then
        UI.TableSetupColumn("Magic Overall", colFlags, nameWidth)
        UI.TableSetupColumn("Damage",        colFlags, width)
        UI.TableSetupColumn("%Player",       colFlags, width)
        UI.TableSetupColumn("MP-",           colFlags, width)
        UI.TableSetupColumn("DMG/MP",        colFlags, width)
        UI.TableHeadersRow()

        -- Totals row always shows.
        local trackable = DB.Trackable.SPELLS_OVERALL
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable)
        UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, nil, nil, true)
        UI.TableNextColumn() Column.Spell.MpUsed(playerName,   trackable)
        UI.TableNextColumn() Column.Damage.PerUnit(playerName, trackable, DB.Metric.MP_SPENT)
        WindowManager.TableRowColor(1)

        -- Show damage types that contribute to total damage.
        local damageTypes =
        {
            { header = "Nuking",       trackable = DB.Trackable.SPELLS_NUKING,       damage = nukeTotal     },
            { header = "DoT",          trackable = DB.Trackable.SPELLS_DOT,          damage = dot           },
            { header = "Enspell",      trackable = DB.Trackable.MELEE_ENSPELL,       damage = enspellCount  },
            { header = "Spikes",       trackable = DB.Trackable.SPELLS_SPIKE_DAMAGE, damage = spikeDamage   },
            { header = "En-DMG (M)",   trackable = DB.Trackable.MELEE_ENDAMAGE,      damage = meleeEndamage },
            { header = "En-DMG (R)",   trackable = DB.Trackable.RANGED_ENDAMAGE,     damage = rangeEndamage },
            { header = "En-Drain (R)", trackable = DB.Trackable.RANGED_ENDRAIN,      damage = endrain       },
        }

        for _, data in ipairs(damageTypes) do
            if data.damage > 0 then
                UI.TableNextColumn() UI.Text(string.format("- %s", data.header))
                UI.TableNextColumn() Column.Damage.ByType(playerName,  data.trackable)
                UI.TableNextColumn() Column.Damage.ByType(playerName,  data.trackable, nil, nil, true)
                UI.TableNextColumn() Column.Spell.MpUsed(playerName,   data.trackable)
                UI.TableNextColumn() Column.Damage.PerUnit(playerName, data.trackable, DB.Metric.MP_SPENT)
                WindowManager.TableRowColor(0)
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Show magic burst breakdown by spell.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@param header     string
---@param makeBrief? boolean
---@param hideMP?    boolean
---@param burst?     boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.DamagingSpell = function(playerName, trackable, header, makeBrief, hideMP, burst)
    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local colFlags   = Column.Flags.None
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    -- Default nuking.
    local metricTotal = burst and DB.Metric.CRITICAL_DAMAGE or DB.Metric.TOTAL
    local metricCount = burst and DB.Metric.CRITICAL_COUNT or DB.Metric.ATTEMPTS_ON_USE
    local metricMin   = burst and DB.Metric.CRITICAL_MIN or DB.Metric.MIN
    local metricMax   = burst and DB.Metric.CRITICAL_MAX or DB.Metric.MAX

    local columns = makeBrief and 5 or 9

    if hideMP then
        columns = columns - 2
    end

    if UI.BeginTable("Damaging Spells", columns, tableFlags) then
        UI.TableSetupColumn(header,    colFlags, nameWidth)
        UI.TableSetupColumn("Average", colFlags, width)
        if not makeBrief then UI.TableSetupColumn("%Player", colFlags, width) end
        UI.TableSetupColumn("Casts",   colFlags, width)
        if not makeBrief then UI.TableSetupColumn("Total",   colFlags, width) end
        if not hideMP    then UI.TableSetupColumn("MP-",     colFlags, width) end
        if not hideMP    then UI.TableSetupColumn("DMG/MP",  colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Minimum", colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Maximum", colFlags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName, trackable, metricTotal)
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricTotal, nil, true) end
        UI.TableNextColumn()                       Column.Damage.Attempts(playerName,      trackable, metricCount)
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricTotal) end
        if not hideMP    then UI.TableNextColumn() Column.Spell.MpUsed(playerName,         trackable, nil, burst) end
        if not hideMP    then UI.TableNextColumn() Column.Damage.PerUnit(playerName,       trackable, DB.Metric.MP_SPENT, nil, burst) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricMin) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricMax) end
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]
            local attempts   = DB.Catalog.Get(playerName, trackable, actionName, metricCount) -- Enspell doesn't have ATTEMPTS_ON_USE

            if trackable == DB.Trackable.MELEE_ENSPELL then
                attempts = DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.ATTEMPTS_ON_TARGET)
            end

            if attempts > 0 then
                UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
                UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName, trackable, metricTotal, actionName)
                if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricTotal, actionName, true) end
                UI.TableNextColumn()                       Column.Damage.Attempts(playerName,      trackable, metricCount, actionName)
                if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricTotal, actionName) end
                if not hideMP    then UI.TableNextColumn() Column.Spell.MpUsed(playerName,         trackable, actionName, burst) end
                if not hideMP    then UI.TableNextColumn() Column.Damage.PerUnit(playerName,       trackable, DB.Metric.MP_SPENT, actionName, burst) end
                if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricMin,   actionName) end
                if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, metricMax,   actionName) end
                WindowManager.TableRowColor(0)
            end

        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a list of buff spells for the player in the focus magic section.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@param header     string
---@param makeBrief? boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.NoDamageSpell = function(playerName, trackable, header, makeBrief)
    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local colFlags   = Column.Flags.None
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    -- MP Drain case.
    local totalString  = "MP+"
    local unitString   = "MP+/MP-"
    local showOvercure = false
    local columns      = makeBrief and 4 or 8

    -- Healing case.
    if trackable == DB.Trackable.SPELLS_HEALING then
        totalString  = "HP+"
        unitString   = "HP+/MP-"
        showOvercure = true
        columns      = columns + 1
    end

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    if UI.BeginTable("No damage spells", columns, tableFlags) then
        UI.TableSetupColumn(header,      colFlags, nameWidth)
        UI.TableSetupColumn("Average",   colFlags, width)
        if showOvercure  then UI.TableSetupColumn("Overcure", colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Casts",    colFlags, width) end
        UI.TableSetupColumn(totalString, colFlags, width)
        UI.TableSetupColumn("MP-",       colFlags, width)
        if not makeBrief then UI.TableSetupColumn(unitString, colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Minimum",  colFlags, width) end
        if not makeBrief then UI.TableSetupColumn("Maximum",  colFlags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName, trackable)
        if showOvercure  then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.OVERCURE) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.Attempts(playerName,      trackable) end
        UI.TableNextColumn()                       Column.Damage.ByType(playerName,        trackable)
        UI.TableNextColumn()                       Column.Spell.MpUsed(playerName,         trackable)
        if not makeBrief then UI.TableNextColumn() Column.Damage.PerUnit(playerName,       trackable, DB.Metric.MP_SPENT) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MIN) end
        if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MAX) end
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]
            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn()                       Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
            if showOvercure  then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.OVERCURE, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.Attempts(playerName,      trackable, nil, actionName) end
            UI.TableNextColumn()                       Column.Damage.ByType(playerName,        trackable, nil, actionName)
            UI.TableNextColumn()                       Column.Spell.MpUsed(playerName,         trackable, actionName)
            if not makeBrief then UI.TableNextColumn() Column.Damage.PerUnit(playerName,       trackable, DB.Metric.MP_SPENT, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MIN, actionName) end
            if not makeBrief then UI.TableNextColumn() Column.Damage.ByType(playerName,        trackable, DB.Metric.MAX, actionName) end
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows debuff overview stats.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param hideMP?    boolean hide MP for things like NIN debuffs.
------------------------------------------------------------------------------------------------------
Focus.Magic.Debuff = function(playerName, hideMP)
    if not playerName then
        return nil
    end

    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard
    local trackable  = DB.Trackable.SPELLS_ENFEEBLING

    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local columns = 4

    if hideMP then
        columns = columns - 1
    end

    if UI.BeginTable("Debuffs", columns, tableFlags) then
        UI.TableSetupColumn("Debuff", colFlags, nameWidth)
        UI.TableSetupColumn("%Land",  colFlags, width)
        UI.TableSetupColumn("Casts",  colFlags, width)
        if not hideMP then UI.TableSetupColumn("MP-", colFlags, width) end
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Acc.ByType(playerName, trackable)
        UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable)
        if not hideMP then UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable) end
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]
            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, nil, false, actionName)
            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)
            if not hideMP then UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable, actionName) end
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a list of buff spells for the player in the focus magic section.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@param header     string
---@param noMP?      boolean
------------------------------------------------------------------------------------------------------
Focus.Magic.BasicSpell = function(playerName, trackable, header, noMP)
    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local colFlags   = Column.Flags.None
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local columns = 3

    if noMP then
        columns = columns - 1
    end

    if UI.BeginTable(trackable, columns, tableFlags) then
        UI.TableSetupColumn(header,  colFlags, nameWidth)
        if not noMP then UI.TableSetupColumn("MP-",   colFlags, width) end
        UI.TableSetupColumn("Casts", colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        if not noMP then UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable) end
        UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable)
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]
            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            if not noMP then UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable, actionName) end
            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows buff overview stats.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@param spellList  table
---@param header     string
---@param hideMP?    boolean      hide MP for things like NIN buffs.
------------------------------------------------------------------------------------------------------
Focus.Magic.FromList = function(playerName, trackable, spellList, header, hideMP)
    if not playerName or not spellList then
        return nil
    end

    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local columns = 3

    if hideMP then
        columns = columns - 1
    end

    if UI.BeginTable("Buffs", columns, tableFlags) then
        UI.TableSetupColumn(header,  colFlags, nameWidth)
        UI.TableSetupColumn("Casts", colFlags, width)
        if not hideMP then UI.TableSetupColumn("MP-", colFlags, width) end
        UI.TableHeadersRow()

        local row = 1

        for _, buffName in ipairs(spellList) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(buffName)
            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, buffName)
            if not hideMP then UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable, buffName) end
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up magic publishing buttons from within the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName   string
---@param nukeTotal    number
---@param healingTotal number
------------------------------------------------------------------------------------------------------
Focus.Magic.Publish = function(playerName, nukeTotal, healingTotal)
    if nukeTotal > 0 then
        Report.Widgets.Button(playerName, DB.Trackable.SPELLS_NUKING, "Publish Nuking")
    end

    if healingTotal > 0 then
        if nukeTotal > 0 then
            UI.SameLine() UI.Text(" ") UI.SameLine()
        end

        Report.Widgets.Button(playerName, DB.Trackable.SPELLS_HEALING, "Publish Healing")
    end
end