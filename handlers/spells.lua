H.Spell = { }

------------------------------------------------------------------------------------------------------
-- Parse the finish spell casting packet.
------------------------------------------------------------------------------------------------------
---@param action     table     action packet data.
---@param actorMob   table     the mob data of the entity performing the action.
---@param ownerMob   table|nil (if pet) the mob data of the entity's owner.
---@param logOffense boolean   if this action should actually be logged.
------------------------------------------------------------------------------------------------------
H.Spell.Action = function(action, actorMob, ownerMob, logOffense)
    if not logOffense then
        return nil
    end

    local spellId   = action.param
    local spellData = Ashita.Spell.GetByID(spellId)

    -- Paralyze, Intimidate, etc.
    local isBlocked = H.Spell.IsActionBlocked(action, actorMob)

    if isBlocked or not spellData then
        return nil
    end

    local spellName      = Ashita.Spell.Name(spellId, spellData)
    local mpCost         = Ashita.Spell.MP(spellId, spellData)
    local totalDamage    = 0
    local targetCount    = 0
    local isBurst        = false
    local hit            = false  -- Mainly for enfeebles in this context.
    local targetMob      = { }
    local skillchainData = { }

    for _, target in pairs(action.targets) do
        targetMob = Ashita.Mob.GetMobByID(target.id) or { name = DB.Enum.DEBUG }

        -- Keep the mob list up-to-date.
        if Ashita.Mob.IsMonster(targetMob) then
            DB.Lists.AddToInitializedMobs(targetMob.name)
        end

        for _, actionData in pairs(target.actions) do
            local targetDamage, targetBurst, spellSkillchain = H.Spell.Parse(spellData, actionData, actorMob, targetMob, ownerMob)

            totalDamage    = totalDamage + (targetDamage or 0)      -- Handle damage. Hits are primarily for enfeebles.
            hit            = hit or (targetDamage > -2)
            isBurst        = isBurst or targetBurst                 -- Burst: The Use level is a burst if any of the target checks are bursts.
            targetCount    = targetCount + 1                        -- AOE Target Counts
            skillchainData = spellSkillchain or skillchainData
        end
    end

    -- Shadow absorption makes it so I can't rely on message ID's in the Count function for MP tracking
    -- because then I don't know what trackable to log the MP to. So, hardcoding of spells is still necessary.
    local audits = H.Spell.Audits(actorMob, targetMob, ownerMob)
    H.Spell.Count(audits, spellId, spellName, hit, mpCost, targetCount)
    H.Spell.Blog(audits, spellId, spellData, spellName, totalDamage, isBurst, targetCount)

    if skillchainData and skillchainData.Damage > 0 then
        Blog.Add(actorMob.name, nil, Blog.ActionType.SKILLCHAIN, skillchainData.Name, skillchainData.Damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Set data for a spell action (including healing).
-- Not all spells do damage and not all spells heal this will sort those out.
------------------------------------------------------------------------------------------------------
---@param spellData  table the main packet; need it to get spell ID
---@param actionData table contains all the information for the action
---@param actorMob   table
---@param targetMob  table
---@param ownerMob?  table
---@return number, boolean, table
------------------------------------------------------------------------------------------------------
H.Spell.Parse = function(spellData, actionData, actorMob, targetMob, ownerMob)
    Debug.Packet.AddAction(actorMob.name, targetMob.name, "Spell", actionData)

    local spellId        = spellData.Index
    local spellName      = Ashita.Spell.Name(spellId, spellData)
    local damage         = actionData.param or 0
    local messageId      = actionData.message
    local isBurst        = H.Messages.MagicBurst(messageId)
    local audits         = H.Spell.Audits(actorMob, targetMob, ownerMob)
    local skillchainData = { }

    -- Shadow absorption
    if H.Messages.NoDamage(messageId) then
        return 0, false, skillchainData

    -- Enfeebles shouldn't come with damage.
    elseif Res.Spells.Enfeebling[spellId] then
        damage = H.Spell.EnfeeblingAndDoTs(audits, DB.Trackable.SPELLS_ENFEEBLING, damage, spellName, messageId, ownerMob)

    -- Some DoTs come with initial damage. Damage gets handled inside the enfeeble function.
    elseif Res.Spells.DoT[spellId] then
        damage = H.Spell.EnfeeblingAndDoTs(audits, DB.Trackable.SPELLS_DOT, damage, spellName, messageId, ownerMob)

    -- Status removal spells can have No Effect just like enfeebles, so can't rely on the message.
    elseif Res.Spells.DebuffRemoval[spellId] then
        if H.Messages.NoEffect(messageId) then
            damage = -1
        end

    -- MP Drain doesn't do damage.
    elseif H.Messages.MpDrain(messageId) then
        local trackable = DB.Trackable.SPELLS_MP_DRAIN

        if ownerMob then
            trackable = DB.Trackable.PET_MP_DRAIN
        end

        H.Offense.CatalogHit(audits, trackable, damage, spellName, isBurst)

    -- Check for magic bursts. Enfeebles shouldn't be caught in this because they are an earlier check.
    elseif H.Messages.Damaging(messageId) then
        H.Spell.Nuke(audits, spellName, damage, messageId, isBurst)

    -- Spells that involve HP recovery.
    elseif H.Messages.Healing(messageId) then
        H.Spell.Healing(audits, spellName, damage)

    -- General buffs.
    elseif H.Messages.Buff(messageId) then
        -- Nothing special.

    else
        local warning = string.format("BENIGN: Spell {%s} (%d) has unaccounted for message {%d}.", spellName, spellId, messageId)
        Debug.Error.Add(Debug.Error.WARNING, "H.Spell.Parse", warning)
    end

    -- SCH Immanence skillchains.
    if actionData.has_add_effect then
        skillchainData = H.Spell.AdditionalEffect(actorMob, targetMob, actionData, spellName)
    end

    return damage, isBurst, skillchainData
end

------------------------------------------------------------------------------------------------------
-- Check if an action is paralyzed, intimidated, etc.
-- Paralyze and intimidate come through this packet even for melee.
------------------------------------------------------------------------------------------------------
---@param action   table
---@param actorMob table
---@return boolean
------------------------------------------------------------------------------------------------------
H.Spell.IsActionBlocked = function(action, actorMob)
    local isBlocked = false

    for _, target in pairs(action.targets) do
        for _, actionData in pairs(target.actions) do
            local messageId = actionData.message
            local audits    = H.Spell.Audits(actorMob, Ashita.Mob.GetMobByID(target.id))

            if messageId == Ashita.Message.IS_PARALYZED or messageId == Ashita.Message.IS_PARALYZED_2 then
                DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.ALL_PARALYZE, DB.Metric.HITS_ON_USE)
                isBlocked = true

            elseif messageId == Ashita.Message.IS_INTIMIDATED then
                DB.Data.Update(DB.UpdateMode.INC, 1, audits, DB.Trackable.ALL_INTIMIDATE, DB.Metric.HITS_ON_USE)
                isBlocked = true
            end
        end
    end

    return isBlocked
