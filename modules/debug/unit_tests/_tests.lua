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
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Endamage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Endebuff())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Enaspir())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Endrain())
    -- Multi-attack

    -- Ranged
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Square())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Truestrike())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.PUP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Endamage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Endebuff())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Endrain())

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
---@param test_name string
---@param player_database table
---@param pet_database? table
---@param battle_log_data? table
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Result = function(test_name, player_database, pet_database, battle_log_data)
    local error_count = 0
    local error_message = ""

    error_message, error_count = Debug.Unit.Check_Parse_Player_Database(player_database, error_message, error_count)
    error_message, error_count = Debug.Unit.Check_Parse_Pet_Database(pet_database, error_message, error_count)
    error_message, error_count = Debug.Unit.Check_Unit_Player_Database(player_database, error_message, error_count)
    error_message, error_count = Debug.Unit.Check_Unit_Pet_Database(pet_database, error_message, error_count)
    error_message, error_count = Debug.Unit.Check_Battle_Log(battle_log_data, error_message, error_count)

    local result = "Pass!"
    local color  = Res.Colors.Basic.GREEN
    if error_count > 0 then
        result = "Fail"
        color  = Res.Colors.Basic.RED
    end

    return {test = test_name, result = result, color = color, count = error_count, message = error_message}
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse player database.
------------------------------------------------------------------------------------------------------
---@param player_database table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Parse_Player_Database = function(player_database, error_message, error_count)
    if not player_database then return error_message, error_count end
    for index, _ in pairs(DB.Parse) do
        if not player_database[index] then
            if error_count > 0 then error_message = error_message .. "\n" end
            error_message = error_message .. "Couldn't find index: " .. tostring(index)
            error_count = error_count + 1
        else
            for trackable, _ in pairs(DB.Parse[index]) do
                for metric, value in pairs(DB.Parse[index][trackable]) do
                    if metric == DB.Enum.Values.CATALOG then
                        error_message, error_count = Debug.Unit.Parse_Player_Catalog(player_database, index, trackable, error_message, error_count)
                    else
                        error_message, error_count = Debug.Unit.Parse_Player(player_database, index, trackable, metric, value, error_message, error_count)
                    end
                end
            end
        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse player nodes.
------------------------------------------------------------------------------------------------------
---@param player_database table
---@param index string
---@param trackable string
---@param metric string
---@param value integer
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Parse_Player = function(player_database, index, trackable, metric, value, error_message, error_count)
    -- Check expected data.
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
    -- Check for unexpected data.
    elseif value ~= 0 and value ~= DB.Enum.Values.MAX_DAMAGE then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "Unexpected data: " .. tostring(index) .. " " .. tostring(trackable) .. " " .. tostring(metric)
        .. " " .. tostring(value)
        error_count = error_count + 1
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse catalog nodes.
------------------------------------------------------------------------------------------------------
---@param player_database table
---@param index string
---@param trackable string
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Parse_Player_Catalog = function(player_database, index, trackable, error_message, error_count)
    for action_name, _ in pairs(DB.Parse[index][trackable][DB.Enum.Values.CATALOG]) do
        for catalog_metric, catalog_value in pairs(DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name]) do
            -- Check expected data.
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
            -- Check for unexpected data.
            elseif catalog_value ~= 0 and catalog_value ~= DB.Enum.Values.MAX_DAMAGE then
                if error_count > 0 then error_message = error_message .. "\n" end
                error_message = error_message .. "Unexpected catalog data: " .. tostring(index) .. " " .. tostring(trackable) .. " "
                .. tostring(catalog_metric) .. " " .. tostring(action_name) .. " " .. tostring(catalog_value)
                error_count = error_count + 1
            end

        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse pet catalog database.
