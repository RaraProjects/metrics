Parse = { }

-- Config has a dependency on this.
Parse.DisplayModes =
{
    FULL = 1,
    MINI = 2,
    NANO = 3,
}

require("modules.parse.help_text")
require("modules.parse.config")
require("modules.parse.columns")
require("modules.parse.widgets")

Parse.Name   = "Parse"
Parse.Title  = "Metrics - Parse"
Parse.Module = "Parse"
Parse.File   = "parse"

Parse.Columns =
{
    [Parse.DisplayModes.FULL] = 0,
    [Parse.DisplayModes.MINI] = 0,
    [Parse.DisplayModes.NANO] = 0,
}

-- How many columns should be visible. Keep this global to avoid recounting over and over again.
Parse.NanoColumns   = 0
Parse.TableFlags    = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)
Parse.IsInitialized = false
Parse.Confirmation  = false

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

    Parse.RefreshColumnCount()
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

    -- The full toolbar is only available in full mode.
    Parse.Toolbar()

    if Parse.Config.IsMiniMode() and Parse.Settings.Lurk_Mode then
        UI.Text(" Lurking...")
    end

    local columns = Parse.Columns[Parse.Settings.Display_Mode]

    if UI.BeginTable("Parse Full", columns, Parse.TableFlags) then
        Parse.Headers()
        Parse.DataRows(player)
        Parse.TotalRow()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the Parse toolbar if in full mode.
------------------------------------------------------------------------------------------------------
Parse.Toolbar = function()
    if Parse.Config.IsFullMode() then
        Parse.Widgets.SettingsButton()
        UI.SameLine() UI.Text(" ") UI.SameLine() Overview.OverviewButton()
        UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.FilterButton()
        UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.PercentDetails()
        UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.TimerButton()
        UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.ResetButton()
        if Parse.Confirmation         then UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.ResetConfirmationButton() end
        if Parse.Settings.Lurk_Mode   then UI.SameLine() UI.Text(" Lurking...") end
        if Parse.Settings.Show_Filter then DB.Widgets.DropdownMobFilter() end
        Parse.Widgets.Clock()
    end
end

------------------------------------------------------------------------------------------------------
-- Populate parse table headers.
------------------------------------------------------------------------------------------------------
Parse.Headers = function()
    for _, col in ipairs(Parse.ColumnContent) do
        if col.Condition() and (not Parse.Config.IsMiniMode() or col.Is_Mini) and (not Parse.Config.IsNanoMode() or col.Is_Nano) then
            UI.TableSetupColumn(col.Header(), Column.Flags.None)
        end
    end
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Populate parse data rows.
------------------------------------------------------------------------------------------------------
---@param player table
------------------------------------------------------------------------------------------------------
Parse.DataRows = function(player)
    local sortedDamage = DB.Lists.GetSortedDamage()

    for rank, data in ipairs(sortedDamage) do
        if rank <= Parse.Config.RankCutoff() or data[1] == player.name then
            -- Player specific content.
            local playerName = data[1]

            for _, col in ipairs(Parse.ColumnContent) do
                if col.Condition() and (not Parse.Config.IsMiniMode() or col.Is_Mini) and (not Parse.Config.IsNanoMode() or col.Is_Nano) then
                    UI.TableNextColumn() col.Content(playerName)
                end
            end

        end

        WindowManager.TableRowColor(rank)
    end
end

------------------------------------------------------------------------------------------------------
-- Populate parse total row.
------------------------------------------------------------------------------------------------------
Parse.TotalRow = function()
    if Parse.Settings.Grand_Totals and not Parse.Config.IsNanoMode() then
        UI.TableNextRow()   -- Need to do this to get the color to apply to the total and not the last data row.
        UI.TableNextRow()

        -- Make the row the same color as the header row.
        local r, g, b, a = UI.GetStyleColorVec4(ImGuiCol_TableHeaderBg)
        local rowBgColor = UI.GetColorU32({ r, g, b, a })

        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, rowBgColor)

        for _, col in ipairs(Parse.ColumnContent) do
            if col.Condition() and (not Parse.Config.IsMiniMode() or col.Is_Mini) and (not Parse.Config.IsNanoMode() or col.Is_Nano) then
                UI.TableNextColumn() col.Total()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Calculates how many columns should be shown on the Parse table based on column visibility flags.
------------------------------------------------------------------------------------------------------
Parse.RefreshColumnCount = function()
    local fullColumns = 0
    local miniColumns = 0
    local nanoColumns = 0

    -- Loop through available columns.
    for _, col in ipairs(Parse.ColumnContent) do
        if col.Condition() then
            fullColumns = fullColumns + 1
            if col.Is_Mini then miniColumns = miniColumns + 1 end
            if col.Is_Nano then nanoColumns = nanoColumns + 1 end
        end
    end

    -- Apply new column count.
    Parse.Columns[Parse.DisplayModes.FULL] = fullColumns
    Parse.Columns[Parse.DisplayModes.MINI] = miniColumns
    Parse.Columns[Parse.DisplayModes.NANO] = nanoColumns
end