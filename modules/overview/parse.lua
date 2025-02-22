Overview.Parse = { }

------------------------------------------------------------------------------------------------------
-- Overview Content
------------------------------------------------------------------------------------------------------
Overview.Parse.Content = function()
    Parse.Widgets.MaskNames()
    UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.PercentDetails()
    Overview.Parse.Settings()
    UI.Separator()

    if Overview.Settings.Show_Timer   then Overview.Parse.Clock() end
    if Overview.Settings.Show_Melee   then Overview.Parse.Melee() end
    if Overview.Settings.Show_Ranged  then Overview.Parse.Ranged() end
    if Overview.Settings.Weaponskills then Overview.Parse.Weaponskills() end
    if Overview.Settings.Show_Nuking  then Overview.Parse.Nukes() end
    if Overview.Settings.Show_Pets    then Overview.Parse.Pets() end
    if Overview.Settings.Show_Healing then Overview.Parse.Healing() end
    if Overview.Settings.Show_Defense then Overview.Parse.Defense() end
end

------------------------------------------------------------------------------------------------------
-- Parse Overview section selection.
------------------------------------------------------------------------------------------------------
Overview.Parse.Settings = function()
    local colFlags = Column.Flags.None
    local width    = Column.Widths.Name

    if UI.BeginTable("Parse Overview", 5) then
        UI.TableSetupColumn("Col 1", colFlags, width)
        UI.TableSetupColumn("Col 2", colFlags, width)
        UI.TableSetupColumn("Col 3", colFlags, width)
        UI.TableSetupColumn("Col 4", colFlags, width)
        UI.TableSetupColumn("Col 5", colFlags, width)

        UI.TableNextColumn() if UI.Checkbox("Timer",        { Overview.Settings.Show_Timer        }) then Overview.Settings.Show_Timer        = not Overview.Settings.Show_Timer end
        UI.TableNextColumn() if UI.Checkbox("Melee",        { Overview.Settings.Show_Melee        }) then Overview.Settings.Show_Melee        = not Overview.Settings.Show_Melee end
        UI.TableNextColumn() if UI.Checkbox("Ranged",       { Overview.Settings.Show_Ranged       }) then Overview.Settings.Show_Ranged       = not Overview.Settings.Show_Ranged end
        UI.TableNextColumn() if UI.Checkbox("Weaponskills", { Overview.Settings.Show_Weaponskills }) then Overview.Settings.Show_Weaponskills = not Overview.Settings.Show_Weaponskills end
        UI.TableNextColumn() if UI.Checkbox("Nuking",       { Overview.Settings.Show_Nuking       }) then Overview.Settings.Show_Nuking       = not Overview.Settings.Show_Nuking end
        UI.TableNextColumn() if UI.Checkbox("Pets",         { Overview.Settings.Show_Pets         }) then Overview.Settings.Show_Pets         = not Overview.Settings.Show_Pets end
        UI.TableNextColumn() if UI.Checkbox("Healing",      { Overview.Settings.Show_Healing      }) then Overview.Settings.Show_Healing      = not Overview.Settings.Show_Healing end
        UI.TableNextColumn() if UI.Checkbox("Defense",      { Overview.Settings.Show_Defense      }) then Overview.Settings.Show_Defense      = not Overview.Settings.Show_Defense end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Overview Clocks