------------------------------------------------------------------------------------------------------
---@param pet_database? table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Parse_Pet_Database = function(pet_database, error_message, error_count)
    if not pet_database then return error_message, error_count end
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
                        for metric, value in pairs(DB.Pet_Parse[index][pet_name][trackable]) do
                            if metric == DB.Enum.Values.CATALOG then
                                error_message, error_count = Debug.Unit.Parse_Pet_Catalog(pet_database, index, pet_name, trackable, error_message, error_count)
                            else
                                error_message, error_count = Debug.Unit.Parse_Pet(pet_database, index, pet_name, trackable, metric, value, error_message, error_count)
                            end
                        end
                    end
                end
            end
        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse pet nodes.
------------------------------------------------------------------------------------------------------
---@param pet_database table
---@param index string
---@param pet_name string
---@param trackable string
---@param metric string
---@param value integer
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Parse_Pet = function(pet_database, index, pet_name, trackable, metric, value, error_message, error_count)
    -- Check expected data.
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
    -- Check for unexpected data.
    elseif value ~= 0 and value ~= DB.Enum.Values.MAX_DAMAGE then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "PET: Unexpected data: " .. tostring(trackable) .. " " .. tostring(metric) .. " "
                        .. tostring(value)
        error_count = error_count + 1
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse pet catalog nodes.
------------------------------------------------------------------------------------------------------
---@param pet_database table
---@param index string
---@param pet_name string
---@param trackable string
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Parse_Pet_Catalog = function(pet_database, index, pet_name, trackable, error_message, error_count)
    for action_name, _ in pairs(DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG]) do
        for catalog_metric, catalog_value in pairs(DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name]) do
            -- Check expected data.
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
            -- Check for unexpected data.
            elseif catalog_value ~= 0 and catalog_value ~= DB.Enum.Values.MAX_DAMAGE then
                if error_count > 0 then error_message = error_message .. "\n" end
                error_message = error_message .. "PET: Unexpected catalog data: " .. tostring(trackable) .. " " .. tostring(catalog_metric)
                                .. " " .. tostring(action_name) .. " " .. tostring(catalog_value)
                error_count = error_count + 1
            end
        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check unit test result player database.
------------------------------------------------------------------------------------------------------
---@param player_database table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Unit_Player_Database = function(player_database, error_message, error_count)
    if not player_database then return error_message, error_count end
    for index, _ in pairs(player_database) do
        if not DB.Parse[index] then
            if error_count > 0 then error_message = error_message .. "\n" end
            error_message = error_message .. "UNIT: Couldn't find index: " .. tostring(index)
            error_count = error_count + 1
        else
            for trackable, _ in pairs(player_database[index]) do
                for metric, value in pairs(player_database[index][trackable]) do
                    if metric == DB.Enum.Values.CATALOG then
                        error_message, error_count = Debug.Unit.Unit_Player_Catalog(player_database, index, trackable, error_message, error_count)
                    else
                        error_message, error_count = Debug.Unit.Unit_Player(player_database, index, trackable, metric, value, error_message, error_count)
                    end
                end
            end
        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check unit player nodes.
