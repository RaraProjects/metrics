Parse.Nano = T{}

Parse.Nano.Table_Flags = bit.bor(ImGuiTableFlags_Borders)

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
Parse.Nano.Populate = function()
    local flags = Column.Flags.None
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local player_name = player.name

    if UI.BeginTable("Team Nano", 4, Parse.Nano.Table_Flags) then
        if Metrics.Parse.DPS then UI.TableSetupColumn("DPS", flags) end
        UI.TableSetupColumn("%T", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags)
        UI.TableHeadersRow()

        UI.TableNextRow()
        if Metrics.Parse.DPS then UI.TableNextColumn() Column.Damage.DPS(player_name, true) end
        UI.TableNextColumn() Column.Damage.Total(player_name, true, true)
        UI.TableNextColumn() Column.Damage.Total(player_name, false, true)
        UI.TableNextColumn() Column.Acc.Running(player_name)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Returns whether nano mode is enabled.
------------------------------------------------------------------------------------------------------
Parse.Nano.Is_Enabled = function()
    return Metrics.Parse.Display_Mode == Parse.Enum.Display_Mode.NANO
end

------------------------------------------------------------------------------------------------------
-- Toggles nano mode.
------------------------------------------------------------------------------------------------------
Parse.Nano.Toggle = function()
    Metrics.Parse.Display_Mode = Parse.Enum.Display_Mode.NANO
end