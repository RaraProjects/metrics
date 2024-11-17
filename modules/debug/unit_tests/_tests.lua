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
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Third_Eye())
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
-- Adds an error to unit test result.
------------------------------------------------------------------------------------------------------
---@param error_message string
---@param error_count integer
---@param new_error string
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Add_Error = function(error_message, error_count, new_error)
    if error_count > 0 then error_message = error_message .. "\n" end
    error_message = error_message .. new_error
    error_count = error_count + 1
    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check test results.
------------------------------------------------------------------------------------------------------
---@param test_name string
---@param player table
---@param player_catalog? table
---@param pet? table
---@param pet_catalog? table
---@param battle_log_data? table
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Result = function(test_name, player, player_catalog, pet, pet_catalog, battle_log_data)
    local error_count = 0
    local error_message = ""

    if not player_catalog then player_catalog = T{} end
    if not pet then pet = T{} end
    if not pet_catalog then pet_catalog = T{} end

    error_message, error_count = Debug.Unit.Test_Player(player, error_message, error_count)
    error_message, error_count = Debug.Unit.Test_Player_Catalog(player_catalog, error_message, error_count)
    error_message, error_count = Debug.Unit.Test_Pet_Database(pet, error_message, error_count)
    error_message, error_count = Debug.Unit.Test_Pet_Catalog_Database(pet_catalog, error_message, error_count)
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
-- Check DB.Parse player nodes.
------------------------------------------------------------------------------------------------------
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Player = function(test_cases, error_message, error_count)
    -- Look for values in Parse that we aren't expecting.
    for index, _ in pairs(DB.Parse) do
        if not test_cases[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player Parse had unexpected index: " .. tostring(index))

        -- If the index exists in the database and the test case then check the trackables and metrics.
        else
            for trackable, _ in pairs(DB.Parse[index]) do
                for metric, value in pairs(DB.Parse[index][trackable]) do

                    -- Test data that exists in both the Parse and player test cases.
                    if test_cases[index][trackable] and test_cases[index][trackable][metric] then
                        if test_cases[index][trackable][metric] == value then
                            -- Pass
                        elseif metric == DB.Enum.Metric.MIN and test_cases[index][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
                            -- Pass
                        elseif test_cases[index][trackable][metric] == 0 then
                            -- Pass
                        else
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse Mismatch! "
                            .. "Expected " .. tostring(test_cases[index][trackable][metric]) .. " Observed " .. tostring(value)
                            .. " for " .. tostring(index) .. "|" .. tostring(trackable) .. "|" .. tostring(metric))
                        end

                    elseif metric == DB.Enum.Metric.MIN then
                        if value == DB.Enum.Values.MAX_DAMAGE then
                            -- Pass
                        else
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse Mismatch! "
                            .. "Unexpected Parse value: " .. tostring(index) .. "|" .. tostring(trackable) .. "|" .. tostring(metric) .. "|" .. tostring(value))
                        end

                    -- Look for data that exists in Parse, but not the test cases.
                    elseif value == 0 then
                        -- Pass

                    else
                        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse Mismatch! "
                        .. "Unexpected Parse value: " .. tostring(index) .. "|" .. tostring(trackable) .. "|" .. tostring(metric) .. "|" .. tostring(value))

                    end

                end
            end
        end
    end

    -- Look for expected values that didn't make it into Parse.
    for index, _ in pairs(test_cases) do
        if not DB.Parse[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player test cases had unexpected index: " .. tostring(index))
        else
            for trackable, _ in pairs(test_cases[index]) do
                if not DB.Parse[index][trackable] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player test cases had unexpected trackable: "
                    .. tostring(trackable) .. " for " .. tostring(index))
                else
                    for metric, _ in pairs(test_cases[index][trackable]) do
                        if not DB.Parse[index][trackable][metric] then
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player test cases had unexpected metric: "
                            .. tostring(metric) .. " for " .. tostring(index) .. "|" .. tostring(trackable))
                        end
                    end
                end
            end
        end
    end

    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Parse_Catalog nodes.