end

------------------------------------------------------------------------------------------------------
-- Need the HIT_COUNT for average calculations in the catalog.
-- This also handles keeping track of how much MP has been spent on certain spells.
------------------------------------------------------------------------------------------------------
---@param audits      table
---@param spellId     number
---@param spellName   string
---@param hit         boolean
---@param mpCost      number
---@param targetCount integer
------------------------------------------------------------------------------------------------------
H.Spell.Count = function(audits, spellId, spellName, hit, mpCost, targetCount)
    local isPet     = audits.pet_name ~= nil
    local trackable = DB.Trackable.SPELLS_OVERALL

    -- Trackable Mapping
    local trackables =
    {
        [Res.Spells.Healing]       = isPet and DB.Trackable.PET_HEALING     or DB.Trackable.SPELLS_HEALING,
        [Res.Spells.DebuffRemoval] = DB.Trackable.SPELLS_DEBUFF_REMOVAL,
        [Res.Spells.Buffs]         = isPet and DB.Trackable.PET_SPELL_BUFFS or DB.Trackable.SPELLS_BUFFS,
        [Res.Spells.Damaging]      = isPet and DB.Trackable.PET_NUKING      or DB.Trackable.SPELLS_NUKING,
        [Res.Spells.Enfeebling]    = isPet and DB.Trackable.PET_ENFEEBLING  or DB.Trackable.SPELLS_ENFEEBLING,
        [Res.Spells.DoT]           = isPet and DB.Trackable.PET_DOT         or DB.Trackable.SPELLS_DOT,
        [Res.Spells.Enspell]       = DB.Trackable.MELEE_ENSPELL,
        [Res.Spells.Spikes]        = DB.Trackable.SPELLS_SPIKE_DAMAGE,
        [Res.Spells.MpDrain]       = DB.Trackable.SPELLS_MP_DRAIN,
        [Res.Spells.BuffSongs]    = DB.Trackable.SPELLS_BUFF_SONG,
    }

    for spellCategory, spellTrackable in pairs(trackables) do
        if spellCategory[spellId] then
            trackable = spellTrackable
            break
        end
    end

    if Ashita.Spell.Skill(spellId) == 44 then
        trackable = DB.Trackable.SPELLS_GEOMANCY
    end

    -- Healing Received (Only counts non-self healing)
    if Res.Spells.Healing[spellId] and audits.player_name ~= audits.target_name and Ashita.Party.IsAffiliate(audits.target_name) then
        local auditSwap = H.Spell.AuditSwap(audits)
        H.Offense.ActionUsed(auditSwap, DB.Trackable.DEF_HEALING_RECEIVED, spellName, hit, mpCost / targetCount)
    end

    -- Set the usage tracking and MP spent.
    H.Offense.ActionUsed(audits, trackable, spellName, hit, mpCost)

    -- Overall mana tracking. Be careful to not double dip on MP Spent for general spells.
    if isPet and trackable ~= DB.Trackable.PET_GENERAL_MAGIC then
        DB.Data.Update(DB.UpdateMode.INC, mpCost, audits, DB.Trackable.PET_GENERAL_MAGIC, DB.Metric.MP_SPENT)
    elseif trackable ~= DB.Trackable.SPELLS_OVERALL then
        DB.Data.Update(DB.UpdateMode.INC, mpCost, audits, DB.Trackable.SPELLS_OVERALL, DB.Metric.MP_SPENT)
    end
