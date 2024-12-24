Focus.Overview = {}

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Display = function(player_name)
    if not player_name or not Ashita.Party.Jobs[player_name] then return Focus.Overview.Anon() end
    if not Ashita.Party.Jobs[player_name].main then return Focus.Overview.Anon() end -- Mob in player list crash prevention.

    local main = Res.Jobs.Get_Job(Ashita.Party.Jobs[player_name].main)
    if not main then Focus.Overview.Anon() end

    local job_id = main.id
    if     job_id == 0  then Focus.Overview.Anon()
    elseif job_id == 1  then Focus.Overview.WAR(player_name)
    elseif job_id == 2  then Focus.Overview.MNK(player_name)
    elseif job_id == 3  then Focus.Overview.WHM(player_name)
    elseif job_id == 4  then Focus.Overview.BLM(player_name)
    elseif job_id == 5  then Focus.Overview.RDM(player_name)
    elseif job_id == 6  then Focus.Overview.THF(player_name)
    elseif job_id == 7  then Focus.Overview.PLD(player_name)
    elseif job_id == 8  then Focus.Overview.DRK(player_name)
    elseif job_id == 9  then Focus.Overview.BST(player_name)
    elseif job_id == 10 then Focus.Overview.BRD(player_name)
    elseif job_id == 11 then Focus.Overview.RNG(player_name)
    elseif job_id == 12 then Focus.Overview.SAM(player_name)
    elseif job_id == 13 then Focus.Overview.NIN(player_name)
    elseif job_id == 14 then Focus.Overview.DRG(player_name)
    elseif job_id == 15 then Focus.Overview.SMN(player_name)
    elseif job_id == 16 then Focus.Overview.BLU(player_name)
    elseif job_id == 17 then Focus.Overview.COR(player_name)
    elseif job_id == 18 then Focus.Overview.PUP(player_name)
    end
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
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.WAR = function(player_name)
    local ability_list = {[1] = "Berserk", [2] = "Warcry", [3] = "Aggressor", [4] = "Provoke", [5] = "Defender"}
    local ranged_damage = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    Focus.Melee.Total(player_name, true)
    if ranged_damage > 0 then Focus.Ranged.Total(player_name, true) end
    Focus.WS.Weaponskill(player_name, true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for MNK.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.MNK = function(player_name)
    local ability_list = {[1] = "Focus", [2] = "Dodge", [3] = "Boost", [4] = "Chi Blast", [5] = "Chakra", [6] = "Counterstance"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for WHM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.WHM = function(player_name)
    local ability_list = {[1] = "Divine Seal", [2] = "Devotion"}
    local buff_list = {[1] = "Regen III", [2] = "Regen II", [3] = "Regen"}
    Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.From_List(player_name, DB.Trackable.SPELLS_BUFFS, buff_list, "Buff Spells")
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BLM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BLM = function(player_name)
    local ability_list = {[1] = "Elemental Seal"}
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RDM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.RDM = function(player_name)
    local ability_list = {[1] = "Convert"}
    local buff_list = {[1] = "Refresh", [2] = "Haste"}
    Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Magic.Debuff(player_name)
    Focus.Magic.From_List(player_name, DB.Trackable.SPELLS_BUFFS, buff_list, "Buff Spells")
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for THF.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.THF = function(player_name)
    local ability_list = {[1] = "Sneak Attack", [2] = "Trick Attack", [3] = "Bully", [4] = "Accomplice", [5] = "Collaborator", [6] = "Mug", [7] = "Steal"}
    local ranged_damage = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    Focus.Melee.Total(player_name, true)
    if ranged_damage > 0 then Focus.Ranged.Total(player_name, true) end
    Focus.WS.Weaponskill(player_name, true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for PLD.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.PLD = function(player_name)
    local ability_list = {[1] = "Sentinel", [2] = "Rampart", [3] = "Cover", [4] = "Chivalry", [5] = "Shield Bash"}
    local buff_list = {[1] = "Enlight"}
    Focus.Defense.Damage_Taken(player_name, true)
    Focus.Defense.Mitigation(player_name)
    Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Defense.Healing_Received(player_name)
    Focus.Magic.Debuff(player_name)
    Focus.Magic.From_List(player_name, DB.Trackable.SPELLS_BUFFS, buff_list, "Buff Spells")
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DRK.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.DRK = function(player_name)
    local ability_list = {[1] = "Last Resort", [2] = "Souleater", [3] = "Weapon Bash"}
    local ranged_damage = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    Focus.Melee.Total(player_name, true)
    if ranged_damage > 0 then Focus.Ranged.Total(player_name, true) end
    Focus.WS.Weaponskill(player_name, true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, false, true)
    Focus.Magic.Debuff(player_name)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BST.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BST = function(player_name)
    local ability_list = {[1] = "Reward", [2] = "Call Beast"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Overview.Pet_TP(player_name)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BRD.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BRD = function(player_name)
    local buff_list = {[1] = "Enlight"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Debuff(player_name)
    Focus.Magic.Basic_Spell(player_name, DB.Trackable.SPELLS_BUFF_SONG, "Buff Songs", true)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RNG.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.RNG = function(player_name)
    local ability_list = {[1] = "Barrage", [2] = "Sharpshot", [3] = "Velocity Shot", [4] = "Unlimited Shot"}
    Focus.Melee.Total(player_name, true)
    Focus.Ranged.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SAM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.SAM = function(player_name)
    local ability_list = {[1] = "Hasso", [2] = "Meditate", [3] = "Seigan", [4] = "Third Eye"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.WS.Skillchains(player_name, true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for NIN.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.NIN = function(player_name)
    local ability_list = {[1] = "Yonin"}
    local buff_list = {[1] = "Utsusemi: Ichi", [2] = "Utsusemi: Ni"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Defense.Damage_Taken(player_name, true)
    Focus.Defense.Mitigation(player_name)
    Focus.Defense.Healing_Received(player_name)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (All)", true, true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke (Bursts)", true, true, true)
    Focus.Magic.Debuff(player_name, true)
    Focus.Magic.From_List(player_name, DB.Trackable.SPELLS_BUFFS, buff_list, "Buff Spells", true)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DRG.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.DRG = function(player_name)
    local ability_list = {[1] = "Jump", [2] = "High Jump", [3] = "Super Jump", [4] = "Spirit Link", [5] = "Call Wyvern"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Overview.Pet_TP(player_name)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SMN.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.SMN = function(player_name)
    Focus.Melee.Total(player_name, true)
    Focus.Overview.Pet_TP(player_name)
    Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Debuff(player_name)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BLU.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BLU = function(player_name)
    local ability_list = {[1] = "Burst Affinity", [2] = "Chain Affinity"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Magic.Damaging_Spell(player_name, DB.Trackable.SPELLS_NUKING, "Nuke", true)
    Focus.Magic.No_Damage_Spell(player_name, DB.Trackable.SPELLS_HEALING, "Healing Spells", true)
    Focus.Magic.Debuff(player_name)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for COR.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.COR = function(player_name)
    Focus.Melee.Total(player_name, true)
    Focus.Ranged.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Abilities.Phantom_Roll(player_name)
    Focus.Abilities.Damaging(player_name, DB.Trackable.ABILITY_DAMAGING, "Quick Draw+", true)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for PUP.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.PUP = function(player_name)
    local ability_list = {[1] = "Deus Ex Automata", [2] = "Repair", [3] = "Maintenance"}
    Focus.Melee.Total(player_name, true)
    Focus.WS.Weaponskill(player_name, true)
    Focus.Abilities.Mauevers(player_name)
    Focus.Abilities.From_List(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Shows skillchain overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Pet_TP = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Pet TP", 4, table_flags) then
        UI.TableSetupColumn("Pet TP", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("~TP", col_flags, width)
        UI.TableHeadersRow()

        local has_data = false
        local row = 1
        if not DB.Tracking.Initialized_Pets[player_name] then DB.Tracking.Initialized_Pets[player_name] = {} end
        for pet_name, _ in pairs(DB.Tracking.Initialized_Pets[player_name]) do
            DB.Lists.Sort.Pet_Catalog_Damage(player_name, pet_name)
            for _, data in ipairs(DB.Sorted.Pet_Catalog_Damage) do
                has_data = true
                local action_name = data[1]
                local trackable = data[3]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Damage.Pet_Average(player_name, pet_name, trackable, action_name)
                UI.TableNextColumn() Column.Acc.By_Type_Pet(player_name, pet_name, action_name, trackable)
                UI.TableNextColumn() Column.Damage.Average_Pet_TP(player_name, pet_name, trackable, action_name)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        end
        if not has_data then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end
        UI.EndTable()
    end
end