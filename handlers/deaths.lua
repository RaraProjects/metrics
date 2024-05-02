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

    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.DEATH, H.Metric.COUNT)

    if Metrics.Blog.Flags.Deaths then Blog.Add(target_mob.name, "Died", nil, actor_mob.name, "Died") end
end