------------------------------------------------------------------------------------------------------
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Player_Catalog = function(test_cases, error_message, error_count)
    -- Look for values in Parse_Catalog that we aren't expecting.
    for index, _ in pairs(DB.Parse_Catalog) do
        if not test_cases[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse_Catalog had unexpected index: " .. tostring(index))

        -- If the index exists in the database and the test case then check the action.
        else
            for action_name, _ in pairs(DB.Parse_Catalog[index]) do
                if not test_cases[index][action_name] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse_Catalog had unexpected action: " .. tostring(action_name)
                    .. " for " .. tostring(index))

                -- If the action exists in the database and the test case then check the trackable.
                else
                    for trackable, _ in pairs(DB.Parse_Catalog[index][action_name]) do
                        if not test_cases[index][action_name][trackable] then
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse_Catalog had unexpected trackable: "
                            .. tostring(trackable) .. " for " .. tostring(index) .. "|" .. tostring(action_name))

                        -- If the trackable exists in the database and the test case then check the metric.
                        else
                            for metric, value in pairs(DB.Parse_Catalog[index][action_name][trackable]) do

                                -- Don't need check every metric in the test catalog because it will only have a select few metrics.
                                if test_cases[index][action_name][trackable][metric] then
                                    if test_cases[index][action_name][trackable][metric] == value then
                                        -- Pass
                                    elseif metric == DB.Enum.Metric.MIN and test_cases[index][action_name][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
                                        -- Pass
                                    elseif test_cases[index][action_name][trackable][metric] == 0 then
                                        -- Pass
                                    else
                                        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse_Catalog Mismatch! "
                                        .. "Expected " .. tostring(test_cases[index][action_name][trackable][metric]) .. " Observed " .. tostring(value)
                                        .. " for " .. tostring(index) .. "|" .. tostring(action_name) .. "|" .. tostring(trackable) .. "|" .. tostring(metric))
                                    end

                                elseif metric == DB.Enum.Metric.MIN then
                                    if value == DB.Enum.Values.MAX_DAMAGE then
                                        -- Pass
                                    else
                                        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse_Catalog Mismatch! "
                                        .. "Unexpected Parse value: " .. tostring(index) .. "|" .. tostring(action_name) .. "|" .. tostring(trackable)
                                        .. "|" .. tostring(metric).. "|" .. tostring(value))
                                    end

                                -- Look for data that exists in Parse, but not the test cases.
                                elseif value == 0 then
                                    -- Pass

                                else
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Parse_Catalog Mismatch! "
                                    .. "Unexpected Parse value: " .. tostring(index) .. "|" .. tostring(action_name) .. "|" .. tostring(trackable)
                                    .. "|" .. tostring(metric).. "|" .. tostring(value))
                                end

                            end
                        end
                    end
                end
            end
        end
    end

    -- Look for expected values that didn't make it into Parse_Catalog.
    for index, _ in pairs(test_cases) do
        if not DB.Parse_Catalog[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player Catalog test cases had unexpected index: " .. tostring(index))
        else
            for action_name, _ in pairs(test_cases[index]) do
                if not DB.Parse_Catalog[index][action_name] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player Catalog test cases had unexpected action_name: "
                    .. tostring(action_name) .. " for " .. tostring(index))
                else
                    for trackable, _ in pairs(test_cases[index][action_name]) do
                        if not DB.Parse_Catalog[index][action_name][trackable] then
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Player Catalog test cases had unexpected trackable: "
                            .. tostring(trackable) .. " for " .. tostring(index) .. "|" .. tostring(action_name))
                        end
                    end
                end
            end
        end
    end

    return error_message, error_count
end

