local bl = T{}

bl.Log = {}
bl.Display = {}
bl.Util = {}

bl.Defaults = T{}
bl.Defaults.Flags = T{
    Timestamp = false,
    Melee     = false,
    Ranged    = false,
    WS        = true,
    SC        = true,
    Magic     = true,
    Ability   = true,
    Pet       = true,
    Healing   = true,
    Deaths    = false,
    Mob_Death = true,
    Show_Length = false,
}
bl.Defaults.Thresholds = T{
    WS    = 600,
    MAGIC = 1000,
    MAX   = 99999,
}
bl.Defaults.Visible_Length = 8

bl.Settings = {
    Size = 32,
    Length = 100,
    Truncate_Length = 6,
    Visible_Length = 8,
}

bl.Enum = {}
bl.Enum.Text = {
    MISS = "MISS!",
    NA   = "---",
    MB   = "BURST!",
    MOB_DEATH = "Defeated",
    PLAYER_DEATH = "Died",
}
bl.Enum.Flags = {
    IGNORE = "ignore",
}
bl.Enum.Thresholds = {
    MAX   = 99999,
}

-- FUTURE CONSIDERATIONS
-- Highlight damage if the damage is higher than the average for that weaponskill.

------------------------------------------------------------------------------------------------------
-- Resets the battle log.
------------------------------------------------------------------------------------------------------
bl.Reset_Log = function()
    bl.Log = {}
end

------------------------------------------------------------------------------------------------------
-- Resets the battle log settings.
------------------------------------------------------------------------------------------------------
bl.Reset_Settings = function()
    Metrics.Blog.Flags.Damage_Highlighting = true
    for index, _ in pairs(Metrics.Blog.Flags) do
        Metrics.Blog.Flags[index] = bl.Defaults.Flags[index]
    end
    for index, _ in pairs(Metrics.Blog.Thresholds) do
        Metrics.Blog.Thresholds[index] = bl.Defaults.Thresholds[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the battle log data to the screen.
------------------------------------------------------------------------------------------------------
bl.Populate = function()
    local table_size = {0, bl.Settings.Size * Metrics.Blog.Visible_Length}
    local columns = 4
    if Metrics.Blog.Flags.Timestamp then columns = columns + 1 end

    -- Resize Options
    if UI.SmallButton("Set Display Length") then
        Metrics.Blog.Flags.Show_Length = not Metrics.Blog.Flags.Show_Length
    end
    if Metrics.Blog.Flags.Show_Length then
        UI.Separator()
        if UI.Button("Default") then
            Metrics.Blog.Visible_Length = bl.Settings.Visible_Length
        end
        UI.SameLine() UI.Text(" ") UI.SameLine()
        local length = {[1] = Metrics.Blog.Visible_Length}
        UI.SetNextItemWidth(50)
        if UI.DragInt("Length", length, 0.1, bl.Settings.Visible_Length, 50, "%d", ImGuiSliderFlags_None) then
            Metrics.Blog.Visible_Length = length[1]
        end
    end

    -- Content
    if UI.BeginTable("Blog", columns, Window.Table.Flags.Scrollable, table_size) then
        bl.Display.Headers()
        for _, entry in ipairs(bl.Log) do
            bl.Display.Rows(entry)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Add an entry to battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that took the action
---@param action_name string name of the action the player took (like a weaponskill or ability).
---@param damage? number usually how much damage the action did.
---@param note? number|string how much TP was used by the weaponskill.
---@param action_type? string a trackable from the data model.
---@param action_data? table additional information about the action to help with text formatting.
------------------------------------------------------------------------------------------------------
bl.Add = function(player_name, action_name, damage, note, action_type, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #bl.Log >= bl.Settings.Length then table.remove(bl.Log, bl.Settings.Length) end
    local entry = {
        Time   = {Value = os.date("%X"), Color = Window.Colors.WHITE},
        Name   = bl.Util.Name(player_name),
        Damage = bl.Util.Damage(damage, action_type),
        Action = bl.Util.Action(action_name, action_type, action_data),
        Note   = bl.Util.Notes(note, action_type)
    }
    -- Gray out mob deaths for better visual parsing of the battle.
    if action_name == bl.Enum.Text.MOB_DEATH then
        bl.Util.Set_Row_Color(entry, Window.Colors.DIM)
    end
    table.insert(bl.Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Format the name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
bl.Util.Name = function(player_name)
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
bl.Util.Damage = function(damage, action_type)
    -- Change the color of the text if the damage is over a certain threshold.
    local threshold = bl.Enum.Thresholds.MAX
    if action_type == DB.Enum.Trackable.WS then
        threshold = Metrics.Blog.Thresholds.WS
    elseif action_type == DB.Enum.Trackable.MAGIC then
        threshold = Metrics.Blog.Thresholds.MAGIC
    elseif action_type == bl.Enum.Flags.IGNORE then
        return {Value = bl.Enum.Text.NA, Color = Window.Colors.WHITE}
    end
    -- Generate damage string.
    if not damage then
        return {Value = bl.Enum.Text.NA, Color = Window.Colors.DIM}
    elseif damage == 0 then
        return {Value = bl.Enum.Text.MISS, Color = Window.Colors.RED}
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
bl.Util.Action = function(action_name, action_type, action_data)
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
bl.Util.Notes = function(note, action_type)
    local color = Window.Colors.WHITE
    local final_note = {Value = " ", Color = color}

    -- A note should be passed in with these actions. Just use that.
    if action_type == DB.Enum.Trackable.MAGIC or action_type == DB.Enum.Trackable.HEALING or action_type == bl.Enum.Flags.IGNORE then
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

------------------------------------------------------------------------------------------------------
-- Sets the color of an entire battle log row.
------------------------------------------------------------------------------------------------------
---@param row_data table
---@return table
------------------------------------------------------------------------------------------------------
bl.Util.Set_Row_Color = function(row_data, color)
    if not row_data then return row_data end
    row_data.Time.Color   = color
    row_data.Name.Color   = color
    row_data.Damage.Color = color
    row_data.Action.Color = color
    row_data.Note.Color   = color
    return row_data
end

------------------------------------------------------------------------------------------------------
-- Build the header component of the battle log table.
------------------------------------------------------------------------------------------------------
bl.Display.Headers = function()
    local no_flags = Window.Columns.Flags.None
    if Metrics.Blog.Flags.Timestamp then UI.TableSetupColumn("Time", no_flags) end
    UI.TableSetupColumn("Name", no_flags)
    UI.TableSetupColumn("Damage", no_flags)
    UI.TableSetupColumn("Action", no_flags)
    UI.TableSetupColumn("Notes", no_flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Build a row of the battle log table.
------------------------------------------------------------------------------------------------------
bl.Display.Rows = function(entry)
    UI.TableNextRow()
    if Metrics.Blog.Flags.Timestamp then UI.TableNextColumn() UI.Text(entry.Time.Value) end
    UI.TableNextColumn() UI.TextColored(entry.Name.Color, entry.Name.Value)
    UI.TableNextColumn() UI.TextColored(entry.Damage.Color, entry.Damage.Value)
    UI.TableNextColumn() UI.TextColored(entry.Action.Color, entry.Action.Value)
    UI.TableNextColumn() UI.Text(tostring(entry.Note.Value))
end

return bl