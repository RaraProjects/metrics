Chat = require("chat")

local a = {}

a.Data = {}
a.Chat = {}
a.Party = {}
a.Party.List = {}
a.Spell = {}
a.WS = {}
a.Item = {}

a.Mob = {}
a.Mob.Enum = {}
a.Mob.Enum.Party_Node = {
    TP = "TP"
}
a.Mob.Enum.Type = {
    PLAYER = 0,
    PET = 2, -- Avatar, Jug Pet, Trust
}

a.Ability = {}
a.Ability.Enum = {}
a.Ability.Enum.Type = {
    PETSUMMON = 1,      -- BST Beastial Loyalty
    PETLOGISTICS = 2,   -- Player uses this on themself. Fight, Heel, Stay, etc.
    BLOODPACTRAGE = 6,  -- Player uses this on themself.
    BLOODPACTWARD = 10, -- Player uses this on themself.
    PETABILITY = 18,    -- Offensive BST/SMN ability.
}

a.Debug = true

-- ------------------------------------------------------------------------------------------------------
-- https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Memory Manager Functions
-- IAutoFollow* GetAutoFollow(void)
-- ICastBar* GetCastBar(void)
-- IEntity* GetEntity(void)
-- IInventory* GetInventory(void)
-- IParty* GetParty(void)
-- IPlayer* GetPlayer(void)
-- IRecast* GetRecast(void)
-- ITarget* GetTarget(void)
-- ------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------
-- Get player data.
-- ------------------------------------------------------------------------------------------------------
a.Data.Player = function()
    return AshitaCore:GetMemoryManager():GetPlayer()
end

-- ------------------------------------------------------------------------------------------------------
-- Get player entity data.
-- I can't figure out where this function is defined, but it works. ¯\_(ツ)_/¯
-- ------------------------------------------------------------------------------------------------------
a.Data.Player_Entity = function()
    return GetPlayerEntity()
end

-- ------------------------------------------------------------------------------------------------------
-- Get player's target index.
-- I grabbed and adjusted this snippet from HXUI and mobdb.
-- https://github.com/tirem/HXUI
-- https://github.com/ThornyFFXI/mobdb
-- ------------------------------------------------------------------------------------------------------
a.Data.Target_Index = function()
    local memory_manager = AshitaCore:GetMemoryManager()
    local entity_manager = memory_manager:GetEntity()
    local target_manager = memory_manager:GetTarget()
    return target_manager:GetTargetIndex(target_manager:GetIsSubTargetActive())
end

-- ------------------------------------------------------------------------------------------------------
-- Get party data. I'm trying to mimic the windower.ffxi.get_party() function.
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
a.Data.Party = function()
    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then return {} end

    local party = {}
    local parties = {}
    local alliance_count = 0

    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local party_number = math.ceil((slot + 1) / 6)
        if not parties[party_number] then parties[party_number] = {} end

        -- The party slot is occupied.
        if data:GetMemberIsActive(slot) == 1 then
            alliance_count = alliance_count + 1

            if not parties[party_number].count then
                parties[party_number].count = 1
            else
                parties[party_number].count = parties[party_number].count + 1
            end

            party[slot] = {}
            party[slot].name  = data:GetMemberName(slot)
            party[slot].index = data:GetMemberTargetIndex(slot)
            party[slot].id    = data:GetMemberServerId(slot)
            party[slot].job   = data:GetMemberMainJob(slot)
            party[slot].hp    = data:GetMemberHP(slot)
            party[slot].hpp   = data:GetMemberHPPercent(slot)
            party[slot].mp    = data:GetMemberMP(slot)
            party[slot].mpp   = data:GetMemberMPPercent(slot)
            party[slot].tp    = data:GetMemberTP(slot)
            party[slot].zone  = data:GetMemberZone(slot)
            party[slot].flags = data:GetMemberFlagMask(slot)
            party[slot].mob   = a.Mob.Get_Mob_By_Index(party[slot].index)

            if party[slot].flags == 4 then
                parties[party_number].leader = party[slot].index
            end

            a.Party.List[party[slot].index] = party_number

        -- The party slot is not occupied.
        else
            if not parties[party_number].leader then
                parties[party_number].leader = nil
            end

		end
    end

    party.party1_leader = parties[1].leader
    party.party2_leader = parties[2].leader
    party.party3_leader = parties[3].leader
    party.party1_count  = parties[1].count or 0
    party.party2_count  = parties[2].count or 0
    party.party3_count  = parties[3].count or 0
    --alliance_leader
    party.alliance_count = alliance_count

    return party
