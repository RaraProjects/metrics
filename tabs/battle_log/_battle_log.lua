Blog = T{}

Blog.Log = T{}          -- Primary Data Node
Blog.Display = T{}
Blog.Util = T{}

Blog.Enum = T{}
Blog.Enum.Text = T{
    MISS = "MISS!",
    NA   = "---",
    MB   = "BURST!",
    MOB_DEATH = "Defeated",
    PLAYER_DEATH = "Died",
}
Blog.Enum.Flags = T{
    IGNORE = "ignore",
}
Blog.Enum.Types = T{
    HEALING = "Healing",
    PET     = "Pet",
    DEATH   = "Death",
    MELEE   = "Melee",
    RANGED  = "Ranged",
    MAGIC   = "Magic",
    WS      = "WS",
    SC      = "SC",
    ABILITY = "Ability",
}

Blog.Page = 1
Blog.Filtered_Count = 0

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
    local table_size = {0, Metrics.Blog.Line_Height * (Metrics.Blog.Visible_Length + 1)}    -- One for header row.
    local columns = 4
    if Metrics.Blog.Flags.Timestamp then columns = columns + 1 end

    Blog.Widgets.Settings_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.First_Page()
    UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Last_Page()
    if Blog.Filtered_Count > 0 then UI.Text("Filtered Rows: " .. tostring(Blog.Filtered_Count)) end

    if UI.BeginTable("Blog", columns, Window.Table.Flags.Scrollable, table_size) then
        Blog.Display.Headers()
        local start = ((Blog.Page - 1) * Metrics.Blog.Visible_Length) + 1
        local stop = Blog.Page * Metrics.Blog.Visible_Length

        local count = 1
        Blog.Filtered_Count = 0
        for i = start, 100000, 1 do
            if count > stop then break end
            local entry = Blog.Log[i]
            if entry then
                if entry.Flag and Blog.Show_Row(entry.Flag.Value) then
                    count = count + 1
                    Blog.Display.Rows(entry)
                else
                    Blog.Filtered_Count = Blog.Filtered_Count + 1
                end
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Add an entry to battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that took the action.
---@param action_flag string the type of action being taken.
---@param action_name string name of the action the player took (like a weaponskill or ability).
---@param damage? number usually how much damage the action did.
---@param note? number|string how much TP was used by the weaponskill.
---@param action_type? string a trackable from the data model.
---@param action_data? table additional information about the action to help with text formatting.
------------------------------------------------------------------------------------------------------
Blog.Add = function(player_name, action_flag, action_name, damage, note, action_type, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #Blog.Log >= Blog.Settings.Max_Length then table.remove(Blog.Log, Blog.Settings.Length) end
    local entry = {
        Time   = {Value = os.date("%X"), Color = Res.Colors.Basic.WHITE},
        Flag   = {Value = action_flag, Color = Res.Colors.Basic.WHITE},
        Name   = Blog.Columns.Name(player_name),
        Damage = Blog.Columns.Damage(damage, action_type),
        Action = Blog.Columns.Action(action_name, action_type, action_data),
        Note   = Blog.Columns.Notes(note, action_type)
    }
    -- Gray out mob deaths for better visual parsing of the battle.
    if action_name == Blog.Enum.Text.MOB_DEATH then
        Blog.Util.Set_Row_Color(entry, Res.Colors.Basic.DIM)
    end
    table.insert(Blog.Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Checks battle log flags to see if the type of action should be shown in the battle log.
------------------------------------------------------------------------------------------------------
---@param action_flag string
------------------------------------------------------------------------------------------------------
Blog.Show_Row = function(action_flag)
    if     action_flag == Blog.Enum.Types.HEALING then return Metrics.Blog.Flags.Healing
    elseif action_flag == Blog.Enum.Types.PET     then return Metrics.Blog.Flags.Pet
    elseif action_flag == Blog.Enum.Types.DEATH   then return Metrics.Blog.Flags.Deaths
    elseif action_flag == Blog.Enum.Types.MELEE   then return Metrics.Blog.Flags.Melee
    elseif action_flag == Blog.Enum.Types.RANGED  then return Metrics.Blog.Flags.Ranged
    elseif action_flag == Blog.Enum.Types.MAGIC   then return Metrics.Blog.Flags.Magic
    elseif action_flag == Blog.Enum.Types.WS      then return Metrics.Blog.Flags.WS
    elseif action_flag == Blog.Enum.Types.SC      then return Metrics.Blog.Flags.SC
    elseif action_flag == Blog.Enum.Types.ABILITY then return Metrics.Blog.Flags.Ability
    else return false end
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
    local no_flags = Column.Flags.None
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

------------------------------------------------------------------------------------------------------
-- Returns the last page of the battle log.
------------------------------------------------------------------------------------------------------
Blog.Max_Page = function()
    local last_page = math.ceil(#Blog.Log / Metrics.Blog.Visible_Length)
    if last_page == 0 then last_page = 1 end
    return last_page
end

return Blog