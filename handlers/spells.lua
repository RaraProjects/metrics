H.Spell = {}

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_offense boolean if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Spell.Action = function(action, actor_mob, owner_mob, log_offense)
    if not log_offense then return nil end

    local result, target_mob, new_damage
    local damage = 0
    local target_count = 0
    local spell_id = action.param
    local spell_data = Ashita.Spell.Get_By_ID(spell_id)
    if not spell_data then return nil end

    local spell_name = Ashita.Spell.Name(spell_id, spell_data)
    local mp_cost = Ashita.Spell.MP(spell_id, spell_data)
    local is_burst = false

    for target_index, target_value in pairs(action.targets) do
        for action_index, _ in pairs(target_value.actions) do
            result = action.targets[target_index].actions[action_index]
            target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
            if target_mob then
                if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end
                is_burst = result.message == Ashita.Enum.Message.BURST
                new_damage = H.Spell.Parse(spell_data, result, actor_mob, target_mob, owner_mob, is_burst)
                if not new_damage then new_damage = 0 end
                target_count = target_count + 1
                damage = damage + new_damage
            end
        end
    end

    local audits = H.Spell.Audits(actor_mob, target_mob, owner_mob)
    H.Spell.Count(audits, spell_id, spell_name, mp_cost, is_burst, target_count)
    H.Spell.Blog(audits, spell_id, spell_data, spell_name, damage, is_burst, target_count)
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spell_data table the main packet; need it to get spell ID
---@param result table contains all the information for the action
---@param actor_mob table
---@param target_mob table
---@param owner_mob? table
---@param burst boolean true if this cast was a magic burst.
---@return number
------------------------------------------------------------------------------------------------------
H.Spell.Parse = function(spell_data, result, actor_mob, target_mob, owner_mob, burst)
    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Spell", result)
    if not spell_data then return 0 end

    local spell_id = spell_data.Index
    local spell_name = Ashita.Spell.Name(spell_id, spell_data)
    local is_mapped = false
    local damage = result.param or 0
    local message_id = result.message
    local audits = H.Spell.Audits(actor_mob, target_mob, owner_mob)

    if Res.Spells.Get_Damaging(spell_id) then
        H.Spell.Nuke(audits, spell_name, damage, burst)
        is_mapped = true
    end

    if Res.Spells.Get_Healing(spell_id) then
        H.Spell.Overcure(audits, spell_name, damage, burst)
        -- Curing NPCs or non-party members makes them show up in the party list.
        if Ashita.Party.Is_Affiliate(target_mob.name) then H.Spell.Healing_Received(audits, spell_name, damage, burst) end
        is_mapped = true
    end

    if Res.Spells.Get_MP_Drain(spell_id) then
        H.Spell.MP_Drain(audits, spell_name, damage, burst)
        is_mapped = true
    end

    if Res.Spells.Get_Enfeeble(spell_id) then
        damage = H.Spell.Enfeebling(audits, spell_name, message_id, damage)
        is_mapped = true
    end

    if Res.Spells.Get_Debuff_Removal(spell_id) then
        is_mapped = true
        if message_id == Ashita.Enum.Message.NO_EFFECT then damage = -1 end
    end

    if Res.Spells.Get_Buff(spell_id) then is_mapped = true end
    if Res.Spells.Get_Buff_Song(spell_id) then is_mapped = true end
    if Res.Spells.Get_Avatar(spell_id) then is_mapped = true end

    if not is_mapped then
        Debug.Error.Add(Debug.Error.WARNING, "H.Spell.Parse", "Actor {" .. tostring(actor_mob.name) .. "} cast spell {" .. tostring(spell_id)
        .. "} named {" .. tostring(spell_name) .. "} which is unhandled.")
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- Adds spell information to the battle log.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_id number
---@param spell_data table
---@param spell_name string
---@param damage number
---@param is_burst boolean true if this cast was a magic burst.
---@param target_count number how many targets were hit by an AOE spell.
------------------------------------------------------------------------------------------------------
H.Spell.Blog = function(audits, spell_id, spell_data, spell_name, damage, is_burst, target_count)
    local blog_note = ""
    local space = ""
    if (Res.Spells.Get_Damaging(spell_id) or Res.Spells.Get_MP_Drain(spell_id)) and not Res.Spells.Get_DoT(spell_id) then
        -- Show magic burst message.
        if is_burst then
            blog_note = Blog.Enum.MAGIC_BURST
            space = " "
        end
        -- Show how many targets were hit on the ga-spell.
        if Res.Spells.Get_AOE(spell_id) then
            blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Action_Type.MAGIC_OFFENSIVE, spell_name, damage, blog_note, spell_data)

    elseif Res.Spells.Get_Healing(spell_id) then
        if Res.Spells.Get_AOE(spell_id) then
            blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Action_Type.ALL_HEALING, spell_name, damage, blog_note, spell_data)

    elseif Res.Spells.Get_Debuff_Removal(spell_id) then
        local buff = Res.Buffs.Get_Buff(damage)
        if damage == -1 then
            blog_note = Blog.Enum.NO_EFFECT
        elseif buff and spell_id == 143 then    -- Erase
            blog_note = buff.en
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Action_Type.DEBUFF_REMOVAL, spell_name, -1, blog_note, spell_data)

    elseif Res.Spells.Get_Enfeeble(spell_id) then
        local action_type = Blog.Action_Type.MAGIC_ENFEEBLE
        if damage == -1 then
            blog_note = Blog.Enum.NO_EFFECT
        elseif damage == -2 then
            blog_note = Blog.Enum.RESIST
        elseif Res.Spells.Get_Dispel(spell_id) then
            local buff = Res.Buffs.Get_Buff(damage)
            if buff then blog_note = buff.en end
            action_type = Blog.Action_Type.DISPEL
        end
        Blog.Add(audits.player_name, audits.pet_name, action_type, spell_name, -1, blog_note, spell_data)

    elseif Res.Spells.Get_Buff_Song(spell_id) then
        blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        Blog.Add(audits.player_name, audits.pet_name, Blog.Action_Type.SONG_BUFFS, spell_name, nil, blog_note, spell_data)

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
-- Swaps the player and target for healing recieved.
------------------------------------------------------------------------------------------------------
---@param audits table
------------------------------------------------------------------------------------------------------
H.Spell.Audit_Swap = function(audits)
    local audit_swap = {
        player_name = audits.target_name,
        target_name = audits.player_name,
        pet_name = audits.pet_name,
    }
    return audit_swap
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
---@param target_count integer
------------------------------------------------------------------------------------------------------
H.Spell.Count = function(audits, spell_id, spell_name, mp_cost, is_burst, target_count)
    local trackable = DB.Trackable.SPELLS_OVERALL
    local is_pet = false

    if audits.pet_name then
        trackable = DB.Trackable.PET_GENERAL_MAGIC
        is_pet = true
    end

    -- Overall Mana Tracking
    DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)

    if Res.Spells.Get_Healing(spell_id) then
        if is_pet then trackable = DB.Trackable.PET_HEALING else trackable = DB.Trackable.SPELLS_HEALING end
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HIT_COUNT)

        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)

        -- Healing Received (Only counts non-self healing)
        if audits.player_name ~= audits.target_name and Ashita.Party.Is_Affiliate(audits.target_name) then
            local audit_swap = H.Spell.Audit_Swap(audits)
            DB.Data.Update(DB.Update_Mode.INC, 1, audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, DB.Metric.ATTEMPTS)
            DB.Data.Update(DB.Update_Mode.INC, 1, audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, DB.Metric.HIT_COUNT)
            DB.Data.Update(DB.Update_Mode.INC, (mp_cost / target_count), audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, DB.Metric.MP_SPENT)
            DB.Catalog.Update_Metric(DB.Update_Mode.INC, (mp_cost / target_count), audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, spell_name, DB.Metric.MP_SPENT)
            DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, spell_name, DB.Metric.ATTEMPTS)
            DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, spell_name, DB.Metric.HIT_COUNT)
        end

    elseif Res.Spells.Get_Debuff_Removal(spell_id) then
        trackable = DB.Trackable.SPELLS_DEBUFF_REMOVAL
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)

    elseif Res.Spells.Get_Buff(spell_id) then
        trackable = DB.Trackable.SPELLS_BUFFS
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)

    elseif Res.Spells.Get_Damaging(spell_id) then
        if is_pet then trackable = DB.Trackable.PET_NUKING else trackable = DB.Trackable.SPELLS_NUKING end
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HIT_COUNT)

        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)

    elseif Res.Spells.Get_Enfeeble(spell_id) then
        if is_pet then trackable = DB.Trackable.PET_ENFEEBLING else trackable = DB.Trackable.SPELLS_ENFEEBLING end
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)

    elseif Res.Spells.Get_Enspell(spell_id) then
        trackable = DB.Trackable.MELEE_ENSPELL
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)

    elseif Res.Spells.Get_Spikes(spell_id) then
        trackable = DB.Trackable.SPELLS_SPIKE_DAMAGE
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)

    elseif Res.Spells.Get_MP_Drain(spell_id) then
        trackable = DB.Trackable.SPELLS_MP_DRAIN
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, trackable, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)

    elseif Res.Spells.Get_Buff_Song(spell_id) then
        trackable = DB.Trackable.SPELLS_BUFF_SONG
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)

    else
        if is_pet then trackable = DB.Trackable.PET_GENERAL_MAGIC else trackable = DB.Trackable.SPELLS_OVERALL end
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, mp_cost, audits, trackable, spell_name, DB.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.ATTEMPTS)
    end

    -- Burst Tracking
    if is_burst then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, DB.Trackable.SPELLS_OVERALL, DB.Metric.MAGIC_BURST_COUNT)
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.MAGIC_BURST_COUNT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.MAGIC_BURST_COUNT)
    end
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
    local trackable = DB.Trackable.SPELLS_NUKING
    if audits.pet_name then
        trackable = DB.Trackable.PET_NUKING
        DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    else
        DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.SPELLS_OVERALL, DB.Metric.TOTAL)
    end
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, audits.pet_name, burst)
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
    DB.Data.Update(DB.Update_Mode.INC, damage, audits, DB.Trackable.ALL_HEAL, DB.Metric.TOTAL)

    local trackable = DB.Trackable.SPELLS_HEALING
    if audits.pet_name then trackable = DB.Trackable.PET_HEALING end
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, audits.pet_name, burst)

    -- AOE attempts are target specific attempts. If there is just one target then this will just be one.
    -- Need these because spell cast counts are handled outside of the target loop.
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.AOE_ATTEMPTS)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.AOE_ATTEMPTS)

    -- Overcure
    local spell_max = DB.Catalog.Get(audits.player_name, trackable, spell_name, DB.Metric.MAX)
    local overcure = 0
    if spell_max > damage then overcure = spell_max - damage end
    DB.Data.Update(DB.Update_Mode.INC, overcure, audits, trackable, DB.Metric.OVERCURE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, overcure, audits, trackable, spell_name, DB.Metric.OVERCURE)
