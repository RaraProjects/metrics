H.Unblinkable = {}

------------------------------------------------------------------------------------------------------
-- Parse the weaponskill packet.
-- Surprises:
-- 1. Some abilities--like DRG Jumps--oddly show up in this packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Unblinkable.Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

    local action_id = action.param
    local ability_data = Ashita.Ability.Get_By_ID(action_id + Ashita.Enum.Ability_Offsets.ABILITY)
    ability_data = H.Ability.Player_Missing_Ability_Check(ability_data, action_id, actor_mob)

    local result, target_mob
    local damage = 0
    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = DB.Enum.DEBUG} end
            damage = damage + H.Ability.Parse(ability_data, result, actor_mob, target_mob.name)

        end
    end
end

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param actor_mob table name of the player that did the action.
---@param target_mob table name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
------------------------------------------------------------------------------------------------------
H.Unblinkable.Target_Parse = function(result, actor_mob, target_mob, ability_data, owner_mob)

    local damage       = result.param
    local message_id   = result.message
    local ability_name = ability_data.Name
    local audits       = H.Spell.Audits(actor_mob, target_mob, owner_mob)

    -- Waltz
    if message_id == Ashita.Enum.Message.ABILITY_RECOVER_HP_2 then
        H.Offense.Hit(audits, DB.Trackable.ALL_HEAL, damage)
        H.Offense.Catalog_Hit(audits, DB.Trackable.ABILITY_HEALING, damage, ability_name)
    end

end