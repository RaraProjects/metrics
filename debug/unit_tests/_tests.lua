_Debug.Unit = {}
_Debug.Unit.Action_Data = {}
_Debug.Unit.Action_Data.Player = {}
_Debug.Unit.Util = {}
_Debug.Unit.Tests = {}
_Debug.Unit.Mob = {}
_Debug.Unit.Active = true

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
        -- Melee
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Main_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Off_Hand_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Main_Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Off_Hand_Miss()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Crit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Enspell()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Shadows()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Mob_Heal()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Pet_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Pet_Crit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Pet_Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Shadows()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Mob_Heal()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Daken_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Daken_Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Daken_Square()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Daken_Truestrike()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Daken_Crit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Kick_Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Kick_Miss()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.Melee.Kick_Crit()
        UI.TableNextColumn()
        UI.TableNextColumn()
        UI.TableNextColumn()
        -- Ranged
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.Hit()
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.Square()
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.Truestrike()
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.Miss()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.Crit()
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.PUP()
        UI.TableNextColumn() _Debug.Unit.Tests.Ranged.Shadows()
        UI.TableNextColumn()
        -- TP Action
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.WS_Hit_1000()
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.WS_Hit_2000()
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.WS_Miss()
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.SC_1000()
        ---
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.SC_2000()
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.Pet_Hit_100()
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.Pet_Hit_200()
        UI.TableNextColumn() _Debug.Unit.Tests.TP_Action.Pet_Miss()
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Build the fake result table.
------------------------------------------------------------------------------------------------------
_Debug.Unit.Util.Build_Action = function(action_id, target_id, damage, animation_id, message_id, add_effect_param, add_effect_message)
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
    action_data.add_effect_message = add_effect_message -- Skillchains

    table.insert(target_data.actions, action_data)
    table.insert(action.targets, target_data)

    return action
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