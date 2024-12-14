Focus.Overview = T{}

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Job_Selection = function(player_name)
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
    Focus.Overview.Melee(player_name)
    if ranged_damage > 0 then Focus.Overview.Ranged(player_name) end
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for MNK.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.MNK = function(player_name)
    local ability_list = {[1] = "Focus", [2] = "Dodge", [3] = "Boost", [4] = "Chi Blast", [5] = "Chakra", [6] = "Counterstance"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for WHM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.WHM = function(player_name)
    local ability_list = {[1] = "Divine Seal", [2] = "Devotion"}
    local buff_list = {[1] = "Regen III", [2] = "Regen II", [3] = "Regen"}
    Focus.Overview.Healing(player_name)
    Focus.Overview.Buffs(player_name, buff_list)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BLM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BLM = function(player_name)
    local ability_list = {[1] = "Elemental Seal"}
    Focus.Overview.Nuking(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RDM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.RDM = function(player_name)
    local ability_list = {[1] = "Convert"}
    local buff_list = {[1] = "Refresh", [2] = "Haste"}
    Focus.Overview.Healing(player_name)
    Focus.Overview.Nuking(player_name)
    Focus.Overview.Debuff(player_name)
    Focus.Overview.Buffs(player_name, buff_list)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for THF.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.THF = function(player_name)
    local ability_list = {[1] = "Sneak Attack", [2] = "Trick Attack", [3] = "Bully", [4] = "Accomplice", [5] = "Collaborator", [6] = "Mug", [7] = "Steal"}
    local ranged_damage = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    Focus.Overview.Melee(player_name)
    if ranged_damage > 0 then Focus.Overview.Ranged(player_name) end
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for PLD.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.PLD = function(player_name)
    local ability_list = {[1] = "Sentinel", [2] = "Rampart", [3] = "Cover", [4] = "Chivalry", [5] = "Shield Bash"}
    local buff_list = {[1] = "Enlight"}
    Focus.Overview.Defense(player_name)
    Focus.Overview.Healing(player_name)
    Focus.Overview.Healing_Received(player_name)
    Focus.Overview.Debuff(player_name)
    Focus.Overview.Buffs(player_name, buff_list)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DRK.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.DRK = function(player_name)
    local ability_list = {[1] = "Last Resort", [2] = "Souleater", [3] = "Weapon Bash"}
    local ranged_damage = DB.Data.Get(player_name, DB.Trackable.RANGED_OVERALL, DB.Metric.ATTEMPTS_ON_USE)
    Focus.Overview.Melee(player_name)
    if ranged_damage > 0 then Focus.Overview.Ranged(player_name) end
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Nuking(player_name)
    Focus.Overview.Debuff(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BST.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BST = function(player_name)
    local ability_list = {[1] = "Reward", [2] = "Call Beast"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Pet_TP(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BRD.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BRD = function(player_name)
    local buff_list = {[1] = "Enlight"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Healing(player_name)
    Focus.Overview.Debuff(player_name)
    Focus.Overview.Buff_Songs(player_name)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for RNG.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.RNG = function(player_name)
    local ability_list = {[1] = "Barrage", [2] = "Sharpshot", [3] = "Velocity Shot", [4] = "Unlimited Shot"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Ranged(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SAM.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.SAM = function(player_name)
    local ability_list = {[1] = "Hasso", [2] = "Meditate", [3] = "Seigan", [4] = "Third Eye"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Skillchains(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for NIN.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.NIN = function(player_name)
    local ability_list = {[1] = "Yonin"}
    local buff_list = {[1] = "Utsusemi: Ichi", [2] = "Utsusemi: Ni"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Defense(player_name)
    Focus.Overview.Healing_Received(player_name)
    Focus.Overview.Nuking(player_name, true)
    Focus.Overview.Debuff(player_name, true)
    Focus.Overview.Buffs(player_name, buff_list, true)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for DRG.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.DRG = function(player_name)
    local ability_list = {[1] = "Jump", [2] = "High Jump", [3] = "Super Jump", [4] = "Spirit Link", [5] = "Call Wyvern"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Pet_TP(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for SMN.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.SMN = function(player_name)
    Focus.Overview.Melee(player_name)
    Focus.Overview.Pet_TP(player_name)
    Focus.Overview.Healing(player_name)
    Focus.Overview.Debuff(player_name)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for BLU.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.BLU = function(player_name)
    local ability_list = {[1] = "Burst Affinity", [2] = "Chain Affinity"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Nuking(player_name, true)
    Focus.Overview.Healing(player_name)
    Focus.Overview.Debuff(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for COR.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.COR = function(player_name)
    Focus.Overview.Melee(player_name)
    Focus.Overview.Ranged(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Phantom_Roll(player_name)
    Focus.Overview.Quick_Shot(player_name)
end

------------------------------------------------------------------------------------------------------
-- Overview screen for PUP.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.PUP = function(player_name)
    local ability_list = {[1] = "Deus Ex Automata", [2] = "Repair", [3] = "Maintenance"}
    Focus.Overview.Melee(player_name)
    Focus.Overview.Weaponskill(player_name)
    Focus.Overview.Overload(player_name)
    Focus.Overview.Maneuvers(player_name)
    Focus.Overview.Abilities(player_name, ability_list)
end


------------------------------------------------------------------------------------------------------
-- Shows melee overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Melee = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local off_hand = DB.Data.Get(player_name, DB.Trackable.MELEE_OFF_HAND, DB.Metric.TOTAL)
    local kick_damage = DB.Data.Get(player_name, DB.Trackable.MELEE_KICK_ATTACKS, DB.Metric.TOTAL)
    local counter_damage = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER, DB.Metric.TOTAL)
    local pet_damage = DB.Data.Get(player_name, DB.Trackable.PET_MELEE_OVERALL, DB.Metric.TOTAL)

    local row = 1
    if UI.BeginTable("Melee", 4, table_flags) then
        UI.TableSetupColumn("Melee", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Crit", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Main-Hand")
        UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_MAIN_HAND)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Trackable.MELEE_OVERALL)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        if off_hand > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Off-Hand")
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_OFF_HAND)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_OFF_HAND)
            UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Trackable.MELEE_OFF_HAND)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if kick_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Kick Attacks")
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Trackable.MELEE_KICK_ATTACKS)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if counter_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if pet_damage > 0 then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Pets")
            UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.PET_MELEE_OVERALL)
            UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.PET_MELEE_OVERALL)
            UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Trackable.PET_MELEE_OVERALL)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows weaponskill overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Ranged = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Ranged", 5, table_flags) then
        UI.TableSetupColumn("Ranged", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("%Crit", col_flags, width)
        UI.TableSetupColumn("Distance", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Projectile")
        UI.TableNextColumn() Column.Damage.Average_By_Type(player_name, DB.Trackable.RANGED_OVERALL)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Trackable.RANGED_OVERALL)
        UI.TableNextColumn() Column.Proc.Crit_Rate(player_name, DB.Trackable.RANGED_OVERALL)
        UI.TableNextColumn() Column.Damage.Shot_Distance(player_name)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows weaponskill overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Weaponskill = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Weaponskills", 4, table_flags) then
        UI.TableSetupColumn("Weaponskill", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Accuracy", col_flags, width)
        UI.TableSetupColumn("~TP", col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.WEAPONSKILL
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Acc(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Average_TP(player_name, action_name)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows skillchain overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Skillchains = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Skillchains", 2, table_flags) then
        UI.TableSetupColumn("Skillchains", col_flags, name_width)
        UI.TableSetupColumn("Count", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Opened")
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.SKILLCHAIN, DB.Metric.SKILLCHAIN_OPENED)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Closed")
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, DB.Trackable.SKILLCHAIN, DB.Metric.SKILLCHAIN_CLOSED)
        Window_Manager.Table_Row_Color(0)

        UI.EndTable()
    end
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
        if not DB.Tracking.Initialized_Pets[player_name] then DB.Tracking.Initialized_Pets[player_name] = T{} end
        for pet_name, _ in pairs(DB.Tracking.Initialized_Pets[player_name]) do
            DB.Lists.Sort.Pet_Catalog_Damage(player_name, pet_name)
            for _, data in ipairs(DB.Sorted.Pet_Catalog_Damage) do
                has_data = true
                local action_name = data[1]
                local trackable = data[3]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Pet_Average(player_name, pet_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Pet_Acc(player_name, pet_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Average_Pet_TP(player_name, pet_name, trackable, action_name)
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

------------------------------------------------------------------------------------------------------
-- Shows nuking overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_mp? boolean hide MP for things like NIN nukes.
------------------------------------------------------------------------------------------------------
Focus.Overview.Nuking = function(player_name, hide_mp)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 5
    if hide_mp then columns = columns - 1 end

    if UI.BeginTable("Nuking", columns, table_flags) then
        UI.TableSetupColumn("Nuking", col_flags, name_width)
        UI.TableSetupColumn("Total", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        if not hide_mp then UI.TableSetupColumn("DMG/MP", col_flags, width) end
        UI.TableSetupColumn("Bursts", col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.SPELLS_NUKING
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.TOTAL)
                UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                if not hide_mp then UI.TableNextColumn() Column.Single.Damage_Per_Unit(player_name, action_name, trackable, DB.Metric.MP_SPENT) end
                UI.TableNextColumn() Column.Single.Bursts(player_name, action_name)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if not hide_mp then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows healing overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Healing = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Healing", 5, table_flags) then
        UI.TableSetupColumn("Healing Cast", col_flags, name_width)
        UI.TableSetupColumn("HP+", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("MP-", col_flags, width)
        UI.TableSetupColumn("Overcure", col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.SPELLS_HEALING
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.TOTAL)
                UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.MP_Used(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Overcure(player_name, action_name)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows healing received overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Healing_Received = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Healing", 4, table_flags) then
        UI.TableSetupColumn("Healing Received", col_flags, name_width)
        UI.TableSetupColumn("HP+", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("MP-", col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.DEF_HEALING_RECEIVED
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.TOTAL)
                UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.MP_Used(player_name, action_name, trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows buff overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param buff_list table
---@param hide_mp? boolean hide MP for things like NIN buffs.
------------------------------------------------------------------------------------------------------
Focus.Overview.Buffs = function(player_name, buff_list, hide_mp)
    if not player_name or not buff_list then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 3
    if hide_mp then columns = columns - 1 end

    if UI.BeginTable("Buffs", columns, table_flags) then
        UI.TableSetupColumn("Buffs", col_flags, name_width)
        UI.TableSetupColumn("Casts", col_flags, width)
        if not hide_mp then UI.TableSetupColumn("-MP", col_flags, width) end
        UI.TableHeadersRow()

        local row = 1
        for _, buff_name in ipairs(buff_list) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(buff_name)
            UI.TableNextColumn() Column.Single.Attempts(player_name, buff_name, DB.Trackable.SPELLS_BUFFS)
            if not hide_mp then UI.TableNextColumn() Column.Single.MP_Used(player_name, buff_name, DB.Trackable.SPELLS_BUFFS) end
            Window_Manager.Table_Row_Color(row)
            row = row + 1
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
Focus.Overview.Debuff = function(player_name, hide_mp)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 4
    if hide_mp then columns = columns - 1 end

    if UI.BeginTable("Debuffs", columns, table_flags) then
        UI.TableSetupColumn("Debuff", col_flags, name_width)
        UI.TableSetupColumn("%Land", col_flags, width)
        UI.TableSetupColumn("Casts", col_flags, width)
        if not hide_mp then UI.TableSetupColumn("MP-", col_flags, width) end
        UI.TableHeadersRow()

        local trackable = DB.Trackable.SPELLS_ENFEEBLING
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Enfeeble_Acc(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                if not hide_mp then UI.TableNextColumn() Column.Single.MP_Used(player_name, action_name, trackable) end
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if not hide_mp then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows buff song overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Buff_Songs = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Buff Songs", 2, table_flags) then
        UI.TableSetupColumn("Buff Song", col_flags, name_width)
        UI.TableSetupColumn("Casts", col_flags, width)
        UI.TableHeadersRow()

        local trackable = DB.Trackable.SPELLS_BUFF_SONG
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows phantom roll overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param full? boolean
------------------------------------------------------------------------------------------------------
Focus.Overview.Phantom_Roll = function(player_name, full)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local columns = 5
    if full then columns = columns + 2 end
    local trackable = DB.Trackable.PHANTOM_ROLL
    if UI.BeginTable("Phantom Roll", columns, table_flags) then
        UI.TableSetupColumn("Phantom Roll", col_flags, name_width)
        UI.TableSetupColumn("Rolls", col_flags, width)
        if full then UI.TableSetupColumn("Re-Rolls", col_flags, width) end
        UI.TableSetupColumn("Lucky", col_flags, width)
        if full then UI.TableSetupColumn("Lucky 11", col_flags, width) end
        UI.TableSetupColumn("Unlucky", col_flags, width)
        UI.TableSetupColumn("Busts", col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.FIRST_ROLL)
                if full then UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.REROLL) end
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.LUCKY)
                if full then UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.LUCKY_11) end
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.UNLUCKY)
                UI.TableNextColumn() Column.Single.Damage(player_name, action_name, trackable, DB.Metric.BUSTS)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if full then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            if full then UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---") end
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows quick shot overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Quick_Shot = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.ABILITY_DAMAGING
    if UI.BeginTable("Quick Shot", 3, table_flags) then
        UI.TableSetupColumn("Abilities", col_flags, name_width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("Uses", col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Average(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows manuever overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Maneuvers = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.MANEUVER
    if UI.BeginTable("Maneuvers", 2, table_flags) then
        UI.TableSetupColumn("Maneuver", col_flags, name_width)
        UI.TableSetupColumn("Uses", col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows maneuver overload overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Overload = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local trackable = DB.Trackable.MANEUVER
    if UI.BeginTable("Overload", 2, table_flags) then
        UI.TableSetupColumn("Misc.", col_flags, name_width)
        UI.TableSetupColumn("Count", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Overload")
        UI.TableNextColumn() Column.Damage.By_Type_Metric(player_name, trackable, DB.Metric.OVERLOAD)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows generic spell overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Spell = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Spells", 3, table_flags) then
        UI.TableSetupColumn("Spell", col_flags, name_width)
        UI.TableSetupColumn("Count", col_flags, width)
        UI.TableSetupColumn("MP-", col_flags, width)

        UI.TableHeadersRow()

        local trackable = DB.Trackable.SPELLS_OVERALL
        local row = 1
        if DB.Tracking.Trackable[trackable] and DB.Tracking.Trackable[trackable][player_name] then
            local sorted_damage = DB.Lists.Sort.Catalog_Damage(player_name, trackable)
            local action_name
            for _, data in ipairs(sorted_damage) do
                action_name = data[1]
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(action_name)
                UI.TableNextColumn() Column.Single.Attempts(player_name, action_name, trackable)
                UI.TableNextColumn() Column.Single.MP_Used(player_name, action_name, trackable)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        else
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("None")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows ability overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param ability_list table
------------------------------------------------------------------------------------------------------
Focus.Overview.Abilities = function(player_name, ability_list)
    if not player_name or not ability_list then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Ability", 2, table_flags) then
        UI.TableSetupColumn("Abilities", col_flags, name_width)
        UI.TableSetupColumn("Uses", col_flags, width)
        UI.TableHeadersRow()

        local row = 1
        for _, ability_name in ipairs(ability_list) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(ability_name)
            UI.TableNextColumn() Column.Single.Attempts(player_name, ability_name, DB.Trackable.ABILITY_OVERALL)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows defensive overview stats.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overview.Defense = function(player_name)
    if not player_name then return nil end

    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Defense", 5, table_flags) then
        UI.TableSetupColumn("Damage Taken", col_flags, name_width)
        UI.TableSetupColumn("HP-", col_flags, width)
        UI.TableSetupColumn("%Party", col_flags, width)
        UI.TableSetupColumn("%Player", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextColumn() UI.Text("Total")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL)
        UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, true)
        UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Melee")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE)
        UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, DB.Trackable.DEF_MELEE)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_MELEE, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_UNMITIGATED)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Magic")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING)
        UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, DB.Trackable.DEF_NUKING)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_NUKING, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_NUKING)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.TableNextColumn() UI.Text("Mob TP")
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE)
        UI.TableNextColumn() Column.General.Percent_Party_Total(player_name, DB.Trackable.DEF_TP_MOVE)
        UI.TableNextColumn() Column.Defense.Damage_Taken_By_Type(player_name, DB.Trackable.DEF_TP_MOVE, true)
        UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_TP_MOVE)
        Window_Manager.Table_Row_Color(row)
        row = row + 1

        UI.EndTable()
    end

    row = 1
    if UI.BeginTable("Defense", 5, table_flags) then
        UI.TableSetupColumn("Mitigation", col_flags, name_width)
        UI.TableSetupColumn("~HP Saved", col_flags, width)
        UI.TableSetupColumn("%Proc", col_flags, width)
        UI.TableSetupColumn("Average", col_flags, width)
        UI.TableSetupColumn("%DT-", col_flags, width)
        UI.TableHeadersRow()

        local evade = DB.Data.Get(player_name, DB.Trackable.DEF_EVASION, DB.Metric.HITS_ON_USE)
        if evade > 0 then
            UI.TableNextColumn() UI.Text("Evasion")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_EVASION)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_EVASION)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local parry = DB.Data.Get(player_name, DB.Trackable.DEF_PARRY, DB.Metric.HITS_ON_USE)
        if parry > 0 then
            UI.TableNextColumn() UI.Text("Parry")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_PARRY)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_PARRY)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local shadows = DB.Data.Get(player_name, DB.Trackable.DEF_SHADOWS, DB.Metric.HITS_ON_USE)
        if shadows > 0 then
            UI.TableNextColumn() UI.Text("Shadows")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_SHADOWS)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_SHADOWS)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local counter = DB.Data.Get(player_name, DB.Trackable.MELEE_COUNTER, DB.Metric.HITS_ON_USE)
        if counter > 0 then
            UI.TableNextColumn() UI.Text("Counter")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.MELEE_COUNTER)
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local guard = DB.Data.Get(player_name, DB.Trackable.DEF_GUARD, DB.Metric.HITS_ON_USE)
        if guard > 0 then
            UI.TableNextColumn() UI.Text("Guard")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_GUARD)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_GUARD)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_GUARD)
            UI.TableNextColumn() Column.Defense.Damage_Reduction(player_name, DB.Trackable.DEF_GUARD)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        local shield = DB.Data.Get(player_name, DB.Trackable.DEF_SHIELD_BLOCK, DB.Metric.HITS_ON_USE)
        if shield > 0 then
            UI.TableNextColumn() UI.Text("Shield Block")
            UI.TableNextColumn() Column.Defense.Damage_Mitigation(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            UI.TableNextColumn() Column.Defense.Proc_Rate_By_Type(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            UI.TableNextColumn() Column.Defense.Average_Damage_By_Type(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            UI.TableNextColumn() Column.Defense.Damage_Reduction(player_name, DB.Trackable.DEF_SHIELD_BLOCK)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

        if (evade + parry + shadows + counter + guard + shield) == 0 then
            UI.TableNextColumn() UI.Text("None Yet")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
            UI.TableNextColumn() UI.TextColored(Res.Colors.Basic.DIM, "---")
        end

        UI.EndTable()
    end
end