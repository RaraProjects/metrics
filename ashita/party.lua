Ashita.Party = T{}

Ashita.Party.List = {}              -- Maintains who is currently in the party.
Ashita.Party.Jobs = {}              -- [player_name] Keeps track of player jobs.
Ashita.Party.Need_Refresh = true    -- Caches if we have the most up-to-date party information.
Ashita.Party.Refresh_Threshold = 3
Ashita.Party.Refresh_Time = os.time()

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
            local name = data:GetMemberName(slot)
            local id = data:GetMemberServerId(slot)
            local member_mob = Ashita.Mob.Get_Mob_By_ID(id)
            if member_mob and name ~= "" then
                Ashita.Party.List[name] = party_number
                DB.Data.Init_Player(name)

                local main_job       = data:GetMemberMainJob(slot)
                local main_job_level = data:GetMemberMainJobLevel(slot)
                local sub_job        = data:GetMemberSubJob(slot)
                local sub_job_level  = data:GetMemberSubJobLevel(slot)

                Ashita.Party.Update_Job(name, main_job, main_job_level, sub_job, sub_job_level)

                -- Might as well grab some data while looping through.
                if player_name and node and player_name == name then return_data = Ashita.Party.Get_Vital(data, slot, node) end
            else
                Debug.Error.Add("Party.Refresh: nil member or blank name {" .. tostring(name) .. "}")
            end
        end
    end

    Ashita.Party.Need_Refresh = false
    return return_data
end

-- ------------------------------------------------------------------------------------------------------
-- Refreshes the party if a refresh is due.
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Check_Refresh_Time = function()
    local now = os.time()
    if now - Ashita.Party.Refresh_Time > Ashita.Party.Refresh_Threshold then
        Ashita.Party.Refresh_Time = now
        Ashita.Party.Need_Refresh = true
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks if a mob index is in the party or alliance.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@return boolean
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Is_Affiliate = function(player_name)
    -- Short circuit for unit tests. Other players won't be in the normal party table.
    if Debug.Enabled and Debug.Unit.Active and player_name == "Player Two" then return true end

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
-- Updates the a player's job for the party.
-- ------------------------------------------------------------------------------------------------------
---@param player_name string
---@param main_job integer
---@param main_lvl integer
---@param sub_job integer
---@param sub_lvl integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Update_Job = function(player_name, main_job, main_lvl, sub_job, sub_lvl)
    if not main_job then main_job = 0 main_lvl = 0 end
    if not sub_job then sub_job = 0 sub_lvl = 0 end

    -- Avoid random members having their job color grayed out when leaving party or zoning.
    -- Only give NON jobs if they don't have one saved already.
    if Ashita.Party.Jobs[player_name] then
        if main_job > 0 then Ashita.Party.Jobs[player_name] = {main = main_job, main_level = main_lvl, sub = sub_job, sub_level = sub_lvl} end
    else
        Ashita.Party.Jobs[player_name] = {main = main_job, main_level = main_lvl, sub = sub_job, sub_level = sub_lvl}
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Get a player's stat.
-- ------------------------------------------------------------------------------------------------------
---@param data table
---@param slot integer
---@param stat? string
---@return integer
-- ------------------------------------------------------------------------------------------------------
Ashita.Party.Get_Vital = function(data, slot, stat)
    if not stat then return 1 end
    if stat == Ashita.Enum.Player_Attributes.TP then
        return data:GetMemberTP(slot)
    end
    return 1
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