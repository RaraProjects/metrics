Ashita.Mob = { }

-- ------------------------------------------------------------------------------------------------------
-- Get an index from a mob ID. I got this from WinterSolstice8's parse lua.
-- Parse: https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
---@param id integer
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.GetIndexByID = function(id)
    if not id then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Mob.GetIndexByID", "Parameter \"id\" was nil.")
    end

    local index = bit.band(id, 0x7FF)
    local entityManager = AshitaCore:GetMemoryManager():GetEntity()

    if entityManager and entityManager:GetServerId(index) == id then
        return index
    end

    for i = 1, 2303 do
        if entityManager:GetServerId(i) == id then
            return i
        end
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- ------------------------------------------------------------------------------------------------------
---@param id integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.GetMobByID = function(id)
    if not id then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Mob.GetMobByID", "Parameter \"id\" was nil.")
    end

    return Ashita.Mob.Data(id, true)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_index() in windower.
-- ------------------------------------------------------------------------------------------------------
---@param index integer
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.GetMobByIndex = function(index)
    if not index then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Mob.GetMobByIndex", "Parameter \"index\" was nil.")
    end

    return Ashita.Mob.Data(index)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- HXUI    : https://github.com/tirem/HXUI
-- Zone might only come from the party packet.
-- ------------------------------------------------------------------------------------------------------
---@param id         integer this can be an ID or an index. If it's an ID then set the convert_id flag.
---@param convertId? boolean if an ID is supplied then the it will be need to be converted to an index.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.Data = function(id, convertId)
    -- Unit testing short circuit for creating pets.
    local unitTestingMob = Debug.Unit.Get_Mob(id)
    if unitTestingMob then
        return unitTestingMob
    end

    local index = convertId and Ashita.Mob.GetIndexByID(id) or id
	local entityManager = AshitaCore:GetMemoryManager():GetEntity()
    local entity = { }

    -- Sometimes players and pets can have blank names.
    entity.name = entityManager:GetName(index)
    if entity.name == "" then
        Debug.Error.Add(Debug.Error.ERROR, "Ashita.Mob.Data", string.format("Encountered a blank mob name. ID {%d}.", id or 0))
        entity.name = DB.Enum.DEBUG
    end

    local serverId      = entityManager:GetServerId(index)
    entity.id           = string.sub(string.format("0x%X", serverId), -3) -- This came from HXUI
    entity.id_num       = serverId
    entity.index        = index                                    -- Primary identifier.
    entity.entity_type  = entityManager:GetType(index)
    entity.status       = entityManager:GetStatus(index)           -- Idle [0], Engaged [1], Healing [33]
    entity.distance     = entityManager:GetDistance(index)         -- This distance is NOT in yalms.
    entity.hpp          = entityManager:GetHPPercent(index)
    entity.x            = entityManager:GetLocalPositionX(index)
    entity.y            = entityManager:GetLocalPositionY(index)
    entity.z            = entityManager:GetLocalPositionZ(index)
    entity.target_index = entityManager:GetTargetIndex(index)      -- Should be same as index.
    entity.pet_index    = entityManager:GetPetTargetIndex(index)   -- The index of the entity's pet. This should be blank for the pet.
    entity.claim_id     = entityManager:GetClaimStatus(index)      -- The server ID of the entity who has claim.
    entity.spawn_flags  = entityManager:GetSpawnFlags(index)       -- Player [525], Avatar/Jug Pet [258], Mob [16], Trust [4366]

    return entity
end

-- ------------------------------------------------------------------------------------------------------
-- Checks to see if a given string matches your character's name.
-- ------------------------------------------------------------------------------------------------------
---@param playerName string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.IsMe = function(playerName)
    local player = Ashita.Mob.GetMobByTarget(Ashita.TargetString.ME)
    if not player then
        return false
    end

    return playerName == player.name
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a given mob is a player.
-- ------------------------------------------------------------------------------------------------------
---@param mobData table
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.IsPlayer = function(mobData)
    if not mobData or not mobData.spawn_flags then
        return false
    end

    return mobData.spawn_flags == Ashita.EntityType.MAINPLAYER or
           mobData.spawn_flags == Ashita.EntityType.OTHERPLAYER or
           mobData.spawn_flags == Ashita.EntityType.IN_PARTY or
           mobData.spawn_flags == Ashita.EntityType.IN_ALLIANCE
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a given mob is an engageable mob.
-- ------------------------------------------------------------------------------------------------------
---@param mobData table
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.IsMonster = function(mobData)
    if not mobData or not mobData.spawn_flags then
        return false
    end

    return mobData.spawn_flags == Ashita.EntityType.MOB
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_target() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
---@param target string Things you put in <> in game like "me", "t", "pet", etc.
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.GetMobByTarget = function(target)
    local player = Ashita.Player.Entity()
    if not player then
        return { }
    end

    local playerId = player.ServerId
    local playerEntity = Ashita.Mob.GetMobByID(playerId)

    if target == Ashita.TargetString.ME then
        return playerEntity

    elseif target == Ashita.TargetString.TARGET then
        local targetIndex = Ashita.Player.TargetIndex()
        if targetIndex then
            return Ashita.Mob.GetMobByIndex(targetIndex)
        end

    elseif target == Ashita.TargetString.PET then
        -- local pet_index = player_entity.pet_index
        -- local pet_id = pet_entity.ServerId
        -- return a.Data.Mob_By_ID(pet_id)
    end

    return { }
end

-- ------------------------------------------------------------------------------------------------------
-- Check to see if the pet belongs to anyone in the party.
-- Influenced by Flippant parse
-- ------------------------------------------------------------------------------------------------------
---@param petData table the pet's mob table; needs to have an index.
---@return table|nil
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.PetOwner = function(petData)
    if not petData or not petData.index then
        return nil
    end

    -- May not always have a pet when running unit tests so need to short circuit here.
    if Debug.Enabled and Debug.Unit.Active and Debug.Unit.Has_Pet and petData.spawn_flags == Ashita.EntityType.PET then
        return Ashita.Mob.GetMobByTarget(Ashita.TargetString.ME)
    end

    -- Loop through party members to find the owner.
    local party = Ashita.Party.Get()
    for _, member in pairs(party) do
        if type(member) == "table" and member.mob and member.mob.pet_index == petData.index then
            return member.mob
        end
    end

    return nil
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is claimed by someone in the party or alliance.
-- ------------------------------------------------------------------------------------------------------
---@param mobData table
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.ClaimedByAffiliate = function(mobData)
    if not mobData or not mobData.claim_id or mobData.claim_id == 0 then
        return false
    end

    local claimer = Ashita.Mob.GetMobByID(mobData.claim_id)
    if not claimer then
        return false
    end

    return Ashita.Party.IsAffiliate(claimer.name)
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the distance between two mobs.
-- ------------------------------------------------------------------------------------------------------
---@param pos1 table could be a mob or any table with an x and y element.
---@param pos2 table could be a mob or any table with an x and y element.
---@return number
-- ------------------------------------------------------------------------------------------------------
Ashita.Mob.Distance = function(pos1, pos2)
    if not pos1 or not pos2 or not pos1.x or not pos2.x or not pos1.y or not pos2.y then
        return -1
    end

    local xDiff = (pos2.x - pos1.x)
    local yDiff = (pos2.y - pos1.y)

    return math.sqrt(xDiff^2 + yDiff^2)
end