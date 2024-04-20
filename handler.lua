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
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
p.Action.Finish_Spell_Casting = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

    local result, target, new_damage
    local damage = 0
    local spell_id = action.param
    local spell_data = A.Spell.ID(spell_id)
    if not spell_data then return nil end
	local spell_name = A.Spell.Name(spell_id, spell_data)
    local is_burst = false

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target then target = {name = "test"} end
            if target.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target.name) end

            is_burst = result.message == 252
            new_damage = p.Handler.Spell_Damage(spell_data, result, actor_mob.name, target.name, is_burst)
            if not new_damage then new_damage = 0 end

            damage = damage + new_damage
        end
    end

    local audits = {
        player_name = actor_mob.name,
        target_name = target.name,
    }

    -- Log the use of the spell
    if Lists.Spell.Damaging[spell_id] then
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.MAGIC, spell_name, p.Metric.COUNT)
    end
    if Lists.Spell.Healing[spell_id] then
        Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.HEALING, spell_name, p.Metric.COUNT)
    end
    if is_burst then Model.Update.Catalog_Metric(p.Mode.INC, 1, audits, p.Trackable.MAGIC, spell_name, p.Metric.BURST_COUNT) end

    if Lists.Spell.Damaging[spell_id] and Blog.Flags.Magic then
        local burst_message = ""
        if is_burst then burst_message = Blog.Enum.Text.MB end
        Blog.Add(actor_mob.name, spell_name, damage, burst_message, Model.Enum.Trackable.MAGIC, spell_data)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spell_data table the main packet; need it to get spell ID
---@param metadata table contains all the information for the action
---@param player_name string name of the player that did the action
---@param target_name string name of the target that received the action
---@param burst boolean true if this cast was a magic burst.
---@return number
------------------------------------------------------------------------------------------------------
p.Handler.Spell_Damage = function(spell_data, metadata, player_name, target_name, burst)
    _Debug.Packet.Add(player_name, target_name, "Spell", metadata)
    if not spell_data then return 0 end

    local spell_id = spell_data.Index
    local spell_name = A.Spell.Name(spell_id, spell_data)
    local is_mapped = false
    local damage = metadata.param or 0

    if Lists.Spell.Damaging[spell_id] then
        Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.MAGIC, damage, spell_name, nil, burst)
        is_mapped = true
    end

    -- TO DO: Handle Overcure
    if Lists.Spell.Healing[spell_id] then
    	Model.Update.Catalog_Damage(player_name, target_name, p.Trackable.HEALING, damage, spell_name, nil, burst)
        local spell_max = Model.Get.Catalog(player_name, p.Trackable.HEALING, spell_name, p.Metric.MAX)
        local overcure = 0
        if spell_max > damage then
            overcure = spell_max - damage
        end
        local audits = {
            player_name = player_name,
            target_name = target_name,
        }
        Model.Update.Data(p.Mode.INC, overcure, audits, p.Trackable.HEALING, p.Metric.OVERCURE)
        Model.Update.Catalog_Metric(p.Mode.INC, overcure, audits, p.Trackable.HEALING, spell_name, p.Metric.OVERCURE)
        is_mapped = true
    end

    if not is_mapped then
        _Debug.Error.Add("Handler.Spell_Damage: {" .. tostring(player_name) .. "} spell " .. tostring(spell_id) .. " named " .. tostring(spell_name) .. " is unhandled.")
    end

    return damage
end

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