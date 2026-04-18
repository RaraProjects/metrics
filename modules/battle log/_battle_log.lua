Blog = { }

require("modules.battle log.enum")
require("modules.battle log.dependencies")
require("modules.battle log.config")
require("modules.battle log.columns")
require("modules.battle log.entries")
require("modules.battle log.widgets")

Blog.Name   = "Battle Log"
Blog.Title  = "Metrics - Battle Log"
Blog.Module = "Blog"
Blog.File   = "blog"

Blog.Log     = { }       -- Primary Data Node
Blog.Display = { }
Blog.Util    = { }

Blog.IsInitialized = false
Blog.FilteredCount = 0
Blog.Page          = 1

Blog.Tables =
{
    WidthName       = 150,
    WidthSettings   = 175,
    ColumnFlagsNone = ImGuiTableColumnFlags_None,
}

------------------------------------------------------------------------------------------------------
-- Resets the battle log.
-- Required dependencies:
-- * Ashita:         Used for accessing game data like party and job composition.
-- * Res:            Basic resources like jobs and colors.
-- * Window_Manager: Necessary for displaying screen elements.
-- * UI:             This should come with Window_Manager, but its the base ImGui tool.
-- * Column:         Provides some unique string formatting.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Blog.Initialize = function(settings)
    if not (Ashita and Res and WindowManager and UI and Column) then
        return nil
    end

    -- Get saved settings from file.
    Blog.Settings = settings or SettingsFile.load(Blog.Config.Defaults, Blog.File)

    -- Create the Blog Window.
    Blog.Window = Window:New
    ({
        Name     = Blog.Name,
        Title    = Blog.Title,
        Module   = Blog.Module,
        Settings = Blog.Settings,
    })

    Blog.Log = { }
    Blog.IsInitialized = true
end

------------------------------------------------------------------------------------------------------
-- Loads the battle log data to the screen.
------------------------------------------------------------------------------------------------------
Blog.Content = function()
    if not Blog.IsInitialized then
        return nil
    end

    local perfStart = Socket.gettime()

    -- Table dimensions.
    local visibleLength = Blog.Settings.Visible_Length
    local tableSize     = { 0, Blog.Settings.Line_Height * (visibleLength + 1) }    -- One for header row.
    local columns       = 4
    columns = Blog.Settings.Show_Timestamp and (columns + 1) or columns

    -- Things to display above the table.
    Blog.Widgets.SettingsButton() UI.SameLine() UI.Text(" ") UI.SameLine() Blog.Widgets.ShowPage()
    if Blog.Settings.Is_Lurking_Enabled then
        UI.SameLine() UI.Text(" Lurking...")
    end

    if Blog.Settings.Is_Paging_Enabled then
        Blog.Widgets.PageButtons()
        if Blog.FilteredCount > 0 then
            UI.Text("Filtered Rows: " .. tostring(Blog.FilteredCount))
        end
    end

    -- Primary content loop.
    if UI.BeginTable("Blog", columns, WindowManager.Table.Flags.Scrollable, tableSize) then
        Blog.Display.Headers()

        local start = ((Blog.Page - 1) * visibleLength) + 1
        local stop  = Blog.Page * visibleLength
        local count = 0
        Blog.FilteredCount = 0

        for i = start, #Blog.Log, 1 do
            local entry = Blog.Log[i]

            if (count > visibleLength) or not entry then
                break
            end

            if entry.Flag and Blog.ShowAction(entry.Flag.Value) and Blog.PlayerFilter(entry) and Blog.ActionNameFilter(entry) then
                count = count + 1
                Blog.Display.Rows(entry)
            else
                Blog.FilteredCount = Blog.FilteredCount + 1
            end
        end

        UI.EndTable()

        -- Need this in the table scope so that I have access to start/stop/count.
        if Debug.IsEnabled() then
            UI.Text(string.format("Start: %d", start)) UI.SameLine() UI.Text(" ") UI.SameLine()
            UI.Text(string.format("Stop: %d", stop)) UI.SameLine() UI.Text(" ") UI.SameLine()
            UI.Text(string.format("Showing: %d", count))
        end
    end

    Perf.Capture(Perf.Enums.UI_BATTLE_LOG, perfStart)
end

