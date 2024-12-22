Blog = T{}

Blog.Name   = "Battle Log"
Blog.Title  = "Metrics - Battle Log"
Blog.Module = "Blog"
Blog.Window = Window:New({
    Name   = Blog.Name,
    Title  = Blog.Title,
    Module = Blog.Module,
})

Blog.Log = {}       -- Primary Data Node
Blog.Display = {}
Blog.Util = {}

Blog.Is_Initialized = false
Blog.Settings = T{}                     -- Keep the "T" on this.
Blog.Page = 1
Blog.Filtered_Count = 0

Blog.Tables = {
    Width_Name        = 150,
    Width_Settings    = 175,
    Column_Flags_None = ImGuiTableColumnFlags_None,
}

require("modules.battle log.enum")
require("modules.battle log.dependencies")
require("modules.battle log.config")
require("modules.battle log.columns")
require("modules.battle log.entries")
require("modules.battle log.widgets")

------------------------------------------------------------------------------------------------------
-- Resets the battle log.
-- Required dependencies:
-- * Ashita:         Used for accessing game data like party and job composition.
-- * Res:            Basic resources like jobs and colors.
-- * Window_Manager: Necessary for displaying screen elements.
-- * UI:             This should come with Window_Manager, but its the base ImGui tool.
-- * Column:         Provides some unique string formatting.
------------------------------------------------------------------------------------------------------
---@param settings_pointer? table you only need to set this once on initial addon load.
------------------------------------------------------------------------------------------------------
Blog.Initialize = function(settings_pointer)
    Blog.Log = {}
    -- Check for necessary settings and dependencies.
    if settings_pointer and Ashita and Res and Window_Manager and UI and Column then
        Blog.Settings = settings_pointer
        Blog.Is_Initialized = true
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the battle log data to the screen.
------------------------------------------------------------------------------------------------------
Blog.Content = function()
    if not Blog.Is_Initialized then return nil end

    -- Table dimensions.
    local table_size = {0, Blog.Settings.Line_Height * (Blog.Settings.Visible_Length + 1)}    -- One for header row.
    local columns = 4
    if Blog.Settings.Show_Timestamp then columns = columns + 1 end

    -- Things to display above the table.
    Blog.Widgets.Settings_Button() UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.Show_Page()
    if Blog.Settings.Is_Lurking_Enabled then UI.SameLine() UI.Text(" Lurking...") end
    if Blog.Settings.Is_Paging_Enabled then
        Blog.Widgets.Page_Buttons()
        if Blog.Filtered_Count > 0 then UI.Text("Filtered Rows: " .. tostring(Blog.Filtered_Count)) end
    end

    -- Primary content loop.
    if UI.BeginTable("Blog", columns, Window_Manager.Table.Flags.Scrollable, table_size) then
        Blog.Display.Headers()
        local start = ((Blog.Page - 1) * Blog.Settings.Visible_Length) + 1
        local stop = Blog.Page * Blog.Settings.Visible_Length

        local count = 1
        Blog.Filtered_Count = 0
        for i = start, 100000, 1 do
            local entry = Blog.Log[i]
            if (count > Blog.Settings.Visible_Length) or not entry then break end
            if entry.Flag and Blog.Action_Filter(entry.Flag.Value) and Blog.Player_Filter(entry) and Blog.Action_Name_Filter(entry) then
                count = count + 1
                Blog.Display.Rows(entry)
            else
                Blog.Filtered_Count = Blog.Filtered_Count + 1
            end
        end
        UI.EndTable()

        -- Need this in the table scope so that I have access to start/stop/count.
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
---@param action_type string the type of action being taken. This is specific to the blog and not the database.
---@param action_name string name of the action the player took (like a weaponskill or ability).
---@param damage? number usually how much damage the action did.
---@param note? number|string how much TP was used by the weaponskill.
---@param action_data? table additional information about the action to help with text formatting.
------------------------------------------------------------------------------------------------------
Blog.Add = function(player_name, pet_name, action_type, action_name, damage, note, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #Blog.Log >= Blog.Enum.MAX_BLOG_ENTRIES then table.remove(Blog.Log) end

    local white = Blog.Dependencies.White()
    local color = white
    local is_mob = not Blog.Dependencies.Check_Party(player_name)
    if Blog.Settings.Is_Lurking_Enabled then is_mob = false end  -- Prevent everything from being dim in Lurk mode.
    if action_data and action_type and action_type == Blog.Action_Type.MAGIC_OFFENSIVE then
        local element = action_data.Element
        color = Blog.Dependencies.Element_Color(element)
    end
    if not pet_name then pet_name = Blog.Enum.NO_PET end

    local entry = {
        Time   = {Value = os.date("%X"), Color = white},
        Flag   = {Value = action_type,   Color = white},
        Player = Blog.Entries.Name(player_name, is_mob),
        Pet    = Blog.Entries.Pet_Name(pet_name),
        Damage = Blog.Entries.Damage(damage, action_type, color),
        Action = Blog.Entries.Action(action_name, color),
        Note   = Blog.Entries.Notes(note, action_type)
    }
    -- Gray out mob deaths for better visual parsing of the battle.
    if action_name == Blog.Enum.MOB_DEATH then
        Blog.Util.Set_Row_Color(entry, Blog.Dependencies.Dim())
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
    if     action_flag == Blog.Action_Type.ABILITY         then return Blog.Settings.Show_Ability
    elseif action_flag == Blog.Action_Type.ALL_HEALING
    or action_flag == Blog.Action_Type.DEBUFF_REMOVAL      then return Blog.Settings.Show_Healing
    elseif action_flag == Blog.Action_Type.DISPEL          then return Blog.Settings.Show_Enfeebling
    elseif action_flag == Blog.Action_Type.MAGIC_OFFENSIVE then return Blog.Settings.Show_Spells
    elseif action_flag == Blog.Action_Type.MAGIC_ENFEEBLE  then return Blog.Settings.Show_Enfeebling
    elseif action_flag == Blog.Action_Type.MAGIC_MISC      then return Blog.Settings.Show_Misc_Spells
    elseif action_flag == Blog.Action_Type.MELEE           then return Blog.Settings.Show_Melee
    elseif action_flag == Blog.Action_Type.MOB_MELEE       then return Blog.Settings.Show_Mob_Melee
    elseif action_flag == Blog.Action_Type.MOB_RANGED      then return Blog.Settings.Show_Mob_Ranged
    elseif action_flag == Blog.Action_Type.MOB_DEATH       then return Blog.Settings.Show_Mob_Deaths
    elseif action_flag == Blog.Action_Type.MOB_TP          then return Blog.Settings.Show_Mob_TP
    elseif action_flag == Blog.Action_Type.MOB_SPELL       then return Blog.Settings.Show_Mob_Spells
    elseif action_flag == Blog.Action_Type.PET_COMMAND     then return Blog.Settings.Show_Pet_Command
    elseif action_flag == Blog.Action_Type.PET_MELEE       then return Blog.Settings.Show_Pet_Melee
    elseif action_flag == Blog.Action_Type.PET_TP          then return Blog.Settings.Show_Pet_TP
    elseif action_flag == Blog.Action_Type.PLAYER_DEATH    then return Blog.Settings.Show_Player_Deaths
    elseif action_flag == Blog.Action_Type.PHANTOM_ROLL    then return Blog.Settings.Show_Phantom_Roll
    elseif action_flag == Blog.Action_Type.RANGED          then return Blog.Settings.Show_Ranged
    elseif action_flag == Blog.Action_Type.SKILLCHAIN      then return Blog.Settings.Show_Skillchain
    elseif action_flag == Blog.Action_Type.SONG_BUFFS      then return Blog.Settings.Show_Song_Buffs
    elseif action_flag == Blog.Action_Type.WEAPONSKILL     then return Blog.Settings.Show_Weaponskill
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
    local no_flags = Blog.Tables.Column_Flags_None
    local width = Blog.Tables.Width_Name
    if Blog.Settings.Show_Timestamp then UI.TableSetupColumn("Time", no_flags) end
    UI.TableSetupColumn("Name",   no_flags, width)
    UI.TableSetupColumn("Damage", no_flags)
    UI.TableSetupColumn("Action", no_flags, width)
    UI.TableSetupColumn("Notes",  no_flags, width)
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
    if (entry.Flag.Value == Blog.Action_Type.MOB_TP or entry.Flag.Value == Blog.Action_Type.MOB_SPELL) and action ~= "Ranged Attack" then
        local r = 0.46
        local g = 0.07
        local b = 0.00
        local a = 1.00
        local row_bg_color = UI.GetColorU32({r, g, b, a})
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)
    elseif entry.Flag.Value == Blog.Action_Type.MOB_MELEE then
        local r = 0.46
        local g = 0.07
        local b = 0.00
        local a = 0.25
        local row_bg_color = UI.GetColorU32({r, g, b, a})
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)
    elseif entry.Flag.Value == Blog.Action_Type.DISPEL and (note and (note ~= Blog.Enum.NO_EFFECT and note ~= Blog.Enum.RESIST)) then
        local r = 1.00
        local g = 1.00
        local b = 1.00
        local a = 0.10
        local row_bg_color = UI.GetColorU32({r, g, b, a})
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)
    end

    if Blog.Settings.Show_Timestamp then UI.TableNextColumn() UI.Text(entry.Time.Value) end
    UI.TableNextColumn() UI.TextColored(entry.Player.Color, name)
    UI.TableNextColumn() UI.TextColored(entry.Damage.Color, damage)
    UI.TableNextColumn() UI.TextColored(action_color, action)
    UI.TableNextColumn() UI.TextColored(note_color, tostring(note))
end

------------------------------------------------------------------------------------------------------
-- Returns the last page of the battle log.
------------------------------------------------------------------------------------------------------
Blog.Max_Page = function()
    local last_page = math.ceil(#Blog.Log / Blog.Settings.Visible_Length)
    if last_page == 0 then last_page = 1 end
    return last_page
end

return Blog