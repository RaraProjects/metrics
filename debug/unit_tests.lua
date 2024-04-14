_Debug.Unit = {}
_Debug.Unit.Action_Data = {}
_Debug.Unit.Action_Data.Player = {}
_Debug.Unit.Util = {}
_Debug.Unit.Tests = {}
_Debug.Unit.Mob = {}
_Debug.Unit.Active = false


_Debug.Unit.Mob.PLAYER = {
    name = "Player",
    id = 1,
    index = 1,
    target_index = 1,
    pet_index = 2,
    spawn_flags = 525,
    in_party = true,
    in_alliance = false,
}

_Debug.Unit.Mob.PET = {
    name = "Pet Name",
    id = 2,
    index = 2,
    target_index = 2,
    spawn_flags = 258,
    in_party = true,
    in_alliance = false,
}

_Debug.Unit.Mob.ENEMY = {
    name = "Enemy",
    id = 3,
    index = 3,
    target_index = 3,
    spawn_flags = 16,
    in_party = false,
    in_alliance = false,
}

-- Create fake packets to represent actions.
-- Add checks to block game packets while unit tests are active.
-- Run the handler functions wit hthe fake packets.
-- The fake data should be visible on the screen and also have a numeric check for each test.
-- MAYBE: Need to edit the Ashita functions to use fake data instead of pulling from Ashita for the tests.

_Debug.Unit.Util.Build_Action = function(action_id, target_id, damage, animation_id, message_id)
    local action = {}
    action.param = action_id
    action.targets = {}

    local target_data = {}
    target_data.id = target_id
    target_data.actions = {}

    local action_data = {}
    action_data.param = damage
    action_data.animation = animation_id
    action_data.message = message_id
    action_data.add_effect_param = 0

    table.insert(target_data.actions, action_data)
    table.insert(action.targets, target_data)

    return action
end


_Debug.Unit.Tests.Melee = function()
    local damage = 200
    local action_id = 836 -- Eclipse Bite

    local action = _Debug.Unit.Util.Build_Action(action_id, 17254144, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.CRIT)
    Handler.Action.Melee(action, _Debug.Unit.Mob.PLAYER, nil, true)
    local melee_damage = Model.Get.Data(_Debug.Unit.Mob.PLAYER.name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.TOTAL)

    _Debug.Message("Melee: " .. tostring(damage) .. " " .. tostring(melee_damage) .. " " .. tostring(damage == melee_damage))
end

------------------------------------------------------------------------------------------------------
-- Test: Using Avatar Rage Blood Pact.
-- SUCCESS CONDITIONS:
-- Overall
-- 1. Grand Total       : Rage damage
-- 2. Raw Pet Damage    : Rage damage
-- 3. Total Pet Damage %: 100%
-- 4. Pet Melee Damage  : 0
-- 5. Pet Ranged Damage : 0
-- 6. Pet WS Damage     : 0
-- 7. Pet Ability Damage: Rage damage
-- Pet Specific
-- 1. Total Damage      : Rage damage
-- 2. Total Damage %    : 100%
-- 3. Melee Damage      : 0
-- 4. Ranged Damage     : 0
-- 5. Weaponskill Damage: 0
-- 6. Ability Damage    : 200
-- Catalog
-- 1. Pet Action Name   : Should exist
-- 2. Total Damage      : Rage damage
-- 3. Attempts          : 1
-- 4. Accuracy %        : 100%
-- 5. Average Damage    : Rage damage
-- 6. Minimum Damage    : Rage damage
-- 7. Maximum Damage    : Rage damage
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Avatar_Rage = function()
    local damage = 100
    local action_id = 836 -- Eclipse Bite

    _Debug.Unit.Active = true

    local action = _Debug.Unit.Util.Build_Action(action_id, 17254144, damage)
    Handler.Action.Pet_Ability(action, _Debug.Unit.Mob.PET, true)

    local results = _Debug.Unit.Util.Avatar_Check(damage)

    for pass, test in pairs(results) do
        if not pass then _Debug.Error.Add("Test.Avatar_Rage: FAIL " .. tostring(test)) end
    end

    _Debug.Unit.Active = false
end

------------------------------------------------------------------------------------------------------
-- Test: Using Avatar Rage Blood Pact.
-- SUCCESS CONDITIONS:
-- Overall
-- 1. Grand Total       : Rage damage
-- 2. Raw Pet Damage    : Rage damage
-- 3. Total Pet Damage %: 100%
-- 4. Pet Melee Damage  : 0
-- 5. Pet Ranged Damage : 0
-- 6. Pet WS Damage     : 0
-- 7. Pet Ability Damage: Rage damage
-- Pet Specific
-- 1. Total Damage      : Rage damage
-- 2. Total Damage %    : 100%
-- 3. Melee Damage      : 0
-- 4. Ranged Damage     : 0
-- 5. Weaponskill Damage: 0
-- 6. Ability Damage    : 200
-- Catalog
-- 1. Pet Action Name   : Should exist
-- 2. Total Damage      : Rage damage
-- 3. Attempts          : 1
-- 4. Accuracy %        : 100%
-- 5. Average Damage    : Rage damage
-- 6. Minimum Damage    : Rage damage
-- 7. Maximum Damage    : Rage damage
------------------------------------------------------------------------------------------------------
_Debug.Unit.Util.Avatar_Check = function(damage)
    local player_name = _Debug.Unit.Mob.PLAYER.name
    local pet_name = _Debug.Unit.Mob.PET.name
    local action_name = "Eclipse Bite"
    local trackable = Model.Enum.Trackable.PET_ABILITY

    local results = {}

    results.player_pet_damage = tostring(damage) == Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET)                    -- Raw Pet Damage
    results.player_pet_damage_perc = tostring("100.0") == Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET, true)        -- Total Pet Damage %
    results.player_pet_melee = tostring("0") == Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE)                  -- Pet Melee Damage
    results.player_pet_ranged = tostring("0") == Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED)                -- Pet Ranged Damage
    results.player_pet_ws = tostring("0") == Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS)                        -- Pet WS Damage
    results.player_pet_ability = tostring(damage) == Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY)           -- Pet Ability Damage

    results.pet_damage = tostring(damage) == Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET)             -- Total Damage
    results.pet_damage_perc = tostring("100.0") == Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET, true) -- Total Damage %
    results.pet_melee = tostring("0") == Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_MELEE)           -- Melee Damage
    results.pet_ranged = tostring("0") == Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_RANGED)         -- Ranged Damage
    results.pet_ws = tostring("0") == Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_WS)                 -- Weaponskill Damage
    results.pet_ability = tostring(damage) == Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_ABILITY)    -- Ability Damage

    results.ability_total = tostring(damage) == Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.TOTAL)  -- Total Damage
    results.ability_attempts = tostring("1") == Col.Single.Pet_Attempts(player_name, pet_name, action_name, trackable)                         -- Attempts
    results.ability_acc = tostring("100.0") == Col.Single.Pet_Acc(player_name, pet_name, action_name, trackable)                               -- Accuracy %
    results.ability_avg = tostring(damage) == Col.Single.Pet_Average(player_name, pet_name, action_name, trackable)                            -- Average Damage
    results.ability_min = tostring(damage) == Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MIN)      -- Minimum Damage
    results.ability_max = tostring(damage) == Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MAX)      -- Maximum Damage

    return results
end

