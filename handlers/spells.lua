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

    local spell_id   = action.param
    local spell_data = Ashita.Spell.Get_By_ID(spell_id)

    -- Paralyze, Intimidate, etc.
    H.Spell.Is_Action_Blocked(action, actor_mob)
    if not spell_data then return nil end

    local spell_name   = Ashita.Spell.Name(spell_id, spell_data)
    local mp_cost      = Ashita.Spell.MP(spell_id, spell_data)
    local target_mob   = {}
    local total_damage = 0
    local target_count = 0
    local is_burst     = false
    local hit          = false  -- Mainly for enfeebles in this context.

    for _, target_data in pairs(action.targets) do
        target_mob = Ashita.Mob.Get_Mob_By_ID(target_data.id)
        if not target_mob then target_mob = {name = DB.Enum.DEBUG} end
        if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end

        for _, action_data in pairs(target_data.actions) do
            if target_mob then
                local target_damage, target_burst = H.Spell.Target_Parse(spell_data, action_data, actor_mob, target_mob, owner_mob)

                -- Handle damage. Hits are primarily for enfeebles.
                target_damage = target_damage or 0
                total_damage  = total_damage + target_damage
                hit = hit or (target_damage > -2)

                -- Burst: The Use level is a burst if any of the target checks are bursts.
                is_burst = is_burst or target_burst

                -- AOE Target Counts
                target_count = target_count + 1
            end
        end
    end

    -- Shadow absorption makes it so I can't rely on message ID's in the Count function for MP tracking
    -- because then I don't know what trackable to log the MP to. So, hardcoding of spells is still necessary.
    local audits = H.Spell.Audits(actor_mob, target_mob, owner_mob)
    H.Spell.Count(audits, spell_id, spell_name, hit, mp_cost, is_burst, target_count)
    H.Spell.Blog(audits, spell_id, spell_data, spell_name, total_damage, is_burst, target_count)
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
---@return number, boolean
------------------------------------------------------------------------------------------------------
H.Spell.Target_Parse = function(spell_data, result, actor_mob, target_mob, owner_mob)
    Debug.Packet.Add_Action(actor_mob.name, target_mob.name, "Spell", result)
    if not spell_data then return 0, false end

    local spell_id   = spell_data.Index
    local spell_name = Ashita.Spell.Name(spell_id, spell_data)
    local damage     = result.param or 0
    local message_id = result.message
    local is_burst   = message_id == Ashita.Enum.Message.SPELL_MAGIC_BURST
    local audits     = H.Spell.Audits(actor_mob, target_mob, owner_mob)

    -- Shadow absorption.
    if H.Message_No_Damage_Hit(message_id) then
        return 0, false end

    -- Enfeebles shouldn't come with damage.
    if Res.Spells.Get_Enfeeble(spell_id) then
        damage = H.Spell.Enfeebling_And_DoTs(audits, DB.Trackable.SPELLS_ENFEEBLING, damage, spell_name, message_id, owner_mob)

    -- Some DoTs come with initial damage. Damage gets handled inside the enfeeble function.
    elseif Res.Spells.Get_DoT(spell_id) then
        damage = H.Spell.Enfeebling_And_DoTs(audits, DB.Trackable.SPELLS_DOT, damage, spell_name, message_id, owner_mob)

    -- Status removal spells can have No Effect just like enfeebles, so can't rely on the message.
    elseif Res.Spells.Get_Debuff_Removal(spell_id) then
        if message_id == Ashita.Enum.Message.SPELL_NO_EFFECT then damage = -1 end

    -- MP Drain doesn't do damage.
    elseif H.Message_MP_Drain(message_id) then
        local trackable = DB.Trackable.SPELLS_MP_DRAIN
        if owner_mob then trackable = DB.Trackable.PET_MP_DRAIN end
        H.Offense.Catalog_Hit(audits, trackable, damage, spell_name)

    -- Check for magic bursts. Enfeebles shouldn't be caught in this because they are an earlier check.
    elseif H.Message_Damaging(message_id) or is_burst then
        H.Spell.Nuke(audits, spell_name, damage, message_id, is_burst)

    -- Spells that involve HP recovery.
    elseif H.Message_Healing(message_id) then
        H.Spell.Healing(audits, spell_name, damage)

    else
        Debug.Error.Add(Debug.Error.WARNING, "H.Spell.Target_Parse",
        "BENIGN: Spell {" .. tostring(spell_name) .. "} (" .. tostring(spell_id) .. ") has unaccounted for message {" .. tostring(message_id) .. "}.")
    end

    return damage, is_burst