------------------------------------------------------------------------------------------------------
---@param player_database table
---@param index string
---@param trackable string
---@param metric string
---@param value integer
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Unit_Player = function(player_database, index, trackable, metric, value, error_message, error_count)
    -- Check expected data.
    if DB.Parse[index][trackable] and player_database[index][trackable][metric] then
        if DB.Parse[index][trackable][metric] == value then
            -- Pass
        elseif metric == DB.Enum.Metric.MIN and player_database[index][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
            -- Pass
        elseif DB.Parse[index][trackable][metric] == 0 then
            -- Pass
        else
            if error_count > 0 then error_message = error_message .. "\n" end
            error_message = error_message .. "UNIT: Data Mismatch: " .. tostring(index) .. " " .. tostring(trackable) .. " " .. tostring(metric)
            .. " " .. tostring(value) .. " Expected: " .. tostring(player_database[index][trackable][metric])
            error_count = error_count + 1
        end
    -- Check for unexpected data.
    elseif value ~= 0 and value ~= DB.Enum.Values.MAX_DAMAGE then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "UNIT: Unexpected data: " .. tostring(index) .. " " .. tostring(trackable) .. " " .. tostring(metric)
        .. " " .. tostring(value)
        error_count = error_count + 1
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check unit catalog nodes.
------------------------------------------------------------------------------------------------------
---@param player_database table
---@param index string
---@param trackable string
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Unit_Player_Catalog = function(player_database, index, trackable, error_message, error_count)
    for action_name, _ in pairs(player_database[index][trackable][DB.Enum.Values.CATALOG]) do
        for catalog_metric, catalog_value in pairs(player_database[index][trackable][DB.Enum.Values.CATALOG][action_name]) do
            -- Check expected data.
            if DB.Parse[index][trackable]
            and DB.Parse[index][trackable][DB.Enum.Values.CATALOG]
            and DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name]
            and DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] then
                if DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == catalog_value then
                    -- Pass
                elseif catalog_metric == DB.Enum.Metric.MIN
                and DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == DB.Enum.Values.MAX_DAMAGE then
                    -- Pass
                elseif DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == 0 then
                    -- Pass
                else
                    if error_count > 0 then error_message = error_message .. "\n" end
                    error_message = error_message .. "UNIT: Catalog Mismatch: " .. tostring(index) .. " " .. tostring(trackable) .. " "
                    .. tostring(catalog_metric) .. " " .. tostring(action_name) .. " " .. tostring(catalog_value) .. " Expected: "
                    .. tostring(DB.Parse[index][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric])
                    error_count = error_count + 1
                end
            -- Check for unexpected data.
            elseif catalog_value ~= 0 and catalog_value ~= DB.Enum.Values.MAX_DAMAGE then
                if error_count > 0 then error_message = error_message .. "\n" end
                error_message = error_message .. "UNIT: Catalog data not in DB.Parse: " .. tostring(index) .. " " .. tostring(trackable) .. " "
                .. tostring(catalog_metric) .. " " .. tostring(action_name) .. " " .. tostring(catalog_value)
                error_count = error_count + 1
            end

        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check unit test result pet database.
------------------------------------------------------------------------------------------------------
---@param pet_database? table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Unit_Pet_Database = function(pet_database, error_message, error_count)
    if not pet_database then return error_message, error_count end
    for index, _ in pairs(pet_database) do
        if not DB.Pet_Parse[index] then
            if error_count > 0 then error_message = error_message .. "\n" end
            error_message = error_message .. "UNIT PET: Couldn't find index: " .. tostring(index)
            error_count = error_count + 1
        else
            for pet_name, _ in pairs(pet_database[index]) do
                if not DB.Pet_Parse[index][pet_name] then
                    if error_count > 0 then error_message = error_message .. "\n" end
                    error_message = error_message .. "UNIT PET: Couldn't find pet index: " .. tostring(index) .. " " .. tostring(pet_name)
                    error_count = error_count + 1
                else
                    for trackable, _ in pairs(pet_database[index][pet_name]) do
                        for metric, value in pairs(pet_database[index][pet_name][trackable]) do
                            if metric == DB.Enum.Values.CATALOG then
                                error_message, error_count = Debug.Unit.Unit_Pet_Catalog(pet_database, index, pet_name, trackable, error_message, error_count)
                            else
                                error_message, error_count = Debug.Unit.Unit_Pet(pet_database, index, pet_name, trackable, metric, value, error_message, error_count)
                            end
                        end
                    end
                end
            end
        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check unit pet nodes.
