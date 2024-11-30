H.Death = {}

------------------------------------------------------------------------------------------------------
-- Parse the player death message.
------------------------------------------------------------------------------------------------------
---@param actor_mob table mob id of the entity performing the action
---@param target_mob table mob id of the entity receiving the action (this is the person dying)
------------------------------------------------------------------------------------------------------
H.Death.Action = function(actor_mob, target_mob)
    if not actor_mob or not target_mob then return nil end

    local audits = {
        player_name = target_mob.name,
        target_name = actor_mob.name,
    }

    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEATH, DB.Metric.ATTEMPTS)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEATH, DB.Metric.TOTAL)
    Blog.Add(target_mob.name, nil, Blog.Action_Type.PLAYER_DEATH, Blog.Enum.PLAYER_DEATH, nil, actor_mob.name)
end
