Debug.DPS = { }

------------------------------------------------------------------------------------------------------
-- Populates the DPS data.
------------------------------------------------------------------------------------------------------
Debug.DPS.Populate = function()
    if UI.BeginTable("DPS Debug", 8, WindowManager.Table.Flags.Borders) then
        Debug.DPS.Headers()

        for playerName, dps in pairs(DB.DPS.DPS) do
            UI.TableNextColumn() UI.Text(playerName)
            UI.TableNextColumn() UI.Text(string.format("%d", (DB.DPS.GetAverageDPS(playerName))))
            UI.TableNextColumn() UI.Text(tostring(Column.Damage.RawTotalPlayerDamage(playerName)))
            UI.TableNextColumn() UI.Text(tostring(Timers.GetDuration(Timers.Types.PARSE)))
            UI.TableNextColumn() UI.Text(string.format("%d", (dps)))

            for _, damage in pairs(DB.DPS.Snapshots[playerName]) do
                UI.TableNextColumn() UI.Text(string.format("%d", (damage)))
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Populates the DPS data headers.
------------------------------------------------------------------------------------------------------
Debug.DPS.Headers = function()
    local flags = Column.Flags.None

    UI.TableSetupColumn("Player", flags)
    UI.TableSetupColumn("A DPS",  flags)
    UI.TableSetupColumn("Damage", flags)
    UI.TableSetupColumn("Time",   flags)
    UI.TableSetupColumn("R DPS",  flags)

    local windowCount = 0

    for playerName, _ in pairs(DB.DPS.DPS) do
        for window, _ in pairs(DB.DPS.Snapshots[playerName]) do
            UI.TableSetupColumn(string.format("DPS %d", window), flags)
            windowCount = windowCount + 1
        end
    end

    for i = windowCount + 1, 3 do
        UI.TableSetupColumn(string.format("DPS %d", i), flags)
    end

    UI.TableHeadersRow()
end