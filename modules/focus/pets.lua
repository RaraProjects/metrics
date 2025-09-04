Focus.Pets = { }

------------------------------------------------------------------------------------------------------
-- Loads data to the pet drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Pets.Display = function(playerName)
    Focus.Pets.Total(playerName)
    Focus.Pets.DamageTaken(playerName)

    -- Pet specific subtabs.
    local petTotal   = DB.Data.Get(playerName, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    local petHealing = DB.Data.Get(playerName, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)

    if (petTotal <= 0 and petHealing <= 0) or not DB.Tracking.InitializedPets[playerName] then
        return nil
    end

    if UI.BeginTabBar("Pet Tabs", WindowManager.Tabs.Flags) then
        for petName, _ in pairs(DB.Tracking.InitializedPets[playerName]) do
            if UI.BeginTabItem(petName) then
                Focus.Pets.PetSubTab(playerName, petName)
                UI.EndTabItem()
            end
        end

        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Displays the breakdown of pet damage.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Pets.Total = function(playerName)
    local colFlags  = Column.Flags.None
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    local row = 1

    if UI.BeginTable("Pets Melee", 4, WindowManager.Table.Flags.FixedBorders) then
        UI.TableSetupColumn("Pets Overall", colFlags, nameWidth)
        UI.TableSetupColumn("Damage",       colFlags, width)
        UI.TableSetupColumn("%Player",      colFlags, width)
        UI.TableSetupColumn("Accuracy",     colFlags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.PET_OVERALL

        UI.TableNextColumn() UI.Text("Total Damage")
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable)
        UI.TableNextColumn() Column.Damage.ByType(playerName, trackable, nil, nil, true)
        UI.TableNextColumn() Column.Acc.ByType(playerName,    trackable)
        WindowManager.TableRowColor(row)
        row = row + 1

        local damageTypes =
        {
            { header = "Melee",   trackable = DB.Trackable.PET_MELEE_OVERALL  },
            { header = "Ranged",  trackable = DB.Trackable.PET_RANGED_OVERALL },
            { header = "Magic",   trackable = DB.Trackable.PET_NUKING         },
            { header = "TP Move", trackable = DB.Trackable.PET_TP             },
        }

        for _, data in ipairs(damageTypes) do
            if DB.Data.Get(playerName, data.trackable, DB.Metric.TOTAL) > 0 then
                UI.TableNextColumn() UI.Text(string.format("- %s", data.header))
                UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable)
                UI.TableNextColumn() Column.Damage.ByType(playerName, data.trackable, nil, nil, true)
                UI.TableNextColumn() Column.Acc.ByType(playerName,    data.trackable)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        local healing = DB.Data.Get(playerName, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)

        if healing > 0 then
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() Column.Damage.HealingPlayer(playerName, nil, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows damage taken breakdown.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Pets.DamageTaken = function(playerName)
    local colFlags  = Column.Flags.None
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    local row = 1

    if UI.BeginTable("Pet Damage Taken", 2, WindowManager.Table.Flags.FixedBorders) then
        UI.TableSetupColumn("Damage Taken", colFlags, nameWidth)
        UI.TableSetupColumn("Pet HP-",      colFlags, width)
        UI.TableHeadersRow()

        local damageTypes =
        {
            { header = "Total Damage", trackable = DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, damage = -1 },
            { header = "- Melee",      trackable = DB.Trackable.DEF_MELEE_PET,              damage = 0  },
            { header = "- Magic",      trackable = DB.Trackable.DEF_NUKING_PET,             damage = 0  },
            { header = "- TP Move",    trackable = DB.Trackable.DEF_TP_MOVE_PET,            damage = 0  },
        }

        for _, data in ipairs(damageTypes) do
            if DB.Data.Get(playerName, data.trackable, DB.Metric.TOTAL) > data.damage then
                UI.TableNextColumn() UI.Text(data.header)
                UI.TableNextColumn() Column.Defense.DamageTakenByType(playerName, data.trackable)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param playerName string owner of the pet.
---@param petName    string
------------------------------------------------------------------------------------------------------
Focus.Pets.PetSubTab = function(playerName, petName)
    if not DB.Tracking.InitializedPets[playerName] then
        Debug.Error.Add(Debug.Error.ERROR, "Focus.Pets.Single", "Tried to loop through pets of unitialized player in the focus window.")
        return nil
    end

    Focus.Pets.PetSpecificTotal(playerName, petName)
    Focus.Pets.PetSpecificTPMoves(playerName, petName, DB.Trackable.PET_TP, "TP Move")

    local trackable = DB.Trackable.PET_NUKING
    local nuking = DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL) > 0

    if nuking then
        Focus.Pets.PetSpecificTPMoves(playerName, petName, trackable, "Nuking")
    end

    trackable = DB.Trackable.PET_ENFEEBLING
    local enfeeble = DB.PetData.Get(playerName, petName, trackable, DB.Metric.HITS_ON_USE) > 0

    if enfeeble then
        Focus.Pets.PetSpecificNonDamagingSpells(playerName, petName, trackable, "Enfeebling")
    end

    trackable = DB.Trackable.PET_HEALING
    local healing = DB.PetData.Get(playerName, petName, trackable, DB.Metric.TOTAL) > 0

    if healing then
        Focus.Pets.PetSpecificTPMoves(playerName, petName, trackable, "Healing")
    end

    trackable = DB.Trackable.PET_SPELL_BUFFS
    local buffs = DB.PetData.Get(playerName, petName, trackable, DB.Metric.HITS_ON_USE) > 0

    if buffs then
        Focus.Pets.PetSpecificNonDamagingSpells(playerName, petName, trackable, "Buffs", true)
    end