end

-- ------------------------------------------------------------------------------------------------------
-- Refreshes the party list.
-- This is a lighter version than Party() for just caching who is in the party.
-- It avoids stack overflow by not computing mob structure.
-- ------------------------------------------------------------------------------------------------------
a.Party.Refresh = function(player_name, node)
    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then return {} end
    local party = {}
    local return_data = nil
    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local party_number = math.ceil((slot + 1) / 6)
        if data:GetMemberIsActive(slot) == 1 then
            party[slot] = {}
            party[slot].index = data:GetMemberTargetIndex(slot)
            a.Party.List[party[slot].index] = party_number

            -- Might as well grab some data while looping through.
            if player_name and node then
                local party_name = data:GetMemberName(slot)
                if party_name == player_name then
                    if node == a.Mob.Enum.Party_Node.TP then
                        return_data = data:GetMemberTP(slot)
                    end
                end
            end
        end
    end
    return return_data
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob index is in the party.
-- ------------------------------------------------------------------------------------------------------
a.Party.Is_Affiliate = function(index)
    local party_number = a.Party.List[index]
    local affiliation = {}
    affiliation.party = false
    affiliation.alliance = false
    if not party_number then return affiliation end
    if party_number == 1 then
        affiliation.party = true
    elseif party_number <=3 then
        affiliation.alliance = true
    end
    return affiliation
end

-- ------------------------------------------------------------------------------------------------------
-- Since I removed the p0, a10, a20 indicies from party, this function helps party loops find
-- their starting slot index.
-- ------------------------------------------------------------------------------------------------------
a.Party.Start_Slot = function(party_number)
    if party_number == 1 then
        return 0
    elseif party_number == 2 then
        return 6
    elseif party_number == 3 then
        return 12
    else
        return 1
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Get an index from a mob ID. I got this from WinterSolstice8's parse lua.
-- Parse: https://github.com/WinterSolstice8/parse
-- ------------------------------------------------------------------------------------------------------
a.Data.Index_By_ID = function(id)
    local index = bit.band(id, 0x7FF)
    local entity_manager = AshitaCore:GetMemoryManager():GetEntity()

    if entity_manager:GetServerId(index) == id then
        return index
    end

    for i = 1, 2303 do
        if entity_manager:GetServerId(i) == id then
            return i
        end
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- ------------------------------------------------------------------------------------------------------
a.Mob.Get_Mob_By_ID = function(id)
    return a.Mob.Data(id, true)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_index() in windower.
-- ------------------------------------------------------------------------------------------------------
a.Mob.Get_Mob_By_Index = function(index)
    return a.Mob.Data(index)
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_id() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
a.Mob.Data = function(id, flag)
    local index = id
    if flag then
        index = a.Data.Index_By_ID(id)
    end

	local entity_manager = AshitaCore:GetMemoryManager():GetEntity()
    local entity = {}

    entity.name = entity_manager:GetName(index)
    entity.id = id
    entity.index = index
    entity.entity_type = entity_manager:GetType(index)
    entity.status = entity_manager:GetStatus(index)
    entity.distance = entity_manager:GetDistance(index)
    entity.hpp = entity_manager:GetHPPercent(index)
    entity.zone = entity_manager:GetZoneId(index)
    entity.x = entity_manager:GetLocalPositionX(index)
    entity.y = entity_manager:GetLocalPositionY(index)
    entity.z = entity_manager:GetLocalPositionZ(index)
    entity.target_index = entity_manager:GetTargetIndex(index)
    entity.pet_index = entity_manager:GetPetTargetIndex(index)
    entity.claim_id = entity_manager:GetClaimStatus(index)
    entity.is_npc = entity_manager:GetType(index)

    a.Party.Refresh()
    local affiliation = a.Party.Is_Affiliate(index)
    entity.in_party = affiliation.party
    entity.in_alliance = affiliation.alliance

    return entity
end

