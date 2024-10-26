Debug.Unit = {}
Debug.Unit.Action_Data = {}
Debug.Unit.Action_Data.Player = {}
Debug.Unit.Util = {}
Debug.Unit.Tests = {}
Debug.Unit.Results = T{}
Debug.Unit.Mob = {}
Debug.Unit.Active = false
Debug.Unit.Has_Pet = false

Debug.Unit.Mob.Target_ID = 3
Debug.Unit.Mob.Target_ID_Two = 4

Debug.Unit.Mob.PLAYER = T{} -- Gets populated dynamically when running the tests.

Debug.Unit.Mob.PET = {
    name = "Pet Name",
    id = 2,
    index = 2,
    target_index = 2,
    spawn_flags = Ashita.Enum.Spawn_Flags.PET,
    in_party = true,
    in_alliance = false,
}

Debug.Unit.Mob.ENEMY = {
    name = "Enemy",
    id = 3,
    index = 3,
    target_index = 3,
    spawn_flags = Ashita.Enum.Spawn_Flags.MOB,
    in_party = false,
    in_alliance = false,
}

Debug.Unit.Mob.ENEMY_TWO = {
    name = "Enemy Two",
    id = 4,
    index = 4,
    target_index = 4,
    spawn_flags = Ashita.Enum.Spawn_Flags.MOB,
    in_party = false,
    in_alliance = false,
}

Debug.Unit.Mob.PLAYER_TWO = {
    name = "Player Two",
    id = 5,
    index = 5,
    target_index = 5,
    pet_index = 6,
    spawn_flags = Ashita.Enum.Spawn_Flags.OTHERPLAYER,
    in_party = true,
    in_alliance = true,
}

Debug.Unit.Mob.PET_TWO = {
    name = "Pet Two",
    id = 6,
    index = 6,
    target_index = 6,
    spawn_flags = Ashita.Enum.Spawn_Flags.PET,
    in_party = false,
    in_alliance = false,
}

-- Melee Attacks
-- Pet Melee Attacks
-- Ranged Attacks
-- Avatar Rage Blood Pact
-- Avatar Ward Blood Pact
-- BST Ability
-- Spell Cast
-- Weaponskill
-- Skillchain
-- Spell Cast MB
-- Spell Cast Ga
-- Healing
-- Curaga


------------------------------------------------------------------------------------------------------
-- Poulates the Unit Test Window.
------------------------------------------------------------------------------------------------------
Debug.Unit.Populate = function()
    local col_flags = Focus.Column_Flags

    local row = 1
    if UI.BeginTable("Unit Tests", 4) then
        UI.TableSetupColumn("Test", col_flags)
        UI.TableSetupColumn("Result", col_flags)
        UI.TableSetupColumn("Errors", col_flags)
        UI.TableSetupColumn("Error Message", col_flags)
        UI.TableHeadersRow()

        for _, result in ipairs(Debug.Unit.Results) do
            if result.count > 0 then
                UI.TableNextColumn() UI.Text(result.test)
                UI.TableNextColumn() UI.TextColored(result.color, result.result)
                UI.TableNextColumn() UI.Text(tostring(result.count))
                UI.TableNextColumn() UI.Text(result.message)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Short circuits Ashita.Mob.Data so that I can create a pet for unit tests.
