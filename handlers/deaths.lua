H.Death = { }

------------------------------------------------------------------------------------------------------
-- Parse the player death message.
------------------------------------------------------------------------------------------------------
---@param actorMob  table mob id of the entity performing the action
---@param targetMob table mob id of the entity receiving the action (this is the person dying)
------------------------------------------------------------------------------------------------------
H.Death.Action = function(actorMob, targetMob)
    if not actorMob or not targetMob then
        return nil
    end

    local audits =
    {
        player_name = targetMob.name,
        target_name = actorMob.name,
    }

    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEATH, DB.Metric.ATTEMPTS_ON_USE)
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.DEATH, DB.Metric.TOTAL)
    Blog.Add(targetMob.name, nil, Blog.Action_Type.PLAYER_DEATH, Blog.Enum.PLAYER_DEATH, nil, actorMob.name)
end
