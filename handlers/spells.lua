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
    local owner_mob = A.Mob.Pet_Owner(actor_mob)    -- Check if pet is casting the spell.

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = A.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if not target_mob then target_mob = {name = Model.Enum.Index.DEBUG} end
            if target_mob.spawn_flags == A.Enum.Spawn_Flags.MOB then Model.Util.Check_Mob_List(target_mob.name) end

            is_burst = result.message == A.Enum.Message.BURST
            new_damage = H.Spell.Parse(spell_data, result, actor_mob, target_mob, owner_mob, is_burst)
            if not new_damage then new_damage = 0 end

            target_count = target_count + 1
            damage = damage + new_damage
        end
    end

    local audits = H.Spell.Audits(actor_mob, target_mob, owner_mob)
    H.Spell.Count(audits, spell_id, spell_name, mp_cost, is_burst)
    H.Spell.Blog(actor_mob, spell_id, spell_data, spell_name, damage, is_burst, target_count)
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spell_data table the main packet; need it to get spell ID
---@param result table contains all the information for the action
---@param actor_mob table
---@param target_mob table
---@param owner_mob table
---@param burst boolean true if this cast was a magic burst.
---@return number
------------------------------------------------------------------------------------------------------
H.Spell.Parse = function(spell_data, result, actor_mob, target_mob, owner_mob, burst)
    _Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Spell", result)
    if not spell_data then return 0 end

    local spell_id = spell_data.Index
    local spell_name = A.Spell.Name(spell_id, spell_data)
    local is_mapped = false
    local damage = result.param or 0
    local message_id = result.message
    local audits = H.Spell.Audits(actor_mob, target_mob, owner_mob)

    if Lists.Spell.Damaging[spell_id] then
        H.Spell.Nuke(audits, spell_name, damage, burst)
        is_mapped = true
    end

    if Lists.Spell.Healing[spell_id] then
    	H.Spell.Overcure(audits, spell_name, damage, burst)
        is_mapped = true
    end

    if Lists.Spell.MP_Drain[spell_id] then
        H.Spell.MP_Drain(audits, spell_name, damage, burst)
        is_mapped = true
    end

    if Lists.Spell.Enfeebling[spell_id] then
        H.Spell.Enfeebling(audits, spell_name, message_id)
        is_mapped = true
    end

    if not is_mapped then
        _Debug.Error.Add("Spell.Parse: {" .. tostring(actor_mob.name) .. "} spell " .. tostring(spell_id) .. " named " .. tostring(spell_name) .. " is unhandled.")
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Adds spell information to the battle log.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param spell_id number
---@param spell_data table
---@param spell_name string
---@param damage number
---@param is_burst boolean true if this cast was a magic burst.
---@param target_count number how many targets were hit by an AOE spell.
------------------------------------------------------------------------------------------------------
H.Spell.Blog = function(actor_mob, spell_id, spell_data, spell_name, damage, is_burst, target_count)
    local blog_note = ""
    local space = ""
    if Lists.Spell.Damaging[spell_id] and not Lists.Spell.DoT[spell_id] and Metrics.Blog.Flags.Magic then
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
    if Lists.Spell.Healing[spell_id] and Metrics.Blog.Flags.Healing then
        if Lists.Spell.AOE[spell_id] then
            blog_note = blog_note .. space .. "Targets: " .. tostring(target_count)
        end
        Blog.Add(actor_mob.name, spell_name, damage, blog_note, Model.Enum.Trackable.HEALING, spell_data)
    end
end

------------------------------------------------------------------------------------------------------
-- Convenient function to build the audit table.
------------------------------------------------------------------------------------------------------
---@param actor_mob table
---@param target_mob table
---@param owner_mob? table this will not be nil if the actor is a pet.
---@return table
------------------------------------------------------------------------------------------------------
H.Spell.Audits = function(actor_mob, target_mob, owner_mob)
    -- Initialize on case where this is a trust or regular monster.
    local player_name = actor_mob.name
    local pet_name = nil
    -- Case where this is a player's pet using an ability.
    if owner_mob then
        player_name = owner_mob.name
        pet_name = actor_mob.name
    end
    local audits = {
        player_name = player_name,
        target_name = target_mob.name,
        pet_name = pet_name,
    }
    return audits
end

