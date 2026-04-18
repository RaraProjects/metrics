Blog.Columns = { }

------------------------------------------------------------------------------------------------------
-- Creates a name string for display in the battle log.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param petName    string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Name = function(playerName, petName)
    if Blog.Dependencies.MaskNames() then
        playerName = Blog.Columns.Job(playerName)
    end

    if petName ~= Blog.Enum.NO_PET then
        local combinedString = string.format("%s (%s)", playerName, petName)

        if string.len(combinedString) > Blog.Enum.TRUNCATE_TOTAL then
            local truncatedPet    = Blog.Dependencies.StringTruncate(petName, Blog.Enum.TRUNCATE_PET, true)
            local truncatedPlayer = Blog.Dependencies.StringTruncate(playerName, Blog.Enum.TRUNCATE_PLAYER)
            combinedString = string.format("%s (%s)", truncatedPlayer, truncatedPet)
        end

        return Blog.Dependencies.StringSetLength(combinedString, Blog.Enum.TRUNCATE_TOTAL)
    end

    playerName = Blog.Dependencies.StringSetLength(playerName, Blog.Enum.TRUNCATE_TOTAL)

    return playerName
end

------------------------------------------------------------------------------------------------------
-- Gets the player's job for name masking.
-- Don't need the color because it gets saved when the entry is saved.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Job = function(playerName)
    local hideSubjob = Blog.Settings.Hide_Subjobs
    local playerInfo = Blog.Dependencies.CheckParty(playerName)

    if not playerName or not playerInfo then
        return hideSubjob and "NON0" or "NON0/NON0"
    end

    local mainData   = Blog.Dependencies.JobData(playerInfo.main) or Blog.Dependencies.JobData(0)
    local mainLevel  = playerInfo.main_level
    local mainString = string.format("%s%02d", mainData.ens, mainLevel)
    local subString  = ""

    if not hideSubjob then
        local subData  = Blog.Dependencies.JobData(playerInfo.sub) or Blog.Dependencies.JobData(0)
        local subLevel = playerInfo.sub_level
        subString = string.format("/%s%02d", subData.ens, subLevel)
    end

    return string.format("%s%s", mainString, subString)
end

------------------------------------------------------------------------------------------------------
-- Formats the damage string.
------------------------------------------------------------------------------------------------------
---@param damage string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Damage = function(damage)
    return Blog.Dependencies.StringSetLength(damage, Blog.Enum.TRUNCATE_DAMAGE)
end

------------------------------------------------------------------------------------------------------
-- Formats the action name.
------------------------------------------------------------------------------------------------------
---@param actionName string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Action = function(actionName)
    return Blog.Dependencies.StringTruncate(actionName, Blog.Enum.TRUNCATE_ACTION)
end

------------------------------------------------------------------------------------------------------
-- Formats the note.
------------------------------------------------------------------------------------------------------
---@param note string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Notes = function(note)
    note = Blog.Dependencies.StringTruncate(note, Blog.Enum.TRUNCATE_ACTION)
    note = Blog.Dependencies.StringSetLength(note, Blog.Enum.TRUNCATE_ACTION)
    return note
end