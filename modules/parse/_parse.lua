Parse = {}

-- Config has a dependency on this.
Parse.Display_Modes = {
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

Parse.Columns = {
    [Parse.Display_Modes.FULL] = 0,
    [Parse.Display_Modes.MINI] = 0,
    [Parse.Display_Modes.NANO] = 0,
}

-- How many columns should be visible. Keep this global to avoid recounting over and over again.
Parse.Nano_Columns = 0

Parse.Table_Flags = bit.bor(ImGuiTableFlags_PadOuterX, ImGuiTableFlags_Borders)

Parse.Is_Initialized = false
Parse.Confirmation   = false

------------------------------------------------------------------------------------------------------
-- Initializes the Parse screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Parse.Initialize = function(settings)
    -- Get saved settings from file.
    Parse.Settings = settings or Settings_File.load(Parse.Config.Defaults, Parse.File)

    -- Create the Parse Window.
    Parse.Window = Window:New({
        Name     = Parse.Name,
        Title    = Parse.Title,
        Module   = Parse.Module,
        Settings = Parse.Settings,
    })

    Parse.Refresh_Column_Count()
    Parse.Is_Initialized = true
end

------------------------------------------------------------------------------------------------------
-- Parse window content.
------------------------------------------------------------------------------------------------------
Parse.Content = function()
    if not Parse.Is_Initialized then return nil end

    local player = Ashita.Player.MyMob()
    if not player then return nil end

    -- The full toolbar is only available in full mode.
    Parse.Toolbar()
    if Parse.Config.IsMiniMode() and Parse.Settings.Lurk_Mode then UI.Text(" Lurking...") end

    local columns = Parse.Columns[Parse.Settings.Display_Mode]

    if UI.BeginTable("Parse Full", columns, Parse.Table_Flags) then
        Parse.Headers()
        Parse.Data_Rows(player)
        Parse.Total_Row()

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the Parse toolbar if in full mode.
------------------------------------------------------------------------------------------------------
Parse.Toolbar = function()
    if Parse.Config.Is_Full_Mode() then
        Parse.Widgets.Settings_Button()
        UI.SameLine() UI.Text(" ") UI.SameLine() Overview.Overview_Button()
        UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Filter_Button()
        UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.PercentDetails()
        UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Timer_Button()
        UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Reset_Button()
        if Parse.Confirmation then UI.SameLine() UI.Text(" ") UI.SameLine() Parse.Widgets.Reset_Confirmation_Button() end
        if Parse.Settings.Lurk_Mode then UI.SameLine() UI.Text(" Lurking...") end
        if Parse.Settings.Show_Filter then DB.Widgets.DropdownMobFilter() end
        Parse.Widgets.Clock()
    end
end

------------------------------------------------------------------------------------------------------
-- Populate parse table headers.
------------------------------------------------------------------------------------------------------
Parse.Headers = function()
    for _, col in ipairs(Parse.Column_Content) do
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
Parse.Data_Rows = function(player)
    local sorted_damage = DB.Lists.GetSortedDamage()

    for rank, data in ipairs(sorted_damage) do
        if rank <= Parse.Config.RankCutoff() or data[1] == player.name then

            -- Player specific content.
            local player_name = data[1]
            for _, col in ipairs(Parse.Column_Content) do
                if col.Condition() and (not Parse.Config.IsMiniMode() or col.Is_Mini) and (not Parse.Config.IsNanoMode() or col.Is_Nano) then
                    UI.TableNextColumn() col.Content(player_name)
                end
            end

        end
        WindowManager.TableRowColor(rank)
    end
end

------------------------------------------------------------------------------------------------------
-- Populate parse total row.
------------------------------------------------------------------------------------------------------
Parse.Total_Row = function()
    if Parse.Settings.Grand_Totals and not Parse.Config.IsNanoMode() then
        UI.TableNextRow()   -- Need to do this to get the color to apply to the total and not the last data row.
        UI.TableNextRow()

        -- Make the row the same color as the header row.
        local r, g, b, a = UI.GetStyleColorVec4(ImGuiCol_TableHeaderBg)
        local row_bg_color = UI.GetColorU32({r, g, b, a})
        UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)

        for _, col in ipairs(Parse.Column_Content) do
            if col.Condition() and (not Parse.Config.IsMiniMode() or col.Is_Mini) and (not Parse.Config.IsNanoMode() or col.Is_Nano) then
                UI.TableNextColumn() col.Total()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Calculates how many columns should be shown on the Parse table based on column visibility flags.
------------------------------------------------------------------------------------------------------
Parse.Refresh_Column_Count = function()
    local full_columns = 0
    local mini_columns = 0
    local nano_columns = 0

    -- Loop through available columns.
    for _, col in ipairs(Parse.Column_Content) do
        if col.Condition() then
            full_columns = full_columns + 1
            if col.Is_Mini then mini_columns = mini_columns + 1 end
            if col.Is_Nano then nano_columns = nano_columns + 1 end
        end
    end

    -- Apply new column count.
    Parse.Columns[Parse.Display_Modes.FULL] = full_columns
    Parse.Columns[Parse.Display_Modes.MINI] = mini_columns
    Parse.Columns[Parse.Display_Modes.NANO] = nano_columns
end