------------------------------------------------------------------------------------------------------
-- Add an entry to battle log.
------------------------------------------------------------------------------------------------------
---@param playerName  string        name of the player that took the action.
---@param petName?    string        name of the pet (if applicable)
---@param actionType  string        the type of action being taken. This is specific to the blog and not the database.
---@param actionName  string        name of the action the player took (like a weaponskill or ability).
---@param damage?     number        usually how much damage the action did.
---@param note?       number|string how much TP was used by the weaponskill.
---@param actionData? table         additional information about the action to help with text formatting.
------------------------------------------------------------------------------------------------------
Blog.Add = function(playerName, petName, actionType, actionName, damage, note, actionData)
    -- If the blog is at max length then we will need to remove the last element
    if #Blog.Log >= Blog.Enum.MAX_BLOG_ENTRIES then
        table.remove(Blog.Log)
    end

    local isMob = not Blog.Dependencies.CheckParty(playerName)
    local white = Blog.Dependencies.White()
    local color = white
    petName     = petName or Blog.Enum.NO_PET

    -- Prevent everything from being dim in Lurk mode.
    if Blog.Settings.Is_Lurking_Enabled then
        isMob = false
    end

    -- Add elemental colors to elemental spells.
    if actionData and actionType and actionType == Blog.ActionType.MAGIC_OFFENSIVE then
        color = Blog.Dependencies.ElementColor(actionData.Element)
    end

    local entry =
    {
        Time   = { Value = os.date("%X"), Color = white },
        Flag   = { Value = actionType,   Color = white  },
        Player = Blog.Entries.Name(playerName, isMob),
        Pet    = Blog.Entries.PetName(petName),
        Damage = Blog.Entries.Damage(damage, actionType, color),
        Action = Blog.Entries.Action(actionName, color),
        Note   = Blog.Entries.Notes(note, actionType)
    }

    -- Gray out mob deaths for better visual parsing of the battle.
    if actionName == Blog.Enum.MOB_DEATH or actionName == Blog.ActionType.ZONE then
        Blog.Util.SetRowColor(entry, Blog.Dependencies.Dim())
    end

    table.insert(Blog.Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Checks battle log flags to see if the type of action should be shown in the battle log.
------------------------------------------------------------------------------------------------------
---@param actionFlag string
---@return boolean
------------------------------------------------------------------------------------------------------
Blog.ShowAction = function(actionFlag)
    local actionMap =
    {
        [ Blog.ActionType.ABILITY         ] = Blog.Settings.Show_Ability,
        [ Blog.ActionType.ALL_HEALING     ] = Blog.Settings.Show_Healing,
        [ Blog.ActionType.DEBUFF_REMOVAL  ] = Blog.Settings.Show_Healing,
        [ Blog.ActionType.DISPEL          ] = Blog.Settings.Show_Enfeebling,
        [ Blog.ActionType.MAGIC_OFFENSIVE ] = Blog.Settings.Show_Spells,
        [ Blog.ActionType.MAGIC_ENFEEBLE  ] = Blog.Settings.Show_Enfeebling,
        [ Blog.ActionType.MAGIC_MISC      ] = Blog.Settings.Show_Misc_Spells,
        [ Blog.ActionType.MELEE           ] = Blog.Settings.Show_Melee,
        [ Blog.ActionType.MOB_MELEE       ] = Blog.Settings.Show_Mob_Melee,
        [ Blog.ActionType.MOB_RANGED      ] = Blog.Settings.Show_Mob_Ranged,
        [ Blog.ActionType.MOB_DEATH       ] = Blog.Settings.Show_Mob_Deaths,
        [ Blog.ActionType.MOB_TP          ] = Blog.Settings.Show_Mob_TP,
        [ Blog.ActionType.MOB_SPELL       ] = Blog.Settings.Show_Mob_Spells,
        [ Blog.ActionType.PET_COMMAND     ] = Blog.Settings.Show_Pet_Command,
        [ Blog.ActionType.PET_MELEE       ] = Blog.Settings.Show_Pet_Melee,
        [ Blog.ActionType.PET_TP          ] = Blog.Settings.Show_Pet_TP,
        [ Blog.ActionType.PLAYER_DEATH    ] = Blog.Settings.Show_Player_Deaths,
        [ Blog.ActionType.PHANTOM_ROLL    ] = Blog.Settings.Show_Phantom_Roll,
        [ Blog.ActionType.RANGED          ] = Blog.Settings.Show_Ranged,
        [ Blog.ActionType.SKILLCHAIN      ] = Blog.Settings.Show_Skillchain,
        [ Blog.ActionType.SONG_BUFFS      ] = Blog.Settings.Show_Song_Buffs,
        [ Blog.ActionType.XP              ] = Blog.Settings.Show_XP,
        [ Blog.ActionType.WEAPONSKILL     ] = Blog.Settings.Show_Weaponskill,
        [ Blog.ActionType.ZONE            ] = Blog.Settings.Show_Zone,
    }

    return actionMap[actionFlag] or false
end

------------------------------------------------------------------------------------------------------
-- Check to see if the entry contains an action that passes the filter.
------------------------------------------------------------------------------------------------------
---@param entry table
---@return boolean
------------------------------------------------------------------------------------------------------
Blog.ActionNameFilter = function(entry)
    if not entry or not entry.Action or type(entry.Action.Value) ~= "string" then
        return false
    end

    -- The search term the player typed in.
    local searchKey = Blog.Widgets.ActionBuffer[1]

    if not searchKey or searchKey == "" then
        return true
    end

    return string.match(entry.Action.Value:lower(), searchKey:lower()) ~= nil
end

------------------------------------------------------------------------------------------------------
-- Check to see if entry contains a player that passes the filter.
------------------------------------------------------------------------------------------------------
---@param entry table
---@return boolean
------------------------------------------------------------------------------------------------------
Blog.PlayerFilter = function(entry)
    if not entry then
        return false
    end

    -- Always pass if a specific player isn't chosen.
    if Blog.Widgets.PlayerFocus == DB.Enum.NONE then
        return true
    end

    return entry.Player.Value == Blog.Widgets.PlayerFocus
end

------------------------------------------------------------------------------------------------------
-- Sets the color of an entire battle log row.
------------------------------------------------------------------------------------------------------
---@param rowData table
---@return table
------------------------------------------------------------------------------------------------------
Blog.Util.SetRowColor = function(rowData, color)
    if not rowData then
        return rowData
    end

    local colorFields =
    {
        "Time",
        "Player",
        "Damage",
        "Action",
        "Note",
    }

    for _, field in ipairs(colorFields) do
        if rowData[field] then
            rowData[field].Color = color
        end
    end

    return rowData
end

------------------------------------------------------------------------------------------------------
-- Build the header component of the battle log table.
------------------------------------------------------------------------------------------------------
Blog.Display.Headers = function()
    local noFlags = Blog.Tables.ColumnFlagsNone
    local width   = Blog.Tables.WidthName

    if Blog.Settings.Show_Timestamp then
        UI.TableSetupColumn("Time", noFlags)
    end

    UI.TableSetupColumn("Name",   noFlags, width)
    UI.TableSetupColumn("Damage", noFlags)
    UI.TableSetupColumn("Action", noFlags, width)
    UI.TableSetupColumn("Notes",  noFlags, width)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Build a row of the battle log table.
------------------------------------------------------------------------------------------------------
---@param entry table
------------------------------------------------------------------------------------------------------
Blog.Display.Rows = function(entry)
    local name   = Blog.Columns.Name(entry.Player.Value, entry.Pet.Value)
    local action = Blog.Columns.Action(entry.Action.Value)
    local note   = Blog.Columns.Notes(entry.Note.Value)

    local actionColor = entry.Action.Color
    local noteColor   = entry.Note.Color
    local damage      = entry.Damage.Value == "-1" and "---" or entry.Damage.Value

    damage = Blog.Columns.Damage(damage)

    -- Colors are RGB
    UI.TableNextRow()
    if (entry.Flag.Value == Blog.ActionType.MOB_TP or entry.Flag.Value == Blog.ActionType.MOB_SPELL) and action ~= "Ranged Attack" then
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, UI.GetColorU32({ 0.46, 0.07, 0.00, 1.00 }))

    elseif entry.Flag.Value == Blog.ActionType.MOB_MELEE then
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, UI.GetColorU32({ 0.46, 0.07, 0.00, 0.25}))

    elseif entry.Flag.Value == Blog.ActionType.DISPEL and (note and (note ~= Blog.Enum.NO_EFFECT and note ~= Blog.Enum.RESIST)) then
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, UI.GetColorU32({1.00, 1.00, 1.00, 0.10}))
    end

    if Blog.Settings.Show_Timestamp then
        UI.TableNextColumn() UI.Text(entry.Time.Value)
    end

    UI.TableNextColumn() UI.TextColored(entry.Player.Color, name)
    UI.TableNextColumn() UI.TextColored(entry.Damage.Color, damage)
    UI.TableNextColumn() UI.TextColored(actionColor, action)
    UI.TableNextColumn() UI.TextColored(noteColor, tostring(note))
end

------------------------------------------------------------------------------------------------------
-- Returns the last page of the battle log.
------------------------------------------------------------------------------------------------------
---@return integer
------------------------------------------------------------------------------------------------------
Blog.MaxPage = function()
    return math.max(1, math.ceil(#Blog.Log / Blog.Settings.Visible_Length))
end

return Blog