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
        Debug.Error.Add("Spell.Parse: {" .. tostring(actor_mob.name) .. "} spell " .. tostring(spell_id) .. " named " .. tostring(spell_name) .. " is unhandled.")
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
            blog_note = Blog.Enum.Text.MB
            space = " "
        end
        -- Show how many targets were hit on the ga-spell.
        if Res.Spells.Get_AOE(spell_id) then
            blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Enum.Types.MAGIC, spell_name, damage, blog_note, DB.Enum.Trackable.MAGIC, spell_data)

    elseif Res.Spells.Get_Healing(spell_id) then
        if Res.Spells.Get_AOE(spell_id) then
            blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Enum.Types.HEALING, spell_name, damage, blog_note, DB.Enum.Trackable.HEALING, spell_data)

    elseif Res.Spells.Get_Debuff_Removal(spell_id) then
        local buff = Res.Buffs.Get_Buff(damage)
        if damage == -1 then
            blog_note = "No Effect"
        elseif buff and spell_id == 143 then    -- Erase
            blog_note = buff.en
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Enum.Types.DEBUFF_REMOVAL, spell_name, -1, blog_note, DB.Enum.Trackable.DEBUFF_REMOVAL, spell_data)

    elseif Res.Spells.Get_Enfeeble(spell_id) then
        if damage == -1 then
            blog_note = "No Effect"
        elseif damage == -2 then
            blog_note = "Resist!"
        elseif Res.Spells.Get_Dispel(spell_id) then
            local buff = Res.Buffs.Get_Buff(damage)
            if buff then blog_note = buff.en end
        end
        Blog.Add(audits.player_name, audits.pet_name, Blog.Enum.Types.ENFEEBLE, spell_name, -1, blog_note, DB.Enum.Trackable.ENFEEBLE, spell_data)

    elseif Res.Spells.Get_Buff_Song(spell_id) then
        blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        Blog.Add(audits.player_name, audits.pet_name, Blog.Enum.Types.BRD_BUFFS, spell_name, nil, blog_note, DB.Enum.Trackable.BUFF_SONG, spell_data)

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
    local trackable = H.Trackable.MAGIC
    local is_pet = false

    if audits.pet_name then
        trackable = H.Trackable.PET_MAGIC
        is_pet = true
    end

    -- Overall Mana Tracking
    DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)

    if Res.Spells.Get_Healing(spell_id) then
        if is_pet then trackable = H.Trackable.PET_HEAL else trackable = H.Trackable.HEALING end
        DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT)

        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)

        -- Healing Received (Only counts non-self healing)
        if audits.player_name ~= audits.target_name and Ashita.Party.Is_Affiliate(audits.target_name) then
            local audit_swap = H.Spell.Audit_Swap(audits)
            DB.Data.Update(H.Mode.INC, 1, audit_swap, H.Trackable.HEALING_RECEIVED, H.Metric.COUNT)
            DB.Data.Update(H.Mode.INC, 1, audit_swap, H.Trackable.HEALING_RECEIVED, H.Metric.HIT_COUNT)
            DB.Data.Update(H.Mode.INC, (mp_cost / target_count), audit_swap, H.Trackable.HEALING_RECEIVED, H.Metric.MP_SPENT)
            DB.Catalog.Update_Metric(H.Mode.INC, (mp_cost / target_count), audit_swap, H.Trackable.HEALING_RECEIVED, spell_name, H.Metric.MP_SPENT)
            DB.Catalog.Update_Metric(H.Mode.INC, 1, audit_swap, H.Trackable.HEALING_RECEIVED, spell_name, H.Metric.COUNT)
            DB.Catalog.Update_Metric(H.Mode.INC, 1, audit_swap, H.Trackable.HEALING_RECEIVED, spell_name, H.Metric.HIT_COUNT)
        end

    elseif Res.Spells.Get_Debuff_Removal(spell_id) then
        trackable = H.Trackable.DEBUFF_REMOVAL
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)

    elseif Res.Spells.Get_Buff(spell_id) then
        trackable = H.Trackable.BUFF_SPELL
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)

    elseif Res.Spells.Get_Damaging(spell_id) then
        if is_pet then trackable = H.Trackable.PET_NUKE else trackable = H.Trackable.NUKE end
        DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT)

        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)

    elseif Res.Spells.Get_Enfeeble(spell_id) then
        if is_pet then trackable = H.Trackable.PET_ENFEEBLING else trackable = H.Trackable.ENFEEBLE end
        DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)

    elseif Res.Spells.Get_Enspell(spell_id) then
        trackable = H.Trackable.ENSPELL
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)

    elseif Res.Spells.Get_Spikes(spell_id) then
        trackable = H.Trackable.OUTGOING_SPIKE_DMG
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)

    elseif Res.Spells.Get_MP_Drain(spell_id) then
        trackable = H.Trackable.MP_DRAIN
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Data.Update(H.Mode.INC, mp_cost, audits, trackable, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)

    elseif Res.Spells.Get_Buff_Song(spell_id) then
        trackable = H.Trackable.BUFF_SONG
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)

    else
        if is_pet then trackable = H.Trackable.PET_MAGIC else trackable = H.Trackable.MAGIC end
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, mp_cost, audits, trackable, spell_name, H.Metric.MP_SPENT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.COUNT)
    end

    -- Burst Tracking
    if is_burst then
        DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.MAGIC, H.Metric.BURST_COUNT)
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.BURST_COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.BURST_COUNT)
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
    local trackable = H.Trackable.NUKE
    if audits.pet_name then
        trackable = H.Trackable.PET_NUKE
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    else
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MAGIC, H.Metric.TOTAL)
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
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.ALL_HEAL, H.Metric.TOTAL)

    local trackable = H.Trackable.HEALING
    if audits.pet_name then trackable = H.Trackable.PET_HEAL end
    DB.Catalog.Update_Damage(audits.player_name, audits.target_name, trackable, damage, spell_name, audits.pet_name, burst)

    -- Overcure
    local spell_max = DB.Catalog.Get(audits.player_name, trackable, spell_name, H.Metric.MAX)
    local overcure = 0
    if spell_max > damage then overcure = spell_max - damage end
    DB.Data.Update(H.Mode.INC, overcure, audits, trackable, H.Metric.OVERCURE)
    DB.Catalog.Update_Metric(H.Mode.INC, overcure, audits, trackable, spell_name, H.Metric.OVERCURE)
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
    local trackable = H.Trackable.HEALING_RECEIVED
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
    local trackable = H.Trackable.MP_DRAIN
    if audits.pet_name then trackable = H.Trackable.PET_MP_DRAIN end
    if damage > 0 then
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)
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
    local trackable = H.Trackable.ENFEEBLE
    if audits.pet_name then trackable = H.Trackable.PET_ENFEEBLING end

    DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.AOE_COUNT)
    DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.AOE_COUNT)

    -- These will not negatively impact resist metrics.
    if message_id == Ashita.Enum.Message.NO_EFFECT or message_id == Ashita.Enum.Message.EFFECT_FAIL or message_id == Ashita.Enum.Message.COMP_RESIST then
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)
        damage = -1
    -- Resists
    elseif message_id == Ashita.Enum.Message.RESIST or message_id == Ashita.Enum.Message.RESIST_2 then
        damage = -2
    -- Effect Landed
    else
        DB.Data.Update(H.Mode.INC, 1, audits, trackable, H.Metric.HIT_COUNT)
        DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, trackable, spell_name, H.Metric.HIT_COUNT)
    end

    return damage
end