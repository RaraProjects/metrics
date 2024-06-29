Blog.Entries = T{}

------------------------------------------------------------------------------------------------------
-- Format the player name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Name = function(player_name)
    local color = Res.Colors.Basic.WHITE
    if Ashita.Mob.Is_Me(player_name) then color = Res.Colors.Basic.GREEN end
    return {Value = player_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the pet name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param pet_name string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Pet_Name = function(pet_name)
    local color = Res.Colors.Basic.WHITE
    if not pet_name then pet_name = Blog.Enum.Text.NO_PET end
    return {Value = pet_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the damage component of the battle log.
------------------------------------------------------------------------------------------------------
---@param damage? number
---@param action_type? string a trackable from the data model.
---@param color? table
---@return table {Damage, Color}
------------------------------------------------------------------------------------------------------
Blog.Entries.Damage = function(damage, action_type, color)
    if action_type == Blog.Enum.Flags.IGNORE then return {Value = Blog.Enum.Text.NA, Color = Res.Colors.Basic.WHITE} end

    local default_color = Res.Colors.Basic.WHITE
    if color then default_color = color end

    -- Change the color of the text if the damage is over a certain threshold.
    local threshold = Blog.Entries.Damage_Threshold(action_type)

    -- Generate damage string.
    if not damage then
        return {Value = Blog.Enum.Text.NA, Color = Res.Colors.Basic.DIM}
    elseif damage == 0 then
        return {Value = Column.String.Format_Number(0), Color = Res.Colors.Basic.DIM, Note = Blog.Enum.Text.MISS}
    elseif damage >= threshold then
        return {Value = Column.String.Format_Number(damage), Color = default_color, Note = Blog.Enum.Text.HIGH_DAMAGE}
    end
    return {Value = Column.String.Format_Number(damage), Color = default_color}
end

------------------------------------------------------------------------------------------------------
-- Helper function for calculating a damage threshold for highlighting.
------------------------------------------------------------------------------------------------------
---@param action_type? string a trackable from the data model.
---@return number
------------------------------------------------------------------------------------------------------
Blog.Entries.Damage_Threshold = function(action_type)
    local threshold = DB.Enum.Values.MAX_DAMAGE
    if not action_type then
        return threshold
    elseif action_type == DB.Enum.Trackable.WS then
        return Metrics.Blog.Thresholds.WS
    elseif action_type == DB.Enum.Trackable.MAGIC then
        return Metrics.Blog.Thresholds.MAGIC
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
---@param note? string|number how much TP was used by the weaponskill
---@param action_type? string a trackable from the data model.
---@return table
------------------------------------------------------------------------------------------------------
Blog.Entries.Notes = function(note, action_type)
    local color = Res.Colors.Basic.WHITE
    local final_note = {Value = " ", Color = color}

    -- A note should be passed in with these actions. Just use that.
    if action_type == DB.Enum.Trackable.MAGIC or action_type == DB.Enum.Trackable.HEALING or action_type == Blog.Enum.Flags.IGNORE then
        final_note.Value = tostring(note)

    -- If the player died then show who kill them.
    elseif action_type == DB.Enum.Trackable.DEATH then
        final_note.Value = "by " .. tostring(note)

    -- We passed in a note, but didn't handle it above.
    elseif type(note) == "string" then
        _Debug.Error.Add("Unhandled battle log note. Note: {" .. tostring(note) .. "} Type: {" .. tostring(action_type) .. "}.")
        final_note.Value = " "

    -- The default case is showing the user's TP for a weaponskill.
    else
        -- TP for WS is the default case.
        ---@diagnostic disable-next-line: param-type-mismatch
        if note then final_note.Value = "TP: " .. Column.String.Format_Number(note) .. " " end
    end

    return final_note
end