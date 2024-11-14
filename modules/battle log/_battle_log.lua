Blog = T{}

Blog.Name   = "Battle Log"
Blog.Title  = "Metrics - Battle Log"
Blog.Module = "Blog"
Blog.Window = Window:New({
    Name   = Blog.Name,
    Title  = Blog.Title,
    Module = Blog.Module,
})

Blog.Log = T{}          -- Primary Data Node
Blog.Display = T{}
Blog.Util = T{}

Blog.Enum = T{}
Blog.Enum.Text = T{
    MISS         = "MISS!",
    NA           = "---",
    MB           = "BURST!",
    HIGH_DAMAGE  = "!!!",
    MOB_DEATH    = "Defeated",
    PLAYER_DEATH = "Died",
    NO_PET       = "NONE",
}
Blog.Enum.Flags = T{
    IGNORE = "ignore",
}
Blog.Enum.Types = T{
    HEALING   = "Healing",
    DEBUFF_REMOVAL = "Debuff Removal",
    PET       = "Pet",
    PET_MELEE = "Pet Melee",
    PET_TP    = "Pet Weaponskill",
    PET_HEAL  = "Pet Heal",
    MOB_MELEE = "Mob Melee",
    MOB_TP    = "Mob TP",
    MOB_SPELL = "Mob Spell",
    MOB_DEATH = "Mob Death",
    DEATH     = "Death",
    MELEE     = "Melee",
    RANGED    = "Ranged",
    MAGIC     = "Magic",
    BRD_BUFFS = "Bard Song Buffs",
    COR_ROLLS = "Phantom_Rolls",
    WS        = "WS",
    SC        = "SC",
    ABILITY   = "Ability",
    ENFEEBLE  = "Enfeeble",
    PET_COMMAND = "Pet Command",
}

Blog.Page = 1
Blog.Filtered_Count = 0