end

------------------------------------------------------------------------------------------------------
-- Adds spell information to the battle log.
------------------------------------------------------------------------------------------------------
---@param audits      table
---@param spellId     integer
---@param spellData   table
---@param spellName   string
---@param damage      integer
---@param isBurst     boolean true if this cast was a magic burst.
---@param targetCount integer how many targets were hit by an AOE spell.
------------------------------------------------------------------------------------------------------
H.Spell.Blog = function(audits, spellId, spellData, spellName, damage, isBurst, targetCount)
    local blogNote = ""

    -- Helper function for appending target counts.
    local function appendTargetCount(always)
        if always or targetCount > 1 then
            local spacer = ""
            if blogNote ~= "" then
                spacer = " "
            end
            blogNote = string.format("%s%sTGTs: %d", blogNote, spacer, targetCount)
        end
    end

    -- Nukes and MP Drains
    if Res.Spells.Damaging[spellId] or Res.Spells.MpDrain[spellId] then
        if isBurst then
            blogNote = Blog.Enum.MAGIC_BURST
        end
        appendTargetCount()
        Blog.Add(audits.player_name, audits.pet_name, Blog.ActionType.MAGIC_OFFENSIVE, spellName, damage, blogNote, spellData)

    -- Healing
    elseif Res.Spells.Healing[spellId] then
        appendTargetCount()
        Blog.Add(audits.player_name, audits.pet_name, Blog.ActionType.ALL_HEALING, spellName, damage, blogNote, spellData)

    -- Debuff Removal
    elseif Res.Spells.DebuffRemoval[spellId] then
        if damage == -1 then
            blogNote = Blog.Enum.NO_EFFECT
        else
            local buff = Res.Buffs.List[damage]
            if buff and spellId == 143 then         -- Erase
                blogNote = buff.en
            end
        end

        Blog.Add(audits.player_name, audits.pet_name, Blog.ActionType.DEBUFF_REMOVAL, spellName, -1, blogNote, spellData)

    -- Enfeebling and DoTs
    elseif Res.Spells.Enfeebling[spellId] or Res.Spells.DoT[spellId] then
        local action_type = Blog.ActionType.MAGIC_ENFEEBLE
        if damage == -1 then
            blogNote = Blog.Enum.NO_EFFECT

        elseif damage == -2 then
            blogNote = Blog.Enum.RESIST

        elseif damage == 999999 then                -- For things like Poison
            damage = -1

        elseif Res.Spells.Dispel[spellId] then
            action_type = Blog.ActionType.DISPEL
            local buff  = Res.Buffs.List[damage]
            if buff then
                blogNote = buff.en
            end
            damage = -1

        elseif Res.Spells.Enfeebling[spellId] then
            damage = -1
        end

        Blog.Add(audits.player_name, audits.pet_name, action_type, spellName, damage, blogNote, spellData)

    -- Bard Songs
    elseif Res.Spells.BuffSongs[spellId] then
        appendTargetCount(true)
        Blog.Add(audits.player_name, audits.pet_name, Blog.ActionType.SONG_BUFFS, spellName, nil, blogNote, spellData)

    else
        Blog.Add(audits.player_name, audits.pet_name, Blog.ActionType.MAGIC_MISC, spellName, nil, blogNote, spellData)

    end
