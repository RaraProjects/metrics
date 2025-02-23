Focus.Defense = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the defense drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Defense.Display = function(playerName)
    Focus.Defense.DamageTaken(playerName)
    Focus.Defense.Auxiliary(playerName)
    Focus.Defense.Mitigation(playerName)
    Focus.Defense.HealingReceived(playerName)

    UI.Separator()

    Focus.Defense.TpMove(playerName, DB.Trackable.DEF_TP_MOVE)
    Focus.Defense.TpMove(playerName, DB.Trackable.DEF_NUKING)

    if Focus.Settings.Show_Misc_Actions then
        Focus.Defense.TpMove(playerName, DB.Trackable.DEF_NO_DAMAGE_SPELLS)
    end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param makeBrief? boolean
------------------------------------------------------------------------------------------------------
Focus.Defense.DamageTaken = function(playerName, makeBrief)
    local colFlags   = Column.Flags.None
    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local melee  = DB.Data.Get(playerName, DB.Trackable.DEF_MELEE,                  DB.Metric.TOTAL)
    local ranged = DB.Data.Get(playerName, DB.Trackable.DEF_RANGED,                 DB.Metric.TOTAL)
    local magic  = DB.Data.Get(playerName, DB.Trackable.DEF_NUKING,                 DB.Metric.TOTAL)
    local tp     = DB.Data.Get(playerName, DB.Trackable.DEF_TP_MOVE,                DB.Metric.TOTAL)
    local pet    = DB.Data.Get(playerName, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL)

    local columns = 5

    if makeBrief then
        columns = columns - 1
    end

    if pet > 0 then
        columns = columns + 1
    end

    if UI.BeginTable("Damage Taken", columns, tableFlags) then
        if makeBrief then
            UI.TableSetupColumn("Damage Taken", colFlags, nameWidth)
            UI.TableSetupColumn("Average",      colFlags, width)
            UI.TableSetupColumn("%Party",       colFlags, width)
            UI.TableSetupColumn("HP-",          colFlags, width)
            if pet > 0 then UI.TableSetupColumn("Pet HP-", colFlags, width) end
        else
            UI.TableSetupColumn("Damage Taken", colFlags, nameWidth)
            UI.TableSetupColumn("Average",      colFlags, width)
            UI.TableSetupColumn("%Player",      colFlags, width)
            UI.TableSetupColumn("%Party",       colFlags, width)
            UI.TableSetupColumn("HP-",          colFlags, width)
            if pet > 0 then UI.TableSetupColumn("Pet HP-", colFlags, width) end
        end
        UI.TableHeadersRow()

        local defenseTrackables =
        {
            { header = "Total",    trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, trackable_pet = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, damage = 1      },
            { header = "- Melee",  trackable = DB.Trackable.DEF_MELEE,              trackable_pet = DB.Trackable.DEF_MELEE_PET,              damage = melee  },
            { header = "- Ranged", trackable = DB.Trackable.DEF_RANGED,             trackable_pet = DB.Trackable.DEF_RANGED_PET,             damage = ranged },
            { header = "- Magic",  trackable = DB.Trackable.DEF_NUKING,             trackable_pet = DB.Trackable.DEF_NUKING_PET,             damage = magic  },
            { header = "- Mob TP", trackable = DB.Trackable.DEF_TP_MOVE,            trackable_pet = DB.Trackable.DEF_TP_MOVE_PET,            damage = tp     },
        }

        for _, data in ipairs(defenseTrackables) do
            if data.damage > 0 then
                UI.TableNextColumn() UI.Text(data.header)

                if makeBrief then
                    UI.TableNextColumn() Column.Defense.AverageDamageByType(playerName, data.trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, data.trackable)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable)
                    if pet > 0 then UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable_pet) end
                else
                    UI.TableNextColumn() Column.Defense.AverageDamageByType(playerName, data.trackable)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable, true)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, data.trackable)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable)
                    if pet > 0 then UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable_pet) end
                end

                if data.header == "Total" then
                    WindowManager.TableRowColor(1)
                else
                    WindowManager.TableRowColor(0)
                end
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows miscellaneous damage breakdown.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Defense.Auxiliary = function(playerName)
    local colFlags   = Column.Flags.None
    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local row = 1

    if UI.BeginTable("Defense Auxiliary", 5, tableFlags) then
        UI.TableSetupColumn("Defense Auxiliary", colFlags, nameWidth)
        UI.TableSetupColumn("Average",           colFlags, width)
        UI.TableSetupColumn("%Player",           colFlags, width)
        UI.TableSetupColumn("%Proc",             colFlags, width)
        UI.TableSetupColumn("HP-",               colFlags, width)
        UI.TableHeadersRow()

        local auxTrackables =
        {
            { header = "Crits",     trackable = DB.Trackable.DEF_CRITICAL,  threshold = 1 },
            { header = "Countered", trackable = DB.Trackable.DEF_COUNTERED, threshold = DB.Data.Get(playerName, DB.Trackable.DEF_COUNTERED, DB.Metric.TOTAL) },
            { header = "Spikes",    trackable = DB.Trackable.DEF_SPIKES,    threshold = DB.Data.Get(playerName, DB.Trackable.DEF_SPIKES, DB.Metric.TOTAL)    },
        }

        for _, data in ipairs(auxTrackables) do
            if data.threshold > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.AverageDamageByType(playerName, data.trackable)
                UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable, true)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows miscellaneous damage breakdown.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Defense.Mitigation = function(playerName)
    local colFlags   = Column.Flags.None
    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    local shieldBlock = DB.Data.Get(playerName, DB.Trackable.DEF_SHIELD_BLOCK, DB.Metric.HITS_ON_TARGET)
    local guard       = DB.Data.Get(playerName, DB.Trackable.DEF_GUARD,        DB.Metric.HITS_ON_TARGET)
    local showDT      = shieldBlock > 0 or guard > 0
    local columns     = 3 + (showDT and 2 or 0)

    local row = 1

    if UI.BeginTable("Defense", columns, tableFlags) then
        UI.TableSetupColumn("Mitigation", colFlags, nameWidth)
        UI.TableSetupColumn("%Proc",      colFlags, width)
        UI.TableSetupColumn("~HP Saved",  colFlags, width)
        if showDT then UI.TableSetupColumn("~Damage", colFlags, width) end
        if showDT then UI.TableSetupColumn("%DT-",    colFlags, width) end
        UI.TableHeadersRow()

        -- Full Mitigation
        local fullMitigationTrackables =
        {
            { header = "Evasion (Melee)",  trackable = DB.Trackable.DEF_EVASION_MELEE          },
            { header = "Evasion (Ranged)", trackable = DB.Trackable.DEF_EVASION_RANGED         },
            { header = "Evasion (TP)",     trackable = DB.Trackable.DEF_EVASION_TP_ACTION      },
            { header = "Parry",            trackable = DB.Trackable.DEF_PARRY                  },
            { header = "Shadows (Melee)",  trackable = DB.Trackable.DEF_SHADOWS_MELEE          },
            { header = "Shadows (Ranged)", trackable = DB.Trackable.DEF_SHADOWS_RANGED         },
            { header = "Shadows (Magic)",  trackable = DB.Trackable.DEF_SHADOWS_MAGIC          },
            { header = "Shadows (TP)",     trackable = DB.Trackable.DEF_SHADOWS_TP_ACTION      },
            { header = "Third Eye",        trackable = DB.Trackable.DEF_THIRD_EYE_ANTICIPATION },
            { header = "Counter",          trackable = DB.Trackable.MELEE_COUNTER              },
        }

        local mitigationFound = false
        for _, data in ipairs(fullMitigationTrackables) do
            if DB.Data.Get(playerName, data.trackable, DB.Metric.HITS_ON_TARGET) > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.DamageMitigation(playerName, data.trackable)
                if showDT then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
                if showDT then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
                WindowManager.TableRowColor(row)
                row = row + 1
                mitigationFound = true
            end
        end

        -- Partial Mitigation
        local partialMitigationTrackables =
        {
            { header = "Guard",        trackable = DB.Trackable.DEF_GUARD        },
            { header = "Shield Block", trackable = DB.Trackable.DEF_SHIELD_BLOCK },
        }

        for _, data in ipairs(partialMitigationTrackables) do
            if DB.Data.Get(playerName, data.trackable, DB.Metric.HITS_ON_TARGET) > 0 then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Acc.ByType(playerName, data.trackable, 0)
                UI.TableNextColumn() Column.Defense.DamageMitigation(playerName, data.trackable)
                if showDT then UI.TableNextColumn() Column.Defense.AverageDamageByType(playerName, data.trackable) end
                if showDT then UI.TableNextColumn() Column.Defense.DamageReduction(playerName, data.trackable) end
                WindowManager.TableRowColor(row)
                row = row + 1
                mitigationFound = true
            end
        end

        -- No mitigation was found.
        -- A Total row doesn't work well with damage mitigation.
        if not mitigationFound then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if showDT then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            if showDT then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows healing received overview stats.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Defense.HealingReceived = function(playerName)
    if not playerName then
        return nil
    end

    -- Error Protection
    local trackable = DB.Trackable.DEF_HEALING_RECEIVED
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    if UI.BeginTable("Healing", 4, tableFlags) then
        UI.TableSetupColumn("Healing Received", colFlags, nameWidth)
        UI.TableSetupColumn("HP+",     colFlags, width)
        UI.TableSetupColumn("Average", colFlags, width)
        UI.TableSetupColumn("MP-",     colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL)
        UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
        UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable)
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]
            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName)
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
            UI.TableNextColumn() Column.Spell.MpUsed(playerName, trackable, actionName)
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable a trackable from the data model.
------------------------------------------------------------------------------------------------------
Focus.Defense.TpMove = function(playerName, trackable)
    if not trackable then
        return nil
    end

    local tableFlags = WindowManager.Table.Flags.FixedBorders
    local colFlags   = Column.Flags.None
    local nameWidth  = Column.Widths.Name
    local width      = Column.Widths.Standard

    -- Error Protection
    if not DB.Tracking.Trackables[trackable] or not DB.Tracking.Trackables[trackable][playerName] then
        return nil
    end

    local actionString = "TP Move"
    local onTarget     = true

    if trackable == DB.Trackable.DEF_NUKING then
        actionString = "Spell - Damaging"
        onTarget     = true

    elseif trackable == DB.Trackable.DEF_NO_DAMAGE_SPELLS then
        actionString = "Spell - Misc"
        onTarget     = true
    end

    if UI.BeginTable(trackable, 6, tableFlags) then
        UI.TableSetupColumn(actionString, colFlags, nameWidth)
        UI.TableSetupColumn("Average",    colFlags, width)
        UI.TableSetupColumn("Tries",      colFlags, width)
        UI.TableSetupColumn("Total",      colFlags, width)
        UI.TableSetupColumn("Minimum",    colFlags, width)
        UI.TableSetupColumn("Maximum",    colFlags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
        UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, nil, onTarget)
        UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, DB.Metric.TOTAL)
        UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, DB.Metric.MAX)
        WindowManager.TableRowColor(1)

        local sortedDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

        for _, data in ipairs(sortedDamage) do
            local actionName = data[1]
            UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName, onTarget)
            UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, DB.Metric.TOTAL, actionName)
            UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, DB.Metric.MIN, actionName)
            UI.TableNextColumn() Column.Damage.ByType(playerName,  trackable, DB.Metric.MAX, actionName)
            WindowManager.TableRowColor(0)
        end

        UI.EndTable()
    end
end