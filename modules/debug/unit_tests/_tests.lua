Debug.Unit = {}
Debug.Unit.Action_Data = {}
Debug.Unit.Action_Data.Player = {}
Debug.Unit.Util = {}
Debug.Unit.Tests = {}
Debug.Unit.Results = {}
Debug.Unit.Mob = {}
Debug.Unit.Active = false
Debug.Unit.Has_Pet = false

Debug.Unit.Mob.Target_ID = 3333333
Debug.Unit.Mob.Target_ID_Two = 4444444

Debug.Unit.Mob.PLAYER = {} -- Gets populated dynamically when running the tests.

Debug.Unit.Mob.PET = {
    name = "Pet Name",
    id = 2222222,
    index = 2222222,
    target_index = 2222222,
    spawn_flags = Ashita.EntityType.PET,
    in_party = true,
    in_alliance = false,
}

Debug.Unit.Mob.ENEMY = {
    name = "Enemy",
    id = 3333333,
    index = 3333333,
    target_index = 3333333,
    spawn_flags = Ashita.EntityType.MOB,
    in_party = false,
    in_alliance = false,
}

Debug.Unit.Mob.ENEMY_TWO = {
    name = "Enemy Two",
    id = 4444444,
    index = 4444444,
    target_index = 4444444,
    spawn_flags = Ashita.EntityType.MOB,
    in_party = false,
    in_alliance = false,
}

Debug.Unit.Mob.PLAYER_TWO = {
    name = "Player Two",
    id = 5555555,
    index = 5555555,
    target_index = 5555555,
    pet_index = 6666666,
    spawn_flags = Ashita.EntityType.OTHERPLAYER,
    in_party = true,
    in_alliance = true,
}

Debug.Unit.Mob.PET_TWO = {
    name = "Pet Two",
    id = 6666666,
    index = 6666666,
    target_index = 6666666,
    spawn_flags = Ashita.EntityType.PET,
    in_party = false,
    in_alliance = false,
}

------------------------------------------------------------------------------------------------------
-- Resets modules between each test.
------------------------------------------------------------------------------------------------------
Debug.Unit.Reset = function()
    DB.Initialize(true)
    Blog.Initialize()
end

------------------------------------------------------------------------------------------------------
-- Populates the Unit Test Window.
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

        local errors_found = false
        for _, result in ipairs(Debug.Unit.Results) do
            if result.count > 0 then
                errors_found = true
                UI.TableNextColumn() UI.Text(result.test)
                UI.TableNextColumn() UI.TextColored(result.color, result.result)
                UI.TableNextColumn() UI.Text(tostring(result.count))
                UI.TableNextColumn() UI.Text(result.message)
                Window_Manager.Table_Row_Color(row)
                row = row + 1
            end
        end

        if not errors_found then
            UI.TableNextColumn() UI.Text("No errors found.")
            UI.TableNextColumn() UI.Text("---")
            UI.TableNextColumn() UI.Text("---")
            UI.TableNextColumn() UI.Text("---")
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Short circuits Ashita.Mob.Data so that I can create a pet for unit tests.
------------------------------------------------------------------------------------------------------
Debug.Unit.Get_Mob = function(mob_id)
    if Debug.Enabled and Debug.Unit.Active then
        if mob_id == 2222222 then
            return Debug.Unit.Mob.PET
        elseif mob_id == 3333333 then
            return Debug.Unit.Mob.ENEMY
        elseif mob_id == 4444444 then
            return Debug.Unit.Mob.ENEMY_TWO
        elseif mob_id == 5555555 then
            return Debug.Unit.Mob.PLAYER_TWO
        elseif mob_id == 6666666 then
            return Debug.Unit.Mob.PET_TWO
        else
            if Debug.Unit.Mob.PLAYER.id then return Debug.Unit.Mob.PLAYER end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Run unit tests.
