Blog.Columns = T{}

------------------------------------------------------------------------------------------------------
-- Format the name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Columns.Name = function(player_name)
    local color = Window.Colors.WHITE
    if Ashita.Mob.Is_Me(player_name) then color = Window.Colors.GREEN end
    return {Value = player_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the damage component of the battle log.
------------------------------------------------------------------------------------------------------
---@param damage? number
---@param action_type? string a trackable from the data model.
---@return table {Damage, Color}
------------------------------------------------------------------------------------------------------
Blog.Columns.Damage = function(damage, action_type)
    -- Change the color of the text if the damage is over a certain threshold.
    local threshold = DB.Enum.Values.MAX_DAMAGE
    if action_type == DB.Enum.Trackable.WS then
        threshold = Metrics.Blog.Thresholds.WS
    elseif action_type == DB.Enum.Trackable.MAGIC then
        threshold = Metrics.Blog.Thresholds.MAGIC
    elseif action_type == Blog.Enum.Flags.IGNORE then
        return {Value = Blog.Enum.Text.NA, Color = Window.Colors.WHITE}
    end
    -- Generate damage string.
    if not damage then
        return {Value = Blog.Enum.Text.NA, Color = Window.Colors.DIM}
    elseif damage == 0 then
        return {Value = Blog.Enum.Text.MISS, Color = Window.Colors.RED}
    elseif damage >= threshold then
        return {Value = Col.String.Format_Number(damage), Color = Window.Colors.PURPLE}
    end
    return {Value = Col.String.Format_Number(damage), Color = Window.Colors.WHITE}
end

------------------------------------------------------------------------------------------------------
-- Format the action component of the battle log.
------------------------------------------------------------------------------------------------------
---@param action_name string
---@param action_type? string a trackable from the data model.
---@param action_data? table additional information about the action to help with text formatting.
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
Blog.Columns.Action = function(action_name, action_type, action_data)
    local color = Window.Colors.WHITE
    if action_type and action_data then
        if action_type == DB.Enum.Trackable.MAGIC then
            local element = action_data.Element
            color = Window.Colors.Elements[element]
        end
    end
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
Blog.Columns.Notes = function(note, action_type)
    local color = Window.Colors.WHITE
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
        if note then final_note.Value = "TP: " .. Col.String.Format_Number(note) .. " " end
    end

    return final_note
end