------------------------------------------------------------------------------------------------------
Overview.Parse.Clock = function()
    local colFlags   = Focus.ColumnFlags
    local tableFlags = Focus.TableFlags
    local nameWidth  = Column.Widths.Name

    if UI.BeginTable("Clocks", 2, tableFlags) then
        UI.TableSetupColumn("Total Time",  colFlags, nameWidth)
        UI.TableSetupColumn("Active Time", colFlags, nameWidth)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(tostring(Timers.Check(Timers.Enum.Names.METRICS)))
        UI.TableNextColumn() UI.Text(tostring(Timers.Check(Timers.Enum.Names.PARSE)))

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse melee overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Melee = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.MELEE_OVERALL

    if UI.BeginTable("Melee", 9, Focus.TableFlags) then
        UI.TableSetupColumn("Melee",    colFlags, nameWidth)
        UI.TableSetupColumn("Damage",   colFlags, width)
        UI.TableSetupColumn("%Party",   colFlags, width)
        UI.TableSetupColumn("Average",  colFlags, width)
        UI.TableSetupColumn("Accuracy", colFlags, width)
        UI.TableSetupColumn("%Crit",    colFlags, width)
        UI.TableSetupColumn("Swings",   colFlags, width)
        UI.TableSetupColumn("Minimum",  colFlags, width)
        UI.TableSetupColumn("Maximum",  colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage     = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, 0, true)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.ATTEMPTS_ON_USE)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MIN)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX)
                    WindowManager.TableRowColor(row)
                    row = row + 1
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse melee overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Ranged = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.RANGED_OVERALL

    if UI.BeginTable("Ranged", 10, Focus.TableFlags) then
        UI.TableSetupColumn("Ranged",    colFlags, nameWidth)
        UI.TableSetupColumn("Damage",    colFlags, width)
        UI.TableSetupColumn("%Party",    colFlags, width)
        UI.TableSetupColumn("Average",   colFlags, width)
        UI.TableSetupColumn("Accuracy",  colFlags, width)
        UI.TableSetupColumn("%Crit",     colFlags, width)
        UI.TableSetupColumn("Shot Dist", colFlags, width)
        UI.TableSetupColumn("Shots",     colFlags, width)
        UI.TableSetupColumn("Minimum",   colFlags, width)
        UI.TableSetupColumn("Maximum",   colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage     = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, 0, true)
                    UI.TableNextColumn() Column.Damage.ShotDistance(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.ATTEMPTS_ON_USE)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MIN)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX)
                    WindowManager.TableRowColor(row)
                    row = row + 1
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse weaponskill overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Weaponskills = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.WEAPONSKILL

    if UI.BeginTable("WS", 10, Focus.TableFlags) then
        UI.TableSetupColumn("Weaponskill", colFlags, nameWidth)
        UI.TableSetupColumn("Damage",      colFlags, width)
        UI.TableSetupColumn("%Party",      colFlags, width)
        UI.TableSetupColumn("Average",     colFlags, width)
        UI.TableSetupColumn("Accuracy",    colFlags, width)
        UI.TableSetupColumn("~TP",         colFlags, width)
        UI.TableSetupColumn("DMG/TP",      colFlags, width)
        UI.TableSetupColumn("Attempts",    colFlags, width)
        UI.TableSetupColumn("Minimum",     colFlags, width)
        UI.TableSetupColumn("Maximum",     colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.PerUnitAverage(playerName, trackable, DB.Metric.TP_SPENT)
                    UI.TableNextColumn() Column.General.Fraction(playerName, trackable, DB.Metric.TOTAL, DB.Metric.TP_SPENT, false, false, true)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.ATTEMPTS_ON_USE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    WindowManager.TableRowColor(1)
                    row = row + 1

                    -- Specific Weaponskills
                    if DB.Tracking.Trackables[trackable] and DB.Tracking.Trackables[trackable][playerName] then
                        local sortedCatalogDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

                        for _, singleData in ipairs(sortedCatalogDamage) do
                            local actionName = singleData[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text(string.format("> %s", tostring(actionName)))
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName)
                            UI.TableNextColumn() Column.General.PercentPartyTotalAction(playerName, actionName, trackable)
                            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
                            UI.TableNextColumn() Column.Acc.ByType(playerName, trackable, nil, false, actionName)
                            UI.TableNextColumn() Column.Damage.PerUnitAverage(playerName, trackable, DB.Metric.TP_SPENT, actionName)
                            UI.TableNextColumn() Column.Damage.PerUnit(playerName, trackable, DB.Metric.TP_SPENT, actionName)
                            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)
                            UI.TableNextColumn() Focus.Catalog.Min(playerName, actionName, trackable)
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX, actionName)
                            WindowManager.TableRowColor(0)
                        end
                    end
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse nuking overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Nukes = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.SPELLS_NUKING

    if UI.BeginTable("Nuke", 9, Focus.TableFlags) then
        UI.TableSetupColumn("Nuke",    colFlags, nameWidth)
        UI.TableSetupColumn("Damage",  colFlags, width)
        UI.TableSetupColumn("%Party",  colFlags, width)
        UI.TableSetupColumn("Average", colFlags, width)
        UI.TableSetupColumn("Bursts",  colFlags, width)
        UI.TableSetupColumn("DMG/MP",  colFlags, width)
        UI.TableSetupColumn("Casts",   colFlags, width)
        UI.TableSetupColumn("Minimum", colFlags, width)
        UI.TableSetupColumn("Maximum", colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAGIC_BURST_COUNT)
                    UI.TableNextColumn() Column.Spell.UnitPerMP(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.HITS_ON_USE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    WindowManager.TableRowColor(1)
                    row = row + 1

                    -- Specific Nuke Spells
                    if DB.Tracking.Trackables[trackable] and DB.Tracking.Trackables[trackable][playerName] then
                        local sortedCatalogDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

                        for _, singleData in ipairs(sortedCatalogDamage) do
                            local actionName = singleData[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text(string.format("> %s", tostring(actionName)))
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName)
                            UI.TableNextColumn() Column.General.PercentPartyTotalAction(playerName, actionName, trackable)
                            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
                            UI.TableNextColumn() Column.Single.Bursts(playerName, actionName)
                            UI.TableNextColumn() Column.Damage.PerUnit(playerName, trackable, DB.Metric.MP_SPENT, actionName)
                            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MIN, actionName)
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX, actionName)
                            WindowManager.TableRowColor(0)
                        end
                    end
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse pet overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Pets = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.PET_OVERALL

    if UI.BeginTable("Pets", 7, Focus.TableFlags) then
        UI.TableSetupColumn("Pet",      colFlags, nameWidth)
        UI.TableSetupColumn("Damage",   colFlags, width)
        UI.TableSetupColumn("%Party",   colFlags, width)
        UI.TableSetupColumn("Accuracy", colFlags, width)
        UI.TableSetupColumn("%Player",  colFlags, width)
        UI.TableSetupColumn("%Melee",   colFlags, width)
        UI.TableSetupColumn("%TP Move", colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    -- Player overall pet damage.
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, DB.Trackable.PET_MELEE_DISCRETE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.PET_MELEE_OVERALL, nil, nil, true)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.PET_TP, nil, nil, true)
                    WindowManager.TableRowColor(1)
                    row = row + 1

                    -- Specific Pets
                    local petName = DB.Enum.DEBUG
                    local petSortedDamage = DB.Lists.GetSortedPetDamage(playerName)

                    for _, petData in ipairs(petSortedDamage) do
                        petName = petData[1]

                        UI.TableNextRow()
                        UI.TableNextColumn() UI.Text(string.format("> %s", tostring(petName)))
                        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, trackable)
                        UI.TableNextColumn() Column.General.PercentPartyTotalPet(playerName, petName, trackable)
                        UI.TableNextColumn() Column.Acc.ByTypePet(playerName, petName, DB.Trackable.PET_MELEE_DISCRETE)
                        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, trackable, true)
                        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, DB.Trackable.PET_MELEE_OVERALL, true)
                        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, DB.Trackable.PET_TP, true)
                        WindowManager.TableRowColor(0)
                    end
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse healing overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Healing = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.SPELLS_HEALING

    if UI.BeginTable("Healing Magic", 9, Focus.TableFlags) then
        UI.TableSetupColumn("Healing",  colFlags, nameWidth)
        UI.TableSetupColumn("HP+",      colFlags, width)
        UI.TableSetupColumn("%Party",   colFlags, width)
        UI.TableSetupColumn("Average",  colFlags, width)
        UI.TableSetupColumn("Overcure", colFlags, width)
        UI.TableSetupColumn("HP+/MP",   colFlags, width)
        UI.TableSetupColumn("Casts",    colFlags, width)
        UI.TableSetupColumn("Minimum",  colFlags, width)
        UI.TableSetupColumn("Maximum",  colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    -- Player Overall
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable)
                    UI.TableNextColumn() Column.Healing.Overcure(playerName)
                    UI.TableNextColumn() Column.Spell.UnitPerMP(playerName, trackable)
                    UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.HITS_ON_USE)
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
                    WindowManager.TableRowColor(1)
                    row = row + 1

                    -- Specific Healing Spells
                    if DB.Tracking.Trackables[trackable] and DB.Tracking.Trackables[trackable][playerName] then
                        local sortedCatalogDamage = DB.Lists.GetSortedCatalogDamage(playerName, trackable)

                        for _, singleData in ipairs(sortedCatalogDamage) do
                            local actionName = singleData[1]

                            UI.TableNextRow()
                            UI.TableNextColumn() UI.Text(string.format("> %s", tostring(actionName)))
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.TOTAL, actionName)
                            UI.TableNextColumn() Column.General.PercentPartyTotalAction(playerName, actionName, trackable)
                            UI.TableNextColumn() Column.Damage.ByTypeAverage(playerName, trackable, nil, actionName)
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.OVERCURE, actionName)
                            UI.TableNextColumn() Column.Damage.PerUnit(playerName, trackable, DB.Metric.MP_SPENT, actionName)
                            UI.TableNextColumn() Column.Damage.Attempts(playerName, trackable, nil, actionName)
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MIN, actionName)
                            UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, DB.Metric.MAX, actionName)
                            WindowManager.TableRowColor(0)
                        end
                    end
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the Parse melee overview.
------------------------------------------------------------------------------------------------------
Overview.Parse.Defense = function()
    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard
    local trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL

    if UI.BeginTable("Defense", 8, Focus.TableFlags) then
        UI.TableSetupColumn("Damage Taken", colFlags, nameWidth)
        UI.TableSetupColumn("HP-",      colFlags, width)
        UI.TableSetupColumn("%Party",   colFlags, width)
        UI.TableSetupColumn("%HP-Rec",  colFlags, width)
        UI.TableSetupColumn("%Melee",   colFlags, width)
        UI.TableSetupColumn("%Magic",   colFlags, width)
        UI.TableSetupColumn("%Mob TP",  colFlags, width)
        UI.TableSetupColumn("%Evasion", colFlags, width)
        UI.TableHeadersRow()

        local sortedDamage = DB.Lists.GetSortedDamage(trackable)
        local row = 1

        for rank, data in ipairs(sortedDamage) do
            if rank <= Parse.Config.RankCutoff() then
                local playerName = data[1]
                local damage = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)

                if damage > 0 then
                    UI.TableNextRow()
                    UI.TableNextColumn() Column.String.FormatName(playerName)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, trackable)
                    UI.TableNextColumn() Column.General.PercentPartyTotal(playerName, DB.Trackable.DEF_HEALING_RECEIVED)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, DB.Trackable.DEF_MELEE, true)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, DB.Trackable.DEF_NUKING, true)
                    UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, DB.Trackable.DEF_TP_MOVE, true)
                    UI.TableNextColumn() Column.Acc.ByType(playerName, DB.Trackable.DEF_EVASION_MELEE, 0)
                    WindowManager.TableRowColor(row)
                    row = row + 1
                end
            end
        end

        if row == 1 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("No data")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end