------------------------------------------------------------------------------------------------------
-- Need the HIT_COUNT for average calculations in the catalog.
-- This also handles keeping track of how much MP has been spent on certain spells.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_id number
---@param spell_name string
---@param mp_cost number
---@param is_burst boolean
------------------------------------------------------------------------------------------------------
H.Spell.Count = function(audits, spell_id, spell_name, mp_cost, is_burst)
    local trackable = H.Trackable.MAGIC
    local is_pet = false
    if audits.pet_name then
        trackable = H.Trackable.PET_MAGIC
        is_pet = true
    end
    -- Overall Mana Tracking
    Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)

    if Lists.Spell.Healing[spell_id] then
        if is_pet then trackable = H.Trackable.PET_HEAL else trackable = H.Trackable.HEALING end
        Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)

    elseif Lists.Spell.Damaging[spell_id] then
        if is_pet then trackable = H.Trackable.PET_NUKE else trackable = H.Trackable.NUKE end
        Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)

    elseif Lists.Spell.Enfeebling[spell_id] then
        if is_pet then trackable = H.Trackable.PET_ENFEEBLING else trackable = H.Trackable.ENFEEBLE end
        Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        -- Counts are handled in parse because we need the result message.

    elseif Lists.Spell.Enspell[spell_id] then
        trackable = H.Trackable.ENSPELL
        Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)

    elseif Lists.Spell.MP_Drain[spell_id] then
        trackable = H.Trackable.MP_DRAIN
        Model.Update.Data(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)

    else
        if is_pet then trackable = H.Trackable.PET_MAGIC else trackable = H.Trackable.MAGIC end
        Model.Update.Data(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        Model.Update.Catalog_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
    end
    if is_burst then Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, H.Trackable.MAGIC, spell_name, H.Metric.BURST_COUNT) end
end

------------------------------------------------------------------------------------------------------
-- Handles spells that damage enemies.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
---@param burst boolean
------------------------------------------------------------------------------------------------------
H.Spell.Nuke = function(audits, spell_name, damage, burst)
    local trackable = H.Trackable.NUKE
    if audits.pet_name then
        trackable = H.Trackable.PET_NUKE
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    else
        Model.Update.Data(H.Mode.INC, damage, audits, H.Trackable.MAGIC, H.Metric.TOTAL)
    end
    Model.Update.Catalog_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, audits.pet_name, burst)
end

------------------------------------------------------------------------------------------------------
-- This calculates how much HP from healing didn't actually go to healing because the player
-- wasn't missing enough health.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
---@param burst boolean
------------------------------------------------------------------------------------------------------
H.Spell.Overcure = function(audits, spell_name, damage, burst)
    local trackable = H.Trackable.HEALING
    if audits.pet_name then trackable = H.Trackable.PET_HEAL end
    Model.Update.Catalog_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, nil, burst)
    local spell_max = Model.Get.Catalog(audits.player_name, trackable, spell_name, H.Metric.MAX)
    local overcure = 0
    if spell_max > damage then
        overcure = spell_max - damage
    end
    Model.Update.Data(H.Mode.INC, overcure, audits, trackable, H.Metric.OVERCURE)
    Model.Update.Catalog_Metric(H.Mode.INC, overcure, audits, trackable, spell_name, H.Metric.OVERCURE)
end

------------------------------------------------------------------------------------------------------
-- Handles spells that drain MP. The drain doesn't get used towards the damage total.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
---@param burst boolean
------------------------------------------------------------------------------------------------------
H.Spell.MP_Drain = function(audits, spell_name, damage, burst)
    local trackable = H.Trackable.MP_DRAIN
    if audits.pet_name then trackable = H.Trackable.PET_MP_DRAIN end
    Model.Update.Catalog_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, nil, burst)
end

------------------------------------------------------------------------------------------------------
-- Handles resist rates of enfeebling spells.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param message_id number defines what happened to the spell (resist, etc.)
------------------------------------------------------------------------------------------------------
H.Spell.Enfeebling = function(audits, spell_name, message_id)
    local trackable = H.Trackable.ENFEEBLE
    if audits.pet_name then trackable = H.Trackable.PET_ENFEEBLING end
    Model.Update.Data(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT) -- Used to flag that data is availabel for show in Focus.
    Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
    if message_id == A.Enum.Message.ENF_LAND or message_id == A.Enum.Message.ENF_BURST then
        Model.Update.Catalog_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)
    end
end