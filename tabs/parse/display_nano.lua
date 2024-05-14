Parse.Nano = T{}

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
Parse.Nano.Populate = function()
    local flags = Window.Columns.Flags.None
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local player_name = player.name

    if UI.BeginTable("Team Nano", 4, Window.Table.Flags.None) then
        UI.TableSetupColumn("DPS", flags)
        UI.TableSetupColumn("%T", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.DPS(player_name, true)
        UI.TableNextColumn() Col.Damage.Total(player_name, true, true)
        UI.TableNextColumn() Col.Damage.Total(player_name, false, true)
        UI.TableNextColumn() Col.Acc.Running(player_name)

        UI.EndTable()
    end
end