Blog.Entries = T{}

------------------------------------------------------------------------------------------------------
-- Format the player name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param is_mob? boolean
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Name = function(player_name, is_mob)
    if not player_name then player_name = "Unknown" end
    local color = Res.Colors.Basic.WHITE
    if not is_mob and Metrics.Parse.Name_Colors and Ashita.Party.Jobs[player_name] then
        local job = Res.Jobs.Get_Job(Ashita.Party.Jobs[player_name].main)
        if not job then job = Res.Jobs.List[0] end
        color = Res.Colors.Get_Job(job.id)
    end
    return {Value = tostring(player_name), Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the pet name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param pet_name string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Pet_Name = function(pet_name)
    local color = Res.Colors.Basic.WHITE
    if not pet_name then pet_name = Blog.Enum.NO_PET end
    return {Value = pet_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the damage component of the battle log.
------------------------------------------------------------------------------------------------------
---@param damage? number
---@param action_type? string a battle log action type.
---@param color? table
---@return table {Damage, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Damage = function(damage, action_type, color)
    if action_type == Blog.Enum.IGNORE then return {Value = Blog.Enum.NOT_APPLICABLE, Color = Res.Colors.Basic.WHITE} end

    local default_color = Res.Colors.Basic.WHITE
    if color then default_color = color end

    -- Change the color of the text if the damage is over a certain threshold.
    local threshold = Blog.Entries.Damage_Threshold(action_type)

    -- Generate damage string.
    if not damage then
        return {Value = Blog.Enum.NOT_APPLICABLE, Color = Res.Colors.Basic.DIM}
    elseif damage < 0 then  -- Enfeeble
        return {Value = Blog.Enum.NOT_APPLICABLE, Color = default_color}
    elseif damage == 0 then
        return {Value = Column.String.Format_Number(0), Color = default_color, Note = Blog.Enum.MISS}
    elseif damage >= threshold then
        return {Value = Column.String.Format_Number(damage), Color = default_color, Note = Blog.Enum.HIGH_DAMAGE}
    end
    return {Value = Column.String.Format_Number(damage), Color = default_color}
end

------------------------------------------------------------------------------------------------------
-- Helper function for calculating a damage threshold for highlighting.
------------------------------------------------------------------------------------------------------
---@param action_type? string a battle log action type.
---@return number
------------------------------------------------------------------------------------------------------
Blog.Entries.Damage_Threshold = function(action_type)
    local threshold = DB.Enum.MAX_DAMAGE

    -- Default to max damage to block damage notifications.
    if not action_type then
        return threshold

    elseif action_type == Blog.Action_Type.WEAPONSKILL then
        return Metrics.Blog.WS_THRESHOLD

    elseif action_type == Blog.Action_Type.MAGIC_OFFENSIVE then
        return Metrics.Blog.MAGIC_THRESHOLD

    else
        return threshold
    end
end

------------------------------------------------------------------------------------------------------
-- Format the action component of the battle log.
------------------------------------------------------------------------------------------------------
---@param action_name string
---@param color table
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Action = function(action_name, color)
    return {Value = action_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the TP component of the battle log.
-- Will also show if a spell cast is a magic burst.
------------------------------------------------------------------------------------------------------
---@param note? number|string a note passed in from the handler; could be TP, BURST!, etc.
---@param action_type? string a blog action type
---@return table
------------------------------------------------------------------------------------------------------
Blog.Entries.Notes = function(note, action_type)
    local color = Res.Colors.Basic.WHITE
    local final_note = {Value = " ", Color = color}

    -- Don't do anything if a note wasn't passed in or is blank.
    if not note or note == "" then return final_note end

    -- If the player died then show who killed them.
    if action_type == Blog.Action_Type.PLAYER_DEATH then
        final_note.Value = "by " .. tostring(note)

    -- Show the TP of the weaponskill.
    elseif action_type == Blog.Action_Type.WEAPONSKILL then
        local tp_value = tonumber(note)
        if tp_value then final_note.Value = "TP: " .. Column.String.Format_Number(tp_value) .. " " end

    -- No special handling; just use the note.
    else
        final_note.Value = tostring(note)
    end

    return final_note
end