------------------------------------------------------------------------------------------------------
Debug.Unit.Get_Mob = function(mob_id)
    if Debug.Enabled and Debug.Unit.Active then
        if mob_id == 2 then
            return Debug.Unit.Mob.PET
        elseif mob_id == 3 then
            return Debug.Unit.Mob.ENEMY
        elseif mob_id == 4 then
            return Debug.Unit.Mob.ENEMY_TWO
        elseif mob_id == 5 then
            return Debug.Unit.Mob.PLAYER_TWO
        elseif mob_id == 6 then
            return Debug.Unit.Mob.PET_TWO
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Run unit tests.
------------------------------------------------------------------------------------------------------
Debug.Unit.Run_Tests = function()
    Debug.Unit.Active = true
    Debug.Unit.Mob.PLAYER = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)

    -- Melee
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Enspell())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Mob_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Off_Hand_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Off_Hand_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Mob_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Square())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Truestrike())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Kick_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Kick_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Kick_Crit())
    -- Endamage
    -- Endebuff
    -- Enaspir

    -- Ranged
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Square())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Truestrike())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.PUP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Shadows())
    -- Endamage
    -- Endebuff

    -- TP Action
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Energy_Steal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Skillchain())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Pet_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Pet_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Pet_Hit_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Pet_No_Damage())

    -- Ability
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Damaging_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Damaging_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Damaging_Hit_TP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Damaging_Miss_TP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Healing())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.MP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.No_Damage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Avatar_Rage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Avatar_Ward())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Avatar_Healing())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Wyvern_Breath_Damage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ability.Wyvern_Breath_Healing())

    -- Spells
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Nuke())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Nuke_Burst())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Nuke_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Pet_Nuke())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Healing())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Healing_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Pet_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.DoT_No_Damage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.DoT_Damage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Aspir())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_Land())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_Resist())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_No_Effect())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_AOE_Land())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Song())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Status_Removal())

    -- Defense
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Parry())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Counter())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Guard())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Shield())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Pet_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Pet_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Pet())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Primary())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Secondary())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Pet())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Pet_AOE_Primary())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Pet_AOE_Secondary())

    Debug.Unit.Active = false
end

------------------------------------------------------------------------------------------------------
-- Build the fake result table.
------------------------------------------------------------------------------------------------------
---@param target_id integer
---@param action_id? integer
---@param damage integer
---@param primary? table
---@param add_effect? table
---@param spike? table
---@param target_id_two? integer
---@param damage_two? integer
---@param message_two? integer
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Util.Build_Action = function(target_id, action_id, damage, primary, add_effect, spike, target_id_two, damage_two, message_two)
    local action = {}
    action.param = action_id
    action.targets = {}

    local target_data = {}
    local target_data_two = {}
    target_data.id = target_id
    target_data.actions = {}

    local action_data = {}
    action_data.param = damage

    if primary then
        action_data.animation = primary.animation
        action_data.reaction = primary.reaction
        action_data.message = primary.message
    else
        action_data.animation = 0
        action_data.reaction = 0
        action_data.message = 0
    end

    if add_effect then
        action_data.has_add_effect = true
        action_data.add_effect_param = add_effect.param
        action_data.add_effect_animation = add_effect.animation
        action_data.add_effect_message = add_effect.message -- Skillchains
    else
        action_data.has_add_effect = false
        action_data.add_effect_param = 0
        action_data.add_effect_animation = 0
        action_data.add_effect_message = 0
    end

    if spike then
        action_data.has_spike_effect = true
        action_data.spike_effect_param = spike.param
        action_data.spike_effect_message = spike.message
    else
        action_data.has_spike_effect = false
        action_data.spike_effect_param = 0
        action_data.spike_effect_message = 0
    end

    if target_id_two then
        target_data_two.id = target_id_two
        target_data_two.actions = {}
        local action_data_two = {}
        action_data_two.param = damage_two
        action_data_two.message = message_two
        table.insert(target_data_two.actions, action_data_two)
    end

    table.insert(target_data.actions, action_data)
    table.insert(action.targets, target_data)
    if target_id_two then table.insert(action.targets, target_data_two) end

    return action
end