end

------------------------------------------------------------------------------------------------------
-- Handles spells that damage enemies.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param spellName string
---@param damage    number
---@param messageId Ashita.Message
---@param isBurst   boolean
------------------------------------------------------------------------------------------------------
H.Spell.Nuke = function(audits, spellName, damage, messageId, isBurst)
    local isPet    = audits.pet_name ~= nil
    local overall  = isPet and DB.Trackable.PET_OVERALL or DB.Trackable.SPELLS_OVERALL
    local discrete = isPet and DB.Trackable.PET_NUKING  or DB.Trackable.SPELLS_NUKING

    -- Shadow absorption (not tracking for pets)
    if not audits.pet_name and H.Messages.NoDamage(messageId) then
        H.Offense.NoDamageHit(audits, discrete, DB.Metric.SHADOW_ABSORPTION)
        H.Offense.CatalogNoDamageHit(audits, discrete, spellName)

    -- If not absorbed by shadows then go through the damage process.
    else
        H.Offense.Hit(audits, overall, damage, isBurst)
        H.Offense.CatalogHit(audits, discrete, damage, spellName, isBurst)
    end
end

------------------------------------------------------------------------------------------------------
-- This calculates how much HP from healing didn't actually go to healing because the player
-- wasn't missing enough health.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param spellName string
---@param damage    number
------------------------------------------------------------------------------------------------------
H.Spell.Healing = function(audits, spellName, damage)
    H.Offense.Hit(audits, DB.Trackable.ALL_HEAL, damage)

    local trackable = audits.pet_name and DB.Trackable.PET_HEALING or DB.Trackable.SPELLS_HEALING
    H.Offense.CatalogHit(audits, trackable, damage, spellName)

    -- Overcure
    local overcure = math.max(0, DB.Catalog.Get(audits.player_name, trackable, spellName, DB.Metric.MAX) - damage)
    if overcure > 0 then
        DB.Data.Update(DB.UpdateMode.INC, overcure, audits, trackable, DB.Metric.OVERCURE)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, overcure, audits, trackable, spellName, DB.Metric.OVERCURE)
    end

    -- Healing Received tracked for party and alliance members only. Self-healing is ignored.
    if Ashita.Party.IsAffiliate(audits.target_name) and audits.player_name ~= audits.target_name then
        local auditSwap = H.Spell.AuditSwap(audits)
        H.Offense.CatalogHit(auditSwap, DB.Trackable.DEF_HEALING_RECEIVED, damage, spellName)
    end
