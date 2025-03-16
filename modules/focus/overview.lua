Focus.Overview = { }

------------------------------------------------------------------------------------------------------
-- Displays the job specific overview.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.Display = function(playerName)
    if not playerName or not Ashita.Party.Jobs[playerName] or not Ashita.Party.Jobs[playerName].main then
        return Focus.Overview.Anon()
    end

    local main  = Res.Jobs.GetJob(Ashita.Party.Jobs[playerName].main) or { id = 0 }
    local jobId = main.id or 0

    local jobHandlers =
    {
        [0]  = Focus.Overview.Anon,
        [1]  = Focus.Overview.WAR,
        [2]  = Focus.Overview.MNK,
        [3]  = Focus.Overview.WHM,
        [4]  = Focus.Overview.BLM,
        [5]  = Focus.Overview.RDM,
        [6]  = Focus.Overview.THF,
        [7]  = Focus.Overview.PLD,
        [8]  = Focus.Overview.DRK,
        [9]  = Focus.Overview.BST,
        [10] = Focus.Overview.BRD,
        [11] = Focus.Overview.RNG,
        [12] = Focus.Overview.SAM,
        [13] = Focus.Overview.NIN,
        [14] = Focus.Overview.DRG,
        [15] = Focus.Overview.SMN,
        [16] = Focus.Overview.BLU,
        [17] = Focus.Overview.COR,
        [18] = Focus.Overview.PUP,
        [19] = Focus.Overview.DNC,
        [20] = Focus.Overview.SCH,
        [21] = Focus.Overview.GEO,
        [22] = Focus.Overview.RUN,
    }

    local jobFunction = jobHandlers[jobId] or Focus.Overview.Anon

    return jobFunction(playerName)
end

------------------------------------------------------------------------------------------------------
-- Highlights for anonymous jobs.
------------------------------------------------------------------------------------------------------
Focus.Overview.Anon = function()
    UI.Text("Player's job is unknown.")
end

