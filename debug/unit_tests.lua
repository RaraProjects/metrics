_Debug.Unit = {}
_Debug.Unit.Action_Data = {}
_Debug.Unit.Action_Data.Player = {}
_Debug.Unit.Util = {}
_Debug.Unit.Tests = {}
_Debug.Unit.Tests.Melee = {}
_Debug.Unit.Mob = {}
_Debug.Unit.Active = false

_Debug.Unit.Mob.Target_ID = 17254144

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
_Debug.Unit.Populate = function()
    if UI.BeginTable("Heals", 4, Window.Table.Flags.Borders) then
        UI.TableNextRow()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Crit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Enspell()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Shadows()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Mob_Heal()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Pet_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Pet_Crit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Pet_Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Shadows()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Mob_Heal()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Throwing_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Throwing_Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Throwing_Square()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Throwing_Truestrike()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Throwing_Crit()
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build the fake result table.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Util.Build_Action = function(action_id, target_id, damage, animation_id, message_id, add_effect_param)
    if not add_effect_param then add_effect_param = 0 end

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
    action_data.add_effect_param = add_effect_param

    table.insert(target_data.actions, action_data)
    table.insert(action.targets, target_data)

    return action
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Hit = function()
    local clicked = 0
    if UI.Button("Melee Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.HIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Crit = function()
    local clicked = 0
    if UI.Button("Melee Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.CRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Miss = function()
    local clicked = 0
    if UI.Button("Melee Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Enspell.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Enspell = function()
    local clicked = 0
    if UI.Button("Melee Enspell") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.HIT, 100)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Shadows.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Shadows = function()
    local clicked = 0
    if UI.Button("Melee Shadows") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.SHADOWS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Mob Heal.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Mob_Heal = function()
    local clicked = 0
    if UI.Button("Melee Mob Heal") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.MOBHEAL373)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Hit = function()
    local clicked = 0
    if UI.Button("Melee Pet Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.HIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Crit = function()
    local clicked = 0
    if UI.Button("Melee Pet Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.CRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Miss = function()
    local clicked = 0
    if UI.Button("Melee Pet Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Shadows.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Shadows = function()
    local clicked = 0
    if UI.Button("Melee Pet Shadows") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.SHADOWS)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Pet Mob Heal.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Pet_Mob_Heal = function()
    local clicked = 0
    if UI.Button("Melee Pet Mob Heal") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.MOBHEAL373)
            H.Melee.Action(action, _Debug.Unit.Mob.PET, _Debug.Unit.Mob.PLAYER, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Throwing Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Throwing_Hit = function()
    local clicked = 0
    if UI.Button("Melee Throwing Hit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.THROWING, A.Enum.Message.RANGEHIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Throwing Square Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Throwing_Square = function()
    local clicked = 0
    if UI.Button("Melee Throwing Square") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.THROWING, A.Enum.Message.SQUARE)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Throwing Truestrike Hit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Throwing_Truestrike = function()
    local clicked = 0
    if UI.Button("Melee Throwing True") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.THROWING, A.Enum.Message.TRUE)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Throwing Miss.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Throwing_Miss = function()
    local clicked = 0
    if UI.Button("Melee Throwing Miss") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.THROWING, A.Enum.Message.MISS)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Melee Throwing Crit.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Tests.Melee.Throwing_Crit = function()
    local clicked = 0
    if UI.Button("Melee Throwing Crit") then
        clicked = 1
        if clicked and 1 then
            local damage = 100
            local action_id = 836 -- Eclipse Bite (not that it matters for this test)
            local action = _Debug.Unit.Util.Build_Action(action_id, _Debug.Unit.Mob.Target_ID, damage, A.Enum.Animation.THROWING, A.Enum.Message.RANGECRIT)
            H.Melee.Action(action, _Debug.Unit.Mob.PLAYER, nil, true)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Test: Using Avatar Rage Blood Pact.
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

_Debug.Unit.Util.Melee_Check = function(damage)
    local hit = {
        Total = damage,
        Acc = 100,
        Mob_Heal = 0,
        Enspell = 0,
        Shadows = 0,
        Main_Damage = damage,
        Main_Acc = 100,
        Off_Damage = 0,
        Off_Acc = 0,
        Kick_Damage = 0,
        Kick_Acc = 0,
    }

    local crit = {
        Total = damage * 2,
        Acc = 100,
        Mob_Heal = 0,
        Enspell = 0,
        Shadows = 0,
        Main_Damage = damage,
        Main_Acc = 100,
        Off_Damage = 0,
        Off_Acc = 0,
        Kick_Damage = 0,
        Kick_Acc = 0,
    }

    local player_name = _Debug.Unit.Mob.PLAYER.name

    Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE)
    Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE)
    UI.Text(Col.String.Format_Number(mob_heal))
    UI.Text(Col.String.Format_Number(enspell))
    UI.Text(Col.String.Format_Number(shadows))
    Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_MAIN)
    Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_MAIN)
    Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_OFFH)
    Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_OFFH)
    Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_KICK)
    Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_KICK)
end