end

------------------------------------------------------------------------------------------------------
-- Handles resist rates of enfeebling spells.
------------------------------------------------------------------------------------------------------
---@param audits    table
---@param trackable DB.Trackable
---@param damage    integer        used as a flag to distinguish between no effect and resist.
---@param spellName string
---@param messageId Ashita.Message defines what happened to the spell (resist, etc.)
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.Spell.EnfeeblingAndDoTs = function(audits, trackable, damage, spellName, messageId, ownerMob)
    local overall = DB.Trackable.SPELLS_OVERALL

    if ownerMob then
        if trackable == DB.Trackable.SPELLS_ENFEEBLING then
            trackable = DB.Trackable.PET_ENFEEBLING
        elseif trackable == DB.Trackable.SPELLS_DOT then
            trackable = DB.Trackable.PET_DOT
        end
    end

    -- Damaging DoTs like Dia, Bio, Helix
    if H.Messages.Damaging(messageId) then
        H.Offense.Hit(audits, overall, damage)
        H.Offense.CatalogHit(audits, trackable, damage, spellName)

        -- Need to supplement counts just in case the damage was zero but it wasn't resisted.
        if damage == 0 then
            DB.Data.Update(DB.UpdateMode.INC, 1, audits, overall, DB.Metric.HITS_ON_TARGET)
            DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)
            DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, spellName, DB.Metric.HITS_ON_TARGET)
        end

    -- No Effects: These will not negatively impact resist metrics.
    elseif H.Messages.NoEffect(messageId) then
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, overall, DB.Metric.HITS_ON_TARGET)
        H.Offense.Hit(audits, overall, 0)
        H.Offense.CatalogNoDamageHit(audits, trackable, spellName)
        damage = -1

    -- Resists
    elseif H.Messages.Resist(messageId) then
        H.Offense.Miss(audits, overall)
        H.Offense.CatalogHit(audits, trackable, 0, spellName)
        damage = -2

    -- Effect Landed
    else
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, overall, DB.Metric.HITS_ON_TARGET)
        H.Offense.Hit(audits, overall, 0)
        H.Offense.CatalogNoDamageHit(audits, trackable, spellName)

        -- Preserve the damage for dispels since it is the buff ID.
        if not H.Messages.Dispel(messageId) then
            damage = 999999
        end
    end

    return damage
end

------------------------------------------------------------------------------------------------------
-- SCH skillchains from Immanence come in as an additional effect.
------------------------------------------------------------------------------------------------------
---@param actorMob   table
---@param targetMob  table
---@param actionData table
---@param spellName  string
---@return table
------------------------------------------------------------------------------------------------------
H.Spell.AdditionalEffect = function(actorMob, targetMob, actionData, spellName)
    local messageId      = actionData.add_effect_message
    local skillchainName = Res.WS.Skillchains[messageId]
    local skillchainData = { }

    if skillchainName then
        local damage = H.TP.SkillchainParse(actionData, actorMob, targetMob, spellName)
        skillchainData = { Name = skillchainName, Damage = damage }
    end

    return skillchainData
end

------------------------------------------------------------------------------------------------------
-- Convenient function to build the audit table.
------------------------------------------------------------------------------------------------------
---@param actorMob  table
---@param targetMob table
---@param ownerMob? table this will not be nil if the actor is a pet.
---@return table
------------------------------------------------------------------------------------------------------
H.Spell.Audits = function(actorMob, targetMob, ownerMob)
    return
    {
        player_name = ownerMob and ownerMob.name or actorMob.name,
        target_name = targetMob.name,
        pet_name    = ownerMob and actorMob.name or nil,
    }
end

------------------------------------------------------------------------------------------------------
-- Swaps the player and target for healing recieved.
------------------------------------------------------------------------------------------------------
---@param audits table
------------------------------------------------------------------------------------------------------
H.Spell.AuditSwap = function(audits)
    return
    {
        player_name = audits.target_name,
        target_name = audits.player_name,
        pet_name    = audits.pet_name,
    }
end