H = { }

---@enum H.Packet
H.Packet =
{
    ACTION          = 0x028,
    ACTION_MESSAGE  = 0x029,
    ALLIANCE_UPDATE = 0x0C8,
    CAPACITY_UPDATE = 0x063,
    EXAMPLAR_UPDATE = 0x061,
    ITEM_DROPPED    = 0x0D2,
    ITEM_OBTAINED   = 0x0D3,
    SPECIAL_MESSAGE = 0x02A,
    PARTY_UPDATE    = 0x0DD,
    PLAYER_UPDATE   = 0x037,
    XP_UPDATE       = 0x02D,
    ZONE_END        = 0x00A,
    ZONE_START      = 0x00B,
}

---@enum H.ActionCategory
H.ActionCategory =
{
    MELEE              = 1,
    FINISH_RANGED      = 2,
    FINISH_WEAPONSKILL = 3,
    FINISH_CASTING     = 4,
    FINISH_ITEM        = 5,
    JOB_ABILITY        = 6,
    BEGIN_TP           = 7,
    BEGIN_CASTING      = 8,
    BEGIN_ITEM         = 9,
    FINISH_TP          = 11,
    BEGIN_RANGED       = 12,
    FINISH_PET_TP      = 13,
    UNBLINKABLE        = 14,
    RUNEFENCER_ABILITY = 15,
}

require("handlers._messages")
require("handlers._utils")
require("handlers.melee")
require("handlers.melee_def")
require("handlers.ranged")
require("handlers.ranged_def")
require("handlers.tp_action")
require("handlers.tp_action_def")
require("handlers.abilities")
require("handlers.spells")
require("handlers.spells_def")
require("handlers.unblinkable")
require("handlers.deaths")
require("handlers.items")

------------------------------------------------------------------------------------------------------
-- Sorts out the entities involved with the action packet.
------------------------------------------------------------------------------------------------------
H.StartActionPacket = function(packet)
    local action = Ashita.Packets.BuildAction(packet.data)

    if not action then
        Debug.Error.Add(Debug.Error.ERROR, "Packet In", "action was nil from Packets.Build_Action")
        return nil
    end

    local actorMob = Ashita.Mob.GetMobByID(action.actor_id)

    if not actorMob then
        Debug.Error.Add(Debug.Error.ERROR, "Packet In", "actor_mob was nil from Mob.Get_Mob_By_ID")
        return nil
    end

    local targetMob = Ashita.Packets.GetActionTarget(action)

    if not targetMob then
        Debug.Error.Add(Debug.Error.ERROR, "Packet In", "target_mob was nil from Mob.Get_Mob_By_ID")
        return nil
    end

    -- Need to refresh party for pet checks.
    Ashita.Party.Refresh()

    local petOwnerMob       = Ashita.Mob.PetOwner(actorMob)    -- Is the actor the pet of someone in the party/alliance?
    local targetPetOwnerMob = Ashita.Mob.PetOwner(targetMob)   -- Is the target the pet of someone in the party/alliance?

    local isOffense   = false
    local isDefense   = false
    local mobSelfBuff = false

    -- OFFENSE: The actor is an affiliate or the pet of an affiliate.
    if petOwnerMob or Ashita.Party.IsAffiliate(actorMob.name) then
        isOffense = true
        Timers.Reset(Timers.Types.AUTOPAUSE)
        Timers.Unpause(Timers.Types.PARSE)

    -- DEFENSE: The actor is not another player and the target is an affiliate or the pet of an affiliate.
    elseif not Ashita.Mob.IsPlayer(actorMob) and (targetPetOwnerMob or Ashita.Party.IsAffiliate(targetMob.name)) then
        isDefense = true
        Timers.Reset(Timers.Types.AUTOPAUSE)
        Timers.Unpause(Timers.Types.PARSE)

    -- The actor is a mob claimed by the party and is doing something that is targetting itself.
    elseif Ashita.Mob.ClaimedByAffiliate(actorMob) and actorMob.name == targetMob.name then
        mobSelfBuff = true

    -- Lurk mode detects all actions.
    elseif Parse.Config.IsLurking() then
        -- If the actor is player so log offense.
        if Ashita.Mob.IsPlayer(actorMob) then
            isOffense = true

        -- This must be a mob. If it's targetting itself then it's a buff. If not, log a defensive action.
        else
            if actorMob.name == targetMob.name then mobSelfBuff = true
            else isDefense = true end
        end
    end

    H.PickActionCategory(action, actorMob, targetPetOwnerMob, petOwnerMob, isOffense, isDefense, mobSelfBuff)
end

