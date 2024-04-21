H.Spell = {}

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Spell.Action = function(action, actor_mob, log_offense)
    if not log_offense then return nil end

    local result, target_mob, new_damage
    local damage = 0
    local target_count = 0
    local spell_id = action.param
    local spell_data = A.Spell.ID(spell_id)
    if not spell_data then return nil end

    local spell_name = A.Spell.Name(spell_id, spell_data)
    local mp_cost = A.Spell.MP(spell_id, spell_data)
    local is_burst = false

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = Model.Enum.Index.DEBUG} end
            if target_mob.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target_mob.name) end

            is_burst = result.message == A.Enum.Message.BURST
            new_damage = H.Spell.Parse(spell_data, result, actor_mob.name, target_mob.name, is_burst)
            if not new_damage then new_damage = 0 end

            if new_damage > 0 then target_count = target_count + 1 end
            damage = damage + new_damage
        end
    end

    local audits = H.Spell.Audits(actor_mob, target_mob)
    H.Spell.Count(audits, spell_id, spell_name, mp_cost, is_burst)
    H.Spell.Blog(actor_mob, spell_id, spell_data, spell_name, damage, is_burst, target_count)
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spell_data table the main packet; need it to get spell ID
---@param result table contains all the information for the action
---@param player_name string name of the player that did the action
---@param target_name string name of the target that received the action
---@param burst boolean true if this cast was a magic burst.
---@return number
------------------------------------------------------------------------------------------------------
H.Spell.Parse = function(spell_data, result, player_name, target_name, burst)
    _Debug.Packet.Add(player_name, target_name, "Spell", result)
    if not spell_data then return 0 end

    local spell_id = spell_data.Index
    local spell_name = A.Spell.Name(spell_id, spell_data)
    local is_mapped = false
    local damage = result.param or 0

    if Lists.Spell.Damaging[spell_id] then
        Model.Update.Catalog_Damage(player_name, target_name, H.Trackable.NUKE, damage, spell_name, nil, burst)
        is_mapped = true
    end

    if Lists.Spell.Healing[spell_id] then
    	H.Spell.Overcure(player_name, target_name, spell_name, damage, burst)
        is_mapped = true
    end

    if Lists.Spell.MP_Drain[spell_id] then
        H.Spell.MP_Drain(player_name, target_name, spell_name, damage, burst)
        is_mapped = true
    end

    if not is_mapped then
        _Debug.Error.Add("Spell.Parse: {" .. tostring(player_name) .. "} spell " .. tostring(spell_id) .. " named " .. tostring(spell_name) .. " is unhandled.")
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
H.Spell.Blog = function(actor_mob, spell_id, spell_data, spell_name, damage, is_burst, target_count)
    if Lists.Spell.Damaging[spell_id] and not Lists.Spell.DoT[spell_id] and Blog.Flags.Magic then
        local blog_note = ""
        local space = ""
        -- Show magic burst message.
        if is_burst then
            blog_note = Blog.Enum.Text.MB
            space = " "
        end
        -- Show how many targets were hit on the ga-spell.
        if Lists.Spell.AOE[spell_id] then
            blog_note = blog_note .. space .. "Targets: " .. tostring(target_count)
        end
        Blog.Add(actor_mob.name, spell_name, damage, blog_note, Model.Enum.Trackable.MAGIC, spell_data)
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
H.Spell.Audits = function(actor_mob, target_mob)
    return {player_name = actor_mob.name, target_name = target_mob.name}
end

------------------------------------------------------------------------------------------------------
-- Need the HIT_COUNT for average calculations in the catalog.
------------------------------------------------------------------------------------------------------
H.Spell.Count = function(audits, spell_id, spell_name, mp_cost, is_burst)
    local trackable = H.Trackable.MAGIC
    -- Overall Mana Tracking
    Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)

    if Lists.Spell.Healing[spell_id] then
        Model.Update.Data(H.Mode.INC, mp_cost, audits, H.Trackable.HEALING, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, H.Trackable.HEALING, spell_name, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.HEALING, spell_name, H.Metric.COUNT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.HEALING, spell_name, H.Metric.HIT_COUNT)
    elseif Lists.Spell.Damaging[spell_id] then
        Model.Update.Data(H.Mode.INC, mp_cost, audits, H.Trackable.NUKE, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, H.Trackable.NUKE, spell_name, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.NUKE, spell_name, H.Metric.COUNT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.NUKE, spell_name, H.Metric.HIT_COUNT)
    else
        Model.Update.Data(H.Mode.INC, 1, audits, H.Trackable.MAGIC, H.Metric.COUNT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, H.Trackable.MAGIC, spell_name, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.MAGIC, spell_name, H.Metric.COUNT)
    end
    if is_burst then Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.MAGIC, spell_name, H.Metric.BURST_COUNT) end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
H.Spell.Overcure = function(player_name, target_name, spell_name, damage, burst)
    Model.Update.Catalog_Damage(player_name, target_name, H.Trackable.HEALING, damage, spell_name, nil, burst)
    local spell_max = Model.Get.Catalog(player_name, H.Trackable.HEALING, spell_name, H.Metric.MAX)
    local overcure = 0
    if spell_max > damage then
        overcure = spell_max - damage
    end
    local audits = {
        player_name = player_name,
        target_name = target_name,
    }
    Model.Update.Data(H.Mode.INC, overcure, audits, H.Trackable.HEALING, H.Metric.OVERCURE)
    Model.Update.Catalog_Metric(H.Mode.INC, overcure, audits, H.Trackable.HEALING, spell_name, H.Metric.OVERCURE)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
H.Spell.MP_Drain = function(player_name, target_name, spell_name, damage, burst)
    Model.Update.Catalog_Damage(player_name, target_name, H.Trackable.MP_DRAIN, damage, spell_name, nil, burst)
end