-- ------------------------------------------------------------------------------------------------------
-- Get mob data. Trying to make this behave like get_mob_by_target() in windower.
-- Ashita  : https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
a.Mob.Get_Mob_By_Target = function(target)
    local player = a.Data.Player_Entity()
    if not player then return {} end
    local player_id = player.ServerId
    local player_entity = a.Mob.Get_Mob_By_ID(player_id)
    A.Chat.Message("Player: " .. player_entity.target_index)

    if target == "me" then
        return player_entity
    elseif target == "t" then
        local target_index = a.Data.Target_Index()
        if target_index then
            return a.Mob.Get_Mob_By_Index(target_index)
        end
    elseif target == "pet" then
        -- local pet_index = player_entity.pet_index
        -- local pet_id = pet_entity.ServerId
        -- return a.Data.Mob_By_ID(pet_id)
    end

    return {}
end

-- ------------------------------------------------------------------------------------------------------
-- Check to see if the pet belongs to anyone in the party.
-- Influenced by Flippant parse
-- ------------------------------------------------------------------------------------------------------
a.Mob.Pet_Owner = function(pet_data)
    local party = A.Data.Party()
    local owner
    for _, member in pairs(party) do
        if type(member) == 'table' and member.mob then
            if member.mob.pet_index == pet_data.index then
                owner = member.mob
            end
        end
    end
    return owner
end

-- ------------------------------------------------------------------------------------------------------
-- Get ability data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- Type 6  = SMN using BloodPactRage
-- Type 10 = BloodPactWard
-- Type 18 = BloodPactRage
-- Offsets
-- WS have zero offset.
-- Abilities have 512 offset.
-- ------------------------------------------------------------------------------------------------------
a.Ability.ID = function(id)
    return AshitaCore:GetResourceManager():GetAbilityById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of an ability.
-- ------------------------------------------------------------------------------------------------------
a.Ability.Name = function(id, data)
    local ability = data
    if not ability then
        ability = a.Ability.ID(id)
    end
    if not ability then return "Error" end
    return ability.Name[1]
end

-- ------------------------------------------------------------------------------------------------------
-- Get the current recast time for an ability by the abilities ID.
-- ------------------------------------------------------------------------------------------------------
a.Ability.Recast_ID = function(id)
    local ability_id
    local recast = 0
    local found = false
    for i = 0, 31 do
        if not found then
            ability_id = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimerId(i)
            if ability_id == id then
                recast = math.floor(AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimer(i) / 60)
                found = true
            end
        end
    end
    return recast
end

-- ------------------------------------------------------------------------------------------------------
-- Get spell data.
-- https://wiki.ashitaxi.com/doku.php?id=addons:adk:iresourcemanager
-- ------------------------------------------------------------------------------------------------------
a.Spell.ID = function(id)
    return AshitaCore:GetResourceManager():GetSpellById(id)
end

-- ------------------------------------------------------------------------------------------------------
-- Get the name of a spell.
-- ------------------------------------------------------------------------------------------------------
a.Spell.Name = function(id, data)
    local spell = data
    if not spell then
        spell = a.Spell.ID(id)
    end
    if not spell then return "Error" end
    return spell.Name[0]
end

-- ------------------------------------------------------------------------------------------------------
-- Gets properties for a WS.
-- The resource file used to do this is from Windower.
-- Some things are treated as weaponskills, but aren't actually. Those can be missing from the WS file.
-- For those I keep track of them in Missing_WS define in the lists.lua
-- ------------------------------------------------------------------------------------------------------
a.WS.ID = function(id)
    local ws = WS[id]
    if not ws then ws = Lists.WS.Missing_WS[id] end
    return ws
end

-- ------------------------------------------------------------------------------------------------------
-- Checks a piece of gear's level.
-- ------------------------------------------------------------------------------------------------------
a.Item.Get_Item_Level = function(item_name)
    local item = AshitaCore:GetResourceManager():GetItemByName(item_name, 0)
    local item_level = item.Level
    if not item_level then return 0 end
    return item_level
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat.
-- ------------------------------------------------------------------------------------------------------
a.Chat.Message = function(message)
    --AshitaCore:GetChatManager():QueueCommand(-1, tostring(message))
    --AshitaCore:GetChatManager():AddChatMessage(255, tostring(message))
    print("METRICS: " .. message)
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat if the debug flag is on.
-- ------------------------------------------------------------------------------------------------------
a.Chat.Debug = function(message)
    if a.Data then print("METRICS DEBUG: " .. message) end
end

return a