------------------------------------------------------------------------------------------------------
-- Primary entry point for the action packet.
------------------------------------------------------------------------------------------------------
---@param action             table
---@param actorMob           table
---@param targetPetOwnerMob? table
---@param petOwnerMob?       table
---@param isOffense          boolean
---@param isDefense          boolean
---@param mobSelfBuff        boolean
------------------------------------------------------------------------------------------------------
H.PickActionCategory = function(action, actorMob, targetPetOwnerMob, petOwnerMob, isOffense, isDefense, mobSelfBuff)
    local category = action.category

    if category == H.ActionCategory.MELEE then
        if isOffense then
            H.Melee.Action(action, actorMob, petOwnerMob, isOffense)
        elseif isDefense then
            H.MeleeDef.Action(action, actorMob, targetPetOwnerMob, isDefense)
        end

    elseif category == H.ActionCategory.FINISH_RANGED then
        H.Ranged.Action(action, actorMob, isOffense)

    elseif category == H.ActionCategory.FINISH_WEAPONSKILL then
        H.TP.Action(action, actorMob, isOffense)

    elseif category == H.ActionCategory.FINISH_CASTING then
        if isOffense then
            H.Spell.Action(action, actorMob, petOwnerMob, isOffense)
        elseif isDefense then
            H.SpellDef.Action(action, actorMob, targetPetOwnerMob, isDefense)
        elseif mobSelfBuff then
            H.SpellDef.MobSelfTarget(action, actorMob)
        end

    elseif category == H.ActionCategory.FINISH_ITEM then
        H.Item.Finish(action, actorMob)

    elseif category == H.ActionCategory.JOB_ABILITY then
        H.Ability.Action(action, actorMob, isOffense)

    elseif category == H.ActionCategory.BEGIN_TP then
        H.TP.BeginMonsterAction(action, actorMob, isOffense)

    elseif category == H.ActionCategory.BEGIN_CASTING then
        -- Do nothing (Begin Spellcasting)

    elseif category == H.ActionCategory.BEGIN_ITEM then
        H.Item.Begin(action, actorMob)

    elseif category == H.ActionCategory.FINISH_TP then
        if isOffense then
            H.TP.MonsterAction(action, actorMob, isOffense)
        elseif isDefense then
            H.TpDef.MonsterAction(action, actorMob, petOwnerMob, isDefense)
        elseif mobSelfBuff then
            H.TpDef.MobSelfTarget(action, actorMob)
        end

    elseif category == H.ActionCategory.BEGIN_RANGED then
        -- Do nothing (Begin Ranged Attack)

    elseif category == H.ActionCategory.FINISH_PET_TP then
        H.Ability.PetAction(action, actorMob, isOffense)

    elseif category == H.ActionCategory.UNBLINKABLE then
        H.Ability.Action(action, actorMob, isOffense)

    elseif category == H.ActionCategory.RUNEFENCER_ABILITY then
        H.Ability.Action(action, actorMob, isOffense)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle action messages.
------------------------------------------------------------------------------------------------------
---@param packet table
------------------------------------------------------------------------------------------------------
H.ActionMessage = function(packet)
    local data = Ashita.Packets.BuildMessage(packet.data)

    if not data then
        return nil
    end

    -- Killing a mob.
    if data.message == Ashita.Message.MOB_KILL then
        local actorMob = Ashita.Mob.GetMobByIndex(data.actor_index)

        if Ashita.Party.IsAffiliate(actorMob.name) or Ashita.Mob.PetOwner(actorMob) then
            local targetMob = Ashita.Mob.GetMobByIndex(data.target_index)

            DB.TallyDefeatedMob(targetMob.name)
            Blog.Add(targetMob.name, nil, Blog.ActionType.MOB_DEATH, Blog.Enum.MOB_DEATH, nil, "------------")
        end

    -- Mob falls to the ground without a killing blow.
    elseif data.message == Ashita.Message.DEATH_FALL then
        local actorMob   = Ashita.Mob.GetMobByIndex(data.actor_index)
        local claimerMob = Ashita.Mob.GetMobByID(actorMob.claim_id)

        if Ashita.Party.IsAffiliate(claimerMob.name) or Ashita.Mob.PetOwner(claimerMob) then
            DB.TallyDefeatedMob(actorMob.name)
            Blog.Add(actorMob.name, nil, Blog.ActionType.MOB_DEATH, Blog.Enum.MOB_DEATH, nil, "------------")
        end

    -- Being defeated by a mob.
    elseif data.message == Ashita.Message.DEATH_FALL or data.message == Ashita.Message.DEATH then
        local targetMob = Ashita.Mob.GetMobByIndex(data.target_index)

        if Ashita.Party.IsAffiliate(targetMob.name) then
            local actorMob = Ashita.Mob.GetMobByIndex(data.actor_index)
            H.Death.Action(actorMob, targetMob)
        end

    -- Gil obtained from kill.
    elseif data.message == Ashita.Message.GIL_ACTOR or data.message == Ashita.Message.GIL_TARGET or data.message == Ashita.Message.GIL_MUG then
        local actorMob = Ashita.Mob.GetMobByIndex(data.target_index)

        if Ashita.Party.IsAffiliate(actorMob.name) or Ashita.Mob.PetOwner(actorMob) then
            Loot.NonDrop(actorMob.name, "Gil", data.param1)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Actions to take after zoning.
------------------------------------------------------------------------------------------------------
H.ZoningEnd = function()
    Ashita.Player.Zoning(false)             -- Clear zoning flag.
    Timers.Reset(Timers.Types.ZONE)    -- Reset time in zone timer.
    WindowManager.SetBarDelay()
    XP.Chains.End()                         -- Reset any XP chains.

    -- Add zone event to the battle log.
    -- Can't add the zone to the notes because member structure doesn't load fast enough after zone.
    Blog.Add("System", nil, Blog.ActionType.ZONE, "Zone", -1)
end

------------------------------------------------------------------------------------------------------
-- Actions to take on player update.
------------------------------------------------------------------------------------------------------
H.PlayerUpdate = function()
    if XP.IsInitialized then
        XP.Dedication.Refresh()
    end
end