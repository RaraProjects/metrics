Parse.Mini = T{}

Parse.Mini.Active = false
Parse.Mini.Column_Flags = Column.Flags.None
Parse.Mini.Table_Flags = bit.bor(ImGuiTableFlags_Borders)

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
Parse.Mini.Populate = function()
    local columns = 5
    if Metrics.Parse.Pet then columns = columns + 2 end
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

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populate table headers for mini mode.
------------------------------------------------------------------------------------------------------
Parse.Mini.Headers = function()
    local flags = Parse.Mini.Column_Flags

    UI.TableSetupColumn("Name", flags)
    if Metrics.Parse.DPS then UI.TableSetupColumn("DPS", flags) end
    UI.TableSetupColumn("%T", flags)
    UI.TableSetupColumn("Total", flags)
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
    if Metrics.Parse.DPS then UI.TableNextColumn() Column.Damage.DPS(player_name, true) end
    UI.TableNextColumn() Column.Damage.Total(player_name, true, true)
    UI.TableNextColumn() Column.Damage.Total(player_name, false, true)
    UI.TableNextColumn() Column.Acc.Running(player_name)
    if Metrics.Parse.Pet then
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET)
        UI.TableNextColumn() Column.Acc.By_Type(player_name, DB.Enum.Trackable.PET_MELEE_DISCRETE)
    end
end

------------------------------------------------------------------------------------------------------
-- Returns whether mini mode is enabled.
------------------------------------------------------------------------------------------------------
Parse.Mini.Is_Enabled = function()
    return Parse.Mini.Active
end

------------------------------------------------------------------------------------------------------
-- Toggles mini mode.
------------------------------------------------------------------------------------------------------
Parse.Mini.Toggle = function()
    Parse.Mini.Active = not Parse.Mini.Active
    if Parse.Mini.Active then Parse.Nano.Active = false end
end