end

------------------------------------------------------------------------------------------------------
-- Check if an action is paralyzed, intimidated, etc.
-- Paralyze and intimidate come through this packet even for melee.
------------------------------------------------------------------------------------------------------
---@param action table
---@param actor_mob table
------------------------------------------------------------------------------------------------------
H.Spell.Is_Action_Blocked = function(action, actor_mob)
    if action.targets and action.targets[1] and action.targets[1].actions and action.targets[1].actions[1] and action.targets[1].actions[1].message then
        local message_id = action.targets[1].actions[1].message
        local temp_audits = H.Spell.Audits(actor_mob, Ashita.Mob.Get_Mob_By_ID(action.targets[1].id))

        if message_id == Ashita.Enum.Message.IS_PARALYZED or message_id == Ashita.Enum.Message.IS_PARALYZED_2 then
            DB.Data.Update(DB.Update_Mode.INC, 1, temp_audits, DB.Trackable.ALL_PARALYZE, DB.Metric.HITS_ON_USE)

        elseif message_id == Ashita.Enum.Message.IS_INTIMIDATED then
            DB.Data.Update(DB.Update_Mode.INC, 1, temp_audits, DB.Trackable.ALL_INTIMIDATE, DB.Metric.HITS_ON_USE)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Need the HIT_COUNT for average calculations in the catalog.
