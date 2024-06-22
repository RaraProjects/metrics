Parse.Mini = T{}

Parse.Mini.Column_Flags = Column.Flags.None
Parse.Mini.Table_Flags = bit.bor(ImGuiTableFlags_Borders)

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
Parse.Mini.Populate = function()
    local columns = 4
    if Metrics.Parse.Pet then columns = columns + 2 end
    if Metrics.Parse.DPS then columns = columns + 1 end
    if UI.BeginTable("Team Mini", columns, Parse.Mini.Table_Flags) then
        Parse.Mini.Headers()

        local player = Ashita.Player.My_Mob()
        if not player then return nil end

        local player_name = "Debug"
        DB.Lists.Sort.Total_Damage()
        for rank, data in ipairs(DB.Sorted.Total_Damage) do
            if rank <= Parse.Config.Rank_Cutoff() then
                player_name = data[1]
                Parse.Mini.Rows(player_name)
            elseif data[1] == player.name then
                Parse.Mini.Rows(player.name)
            end
        end
        if Metrics.Parse.Grand_Totals and #DB.Sorted.Total_Damage > 0 then Parse.Mini.Total_Row() end

        UI.EndTable()
    end

    Throttle.Block()
end

------------------------------------------------------------------------------------------------------
-- Populate table headers for mini mode.
------------------------------------------------------------------------------------------------------
Parse.Mini.Headers = function()
    local flags = Parse.Mini.Column_Flags

    UI.TableSetupColumn("Name", flags)
    UI.TableSetupColumn("Total", flags)
    UI.TableSetupColumn("%T", flags)
    if Metrics.Parse.DPS then UI.TableSetupColumn("DPS", flags) end
    UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags)
    if Metrics.Parse.Pet then
        UI.TableSetupColumn("Pet D.", flags)
        UI.TableSetupColumn("Pet A.", flags)
    end
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Populate table rows for mini mode.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Parse.Mini.Rows = function(player_name)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(player_name)
    UI.TableNextColumn() Column.Damage.Total(player_name, false, true)
    UI.TableNextColumn() Column.Damage.Total(player_name, true, true)
    if Metrics.Parse.DPS then UI.TableNextColumn() Column.Damage.DPS(player_name, true) end
    UI.TableNextColumn() Column.Acc.Running(player_name)
    if Metrics.Parse.Pet then
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
    end
end

------------------------------------------------------------------------------------------------------
-- Shows totals for each column.
------------------------------------------------------------------------------------------------------
Parse.Mini.Total_Row = function()
    UI.TableNextRow()
    local x, y, z, w = UI.GetStyleColorVec4(ImGuiCol_TableHeaderBg)
    local row_bg_color = UI.GetColorU32({x, y, z, w})
    UI.TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_bg_color)

    UI.TableNextColumn() UI.Text("Total")
    UI.TableNextColumn() Column.Damage.Parse_Total(true)
    UI.TableNextColumn() UI.Text(" ")
    if Metrics.Parse.DPS then UI.TableNextColumn() Column.Damage.Parse_DPS(true) end
    UI.TableNextColumn() UI.Text(" ")
    if Metrics.Parse.Pet then
        UI.TableNextColumn() UI.Text(" ")
        UI.TableNextColumn() Column.Damage.Trackable_Total(DB.Enum.Trackable.PET, true)
        UI.TableNextColumn() UI.Text(" ")
    end
end

------------------------------------------------------------------------------------------------------
-- Returns whether mini mode is enabled.
------------------------------------------------------------------------------------------------------
Parse.Mini.Is_Enabled = function()
    return Metrics.Parse.Display_Mode == Parse.Enum.Display_Mode.MINI
end

------------------------------------------------------------------------------------------------------
-- Toggles mini mode.
------------------------------------------------------------------------------------------------------
Parse.Mini.Toggle = function()
    Metrics.Parse.Display_Mode = Parse.Enum.Display_Mode.MINI
end
