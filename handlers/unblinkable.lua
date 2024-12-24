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
    H.Ability.Action(action, actor_mob, log_offense)
end