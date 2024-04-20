local p = {}

p.Action = {}
p.Handler = {}
p.Packets = {}
p.Util = {}

p.Mode = Model.Enum.Mode
p.Trackable = Model.Enum.Trackable
p.Metric = Model.Enum.Metric

p.Enum = {}
p.Enum.Offsets = {
    ABILITY = 512,
    PET  = 512,
}
p.Enum.Flags = {
    IGNORE = "ignore",
}
p.Enum.Text = {
    BLANK = "",
}

-- FUTURE CONSIDERATIONS 
-- 1. Catalog enspell damage.

------------------------------------------------------------------------------------------------------
-- Parse the player death message.
------------------------------------------------------------------------------------------------------
---@param actor_id number mob id of the entity performing the action
---@param target_id number mob id of the entity receiving the action (this is the person dying)
------------------------------------------------------------------------------------------------------
function Player_Death(actor_id, target_id)
    local target = A.Mob.Get_Mob_By_ID(target_id)
    if not target then return end

    local log_death = target.in_party or target.in_alliance
    if not log_death then return end

    local actor = A.Mob.Get_Mob_By_ID(actor_id)
    if not actor then return end

    local audits = {
        player_name = target.name,
        target_name = actor.name,
    }

    Model.Update.Data(p.Mode.INC, 1, audits, p.Trackable.DEATH, p.Metric.COUNT)

    if Blog.Flags.Deaths then Blog.Add(actor.name, "Death", 0) end
end

return p