------------------------------------------------------------------------------------------------------
-- Overview screen for WAR.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.WAR = function(playerName)
    local abilityList  = { "Berserk", "Warcry", "Aggressor", "Provoke", "Defender" }
    local rangedDamage = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)

    Focus.Melee.Total(playerName, true)

    if rangedDamage > 0 then
        Focus.Ranged.Total(playerName, true)
    end

    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for MNK.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.MNK = function(playerName)
    local abilityList = { "Focus", "Dodge", "Boost", "Chi Blast", "Chakra", "Counterstance" }

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for WHM.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.WHM = function(playerName)
    local abilityList = { "Divine Seal", "Devotion" }
    local buffList    = { "Regen III", "Regen II", "Regen" }

    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.FromList(playerName, DB.Trackable.SPELLS_BUFFS, buffList, "Buff Spells")
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BLM.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.BLM = function(playerName)
    local abilityList = { "Elemental Seal" }

    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RDM.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.RDM = function(playerName)
    local abilityList = { "Convert"}
    local buffList    = { "Refresh", "Haste" }

    if not Focus.Dependencies.HorizonMode() then
        buffList = { "Refresh III", "Haste II" }
    end

    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Magic.Debuff(playerName)
    Focus.Magic.FromList(playerName, DB.Trackable.SPELLS_BUFFS, buffList, "Buff Spells")
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for THF.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.THF = function(playerName)
    local abilityList  = { "Sneak Attack", "Trick Attack", "Bully", "Accomplice", "Collaborator", "Mug", "Steal" }
    local rangedDamage = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)

    Focus.Melee.Total(playerName, true)

    if rangedDamage > 0 then
        Focus.Ranged.Total(playerName, true)
    end

    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for PLD.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.PLD = function(playerName)
    local abilityList = { "Sentinel", "Rampart", "Cover", "Chivalry", "Shield Bash" }
    local buffList    = { "Enlight" }

    Focus.Defense.DamageTaken(playerName, true)
    Focus.Defense.Mitigation(playerName)
    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Defense.HealingReceived(playerName)
    Focus.Magic.Debuff(playerName)
    Focus.Magic.FromList(playerName, DB.Trackable.SPELLS_BUFFS, buffList, "Buff Spells")
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DRK.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.DRK = function(playerName)
    local abilityList  = { "Last Resort", "Souleater", "Weapon Bash" }
    local rangedDamage = DB.Data.Get(playerName, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)

    Focus.Melee.Total(playerName, true)

    if rangedDamage > 0 then
        Focus.Ranged.Total(playerName, true)
    end

    Focus.WS.Weaponskill(playerName, true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Magic.Debuff(playerName)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BST.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.BST = function(playerName)
    local abilityList = { "Reward", "Call Beast" }

    if not Focus.Dependencies.HorizonMode() then
        table.insert(abilityList, "Bestial Loyalty")
    end

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Overview.PetTP(playerName)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BRD.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.BRD = function(playerName)
    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Debuff(playerName)
    Focus.Magic.BasicSpell(playerName, DB.Trackable.SPELLS_BUFF_SONG, "Buff Songs", true)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RNG.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.RNG = function(playerName)
    local abilityList = { "Barrage", "Sharpshot", "Velocity Shot", "Unlimited Shot" }

    Focus.Melee.Total(playerName, true)
    Focus.Ranged.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SAM.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.SAM = function(playerName)
    local abilityList = { "Hasso", "Meditate", "Seigan", "Third Eye" }

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.WS.Skillchains(playerName, true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for NIN.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.NIN = function(playerName)
    local abilityList = { "Yonin" }
    local buffList    = { "Utsusemi: Ichi", "Utsusemi: Ni" }

    if not Focus.Dependencies.HorizonMode() then
        table.insert(buffList, "Utsusemi: San")
    end

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Defense.DamageTaken(playerName, true)
    Focus.Defense.Mitigation(playerName)
    Focus.Defense.HealingReceived(playerName)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true, true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, true, true)
    Focus.Magic.Debuff(playerName, true)
    Focus.Magic.FromList(playerName, DB.Trackable.SPELLS_BUFFS, buffList, "Buff Spells", true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DRG.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.DRG = function(playerName)
    local abilityList = { "Jump", "High Jump", "Super Jump", "Spirit Link", "Call Wyvern" }

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Overview.PetTP(playerName)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SMN.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.SMN = function(playerName)
    Focus.Melee.Total(playerName, true)
    Focus.Overview.PetTP(playerName)
    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Debuff(playerName)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BLU.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.BLU = function(playerName)
    local abilityList = { "Burst Affinity", "Chain Affinity" }

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke", true)
    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Debuff(playerName)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for COR.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.COR = function(playerName)
    Focus.Melee.Total(playerName, true)
    Focus.Ranged.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.PhantomRoll(playerName)
    Focus.Abilities.Damaging(playerName, DB.Trackable.ABILITY_DAMAGING, "Quick Draw+", true)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for PUP.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.PUP = function(playerName)
    local abilityList = { "Deus Ex Automata", "Repair", "Maintenance" }

    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.Mauevers(playerName)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DNC.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.DNC = function(playerName)
    Focus.Melee.Total(playerName, true)
    Focus.WS.Weaponskill(playerName, true)
    Focus.Abilities.Damaging(playerName, DB.Trackable.ABILITY_HEALING, "Healing", true)
    Focus.Abilities.AbilitiesGeneral(playerName)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SCH.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.SCH = function(playerName)
    local buff_list = { "Regen V" }

    Focus.Magic.NoDamageSpell(playerName, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Magic.FromList(playerName, DB.Trackable.SPELLS_BUFFS, buff_list, "Buff Spells")
    Focus.Abilities.AbilitiesGeneral(playerName)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for GEO.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.GEO = function(playerName)
    local abilityList = { "Blaze of Glory", "Dematerialize", "Ecliptic Attrition", "Entrust", "Life Cycle" }

    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.DamagingSpell(playerName, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Magic.BasicSpell(playerName, DB.Trackable.SPELLS_GEOMANCY, "Geomancy", true)
    Focus.Abilities.FromList(playerName, abilityList)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RUN.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.RUN = function(playerName)
    local buffList = { "Foil", "Regen IV", "Refresh", "Phalanx", "Crusade" }

    Focus.Defense.DamageTaken(playerName, true)
    Focus.Defense.Mitigation(playerName)
    Focus.Defense.HealingReceived(playerName)
    Focus.Magic.FromList(playerName, DB.Trackable.SPELLS_BUFFS, buffList, "Buff Spells")
    Focus.Abilities.Damaging(playerName, DB.Trackable.ABILITY_HEALING, "Healing", true)
    Focus.Abilities.AbilitiesGeneral(playerName)
end

------------------------------------------------------------------------------------------------------
-- Shows skillchain overview stats.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.Overview.PetTP = function(playerName)
    if not playerName then
        return nil
    end

    local colFlags  = Focus.ColumnFlags
    local nameWidth = Column.Widths.Name
    local width     = Column.Widths.Standard

    if UI.BeginTable("Pet TP", 4, Focus.TableFlags) then
        UI.TableSetupColumn("Pet TP",   colFlags, nameWidth)
        UI.TableSetupColumn("Average",  colFlags, width)
        UI.TableSetupColumn("Accuracy", colFlags, width)
        UI.TableSetupColumn("~TP",      colFlags, width)
        UI.TableHeadersRow()

        local hasData = false
        local row = 1
        DB.Tracking.InitializedPets[playerName] = DB.Tracking.InitializedPets[playerName] or { }

        for petName, _ in pairs(DB.Tracking.InitializedPets[playerName]) do
            local sortedDamage = DB.Lists.GetSortedPetCatalogDamage(playerName, petName)

            for _, data in ipairs(sortedDamage) do
                hasData = true
                local actionName = data[1]
                local trackable  = data[3]

                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(actionName)
                UI.TableNextColumn() Column.Damage.PetAverage(playerName, petName, trackable, actionName)
                UI.TableNextColumn() Column.Acc.ByTypePet(playerName, petName, trackable, actionName)
                UI.TableNextColumn() Column.Damage.AveragePetTP(playerName, petName, trackable, actionName)
                WindowManager.TableRowColor(row)
                row = row + 1
            end
        end

        if not hasData then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end