------------------------------------------------------------------------------------------------------
Debug.Unit.Run_Tests = function()
    Debug.Unit.Active = true
    Debug.Unit.Mob.PLAYER = Ashita.Mob.Get_Mob_By_Target(Ashita.TargetString.ME)

    -- Melee
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Off_Hand_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Off_Hand_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Kick_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Kick_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Kick_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Multi_Attack())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Multi_Attack_Hit_Miss_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Multi_Attack_Hit_Miss_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Multi_Attack_Miss_Miss_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Multi_Attack_Kick())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Main_Multi_Attack_Enspell())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Paralyzed())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Intimidated())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Mob_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Pet_Mob_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Enspell())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Endamage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Endebuff())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Enaspir())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Endrain())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Spikes())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Square())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Truestrike())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Melee.Daken_Crit())

    -- Ranged
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Square())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Truestrike())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.PUP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Mob_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Endamage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Endebuff())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Ranged.Endrain())

    -- TP Action
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.TP_Action.Shadow())
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
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Nuke_Shadow())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Nuke_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Nuke_AOE_Burst())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Pet_Nuke())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Healing())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Healing_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Pet_Heal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.DoT_No_Damage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.DoT_Damage())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Poison())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Aspir())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Aspir_Burst())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_Land())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_Resist())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_No_Effect())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_Shadow())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_AOE_Land())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Enfeeble_AOE_One_Resist())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Dispel())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Song())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Status_Removal())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Buff())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Spells.Misc())

    -- Defense
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Parry())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Shadows())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Third_Eye())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Counter())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Guard())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Shield())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Crit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Spikes())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Enspell())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Pet_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Melee_Pet_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Ranged_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Ranged_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Shadow())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Pet())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Primary())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.Nuke_Pet_AOE_Secondary())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Miss())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Shadow())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_MP())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_No_Damage_Skill_Hit())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_AOE())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Pet())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Pet_AOE_Primary())
    table.insert(Debug.Unit.Results, Debug.Unit.Tests.Defense.TP_Pet_AOE_Secondary())

    Debug.Unit.Active = false
end

------------------------------------------------------------------------------------------------------
-- Builds a target packet.
------------------------------------------------------------------------------------------------------
---@param id integer
---@param param integer
---@param animation? integer
---@param reaction? integer
---@param message? integer
---@param has_add_effect? boolean
---@param add_effect_param? integer
---@param add_effect_animation? integer
---@param add_effect_message? integer
---@param has_spike_effect? boolean
---@param spike_effect_param? integer
---@param spike_effect_animation? integer
---@param spike_effect_message? integer
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Util.Build_Target_Packet = function(id, param, animation, reaction, message,
                                        has_add_effect, add_effect_param, add_effect_animation, add_effect_message,
                                        has_spike_effect, spike_effect_param, spike_effect_animation, spike_effect_message)
    local packet = {}

    packet.id    = id or 0
    packet.param = param or 0

    packet.animation = animation or 0
    packet.reaction  = reaction or 0
    packet.message   = message or 0

    packet.has_add_effect       = has_add_effect
    packet.add_effect_param     = add_effect_param or 0
    packet.add_effect_animation = add_effect_animation or 0
    packet.add_effect_message   = add_effect_message or 0 -- Skillchains

    packet.has_spike_effect       = has_spike_effect
    packet.spike_effect_param     = spike_effect_param or 0
    packet.spike_effect_animation = spike_effect_animation or 0
    packet.spike_effect_message   = spike_effect_message or 0

    return packet
end

------------------------------------------------------------------------------------------------------
-- Build the fake result table.
------------------------------------------------------------------------------------------------------
---@param packet_rounds table
---@param action_id? integer
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Util.Build_Action = function(packet_rounds, action_id)
    local action = {}
    action.param = action_id

    action.targets = {}
    local target_data = {}
    local action_data = {}

    for _, target_round in ipairs(packet_rounds) do
        target_data = {}
        target_data.id = target_round.id or 0
        target_data.actions = {}

        action_data = {}
        action_data.param = target_round.param or 0

        action_data.animation = target_round.animation or 0
        action_data.reaction  = target_round.reaction or 0
        action_data.message   = target_round.message or 0

        action_data.has_add_effect       = target_round.has_add_effect
        action_data.add_effect_param     = target_round.add_effect_param or 0
        action_data.add_effect_animation = target_round.add_effect_animation or 0
        action_data.add_effect_message   = target_round.add_effect_message or 0 -- Skillchains

        action_data.has_spike_effect       = target_round.has_spike_effect
        action_data.spike_effect_param     = target_round.spike_effect_param or 0
        action_data.spike_effect_animation = target_round.spike_effect_animation or 0
        action_data.spike_effect_message   = target_round.spike_effect_message or 0

        table.insert(target_data.actions, action_data)
        table.insert(action.targets, target_data)
    end

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
---@param package table
---@return table
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Result = function(test_name, package)
    local error_count = 0
    local error_message = ""

    local player         = package.player or {}
    local player_catalog = package.player_catalog or {}
    local pet            = package.pet or {}
    local pet_catalog    = package.pet_catalog or {}
    local misc           = package.misc or {}

    error_message, error_count = Debug.Unit.Test_Player("DB.Parse", DB.Parse, player, error_message, error_count)
    error_message, error_count = Debug.Unit.Test_Player_Catalog("DB.Parse_Catalog", DB.Parse_Catalog, player_catalog, error_message, error_count)
    error_message, error_count = Debug.Unit.Test_Pet_Database("DB.Pet_Parse", DB.Pet_Parse, pet, error_message, error_count)
    error_message, error_count = Debug.Unit.Test_Pet_Catalog_Database("DB.Pet_Parse_Catalog", DB.Pet_Parse_Catalog, pet_catalog, error_message, error_count)
    error_message, error_count = Debug.Unit.Check_Battle_Log(package.battle_log, error_message, error_count)
    error_message, error_count = Debug.Unit.Check_Misc_Data(misc, error_message, error_count)

    local result = "Pass!"
    local color  = Res.Colors.Basic.GREEN
    if error_count > 0 then
        result = "Fail"
        color  = Res.Colors.Basic.RED
    end

    return {test = test_name, result = result, color = color, count = error_count, message = error_message}
