H.Ranged = {}

------------------------------------------------------------------------------------------------------
-- Parse the ranged attack packet.
------------------------------------------------------------------------------------------------------
---@param act table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Ranged.Action = function(act, actor_mob, log_offense)
    if not log_offense then return end
    local result, target
    local damage = 0

    for target_index, target_value in pairs(act.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = act.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(act.targets[target_index].id)
            if target then
                damage = damage + H.Ranged.Parse(result, actor_mob.name, target.name)
            end
        end
    end

    H.Ranged.Blog(actor_mob, damage)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds ranged damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
H.Ranged.Blog = function(actor_mob, damage)
    if Blog.Flags.Ranged then
        Blog.Add(actor_mob.name, H.Trackable.RANGED, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a ranged attack action.
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return number
------------------------------------------------------------------------------------------------------
H.Ranged.Parse = function(result, player_name, target_name, owner_mob)
    _Debug.Packet.Add(player_name, target_name, "Ranged", result)
    local damage = result.param
    local message_id = result.message

    -- Need special handling for pets
    local ranged_type = H.Trackable.RANGED
    if owner_mob then
        ranged_type = H.Trackable.PET_RANGED
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
    }

    -- Totals
    H.Ranged.Totals(audits, damage, ranged_type)

    -- Pet Totals
    H.Ranged.Pet_Total(owner_mob, audits, damage)

    -- Accuracy and misc. traits.
    H.Ranged.Message(message_id, audits, damage, ranged_type)

    -- Min/Max
    H.Ranged.Min_Max(damage, audits, ranged_type)

    return damage
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
H.Ranged.Totals = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.TOTAL,  H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage.
------------------------------------------------------------------------------------------------------
H.Ranged.Pet_Total = function(owner_mob, audits, damage)
    if owner_mob then
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
------------------------------------------------------------------------------------------------------
H.Ranged.Message = function(message_id, audits, damage, ranged_type)
    if message_id == A.Enum.Message.RANGEHIT then
        H.Ranged.Hit(audits, damage, ranged_type)
    elseif message_id == A.Enum.Message.SQUARE then
        H.Ranged.Square(audits, damage, ranged_type)
    elseif message_id == A.Enum.Message.TRUE then
        H.Ranged.Truestrike(audits, damage, ranged_type)
    elseif message_id == A.Enum.Message.RANGECRIT then
        H.Ranged.Crit(audits, damage, ranged_type)
    elseif message_id == A.Enum.Message.RANGEPUP then
        H.Ranged.PUP_Hit(audits, damage, ranged_type)
    elseif message_id == A.Enum.Message.RANGEMISS then
        return H.Ranged.Miss(audits, damage, ranged_type)
    elseif message_id == A.Enum.Message.SHADOWS then
        return H.Ranged.Shadows(audits, damage, ranged_type)
    else
        _Debug.Error.Add("Handler.Ranged: {" .. tostring(audits.player_name) .. "} Unhandled Ranged Nuance " .. tostring(message_id))
    end
end

------------------------------------------------------------------------------------------------------
-- Regular ranged hit.
------------------------------------------------------------------------------------------------------
H.Ranged.Hit = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged square hit.
------------------------------------------------------------------------------------------------------
H.Ranged.Square = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged truestrike hit.
------------------------------------------------------------------------------------------------------
H.Ranged.Truestrike = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged critical hit.
------------------------------------------------------------------------------------------------------
H.Ranged.Crit = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.CRIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, ranged_type, H.Metric.CRIT_DAMAGE)
    Model.Update.Data(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Puppet ranged hit.
------------------------------------------------------------------------------------------------------
H.Ranged.PUP_Hit = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC, damage, audits, ranged_type, H.Metric.TOTAL)
    Model.Update.Running_Accuracy(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Regular ranged miss.
------------------------------------------------------------------------------------------------------
H.Ranged.Miss = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.MISS_COUNT)
    Model.Update.Running_Accuracy(audits.player_name, false)
    return damage
end

------------------------------------------------------------------------------------------------------
-- Regular ranged absorbed by shadows.
------------------------------------------------------------------------------------------------------
H.Ranged.Shadows = function(audits, damage, ranged_type)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.HIT_COUNT)
    Model.Update.Data(H.Mode.INC,      1, audits, ranged_type, H.Metric.SHADOWS)
    return damage
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum ranged values.
------------------------------------------------------------------------------------------------------
H.Ranged.Min_Max = function(damage, audits, ranged_type)
    if damage > 0 and (damage < Model.Get.Data(audits.player_name, ranged_type, H.Metric.MIN)) then Model.Update.Data(H.Mode.SET, damage, audits, ranged_type, H.Metric.MIN) end
    if damage > Model.Get.Data(audits.player_name, ranged_type, H.Metric.MAX) then Model.Update.Data(H.Mode.SET, damage, audits, ranged_type, H.Metric.MAX) end
end