end

------------------------------------------------------------------------------------------------------
-- Checks how much healing a player has recieved. Ignores self-healing.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
---@param burst boolean
------------------------------------------------------------------------------------------------------
H.Spell.Healing_Received = function(audits, spell_name, damage, burst)
    if audits.player_name == audits.target_name then return nil end
    local trackable = DB.Trackable.DEF_HEALING_RECEIVED
    local audit_swap = H.Spell.Audit_Swap(audits)
    DB.Catalog.Update_Damage(audit_swap.player_name, audit_swap.target_name, trackable, damage, spell_name, nil, burst)
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
    local trackable = DB.Trackable.SPELLS_MP_DRAIN
    if audits.pet_name then trackable = DB.Trackable.PET_MP_DRAIN end
    if damage > 0 then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HIT_COUNT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)
    end
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, nil, burst)
end

------------------------------------------------------------------------------------------------------
-- Handles resist rates of enfeebling spells.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param message_id number defines what happened to the spell (resist, etc.)
---@param damage integer used as a flag to distinguish between no effect and resist.
------------------------------------------------------------------------------------------------------
H.Spell.Enfeebling = function(audits, spell_name, message_id, damage)
    local trackable = DB.Trackable.SPELLS_ENFEEBLING
    if audits.pet_name then trackable = DB.Trackable.PET_ENFEEBLING end

    -- AOE attempts are target specific attempts. If there is just one target then this will just be one.
    -- Need these because spell cast counts are handled outside of the target loop.
    DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.AOE_ATTEMPTS)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.AOE_ATTEMPTS)

    -- These will not negatively impact resist metrics.
    if message_id == Ashita.Enum.Message.NO_EFFECT or message_id == Ashita.Enum.Message.EFFECT_FAIL or message_id == Ashita.Enum.Message.COMP_RESIST then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HIT_COUNT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)
        damage = -1
    -- Resists
    elseif message_id == Ashita.Enum.Message.RESIST or message_id == Ashita.Enum.Message.RESIST_2 then
        damage = -2
    -- Effect Landed
    else
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HIT_COUNT)
        DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HIT_COUNT)
    end

    return damage
end