------------------------------------------------------------------------------------------------------
-- Check test results.
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Result = function(test_name, player_database, pet_database)

    local error_count = 0
    local error_message = ""

    -- Player Database
    for index, _ in pairs(DB.Parse) do
        if not player_database[index] then
            if error_count > 0 then error_message = error_message .. "\n" end
            error_message = error_message .. "Couldn't find index: " .. tostring(index)
            error_count = error_count + 1

        else
            for trackable, _ in pairs(DB.Parse[index]) do
                if not DB.Parse[index][trackable] then
                    if error_count > 0 then error_message = error_message .. "\n" end
                    error_message = error_message .. "Couldn't find trackable: " .. tostring(index) .. " " .. tostring(trackable)
                    error_count = error_count + 1

                else
                    for metric, value in pairs(DB.Parse[index][trackable]) do

                        -- Cataloged Data
                        if metric == DB.Enum.Values.CATALOG then
                            for action_name, _ in pairs(DB.Parse[index][trackable][DB.Enum.Values.CATALOG]) do
                                for catalog_metric, catalog_value in pairs(DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name]) do

                                    -- Make sure expected data matches.
                                    if player_database[index][trackable]
                                    and player_database[index][trackable][DB.Enum.Values.CATALOG]
                                    and player_database[index][trackable][DB.Enum.Values.CATALOG][action_name]
                                    and player_database[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] then
                                        if player_database[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == catalog_value then
                                            -- Pass
                                        elseif catalog_metric == DB.Enum.Metric.MIN
                                        and player_database[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == DB.Enum.Values.MAX_DAMAGE then
                                            -- Pass
                                        elseif player_database[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == 0 then
                                            -- Pass
                                        else
                                            if error_count > 0 then error_message = error_message .. "\n" end
                                            error_message = error_message .. "Catalog Mismatch: " .. tostring(index) .. " " .. tostring(trackable) .. " "
                                            .. tostring(catalog_metric) .. " " .. tostring(action_name) .. " " .. tostring(catalog_value) .. " Expected: "
                                            .. tostring(player_database[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric])
                                            error_count = error_count + 1
                                        end

                                    -- There is unexpected data.
                                    elseif catalog_value ~= 0 and catalog_value ~= DB.Enum.Values.MAX_DAMAGE then
                                        if error_count > 0 then error_message = error_message .. "\n" end
                                        error_message = error_message .. "Unexpected catalog data: " .. tostring(index) .. " " .. tostring(trackable) .. " "
                                        .. tostring(catalog_metric) .. " " .. tostring(action_name) .. " " .. tostring(catalog_value)
                                        error_count = error_count + 1
                                    end

                                end
                            end

                        -- Non-cataloged Data
                        else
                            -- Make sure expected data matches.
                            if player_database[index][trackable] and player_database[index][trackable][metric] then
                                if player_database[index][trackable][metric] == value then
                                    -- Pass
                                elseif metric == DB.Enum.Metric.MIN and DB.Parse[index][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
                                    -- Pass
                                elseif player_database[index][trackable][metric] == 0 then
                                    -- Pass
                                else
                                    if error_count > 0 then error_message = error_message .. "\n" end
                                    error_message = error_message .. "Data Mismatch: " .. tostring(index) .. " " .. tostring(trackable) .. " " .. tostring(metric)
                                    .. " " .. tostring(value) .. " Expected: " .. tostring(player_database[index][trackable][metric])
                                    error_count = error_count + 1
                                end

                            -- There is unexpected data.
                            elseif value ~= 0 and value ~= DB.Enum.Values.MAX_DAMAGE then
                                if error_count > 0 then error_message = error_message .. "\n" end
                                error_message = error_message .. "Unexpected data: " .. tostring(index) .. " " .. tostring(trackable) .. " " .. tostring(metric)
                                .. " " .. tostring(value)
                                error_count = error_count + 1
                            end
                        end
                    end
                end
            end
        end
    end

    -- Pet Database
    if pet_database then
        for index, _ in pairs(DB.Pet_Parse) do
            if not pet_database[index] then
                if error_count > 0 then error_message = error_message .. "\n" end
                error_message = error_message .. "PET: Couldn't find index: " .. tostring(index)
                error_count = error_count + 1

            else
                for pet_name, _ in pairs(DB.Pet_Parse[index]) do
                    if not pet_database[index][pet_name] then
                        if error_count > 0 then error_message = error_message .. "\n" end
                        error_message = error_message .. "PET: Couldn't find pet index: " .. tostring(index) .. " " .. tostring(pet_name)
                        error_count = error_count + 1

                    else
                        for trackable, _ in pairs(DB.Pet_Parse[index][pet_name]) do
                            if not DB.Pet_Parse[index][pet_name][trackable] then
                                if error_count > 0 then error_message = error_message .. "\n" end
                                error_message = error_message .. "PET: Couldn't find trackable: " .. tostring(index) .. " " .. tostring(trackable)
                                error_count = error_count + 1

                            else
                                for metric, value in pairs(DB.Pet_Parse[index][pet_name][trackable]) do

                                    -- Cataloged Data
                                    if metric == DB.Enum.Values.CATALOG then
                                        for action_name, _ in pairs(DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG]) do
                                            for catalog_metric, catalog_value in pairs(DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name]) do
                                                -- Make sure expected data matches.
                                                if pet_database[index][pet_name][trackable]
                                                and pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG]
                                                and pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name]
                                                and pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] then
                                                    if pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == catalog_value then
                                                        -- Pass
                                                    elseif catalog_metric == DB.Enum.Metric.MIN and
                                                    pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == DB.Enum.Values.MAX_DAMAGE then
                                                        -- Pass
                                                    elseif pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == 0 then
                                                        -- Pass
                                                    else
                                                        if error_count > 0 then error_message = error_message .. "\n" end
                                                        error_message = error_message .. "PET: Catalog Mismatch: " .. tostring(trackable) .. " " .. tostring(catalog_metric)
                                                                        .. " " .. tostring(action_name) .. " " .. tostring(catalog_value) .. " Expected: "
                                                                        .. tostring(pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric])
                                                        error_count = error_count + 1
                                                    end

                                                -- There is unexpected data.
                                                elseif catalog_value ~= 0 and catalog_value ~= DB.Enum.Values.MAX_DAMAGE then
                                                    if error_count > 0 then error_message = error_message .. "\n" end
                                                    error_message = error_message .. "PET: Unexpected catalog data: " .. tostring(trackable) .. " " .. tostring(catalog_metric)
                                                                    .. " " .. tostring(action_name) .. " " .. tostring(catalog_value)
                                                    error_count = error_count + 1
                                                end
                                            end
                                        end

                                    -- Non-cataloged Data
                                    else
                                        -- Make sure expected data matches.
                                        if pet_database[index][pet_name][trackable]
                                        and pet_database[index][pet_name][trackable][metric] then
                                            if pet_database[index][pet_name][trackable][metric] == value then
                                                -- Pass
                                            elseif metric == DB.Enum.Metric.MIN and DB.Pet_Parse[index][pet_name][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
                                                -- Pass
                                            elseif pet_database[index][pet_name][trackable][metric] == 0 then
                                                -- Pass
                                            else
                                                if error_count > 0 then error_message = error_message .. "\n" end
                                                error_message = error_message .. "PET: Data Mismatch: " .. tostring(trackable) .. " " .. tostring(metric) .. " "
                                                                .. tostring(value) .. " Expected: " .. tostring(pet_database[index][pet_name][trackable][metric])
                                                error_count = error_count + 1
                                            end

                                        -- There is unexpected data.
                                        elseif value ~= 0 and value ~= DB.Enum.Values.MAX_DAMAGE then
                                            if error_count > 0 then error_message = error_message .. "\n" end
                                            error_message = error_message .. "PET: Unexpected data: " .. tostring(trackable) .. " " .. tostring(metric) .. " "
                                                            .. tostring(value)
                                            error_count = error_count + 1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local result = "Pass!"
    local color  = Res.Colors.Basic.GREEN
    if error_count > 0 then
        result = "Fail"
        color  = Res.Colors.Basic.RED
    end

    return {test = test_name, result = result, color = color, count = error_count, message = error_message}
end