------------------------------------------------------------------------------------------------------
-- Check DB.Pet_Parse database.
------------------------------------------------------------------------------------------------------
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Pet_Database = function(test_cases, error_message, error_count)
    -- Look for values in Parse that we aren't expecting.
    for index, _ in pairs(DB.Pet_Parse) do
        if not test_cases[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse had unexpected index: " .. tostring(index))

        -- If the index exists in the database and the test case then check the pet name.
        else
            for pet_name, _ in pairs(DB.Pet_Parse[index]) do
                if not test_cases[index][pet_name] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse had unexpected pet for: "
                    .. tostring(index) .. "|" .. tostring(pet_name))

                -- If the pet exists in the database and the test case then check the trackables and metrics.
                else
                    for trackable, _ in pairs(DB.Pet_Parse[index][pet_name]) do
                        for metric, value in pairs(DB.Pet_Parse[index][pet_name][trackable]) do

                            -- Test data that exists in both the database test cases.
                            if test_cases[index][pet_name][trackable] and test_cases[index][pet_name][trackable][metric] then
                                if test_cases[index][pet_name][trackable][metric] == value then
                                    -- Pass
                                elseif metric == DB.Enum.Metric.MIN and test_cases[index][pet_name][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
                                    -- Pass
                                elseif test_cases[index][pet_name][trackable][metric] == 0 then
                                    -- Pass
                                else
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse Mismatch! "
                                    .. "Expected " .. tostring(test_cases[index][pet_name][trackable][metric]) .. " Observed " .. tostring(value)
                                    .. " for " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(trackable) .. "|" .. tostring(metric))
                                end

                            elseif metric == DB.Enum.Metric.MIN then
                                if value == DB.Enum.Values.MAX_DAMAGE then
                                    -- Pass
                                else
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse Mismatch! "
                                    .. "Unexpected value: " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(trackable) .. "|"
                                    .. tostring(metric) .. "|" .. tostring(value))
                                end

                            -- Look for data that exists in the database, but not the test cases.
                            elseif value == 0 then
                                -- Pass

                            else
                                error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse Mismatch! "
                                .. "Unexpected value: " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(trackable) .. "|"
                                .. tostring(metric) .. "|" .. tostring(value))

                            end

                        end
                    end
                end
            end
        end
    end

    -- Look for expected values that didn't make it into the database.
    for index, _ in pairs(test_cases) do
        if not DB.Pet_Parse[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet test cases had unexpected index: " .. tostring(index))

        -- If the index exists in the database then check the pet name.
        else
            for pet_name, _ in pairs(test_cases[index]) do
                if not DB.Pet_Parse[index][pet_name] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet test cases had unexpected pet: "
                    .. tostring(index) .. "|" .. tostring(pet_name))

                -- If the pet name exists in the database then check the trackables.
                else
                    for trackable, _ in pairs(test_cases[index][pet_name]) do
                        if not DB.Pet_Parse[index][pet_name][trackable] then
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet test cases had unexpected trackable: "
                            .. tostring(trackable) .. " for " .. tostring(index) .. "|" .. tostring(pet_name))

                        -- If the trackable exists in the database then check the metrics.
                        else
                            for metric, _ in pairs(test_cases[index][pet_name][trackable]) do
                               if not DB.Pet_Parse[index][pet_name][trackable][metric] then
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet test cases had unexpected metric: "
                                    .. tostring(metric) .. " for " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(trackable))
                               end
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
-- Check DB.Parse pet catalog nodes.
------------------------------------------------------------------------------------------------------
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Pet_Catalog_Database = function(test_cases, error_message, error_count)
    -- Look for values in the database that we aren't expecting.
    for index, _ in pairs(DB.Pet_Parse_Catalog) do
        if not test_cases[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog had unexpected index: " .. tostring(index))

        -- If the index exists in the database and the test case then check the pet name.
        else
            for pet_name, _ in pairs(DB.Pet_Parse_Catalog[index]) do
                if not test_cases[index][pet_name] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog had unexpected pet name: "
                    .. tostring(index .. "|" .. tostring(pet_name)))

                -- If the pet name exists in the database and the test case then check the action.
                else
                    for action_name, _ in pairs(DB.Pet_Parse_Catalog[index][pet_name]) do
                        if not test_cases[index][pet_name][action_name] then
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog had unexpected action: " .. tostring(action_name)
                            .. " for " .. tostring(index) .. "|" .. tostring(pet_name))

                        -- If the action exists in the database and the test case then check the trackable.
                        else
                            for trackable, _ in pairs(DB.Pet_Parse_Catalog[index][pet_name][action_name]) do
                                if not test_cases[index][pet_name][action_name][trackable] then
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog had unexpected trackable: "
                                    .. tostring(trackable) .. " for " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(action_name))

                                -- If the trackable exists in the database and the test case then check the metric.
                                else
                                    for metric, value in pairs(DB.Pet_Parse_Catalog[index][pet_name][action_name][trackable]) do

                                        -- Don't need check every metric in the test catalog because it will only have a select few metrics.
                                        if test_cases[index][pet_name][action_name][trackable][metric] then
                                            if test_cases[index][pet_name][action_name][trackable][metric] == value then
                                                -- Pass
                                            elseif metric == DB.Enum.Metric.MIN and test_cases[index][pet_name][action_name][trackable][metric] == DB.Enum.Values.MAX_DAMAGE then
                                                -- Pass
                                            elseif test_cases[index][pet_name][action_name][trackable][metric] == 0 then
                                                -- Pass
                                            else
                                                error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog Mismatch! "
                                                .. "Expected " .. tostring(test_cases[index][pet_name][action_name][trackable][metric]) .. " Observed ".. tostring(value)
                                                .. " for " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(action_name) .. "|" .. tostring(trackable)
                                                .. "|" .. tostring(metric))
                                            end

                                        elseif metric == DB.Enum.Metric.MIN then
                                            if value == DB.Enum.Values.MAX_DAMAGE then
                                                -- Pass
                                            else
                                                error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog Mismatch! "
                                                .. "Unexpected Parse value: " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(action_name)
                                                .. "|" .. tostring(trackable) .. "|" .. tostring(metric).. "|" .. tostring(value))
                                            end

                                        -- Look for data that exists in Parse, but not the test cases.
                                        elseif value == 0 then
                                            -- Pass

                                        else
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet_Parse_Catalog Mismatch! "
                                            .. "Unexpected Parse value: " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(action_name)
                                            .. "|" .. tostring(trackable) .. "|" .. tostring(metric).. "|" .. tostring(value))
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

    -- Look for expected values that didn't make it into Pet_Parse_Catalog.
    for index, _ in pairs(test_cases) do
        if not DB.Pet_Parse_Catalog[index] then
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet Catalog test cases had unexpected index: " .. tostring(index))

        -- If the index exists in the database then check for pet names.
        else
            for pet_name, _ in pairs(test_cases[index]) do
                if not DB.Pet_Parse_Catalog[index][pet_name] then
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet Catalog test cases had unexpected pet: "
                    .. tostring(index) .. "|" .. tostring(pet_name))

                -- If the pet name exists in the database then check for actions.
                else
                    for action_name, _ in pairs(test_cases[index][pet_name]) do
                        if not DB.Pet_Parse_Catalog[index][pet_name][action_name] then
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet Catalog test cases had unexpected action_name: "
                            .. tostring(action_name) .. " for " .. tostring(index) .. "|" .. tostring(pet_name))

                        -- If the action name exists in the database then check for trackables.
                        else
                            for trackable, _ in pairs(test_cases[index][pet_name][action_name]) do
                                if not DB.Pet_Parse_Catalog[index][pet_name][action_name][trackable] then
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Pet Catalog test cases had unexpected trackable: "
                                    .. tostring(trackable) .. " for " .. tostring(index) .. "|" .. tostring(pet_name) .. "|" .. tostring(action_name))
                                end
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