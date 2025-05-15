Ashita.Party = { }

Ashita.Party.List = { }                 -- Maintains who is currently in the party.
Ashita.Party.Jobs = { }                 -- [player_name] Keeps track of player jobs.
Ashita.Party.NeedRefresh      = true    -- Caches if we have the most up-to-date party information.
Ashita.Party.RefreshThreshold = 3
Ashita.Party.RefreshTime      = os.time()

-- ------------------------------------------------------------------------------------------------------
-- Get party data. I'm trying to mimic the windower.ffxi.get_party() function.
-- Windower: https://github.com/Windower/Lua/wiki/FFXI-Functions
-- ------------------------------------------------------------------------------------------------------
---@return table
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Get = function()
    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then
        return { }
    end

    local party = { }
    local parties =
    {
        [1] = { },
        [2] = { },
        [3] = { },
    }
    local allianceCount = 0

    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local partyNumber  = math.ceil((slot + 1) / 6)
        local slotOccupied = data:GetMemberIsActive(slot)

        if not parties[partyNumber] then
            parties[partyNumber] = { }
        end

        -- The party slot is occupied.
        if slotOccupied == 1 then
            allianceCount = allianceCount + 1

            -- Initialize party count if not already.
            parties[partyNumber].count = (parties[partyNumber].count or 0) + 1

            local member =
            {
                name  = data:GetMemberName(slot),
                index = data:GetMemberTargetIndex(slot),
                id    = data:GetMemberServerId(slot),
                job   = data:GetMemberMainJob(slot),
                hp    = data:GetMemberHP(slot),
                hpp   = data:GetMemberHPPercent(slot),
                mp    = data:GetMemberMP(slot),
                mpp   = data:GetMemberMPPercent(slot),
                tp    = data:GetMemberTP(slot),
                zone  = data:GetMemberZone(slot),
                flags = data:GetMemberFlagMask(slot),
                mob   = Ashita.Mob.GetMobByIndex(data:GetMemberTargetIndex(slot)),
            }
            party[slot] = member

            -- Set party leader.
            if member.flags == 4 then
                parties[partyNumber].leader = member.index
            end
		end
    end

    party.party1_leader  = parties[1].leader
    party.party2_leader  = parties[2].leader
    party.party3_leader  = parties[3].leader
    party.party1_count   = parties[1].count or 0
    party.party2_count   = parties[2].count or 0
    party.party3_count   = parties[3].count or 0
    party.alliance_count = allianceCount

    return party
end

-- ------------------------------------------------------------------------------------------------------
-- Returns player party data.
-- ------------------------------------------------------------------------------------------------------
---@param playerName string
---@return nil|table
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.GetMember = function(playerName)
    if not playerName then
        return nil
    end

    return Ashita.Party.Jobs[playerName]
end

-- ------------------------------------------------------------------------------------------------------
-- Refreshes the party list.
-- This is a lighter version than Party() for just caching who is in the party.
-- It avoids stack overflow by not computing mob structure.
-- ------------------------------------------------------------------------------------------------------
---@param playerName? string
---@param node? string
---@return nil|number
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Refresh = function(playerName, node)
    if not Ashita.Party.NeedRefresh and not playerName then
        return nil
    end

    local data = AshitaCore:GetMemoryManager():GetParty()
    if not data then
        return nil
    end

    Ashita.Party.List = { }
    local returnData = nil

    for slot = 0, 17 do
        -- Group the 18 members up into 3 parties.
        local partyNumber = math.ceil((slot + 1) / 6)

        if data:GetMemberIsActive(slot) == 1 then
            local name      = data:GetMemberName(slot)
            local id        = data:GetMemberServerId(slot)
            local memberMob = Ashita.Mob.GetMobByID(id)

            if memberMob and name ~= "" then
                Ashita.Party.List[name] = partyNumber
                DB.Data.InitializePlayerTrackingTables(name)

                local mainJob      = data:GetMemberMainJob(slot)
                local mainJobLevel = data:GetMemberMainJobLevel(slot)
                local subJob       = data:GetMemberSubJob(slot)
                local subJobLevel  = data:GetMemberSubJobLevel(slot)

                Ashita.Party.UpdateJob(name, mainJob, mainJobLevel, subJob, subJobLevel)

                -- Might as well grab some data while looping through.
                if playerName and node and playerName == name then
                    returnData = Ashita.Party.GetVital(data, slot, node)
                end

            else
                Debug.Error.Add(Debug.Error.ERROR, "Ashita.Party.Refresh", "Nil member or blank name {" .. tostring(name) .. "}")
            end
        end
    end

    -- Reset the refresh flag.
    Ashita.Party.NeedRefresh = false

    return returnData
end

-- ------------------------------------------------------------------------------------------------------
-- Refreshes the party if a refresh is due.
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.CheckRefreshTime = function()
    local now = os.time()
    if now - Ashita.Party.RefreshTime > Ashita.Party.RefreshThreshold then
        Ashita.Party.RefreshTime = now
        Ashita.Party.NeedRefresh = true
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob index is in the party or alliance.
-- ------------------------------------------------------------------------------------------------------
---@param playerName string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.IsAffiliate = function(playerName)
    -- Disregard if player isn't in the party list.
    if not Ashita.Party.List[playerName] then
        return false
    end

    return Ashita.Party.InParty(playerName) or Ashita.Party.InAlliance(playerName)
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is in the party.
-- ------------------------------------------------------------------------------------------------------
---@param playerName string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.InParty = function(playerName)
    local partyNumber = Ashita.Party.List[playerName]

    if not partyNumber then
        return false
    end

    return partyNumber == 1
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob is in the alliance.
-- ------------------------------------------------------------------------------------------------------
---@param playerName string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.InAlliance = function(playerName)
    local partyNumber = Ashita.Party.List[playerName]

    if not partyNumber then
        return false
    end

    return partyNumber == 2 or partyNumber == 3
end

-- ------------------------------------------------------------------------------------------------------
-- Updates the a player's job for the party.
-- ------------------------------------------------------------------------------------------------------
---@param playerName string
---@param mainJob    integer
---@param mainLevel  integer
---@param subJob     integer
---@param subLevel   integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.UpdateJob = function(playerName, mainJob, mainLevel, subJob, subLevel)
    mainJob, mainLevel = mainJob or 0, mainLevel or 0
    subJob,  subLevel  = subJob  or 0, subLevel  or 0

    -- Avoid random members having their job color grayed out when leaving party or zoning.
    -- Only give NON jobs if they don't have one saved already.
    if not Ashita.Party.Jobs[playerName] or mainJob > 0 then
        Ashita.Party.Jobs[playerName] = { main = mainJob, main_level = mainLevel, sub = subJob, sub_level = subLevel }
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Get a player's stat.
-- ------------------------------------------------------------------------------------------------------
---@param data  table
---@param slot  integer
---@param stat? string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.GetVital = function(data, slot, stat)
    if not stat then
        return 1
    end

    if stat == Ashita.PlayerAttributes.TP then
        return data:GetMemberTP(slot)
    end

    return 1
end