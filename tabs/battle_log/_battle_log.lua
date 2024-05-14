Blog = T{}

Blog.Log = {}       -- Primary Data Node
Blog.Display = {}
Blog.Util = {}

Blog.Enum = {}
Blog.Enum.Text = {
    MISS = "MISS!",
    NA   = "---",
    MB   = "BURST!",
    MOB_DEATH = "Defeated",
    PLAYER_DEATH = "Died",
}
Blog.Enum.Flags = {
    IGNORE = "ignore",
}

require("tabs.battle_log.config")
require("tabs.battle_log.columns")
require("tabs.battle_log.widgets")

-- FUTURE CONSIDERATIONS
-- Highlight damage if the damage is higher than the average for that weaponskill.

------------------------------------------------------------------------------------------------------
-- Resets the battle log.
------------------------------------------------------------------------------------------------------
Blog.Reset_Log = function()
    Blog.Log = {}
end

------------------------------------------------------------------------------------------------------
-- Loads the battle log data to the screen.
------------------------------------------------------------------------------------------------------
Blog.Populate = function()
    local table_size = {0, Blog.Settings.Size * Metrics.Blog.Visible_Length}
    local columns = 4
    if Metrics.Blog.Flags.Timestamp then columns = columns + 1 end

    -- Resize Options
    if UI.SmallButton("Set Display Length") then
        Metrics.Blog.Flags.Show_Length = not Metrics.Blog.Flags.Show_Length
    end
    if Metrics.Blog.Flags.Show_Length then
        UI.Separator()
        if UI.Button("Default") then
            Metrics.Blog.Visible_Length = Blog.Settings.Visible_Length
        end
        UI.SameLine() UI.Text(" ") UI.SameLine()
        local length = {[1] = Metrics.Blog.Visible_Length}
        UI.SetNextItemWidth(50)
        if UI.DragInt("Length", length, 0.1, Blog.Settings.Visible_Length, 50, "%d", ImGuiSliderFlags_None) then
            Metrics.Blog.Visible_Length = length[1]
        end
    end

    -- Content
    if UI.BeginTable("Blog", columns, Window.Table.Flags.Scrollable, table_size) then
        Blog.Display.Headers()
        for _, entry in ipairs(Blog.Log) do
            Blog.Display.Rows(entry)
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
Blog.Add = function(player_name, action_name, damage, note, action_type, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #Blog.Log >= Blog.Settings.Length then table.remove(Blog.Log, Blog.Settings.Length) end
    local entry = {
        Time   = {Value = os.date("%X"), Color = Window.Colors.WHITE},
        Name   = Blog.Columns.Name(player_name),
        Damage = Blog.Columns.Damage(damage, action_type),
        Action = Blog.Columns.Action(action_name, action_type, action_data),
        Note   = Blog.Columns.Notes(note, action_type)
    }
    -- Gray out mob deaths for better visual parsing of the battle.
    if action_name == Blog.Enum.Text.MOB_DEATH then
        Blog.Util.Set_Row_Color(entry, Window.Colors.DIM)
    end
    table.insert(Blog.Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Sets the color of an entire battle log row.
------------------------------------------------------------------------------------------------------
---@param row_data table
---@return table
------------------------------------------------------------------------------------------------------
Blog.Util.Set_Row_Color = function(row_data, color)
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
Blog.Display.Headers = function()
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
Blog.Display.Rows = function(entry)
    UI.TableNextRow()
    if Metrics.Blog.Flags.Timestamp then UI.TableNextColumn() UI.Text(entry.Time.Value) end
    UI.TableNextColumn() UI.TextColored(entry.Name.Color, entry.Name.Value)
    UI.TableNextColumn() UI.TextColored(entry.Damage.Color, entry.Damage.Value)
    UI.TableNextColumn() UI.TextColored(entry.Action.Color, entry.Action.Value)
    UI.TableNextColumn() UI.Text(tostring(entry.Note.Value))
end

return Blog