require("modules.battle log.config")
require("modules.battle log.columns")
require("modules.battle log.entries")
require("modules.battle log.widgets")

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
Blog.Content = function()
    local table_size = {0, Metrics.Blog.Line_Height * (Metrics.Blog.Visible_Length + 1)}    -- One for header row.
    local columns = 4
    if Metrics.Blog.Timestamp then columns = columns + 1 end

    Blog.Widgets.Settings_Button() UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Show_Page()
    if Metrics.Parse.Lurk_Mode then UI.SameLine() UI.Text(" Lurking...") end
    if Metrics.Blog.Paging then
        Blog.Widgets.Page_Buttons()
        if Blog.Filtered_Count > 0 then UI.Text("Filtered Rows: " .. tostring(Blog.Filtered_Count)) end
    end

    if UI.BeginTable("Blog", columns, Window_Manager.Table.Flags.Scrollable, table_size) then
        Blog.Display.Headers()
        local start = ((Blog.Page - 1) * Metrics.Blog.Visible_Length) + 1
        local stop = Blog.Page * Metrics.Blog.Visible_Length

        local count = 1
        Blog.Filtered_Count = 0
        for i = start, 100000, 1 do
            if count > Metrics.Blog.Visible_Length then break end
            local entry = Blog.Log[i]
            if entry then
                if entry.Flag and Blog.Action_Filter(entry.Flag.Value) and Blog.Player_Filter(entry) and Blog.Action_Name_Filter(entry) then
                    count = count + 1
                    Blog.Display.Rows(entry)
                else
                    Blog.Filtered_Count = Blog.Filtered_Count + 1
                end
            end
        end

        UI.EndTable()

        if Debug.Is_Enabled() then
            UI.Text("Start: " ..tostring(start)) UI.SameLine() UI.Text(" ") UI.SameLine()
            UI.Text("Stop: " ..tostring(stop)) UI.SameLine() UI.Text(" ") UI.SameLine()
            UI.Text("Showing: " ..tostring(count - 1))
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Add an entry to battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that took the action.
---@param pet_name? string name of the pet (if applicable)
---@param action_flag string the type of action being taken. This is specific to the blog and not the database.
---@param action_name string name of the action the player took (like a weaponskill or ability).
---@param damage? number usually how much damage the action did.
---@param note? number|string how much TP was used by the weaponskill.
---@param action_type? string a trackable from the data model.
---@param action_data? table additional information about the action to help with text formatting.
------------------------------------------------------------------------------------------------------
Blog.Add = function(player_name, pet_name, action_flag, action_name, damage, note, action_type, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #Blog.Log >= Blog.Settings.Max_Length then table.remove(Blog.Log, Blog.Settings.Length) end

    local color = Res.Colors.Basic.WHITE
    local is_mob = not Ashita.Party.Jobs[player_name]
    if Metrics.Parse.Lurk_Mode then is_mob = false end  -- Prevent everything from being dim in Lurk mode.
    if action_type and action_data then
        if action_type == DB.Enum.Trackable.MAGIC then
            local element = action_data.Element
            color = Res.Colors.Get_Element(element)
        end
    end
    if not pet_name then pet_name = "NONE" end

    local entry = {
        Time   = {Value = os.date("%X"), Color = Res.Colors.Basic.WHITE},
        Flag   = {Value = action_flag, Color = Res.Colors.Basic.WHITE},
        Player = Blog.Entries.Name(player_name, is_mob),
        Pet    = Blog.Entries.Pet_Name(pet_name),
        Damage = Blog.Entries.Damage(damage, action_type, color, is_mob),
        Action = Blog.Entries.Action(action_name, color, is_mob),
        Note   = Blog.Entries.Notes(note, action_type, is_mob)
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
---@return boolean
------------------------------------------------------------------------------------------------------
Blog.Action_Filter = function(action_flag)
    if     action_flag == Blog.Enum.Types.HEALING or action_flag == Blog.Enum.Types.DEBUFF_REMOVAL then return Metrics.Blog.Healing
    elseif action_flag == Blog.Enum.Types.PET_MELEE then return Metrics.Blog.Pet_Melee
    elseif action_flag == Blog.Enum.Types.PET_TP    then return Metrics.Blog.Pet_TP
    elseif action_flag == Blog.Enum.Types.PET_HEAL  then return Metrics.Blog.Pet_Heal
    elseif action_flag == Blog.Enum.Types.DEATH     then return Metrics.Blog.Deaths
    elseif action_flag == Blog.Enum.Types.MOB_MELEE then return Metrics.Blog.Mob_Melee
    elseif action_flag == Blog.Enum.Types.MOB_TP    then return Metrics.Blog.Mob_TP
    elseif action_flag == Blog.Enum.Types.MOB_SPELL then return Metrics.Blog.Mob_Spell
    elseif action_flag == Blog.Enum.Types.MOB_DEATH then return Metrics.Blog.Mob_Death
    elseif action_flag == Blog.Enum.Types.MELEE     then return Metrics.Blog.Melee
    elseif action_flag == Blog.Enum.Types.RANGED    then return Metrics.Blog.Ranged
    elseif action_flag == Blog.Enum.Types.MAGIC     then return Metrics.Blog.Magic
    elseif action_flag == Blog.Enum.Types.BRD_BUFFS then return Metrics.Blog.BRD_Buffs
    elseif action_flag == Blog.Enum.Types.COR_ROLLS then return Metrics.Blog.COR_Rolls
    elseif action_flag == Blog.Enum.Types.WS        then return Metrics.Blog.WS
    elseif action_flag == Blog.Enum.Types.SC        then return Metrics.Blog.SC
    elseif action_flag == Blog.Enum.Types.ABILITY   then return Metrics.Blog.Ability
    elseif action_flag == Blog.Enum.Types.PET_COMMAND then return Metrics.Blog.Pet_Command
    elseif action_flag == Blog.Enum.Types.ENFEEBLE  then return Metrics.Blog.Enfeeble
    else return false end
end

------------------------------------------------------------------------------------------------------
-- Check to see if the entry contains an action that passes the filter.
------------------------------------------------------------------------------------------------------
---@param entry table
---@return boolean
------------------------------------------------------------------------------------------------------
Blog.Action_Name_Filter = function(entry)
    if not entry or not entry.Action or not entry.Action.Value then return false end
    local action_string = Blog.Widgets.Action_Buffer[1]
    if not action_string then return true end
    return string.find(string.lower(entry.Action.Value), string.lower(action_string)) ~= nil
end

------------------------------------------------------------------------------------------------------
-- Check to see if entry contains a player that passes the filter.
------------------------------------------------------------------------------------------------------
---@param entry table
---@return boolean
------------------------------------------------------------------------------------------------------
Blog.Player_Filter = function(entry)
    if not entry then return false end
    if Blog.Widgets.Player_Focus == DB.Widgets.Dropdown.Enum.NONE then return true end
    return entry.Player.Value == Blog.Widgets.Player_Focus
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
    row_data.Player.Color = color
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
    if Metrics.Blog.Timestamp then UI.TableSetupColumn("Time", no_flags) end
    UI.TableSetupColumn("Name", no_flags, Column.Widths.Name)
    UI.TableSetupColumn("Damage", no_flags)
    UI.TableSetupColumn("Action", no_flags, Column.Widths.Name)
    UI.TableSetupColumn("Notes", no_flags, Column.Widths.Name)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Build a row of the battle log table.
------------------------------------------------------------------------------------------------------
Blog.Display.Rows = function(entry)
    local name   = Blog.Columns.Name(entry.Player.Value, entry.Pet.Value)
    local action = Blog.Columns.Action(entry.Action.Value)
    local note   = Blog.Columns.Notes(entry.Note.Value)

    local action_color = entry.Action.Color
    local note_color = entry.Note.Color

    local damage = entry.Damage.Value
    if damage == "-1" then damage = "---" end
    damage = Blog.Columns.Damage(damage)


    UI.TableNextRow()
    if Metrics.Blog.Timestamp then UI.TableNextColumn() UI.Text(entry.Time.Value) end
    UI.TableNextColumn() UI.TextColored(entry.Player.Color, name)
    UI.TableNextColumn() UI.TextColored(entry.Damage.Color, damage)
    UI.TableNextColumn() UI.TextColored(action_color, action)
    UI.TableNextColumn() UI.TextColored(note_color, tostring(note))
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