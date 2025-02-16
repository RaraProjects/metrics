Blog.Entries = { }

------------------------------------------------------------------------------------------------------
-- Format the player name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param isMob?     boolean
---@return table { Name, Color }
------------------------------------------------------------------------------------------------------
Blog.Entries.Name = function(playerName, isMob)
    playerName       = playerName or Blog.Enum.UNKNOWN
    local color      = Blog.Dependencies.White()
    local playerData = Blog.Dependencies.CheckParty(playerName)

    if not isMob and Blog.Settings.Show_Job_Colors and playerData then
        local job = Blog.Dependencies.JobData(playerData.main) or Blog.Dependencies.JobData(0)
        color     = Blog.Dependencies.JobColor(job.id)
    end

    return { Value = tostring(playerName), Color = color }
end

------------------------------------------------------------------------------------------------------
-- Format the pet name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param petName string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.PetName = function(petName)
    return { Value = petName or Blog.Enum.NO_PET, Color = Blog.Dependencies.White() }
end

------------------------------------------------------------------------------------------------------
-- Format the damage component of the battle log.
------------------------------------------------------------------------------------------------------
---@param damage?     number
---@param actionType? string a battle log action type.
---@param color?      table
---@return table { Damage, Color }
------------------------------------------------------------------------------------------------------
Blog.Entries.Damage = function(damage, actionType, color)
    local defaultColor = color or Blog.Dependencies.White()

    if actionType == Blog.Enum.IGNORE then
        return { Value = Blog.Enum.NOT_APPLICABLE, Color = defaultColor }
    end

    -- Generate damage string.
    if not damage then
        return { Value = Blog.Enum.NOT_APPLICABLE, Color = Blog.Dependencies.Dim() }

    elseif damage < 0 then  -- Enfeeble
        return { Value = Blog.Enum.NOT_APPLICABLE, Color = defaultColor }

    elseif damage == 0 then
        return { Value = Blog.Dependencies.StringFormatNumber(0),  Color = defaultColor }
    end

    return { Value = Blog.Dependencies.StringFormatNumber(damage), Color = defaultColor }
end

------------------------------------------------------------------------------------------------------
-- Format the action component of the battle log.
------------------------------------------------------------------------------------------------------
---@param actionName string
---@param color      table
---@return table { Name, Color }
------------------------------------------------------------------------------------------------------
Blog.Entries.Action = function(actionName, color)
    return { Value = actionName, Color = color }
end

------------------------------------------------------------------------------------------------------
-- Format the TP component of the battle log.
-- Will also show if a spell cast is a magic burst.
------------------------------------------------------------------------------------------------------
---@param note?       number|string a note passed in from the handler; could be TP, BURST!, etc.
---@param actionType? string        a blog action type
---@return table
------------------------------------------------------------------------------------------------------
Blog.Entries.Notes = function(note, actionType)
    local color     = Blog.Dependencies.White()
    local finalNote = { Value = " ", Color = color }

    -- Don't do anything if a note wasn't passed in or is blank.
    if not note or note == "" then
        return finalNote
    end

    -- If the player died then show who killed them.
    if actionType == Blog.ActionType.PLAYER_DEATH then
        finalNote.Value = string.format("by %s", note)

    -- Show the TP of the weaponskill.
    elseif actionType == Blog.ActionType.WEAPONSKILL then
        local tpValue = tonumber(note)

        if tpValue then
            finalNote.Value = string.format("TP: %s ", Blog.Dependencies.StringFormatNumber(tpValue))
        end

    -- No special handling; just use the note.
    else
        finalNote.Value = tostring(note)
    end

    return finalNote
end