end

------------------------------------------------------------------------------------------------------
-- Check database player nodes.
------------------------------------------------------------------------------------------------------
---@param name string
---@param database table
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Player = function(name, database, test_cases, error_message, error_count)
    local error = nil

    -- Look for values in the database that we aren't expecting.
    for player_name, _ in pairs(database) do
        if not test_cases[player_name] then
            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

        else
            for target_name, _ in pairs(database[player_name]) do
                if not test_cases[player_name][target_name] then
                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                -- If the index exists in the database and the test case then check the trackables and metrics.
                else
                    for trackable, _ in pairs(database[player_name][target_name]) do
                        for metric, database_value in pairs(database[player_name][target_name][trackable]) do

                            -- Test data that the database data exists in the test cases.
                            -- If the test data exists.
                            if test_cases[player_name][target_name][trackable] and test_cases[player_name][target_name][trackable][metric] then
                                local test_case_value = test_cases[player_name][target_name][trackable][metric]
                                if test_case_value == database_value then
                                    -- Pass (Match)
                                elseif DB.Metric_Needs_Max_Value(metric) and test_case_value == DB.Enum.MAX_DAMAGE then
                                    -- Pass (Default Minimum)
                                elseif test_case_value == 0 then
                                    -- Pass (Default Zero)
                                else
                                    error = "Mismatch: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                    .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value) .. ". Expected: " .. tostring(test_case_value)
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                end

                            -- I don't set minimums for every metric in the unit tests. Filter out defaulted minimums if not explicitly stated in the test case.
                            elseif DB.Metric_Needs_Max_Value(metric) then
                                if database_value == DB.Enum.MAX_DAMAGE then
                                    -- Pass (Default Minimum)
                                else
                                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                    .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                end

                            -- I don't set zeroes for every metric in the unit tests. Filter out defaulted zeroes if not explicitly stated in the test case.
                            elseif database_value == 0 then
                                -- Pass (Default Zero)

                            -- Found some data that was set in the database but is unaccounted for in the test cases.
                            else
                                error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                            end

                        end
                    end
                end
            end
        end
    end

    -- Look for test values that didn't get set in the database.
    for player_name, _ in pairs(test_cases) do
        if not database[player_name] then
            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
        else
            for target_name, _ in pairs(test_cases[player_name]) do
                if not database[player_name][target_name] then
                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                else
                    for trackable, _ in pairs(test_cases[player_name][target_name]) do
                        if not database[player_name][target_name][trackable] then
                            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(target_name)
                            .. "][" .. tostring(trackable) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                        else
                            for metric, _ in pairs(test_cases[player_name][target_name][trackable]) do
                                if not database[player_name][target_name][trackable][metric] then
                                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(target_name)
                                    .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "]"
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
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
-- Check player catalog nodes.
------------------------------------------------------------------------------------------------------
---@param name string
---@param database table
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Player_Catalog = function(name, database, test_cases, error_message, error_count)
    local error = nil

    -- Look for values in the database that we aren't expecting.
    for player_name, _ in pairs(database) do
        if not test_cases[player_name] then
            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

        -- If the player exists in the database and the test case then check the target.
        else
            for target_name, _ in pairs(database[player_name]) do
                if not test_cases[player_name][target_name] then
                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                -- If the target exists in the database and the test case then check the action.
                else
                    for action_name, _ in pairs(database[player_name][target_name]) do
                        if not test_cases[player_name][target_name][action_name] then
                            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "][" .. tostring(action_name) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                        -- If the action exists in the database and the test case then check the trackable.
                        else
                            for trackable, _ in pairs(database[player_name][target_name][action_name]) do
                                if not test_cases[player_name][target_name][action_name][trackable] then
                                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                    .. tostring(action_name) .. "][" .. tostring(trackable) .. "]"
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                                -- If the trackable exists in the database and the test case then check the metric.
                                else
                                    for metric, database_value in pairs(database[player_name][target_name][action_name][trackable]) do

                                        -- Don't need check every metric in the test catalog because it will only have a select few metrics.
                                        if test_cases[player_name][target_name][action_name][trackable][metric] then
                                            local test_case_value = test_cases[player_name][target_name][action_name][trackable][metric]
                                            if test_case_value == database_value then
                                                -- Pass (Match)
                                            elseif DB.Metric_Needs_Max_Value(metric) and test_case_value == DB.Enum.MAX_DAMAGE then
                                                -- Pass (Default Minimum)
                                            elseif test_case_value == 0 then
                                                -- Pass (Default Zero)
                                            else
                                                error = "Mismatch: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                                .. tostring(action_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "] = "
                                                .. tostring(database_value) .. ". Expected: " .. tostring(test_case_value)
                                                error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                            end

                                        -- I don't set minimums for every metric in the unit tests. Filter out defaulted minimums if not explicitly stated in the test case.
                                        elseif DB.Metric_Needs_Max_Value(metric) then
                                            if database_value == DB.Enum.MAX_DAMAGE then
                                                -- Pass (Default Minimum)
                                            else
                                                error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                                .. tostring(action_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                                error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                            end

                                        -- I don't set zeroes for every metric in the unit tests. Filter out defaulted zeroes if not explicitly stated in the test case.
                                        elseif database_value == 0 then
                                            -- Pass (Default Zero)

                                        -- Found some data that was set in the database but is unaccounted for in the test cases.
                                        else
                                            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                            .. tostring(action_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
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

    -- Look for test values that didn't get set in the database.
    for player_name, _ in pairs(test_cases) do
        if not database[player_name] then
            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
        else
            for target_name, _ in pairs(test_cases[player_name]) do
                if not database[player_name][target_name] then
                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                else
                    for action_name, _ in pairs(test_cases[player_name][target_name]) do
                        if not database[player_name][target_name][action_name] then
                            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(target_name)
                            .. "][" .. tostring(action_name) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                        else
                            for trackable, _ in pairs(test_cases[player_name][target_name][action_name]) do
                                if not database[player_name][target_name][action_name][trackable] then
                                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(target_name) .. "]["
                                    .. tostring(action_name) .. "][" .. tostring(trackable) .. "]"
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
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
-- Check the pet database.
------------------------------------------------------------------------------------------------------
---@param name string
---@param database table
---@param test_cases table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Test_Pet_Database = function(name, database, test_cases, error_message, error_count)
    local error = nil

    -- Look for values in the database that we aren't expecting.
    for player_name, _ in pairs(database) do
        if not test_cases[player_name] then
            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

        -- If the player exists in the database and the test case then check the pet name.
        else
            for pet_name, _ in pairs(database[player_name]) do
                if not test_cases[player_name][pet_name] then
                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                -- If the pet exists in the database and the test case then check the target name.
                else
                    for target_name, _ in pairs(database[player_name][pet_name]) do
                        if not test_cases[player_name][pet_name][target_name] then
                            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "][" .. tostring(target_name) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                        -- If the target exists in the database and the test case then check the trackables and metrics.
                        else
                            for trackable, _ in pairs(database[player_name][pet_name][target_name]) do
                                for metric, database_value in pairs(database[player_name][pet_name][target_name][trackable]) do

                                    -- Test data that the database data exists in the test cases.
                                    -- If the test data exists.
                                    if test_cases[player_name][pet_name][target_name][trackable] and test_cases[player_name][pet_name][target_name][trackable][metric] then
                                        local test_case_value = test_cases[player_name][pet_name][target_name][trackable][metric]
                                        if test_case_value == database_value then
                                            -- Pass (Match)
                                        elseif DB.Metric_Needs_Max_Value(metric) and test_case_value == DB.Enum.MAX_DAMAGE then
                                            -- Pass (Default Minimum)
                                        elseif test_case_value == 0 then
                                            -- Pass (Default Zero)
                                        else
                                            error = "Mismatch: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                            .. tostring(target_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                            .. ". Expected: " .. tostring(test_case_value)
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                        end

                                    -- I don't set minimums for every metric in the unit tests. Filter out defaulted minimums if not explicitly stated in the test case.
                                    elseif DB.Metric_Needs_Max_Value(metric) then
                                        if database_value == DB.Enum.MAX_DAMAGE then
                                            -- Pass (Default Minimum)
                                        else
                                            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                            .. tostring(target_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                        end

                                    -- I don't set zeroes for every metric in the unit tests. Filter out defaulted zeroes if not explicitly stated in the test case.
                                    elseif database_value == 0 then
                                        -- Pass (Default Zero)

                                    -- Found some data that was set in the database but is unaccounted for in the test cases.
                                    else
                                        error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                        .. tostring(target_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "] = " .. tostring(database_value)
                                        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                    end

                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Look for test values that didn't get set in the database.
    for player_name, _ in pairs(test_cases) do
        if not database[player_name] then
            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
        else
            for pet_name, _ in pairs(test_cases[player_name]) do
                if not database[player_name][pet_name] then
                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                else
                    for target_name, _ in pairs(test_cases[player_name][pet_name]) do
                        if not database[player_name][pet_name][target_name] then
                            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "][" .. tostring(target_name) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                        else
                            for trackable, _ in pairs(test_cases[player_name][pet_name][target_name]) do
                                if not database[player_name][pet_name][target_name][trackable] then
                                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                    .. tostring(target_name) .. "][" .. tostring(trackable) .. "]"
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                else
                                    for metric, _ in pairs(test_cases[player_name][pet_name][target_name][trackable]) do
                                        if not database[player_name][pet_name][target_name][trackable][metric] then
                                            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                            .. tostring(target_name) .. "][" .. tostring(trackable) .. "][" .. tostring(metric) .. "]"
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
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
Debug.Unit.Test_Pet_Catalog_Database = function(name, database, test_cases, error_message, error_count)
    local error = nil

    -- Look for values in the database that we aren't expecting.
    for player_name, _ in pairs(database) do
        if not test_cases[player_name] then
            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

        -- If the player exists in the database and the test case then check the pet name.
        else
            for pet_name, _ in pairs(database[player_name]) do
                if not test_cases[player_name][pet_name] then
                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                -- If the pet name exists in the database and the test case then check the target name.
                else
                    for target_name, _ in pairs(database[player_name][pet_name]) do
                        if not test_cases[player_name][pet_name][target_name] then
                            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "][" .. tostring(target_name) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                        -- If the target name exists in the database and the test case then check the action name.
                        else
                            for action_name, _ in pairs(database[player_name][pet_name][target_name]) do
                                if not test_cases[player_name][pet_name][target_name][action_name] then
                                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                    .. tostring(target_name) .. "][" .. tostring(action_name) .. "]"
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                                -- If the action exists in the database and the test case then check the trackable.
                                else
                                    for trackable, _ in pairs(database[player_name][pet_name][target_name][action_name]) do
                                        if not test_cases[player_name][pet_name][target_name][action_name][trackable] then
                                            error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                            .. tostring(target_name) .. "][" .. tostring(action_name) .. "][" .. tostring(trackable) .. "]"
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)

                                        -- If the trackable exists in the database and the test case then check the metric.
                                        else
                                            for metric, database_value in pairs(DB.Pet_Parse_Catalog[player_name][pet_name][target_name][action_name][trackable]) do

                                                -- Test data that the database data exists in the test cases.
                                                -- If the test data exists.
                                                if test_cases[player_name][pet_name][target_name][action_name][trackable]
                                                and test_cases[player_name][pet_name][target_name][action_name][trackable][metric] then
                                                    local test_case_value = test_cases[player_name][pet_name][target_name][action_name][trackable][metric]
                                                    if test_case_value == database_value then
                                                        -- Pass (Match)
                                                    elseif DB.Metric_Needs_Max_Value(metric) and test_case_value == DB.Enum.MAX_DAMAGE then
                                                        -- Pass (Default Minimum)
                                                    elseif test_case_value == 0 then
                                                        -- Pass (Default Zero)
                                                    else
                                                        error = "Mismatch: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                                        .. tostring(target_name) .. "][" .. tostring(action_name) .. "][ " .. tostring(trackable) .. "]["
                                                        .. tostring(metric) .. "] = " .. tostring(database_value)
                                                        .. ". Expected: " .. tostring(test_case_value)
                                                        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                                    end

                                                -- I don't set minimums for every metric in the unit tests. Filter out defaulted minimums if not explicitly stated in the test case.
                                                elseif DB.Metric_Needs_Max_Value(metric) then
                                                    if database_value == DB.Enum.MAX_DAMAGE then
                                                        -- Pass (Default Minimum)
                                                    else
                                                        error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                                        .. tostring(target_name) .. "][" .. tostring(action_name) .. "][" .. tostring(trackable) .. "]["
                                                        .. tostring(metric) .. "] = " .. tostring(database_value)
                                                        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                                    end

                                                -- I don't set zeroes for every metric in the unit tests. Filter out defaulted zeroes if not explicitly stated in the test case.
                                                elseif database_value == 0 then
                                                    -- Pass (Default Zero)

                                                -- Found some data that was set in the database but is unaccounted for in the test cases.
                                                else
                                                    error = "Unexpected: " .. tostring(name) .. "[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                                    .. tostring(target_name) .. "][" .. tostring(action_name) .. "][" .. tostring(trackable) .. "]["
                                                    .. tostring(metric) .. "] = " .. tostring(database_value)
                                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
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
        end
    end

    -- Look for test values that didn't get set in the database.
    for player_name, _ in pairs(test_cases) do
        if not database[player_name] then
            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "]"
            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
        else
            for pet_name, _ in pairs(test_cases[player_name]) do
                if not database[player_name][pet_name] then
                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]"
                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                else
                    for target_name, _ in pairs(test_cases[player_name][pet_name]) do
                        if not database[player_name][pet_name][target_name] then
                            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "][" .. tostring(target_name) .. "]"
                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                        else
                            for action_name, _ in pairs(test_cases[player_name][pet_name][target_name]) do
                                if not database[player_name][pet_name][target_name][action_name] then
                                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                    .. tostring(target_name) .. "][" .. tostring(action_name) .. "]"
                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                else
                                    for trackable, _ in pairs(test_cases[player_name][pet_name][target_name][action_name]) do
                                        if not database[player_name][pet_name][target_name][action_name][trackable] then
                                            error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                            .. tostring(target_name) .. "][" .. tostring(action_name) .. "][" .. tostring(trackable) .. "]"
                                            error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
                                        else
                                            for metric, _ in pairs(test_cases[player_name][pet_name][target_name][action_name][trackable]) do
                                                if not database[player_name][pet_name][target_name][action_name][trackable][metric] then
                                                    error = tostring(name) .. " Unexpected: Test_Case[" .. tostring(player_name) .. "][" .. tostring(pet_name) .. "]["
                                                    .. tostring(target_name) .. "][" .. tostring(action_name) .. "][" .. tostring(trackable) .. "]["
                                                    .. tostring(metric) .. "]"
                                                    error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, error)
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
    if not entry then
        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "BLOG: No entry for {" .. tostring(expected_data.player) .. "}.")
        return error_message, error_count
    end

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

------------------------------------------------------------------------------------------------------
-- Check miscellaneous nodes.
------------------------------------------------------------------------------------------------------
---@param expected_data? table
---@param error_message string
---@param error_count integer
---@return string
---@return integer
------------------------------------------------------------------------------------------------------
Debug.Unit.Check_Misc_Data = function(expected_data, error_message, error_count)
    if not expected_data then return error_message, error_count end
    if expected_data["Total Damage"] and expected_data["Total Damage"] ~= DB.Total_Damage then
        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Misc - Total Damage: Expected {"
        .. tostring(expected_data["Total Damage"]) .. "} got {" .. tostring(DB.Total_Damage) .. "}.")
    end
    if expected_data["Total Damage No Skillchain"] and expected_data["Total Damage No Skillchain"] ~= DB.Total_Damage_No_Skillchain then
        error_message, error_count = Debug.Unit.Add_Error(error_message, error_count, "Misc - Total Damage No Skillchain: Expected {"
        .. tostring(expected_data["Total Damage No Skillchain"]) .. "} got {" .. tostring(DB.Total_Damage_No_Skillchain) .. "}.")
    end
    return error_message, error_count
end