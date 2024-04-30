Ashita.Party = T{}

Ashita.Party.List = {}              -- Maintains who is currently in the party.
Ashita.Party.Need_Refresh = true    -- Caches if we have the most up-to-date party information.

-- ------------------------------------------------------------------------------------------------------
-- Get party data. I'm trying to mimic the windower.ffxi.get_party() function.
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Get = function()
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
            party[slot].mob   = Ashita.Mob.Get_Mob_By_Index(party[slot].index)

            if party[slot].flags == 4 then
                parties[party_number].leader = party[slot].index
            end

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
---@param player_name? string
---@param node? string
---@return nil|number
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Refresh = function(player_name, node)
    if not Ashita.Party.Need_Refresh and not player_name then return nil end

    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then return nil end

    Ashita.Party.List = {}
    local return_data = nil

    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local party_number = math.ceil((slot + 1) / 6)
        if data:GetMemberIsActive(slot) == 1 then
            Ashita.Party.List[data:GetMemberName(slot)] = party_number

            -- Might as well grab some data while looping through.
            if player_name then
                local member_name = data:GetMemberName(slot)
                if member_name == player_name then
                    if node then
                        if node == Ashita.Enum.Player_Attributes.TP then
                            return_data = data:GetMemberTP(slot)
                        end
                    else
                        return_data = 1
                    end
                end
            end
        end
    end

    Ashita.Party.Need_Refresh = false
    return return_data
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob index is in the party or alliance.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Is_Affiliate = function(player_name)
    local party_number = Ashita.Party.List[player_name]
    if not party_number then return false end
    return Ashita.Party.In_Party(player_name) or Ashita.Party.In_Alliance(player_name)
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is in the party.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.In_Party = function(player_name)
    local party_number = Ashita.Party.List[player_name]
    if not party_number then return false end
    return party_number == 1
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is in the alliance.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.In_Alliance = function(player_name)
    local party_number = Ashita.Party.List[player_name]
    if not party_number then return false end
    return party_number == 2 or party_number == 3
end

-- ------------------------------------------------------------------------------------------------------
-- Since I removed the p0, a10, a20 indicies from party, this function helps party loops find
-- their starting slot index.
-- ------------------------------------------------------------------------------------------------------
---@param party_number number party 1, 2, or 3.
---@return integer starting slot for that particular party.
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Start_Slot = function(party_number)
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