end

------------------------------------------------------------------------------------------------------
-- Breaks down individual pet damage.
------------------------------------------------------------------------------------------------------
---@param playerName string owner of the pet.
---@param petName    string
------------------------------------------------------------------------------------------------------
Focus.Pets.PetSpecificTotal = function(playerName, petName)
    local colFlags  = Column.Flags.None
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    local row = 1

    if UI.BeginTable(petName, 5, WindowManager.Table.Flags.FixedBorders) then
        UI.TableSetupColumn("Damage Type", colFlags, nameWidth)
        UI.TableSetupColumn("Damage",      colFlags, width)
        UI.TableSetupColumn("%Player",     colFlags, width)
        UI.TableSetupColumn("%Pet",        colFlags, width)
        UI.TableSetupColumn("Accuracy",    colFlags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.PET_OVERALL

        UI.TableNextColumn() UI.Text("Total Damage")
        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, trackable)
        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, trackable, true, nil, true)
        UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, trackable, true)
        UI.TableNextColumn() Column.Acc.ByTypePet(playerName, petName, trackable)
        WindowManager.TableRowColor(row)
        row = row + 1

        local damageTypes =
        {
            { header = "Melee",   trackable = DB.Trackable.PET_MELEE_OVERALL },
            { header = "Ranged",  trackable = DB.Trackable.PET_RANGED_OVERALL},
            { header = "Magic",   trackable = DB.Trackable.PET_NUKING        },
            { header = "TP Move", trackable = DB.Trackable.PET_TP            },
        }

        for _, data in ipairs(damageTypes) do
            if DB.PetData.Get(playerName, petName, data.trackable, DB.Metric.TOTAL) > 0 then
                UI.TableNextColumn() UI.Text(string.format("- %s", data.header))
                UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, data.trackable)
                UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, data.trackable, true, nil, true)
                UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, data.trackable, true)
                UI.TableNextColumn() Column.Acc.ByTypePet(playerName,    petName, data.trackable)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        local petHealing = DB.PetData.Get(playerName, petName, DB.Trackable.PET_HEALING, DB.Metric.TOTAL)

        if petHealing > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Healing")
            UI.TableNextColumn() Column.Damage.PetByType(playerName, petName, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() Column.Damage.HealingPlayer(playerName, petName, DB.Trackable.PET_HEALING)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            WindowManager.TableRowColor(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Lists out specific pet's TP moves.
------------------------------------------------------------------------------------------------------
---@param playerName string       owner of the pet.
---@param petName    string
---@param trackable  DB.Trackable
---@param header     string
------------------------------------------------------------------------------------------------------
Focus.Pets.PetSpecificTPMoves = function(playerName, petName, trackable, header)
    if not playerName or not petName then
        return nil
    end

    local colFlags  = Column.Flags.None
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    trackable          = trackable or DB.Trackable.PET_TP
    local damageString = (trackable == DB.Trackable.PET_HEALING) and "HP+" or "Damage"

    if UI.BeginTable(string.format("%s single", petName), 8, WindowManager.Table.Flags.FixedBorders) then
        UI.TableSetupColumn(tostring(header), colFlags, nameWidth)
        UI.TableSetupColumn("Average",     colFlags, width)
        UI.TableSetupColumn("Accuracy",    colFlags, width)
        UI.TableSetupColumn("Attempts",    colFlags, width)
        UI.TableSetupColumn("~TP",         colFlags, width)
        UI.TableSetupColumn(damageString,  colFlags, width)
        UI.TableSetupColumn("Minimum",     colFlags, width)
        UI.TableSetupColumn("Maximum",     colFlags, width)
        UI.TableHeadersRow()

        local row = 1

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Damage.PetAverage(playerName,   petName, trackable)
        UI.TableNextColumn() Column.Acc.ByTypePet(playerName,       petName, trackable)
        UI.TableNextColumn() Column.Damage.PetAttempts(playerName,  petName, trackable)
        UI.TableNextColumn() Column.Damage.AveragePetTP(playerName, petName, trackable)
        UI.TableNextColumn() Column.Damage.ByTypePet(playerName,    petName, trackable)
        UI.TableNextColumn() Column.Damage.ByTypePet(playerName,    petName, trackable, DB.Metric.MIN)
        UI.TableNextColumn() Column.Damage.ByTypePet(playerName,    petName, trackable, DB.Metric.MAX)
        WindowManager.TableRowColor(row)
        row = row + 1

        local sortedDamage = DB.Lists.GetSortedPetCatalogDamage(playerName, petName)

        for _, data in ipairs(sortedDamage) do
            local actionName      = data[1]
            local actionTrackable = data[3]

            if trackable == actionTrackable then
                UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
                UI.TableNextColumn() Column.Damage.PetAverage(playerName,   petName, actionTrackable, actionName)
                UI.TableNextColumn() Column.Acc.ByTypePet(playerName,       petName, actionTrackable, actionName)
                UI.TableNextColumn() Column.Damage.PetAttempts(playerName,  petName, actionTrackable, actionName)
                UI.TableNextColumn() Column.Damage.AveragePetTP(playerName, petName, actionTrackable, actionName)
                UI.TableNextColumn() Column.Damage.ByTypePet(playerName,    petName, actionTrackable, nil, actionName)
                UI.TableNextColumn() Column.Damage.ByTypePet(playerName,    petName, actionTrackable, DB.Metric.MIN, actionName)
                UI.TableNextColumn() Column.Damage.ByTypePet(playerName,    petName, actionTrackable, DB.Metric.MAX, actionName)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Lists out specific pet's TP moves.
------------------------------------------------------------------------------------------------------
---@param playerName string       owner of the pet.
---@param petName    string
---@param trackable  DB.Trackable
---@param header     string
---@param isBuff?    boolean
------------------------------------------------------------------------------------------------------
Focus.Pets.PetSpecificNonDamagingSpells = function(playerName, petName, trackable, header, isBuff)
    if not playerName or not petName then
        return nil
    end

    local colFlags  = Column.Flags.None
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    trackable = trackable or DB.Trackable.PET_ENFEEBLING
    local columns = isBuff and 2 or 4

    if UI.BeginTable(string.format("%s single", petName), columns, WindowManager.Table.Flags.FixedBorders) then
        UI.TableSetupColumn(tostring(header), colFlags, nameWidth)
        if not isBuff then UI.TableSetupColumn("Average",  colFlags, width) end
        if not isBuff then UI.TableSetupColumn("Accuracy", colFlags, width) end
        UI.TableSetupColumn("Attempts", colFlags, width)
        UI.TableHeadersRow()

        local row = 1

        UI.TableNextColumn() UI.Text("Total")
        if not isBuff then UI.TableNextColumn() Column.Damage.PetAverage(playerName, petName, trackable) end
        if not isBuff then UI.TableNextColumn() Column.Acc.ByTypePet(playerName, petName, trackable) end
        UI.TableNextColumn() Column.Damage.PetAttempts(playerName, petName, trackable)
        WindowManager.TableRowColor(row)
        row = row + 1

        local sortedDamage = DB.Lists.GetSortedPetCatalogDamage(playerName, petName)

        for _, data in ipairs(sortedDamage) do
            local actionName      = data[1]
            local actionTrackable = data[3]

            if trackable == actionTrackable then
                UI.TableNextColumn() UI.Text(string.format("- %s", actionName))
                if not isBuff then UI.TableNextColumn() Column.Damage.PetAverage(playerName, petName, actionTrackable, actionName) end
                if not isBuff then UI.TableNextColumn() Column.Acc.ByTypePet(playerName, petName, actionTrackable, actionName) end
                UI.TableNextColumn() Column.Damage.PetAttempts(playerName, petName, actionTrackable, actionName)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end