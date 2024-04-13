_Debug.Unit = {}
_Debug.Unit.Action_Data = {}
_Debug.Unit.Action_Data.Player = {}
_Debug.Unit.Util = {}
_Debug.Unit.Tests = {}
_Debug.Unit.Mob = {}


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

_Debug.Unit.Mob.ENEMY = {
    name = "Pet",
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


_Debug.Unit.Tests.Test = function()
    local damage = 200
    local action_id = 100

    local action = _Debug.Unit.Util.Build_Action(action_id, 17254144, damage, A.Enum.Animation.MELEE_MAIN, A.Enum.Message.CRIT)
    Handler.Action.Melee(action, _Debug.Unit.Mob.PLAYER, nil, true)
    local melee_damage = Model.Get.Data(_Debug.Unit.Mob.PLAYER.name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.TOTAL)

    _Debug.Message("Melee: " .. tostring(damage) .. " " .. tostring(melee_damage) .. " " .. tostring(damage == melee_damage))
end