-- This also handles keeping track of how much MP has been spent on certain spells.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_id number
---@param spell_name string
---@param hit boolean
---@param mp_cost number
---@param is_burst boolean
---@param target_count integer
------------------------------------------------------------------------------------------------------
H.Spell.Count = function(audits, spell_id, spell_name, hit, mp_cost, is_burst, target_count)
    local is_pet = false
    if audits.pet_name then is_pet = true end

    -- Spell specific trackable decision.
    local trackable = DB.Trackable.SPELLS_OVERALL
    if Res.Spells.Get_Healing(spell_id) then
        if is_pet then trackable = DB.Trackable.PET_HEALING else trackable = DB.Trackable.SPELLS_HEALING end

        -- Healing Received (Only counts non-self healing).
        if audits.player_name ~= audits.target_name and Ashita.Party.Is_Affiliate(audits.target_name) then
            local audit_swap = H.Spell.Audit_Swap(audits)
            H.Offense.Action_Used(audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, spell_name, hit, mp_cost / target_count)
        end

    elseif Res.Spells.Get_Debuff_Removal(spell_id) then trackable = DB.Trackable.SPELLS_DEBUFF_REMOVAL
    elseif Res.Spells.Get_Buff(spell_id)           then trackable = DB.Trackable.SPELLS_BUFFS
    elseif Res.Spells.Get_Damaging(spell_id)       then if is_pet then trackable = DB.Trackable.PET_NUKING else trackable = DB.Trackable.SPELLS_NUKING end
    elseif Res.Spells.Get_Enfeeble(spell_id)       then if is_pet then trackable = DB.Trackable.PET_ENFEEBLING else trackable = DB.Trackable.SPELLS_ENFEEBLING end
    elseif Res.Spells.Get_DoT(spell_id)            then if is_pet then trackable = DB.Trackable.PET_DOT else trackable = DB.Trackable.SPELLS_DOT end
    elseif Res.Spells.Get_Enspell(spell_id)        then trackable = DB.Trackable.MELEE_ENSPELL
    elseif Res.Spells.Get_Spikes(spell_id)         then trackable = DB.Trackable.SPELLS_SPIKE_DAMAGE
    elseif Res.Spells.Get_MP_Drain(spell_id)       then trackable = DB.Trackable.SPELLS_MP_DRAIN
    elseif Res.Spells.Get_Buff_Song(spell_id)      then trackable = DB.Trackable.SPELLS_BUFF_SONG
    end

    if trackable == DB.Trackable.SPELLS_NUKING and is_burst then trackable = DB.Trackable.SPELLS_BURSTS end

    -- Set the usage tracking and MP spent.
    H.Offense.Action_Used(audits, trackable, spell_name, hit, mp_cost)

    -- Overall mana tracking. Be careful to not double dip on MP Spent for general spells.
    if is_pet and trackable ~= DB.Trackable.PET_GENERAL_MAGIC then
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, DB.Trackable.PET_GENERAL_MAGIC, DB.Metric.MP_SPENT)
    elseif trackable ~= DB.Trackable.SPELLS_OVERALL then
        DB.Data.Update(DB.Update_Mode.INC, mp_cost, audits, DB.Trackable.SPELLS_OVERALL, DB.Metric.MP_SPENT)
    end
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

    if Res.Spells.Get_Damaging(spell_id) or Res.Spells.Get_MP_Drain(spell_id) then
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

    elseif Res.Spells.Get_Enfeeble(spell_id) or Res.Spells.Get_DoT(spell_id) then
        local action_type = Blog.Action_Type.MAGIC_ENFEEBLE
        if damage == -1     then blog_note = Blog.Enum.NO_EFFECT
        elseif damage == -2 then blog_note = Blog.Enum.RESIST
        elseif damage == 999999 then    -- For things like Poison
            damage = -1
        elseif Res.Spells.Get_Dispel(spell_id) then
            local buff = Res.Buffs.Get_Buff(damage)
            if buff then blog_note = buff.en end
            action_type = Blog.Action_Type.DISPEL
        elseif Res.Spells.Get_Enfeeble(spell_id) then
            damage = -1
        end
        Blog.Add(audits.player_name, audits.pet_name, action_type, spell_name, damage, blog_note, spell_data)

    elseif Res.Spells.Get_Buff_Song(spell_id) then
        blog_note = blog_note .. space .. "TGTs: " .. tostring(target_count)
        Blog.Add(audits.player_name, audits.pet_name, Blog.Action_Type.SONG_BUFFS, spell_name, nil, blog_note, spell_data)

    else
        Blog.Add(audits.player_name, audits.pet_name, Blog.Action_Type.MAGIC_MISC, spell_name, nil, blog_note, spell_data)

    end
end

------------------------------------------------------------------------------------------------------
-- Handles spells that damage enemies.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
---@param message_id integer
---@param burst boolean
------------------------------------------------------------------------------------------------------
H.Spell.Nuke = function(audits, spell_name, damage, message_id, burst)
    local trackable = DB.Trackable.SPELLS_NUKING

    -- Shadow absorption.
    if H.Message_No_Damage_Hit(message_id) then
        H.Offense.No_Damage_Hit(audits, trackable, DB.Metric.SHADOW_ABSORPTION)
        H.Offense.Catalog_No_Damage_Hit(audits, trackable, spell_name)

    -- If not absorbed by shadows then go through the damage process.
    else
        -- Not tracking bursts for pets.
        if audits.pet_name then
            trackable = DB.Trackable.PET_NUKING
            H.Offense.Hit(audits, DB.Trackable.PET_OVERALL, damage)

        -- This just catches the the overall magic damage for the player.
        else
            H.Offense.Hit(audits, DB.Trackable.SPELLS_OVERALL, damage, burst)
        end

        -- Burst and non-burst damage are tracked seperately.
        if burst then
            H.Offense.Catalog_Hit(audits, DB.Trackable.SPELLS_BURSTS, damage, spell_name, burst)
        else
            H.Offense.Catalog_Hit(audits, trackable, damage, spell_name)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- This calculates how much HP from healing didn't actually go to healing because the player