------------------------------------------------------------------------------------------------------
---@param pet_database table
---@param index string
---@param pet_name string
---@param trackable string
---@param metric string
---@param value integer
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Unit_Pet = function(pet_database, index, pet_name, trackable, metric, value, error_message, error_count)
    -- Check expected data.
    if DB.Pet_Parse[index][pet_name][trackable]
    and DB.Pet_Parse[index][pet_name][trackable][metric] then
        if DB.Pet_Parse[index][pet_name][trackable][metric] == value then
            -- Pass
        elseif metric == DB.Enum.Metric.MIN and pet_database[index][pet_name][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
            -- Pass
        elseif DB.Pet_Parse[index][pet_name][trackable][metric] == 0 then
            -- Pass
        else
            if error_count > 0 then error_message = error_message .. "\n" end
            error_message = error_message .. "UNIT PET: Data Mismatch: " .. tostring(trackable) .. " " .. tostring(metric) .. " "
                            .. tostring(value) .. " Expected: " .. tostring(DB.Pet_Parse[index][pet_name][trackable][metric])
            error_count = error_count + 1
        end
    -- Check for unexpected data.
    elseif value ~= 0 and value ~= DB.Enum.Values.MAX_DAMAGE then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "UNIT PET: Unexpected data: " .. tostring(trackable) .. " " .. tostring(metric) .. " "
                        .. tostring(value)
        error_count = error_count + 1
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check unit pet catalog nodes.
------------------------------------------------------------------------------------------------------
---@param pet_database table
---@param index string
---@param pet_name string
---@param trackable string
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Unit_Pet_Catalog = function(pet_database, index, pet_name, trackable, error_message, error_count)
    for action_name, _ in pairs(pet_database[index][pet_name][trackable][DB.Enum.Values.CATALOG]) do
        for catalog_metric, catalog_value in pairs(DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name]) do
            -- Check expected data.
            if DB.Pet_Parse[index][pet_name][trackable]
            and DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG]
            and DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name]
            and DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] then
                if DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == catalog_value then
                    -- Pass
                elseif catalog_metric == DB.Enum.Metric.MIN and
                DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == DB.Enum.Values.MAX_DAMAGE then
                    -- Pass
                elseif DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric] == 0 then
                    -- Pass
                else
                    if error_count > 0 then error_message = error_message .. "\n" end
                    error_message = error_message .. "UNIT PET: Catalog Mismatch: " .. tostring(trackable) .. " " .. tostring(catalog_metric)
                                    .. " " .. tostring(action_name) .. " " .. tostring(catalog_value) .. " Expected: "
                                    .. tostring(DB.Pet_Parse[index][pet_name][trackable][DB.Enum.Values.CATALOG][action_name][catalog_metric])
                    error_count = error_count + 1
                end
            -- Check for unexpected data.
            elseif catalog_value ~= 0 and catalog_value ~= DB.Enum.Values.MAX_DAMAGE then
                if error_count > 0 then error_message = error_message .. "\n" end
                error_message = error_message .. "UNIT PET: Unexpected catalog data: " .. tostring(trackable) .. " " .. tostring(catalog_metric)
                                .. " " .. tostring(action_name) .. " " .. tostring(catalog_value)
                error_count = error_count + 1
            end
        end
    end
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check battle log nodes.
------------------------------------------------------------------------------------------------------
---@param expected_data? table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Battle_Log = function(expected_data, error_message, error_count)
    if not expected_data then return error_message, error_count end
    local entry = Blog.Log[1]
    if expected_data.player ~= entry.Player.Value then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "BLOG: Expected player {" .. tostring(expected_data.player) .. "} got {" .. tostring(entry.Player.Value) .. "}"
        error_count = error_count + 1
    end
    if expected_data.pet ~= entry.Pet.Value then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "BLOG: Expected pet {" .. tostring(expected_data.pet) .. "} got {" .. tostring(entry.Pet.Value) .. "}"
        error_count = error_count + 1
    end
    if expected_data.damage ~= entry.Damage.Value then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "BLOG: Expected damage {" .. tostring(expected_data.damage) .. "} got {" .. tostring(entry.Damage.Value) .. "}"
        error_count = error_count + 1
    end
    if expected_data.action ~= entry.Action.Value then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "BLOG: Expected action {" .. tostring(expected_data.action) .. "} got {" .. tostring(entry.Action.Value) .. "}"
        error_count = error_count + 1
    end
    if expected_data.note ~= entry.Note.Value then
        if error_count > 0 then error_message = error_message .. "\n" end
        error_message = error_message .. "BLOG: Expected note {" .. tostring(expected_data.note) .. "} got {" .. tostring(entry.Note.Value) .. "}"
        error_count = error_count + 1
    end
    return error_message, error_count
end