-- Performance review: 01/17/26

Parse = { }

-- Config has a dependency on this.
Parse.DisplayModes =
{
    FULL = 1,
    MINI = 2,
    NANO = 3,
}

require('modules.parse.help_text')
require('modules.parse.config')
require('modules.parse.columns')
require('modules.parse.widgets')

Parse.Name   = 'Parse'
Parse.Title  = 'Metrics - Parse'
Parse.Module = 'Parse'
Parse.File   = 'parse'

Parse.VisibleColumnsByMode =
{
    [Parse.DisplayModes.FULL] = { },
    [Parse.DisplayModes.MINI] = { },
    [Parse.DisplayModes.NANO] = { },
}

Parse.IsInitialized = false
Parse.Confirmation  = false

------------------------------------------------------------------------------------------------------
-- Shows the Parse toolbar if in full mode.
------------------------------------------------------------------------------------------------------
local toolbar = function()
    local settings = Parse.Settings
    local widgets  = Parse.Widgets

    if Parse.Config.IsFullMode() then
        widgets.SettingsButton()

        UI.SameLine() UI.Text(' ') UI.SameLine() Overview.OverviewButton()
        UI.SameLine() UI.Text(' ') UI.SameLine() widgets.FilterButton()
        UI.SameLine() UI.Text(' ') UI.SameLine() Focus.Config.PercentDetails()
        UI.SameLine() UI.Text(' ') UI.SameLine() widgets.TimerButton()
        UI.SameLine() UI.Text(' ') UI.SameLine() widgets.ResetButton()
        if Parse.Confirmation   then UI.SameLine() UI.Text(' ') UI.SameLine() widgets.ResetConfirmationButton() end
        if settings.Lurk_Mode   then UI.SameLine() UI.Text(' Lurking...') end

        if settings.Show_Filter then DB.Widgets.DropdownMobFilter() end
        widgets.Clock()
    end
end

------------------------------------------------------------------------------------------------------
-- Populate parse table headers.
------------------------------------------------------------------------------------------------------
---@param columnList table
------------------------------------------------------------------------------------------------------
local headers = function(columnList)
    for _, col in ipairs(columnList) do
        UI.TableSetupColumn(col.Header(), Column.Flags.None)
    end
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Populate parse data rows.
------------------------------------------------------------------------------------------------------
---@param columnList table
---@param player     table
------------------------------------------------------------------------------------------------------
local dataRows = function(columnList, player)
    local sortedDamage = DB.Lists.GetSortedDataDamage()

    for rank, data in ipairs(sortedDamage) do
        if rank <= Parse.Config.RankCutoff() or data[1] == player.name then
            local playerName = data[1]

            for _, col in ipairs(columnList) do
                UI.TableNextColumn() col.Content(playerName)
            end
        end

        WindowManager.TableRowColor(rank)
    end
end

------------------------------------------------------------------------------------------------------
-- Populate parse total row.
------------------------------------------------------------------------------------------------------
---@param columnList table
------------------------------------------------------------------------------------------------------
local totalRow = function(columnList)
    if Parse.Settings.Grand_Totals and not Parse.Config.IsNanoMode() then
        UI.TableNextRow()   -- Need to do this to get the color to apply to the total and not the last data row.
        UI.TableNextRow()

        -- Make the row the same color as the header row.
        local r, g, b, a = UI.GetStyleColorVec4(ImGuiCol_TableHeaderBg)
        local rowBgColor = UI.GetColorU32({ r, g, b, a })

        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, rowBgColor)

        for _, col in ipairs(columnList) do
            UI.TableNextColumn() col.Total()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Initializes the Parse screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Parse.Initialize = function(settings)
    -- Get saved settings from file.
    Parse.Settings = settings or SettingsFile.load(Parse.Config.Defaults, Parse.File)

    -- Create the Parse Window.
    Parse.Window = Window:New
    ({
        Name     = Parse.Name,
        Title    = Parse.Title,
        Module   = Parse.Module,
        Settings = Parse.Settings,
    })

    Parse.RefreshColumnList()
    Parse.IsInitialized = true
end

------------------------------------------------------------------------------------------------------
-- Parse window content.
------------------------------------------------------------------------------------------------------
Parse.Content = function()
    if not Parse.IsInitialized then
        return nil
    end

    local player = Ashita.Player.MyMob()

    if not player then
        return nil
    end

    local perfStart = Socket.gettime()
    local settings  = Parse.Settings

    -- Toolbar is only available in full mode.
    toolbar()

    if Parse.Config.IsMiniMode() and settings.Lurk_Mode then
        UI.Text(' Lurking...')
    end

    local columnList = Parse.VisibleColumnsByMode[settings.Display_Mode]
    local tableFlags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)

    if UI.BeginTable('Parse Full', #columnList, tableFlags) then
        headers(columnList)
        dataRows(columnList, player)
        totalRow(columnList)

        UI.EndTable()
    end

    Perf.Capture(Perf.Enums.UI_PARSE, perfStart)
end

------------------------------------------------------------------------------------------------------
-- Calculates how many columns should be shown on the Parse table based on column visibility flags.
------------------------------------------------------------------------------------------------------
Parse.RefreshColumnList = function()
    local fullList    = { }
    local miniList    = { }
    local nanoList    = { }

    -- Loop through available columns.
    for _, col in ipairs(Parse.ColumnContent) do
        if col.Condition() then
            fullList[#fullList + 1] = col
            if col.Is_Mini then miniList[#miniList + 1] = col end
            if col.Is_Nano then nanoList[#nanoList + 1] = col end
        end
    end

    -- Apply new column list.
    Parse.VisibleColumnsByMode[Parse.DisplayModes.FULL] = fullList
    Parse.VisibleColumnsByMode[Parse.DisplayModes.MINI] = miniList
    Parse.VisibleColumnsByMode[Parse.DisplayModes.NANO] = nanoList
end