-- wasn't missing enough health.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
------------------------------------------------------------------------------------------------------
H.Spell.Healing = function(audits, spell_name, damage)
    H.Offense.Hit(audits, DB.Trackable.ALL_HEAL, damage)

    local trackable = DB.Trackable.SPELLS_HEALING
    if audits.pet_name then trackable = DB.Trackable.PET_HEALING end
    H.Offense.Catalog_Hit(audits, trackable, damage, spell_name)

    -- Overcure
    local spell_max = DB.Catalog.Get(audits.player_name, trackable, spell_name, DB.Metric.MAX)
    local overcure = 0
    if spell_max > damage then overcure = spell_max - damage end
    DB.Data.Update(DB.Update_Mode.INC, overcure, audits, trackable, DB.Metric.OVERCURE)
    DB.Catalog.Update_Metric(DB.Update_Mode.INC, overcure, audits, trackable, spell_name, DB.Metric.OVERCURE)

    -- Healing Received
    -- Curing NPCs or non-party members makes them show up in the party list.
    if Ashita.Party.Is_Affiliate(audits.target_name) then
        H.Spell.Healing_Received(audits, spell_name, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Checks how much healing a player has recieved. Ignores self-healing.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param spell_name string
---@param damage number
------------------------------------------------------------------------------------------------------
H.Spell.Healing_Received = function(audits, spell_name, damage)
    if audits.player_name == audits.target_name then return nil end
    local audit_swap = H.Spell.Audit_Swap(audits)
    H.Offense.Catalog_Hit(audit_swap, DB.Trackable.DEF_HEALING_RECEIVED, damage, spell_name)
end

------------------------------------------------------------------------------------------------------
-- Handles resist rates of enfeebling spells.
------------------------------------------------------------------------------------------------------
---@param audits table
---@param trackable string
---@param damage integer used as a flag to distinguish between no effect and resist.
---@param spell_name string
---@param message_id number defines what happened to the spell (resist, etc.)
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Spell.Enfeebling_And_DoTs = function(audits, trackable, damage, spell_name, message_id, owner_mob)
    local overall = DB.Trackable.SPELLS_OVERALL

    if owner_mob then
        if trackable == DB.Trackable.SPELLS_ENFEEBLING then
            trackable = DB.Trackable.PET_ENFEEBLING
        elseif trackable == DB.Trackable.SPELLS_DOT then
            trackable = DB.Trackable.PET_DOT
        end
    end

    -- Damaging DoTs like Dia, Bio, Helix
    if H.Message_Damaging(message_id) then
        H.Offense.Hit(audits, overall, damage)
        H.Offense.Catalog_Hit(audits, trackable, damage, spell_name)

        -- Need to supplement counts just in case the damage was zero but it wasn't resisted.
        if damage == 0 then
            DB.Data.Update(DB.Update_Mode.INC, 1, audits, overall, DB.Metric.HITS_ON_TARGET)
            DB.Data.Update(DB.Update_Mode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)
            DB.Catalog.Update_Metric(DB.Update_Mode.INC, 1, audits, trackable, spell_name, DB.Metric.HITS_ON_TARGET)
        end

    -- No Effects: These will not negatively impact resist metrics.
    elseif H.Message_No_Effect(message_id) then
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, overall, DB.Metric.HITS_ON_TARGET)
        H.Offense.Hit(audits, overall, 0)
        H.Offense.Catalog_No_Damage_Hit(audits, trackable, spell_name)
        damage = -1

    -- Resists
    elseif H.Message_Resist(message_id) then
        H.Offense.Miss(audits, overall)
        H.Offense.Catalog_Hit(audits, trackable, 0, spell_name)
        damage = -2

    -- Effect Landed
    else
        DB.Data.Update(DB.Update_Mode.INC, 1, audits, overall, DB.Metric.HITS_ON_TARGET)
        H.Offense.Hit(audits, overall, 0)
        H.Offense.Catalog_No_Damage_Hit(audits, trackable, spell_name)
        damage = 999999
    end

    return damage
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