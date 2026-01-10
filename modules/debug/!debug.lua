Debug = { }
Debug.Enabled = false

Debug.Name   = "Debug"
Debug.Title  = "Metrics - Debug"
Debug.Module = "Debug"

Debug.Window = Window:New({
    Name       = Debug.Name,
    Title      = Debug.Title,
    Module     = Debug.Module,
    Settings   = { Visible = { false }, X = 100, Y = 100 },
    Show_Title = true,
})

Debug.Modes =
{
    DATA_VIEWER = "Data Viewer",
    DPS         = "DPS        ",
    ERROR_LOG   = "Error Log  ",
    JOB_COLORS  = "Job Colors ",
    UNIT_TESTS  = "Unit Tests ",
}

require("modules.debug.error_log")
require("modules.debug.data_viewer")
require("modules.debug.dps")
require("modules.debug.unit_tests")

------------------------------------------------------------------------------------------------------
-- Is debug mode enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Debug.IsEnabled = function()
    return Debug.Enabled
end

------------------------------------------------------------------------------------------------------
-- Toggles debug mode.
------------------------------------------------------------------------------------------------------
Debug.Toggle = function()
    Debug.Enabled = not Debug.Enabled

    if Debug.Enabled then
        Debug.Window.Show()
    else
        Debug.Window.Hide()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat if the debug mode is enabled.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Debug.Message = function(message)
    if Debug.Enabled then
        print("METRICS: " .. message)
    end
end

------------------------------------------------------------------------------------------------------
-- Poplates the debug screen to show debug tools.
------------------------------------------------------------------------------------------------------
Debug.Content = function()
    local col_flags = Column.Flags.None
    local width     = 150

    if UI.BeginTable("Debug Functions", 4, WindowManager.Table.Flags.None) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)
        UI.TableSetupColumn("Col 4", col_flags, width)

        UI.TableNextColumn() if UI.Button(Debug.Modes.ERROR_LOG)   then Debug.Active_Mode = Debug.Modes.ERROR_LOG end
        UI.TableNextColumn() if UI.Button(Debug.Modes.DATA_VIEWER) then Debug.Active_Mode = Debug.Modes.DATA_VIEWER end
        UI.TableNextColumn() if UI.Button(Debug.Modes.DPS)         then Debug.Active_Mode = Debug.Modes.DPS end

        UI.TableNextColumn() if UI.Button(Debug.Modes.UNIT_TESTS)  then
            Debug.Active_Mode  = Debug.Modes.UNIT_TESTS
            Debug.Unit.Results = { }
            Debug.Unit.RunTests()
        end

        UI.TableNextColumn() if UI.Button(Debug.Modes.JOB_COLORS)  then Debug.Active_Mode = Debug.Modes.JOB_COLORS end

        UI.TableNextColumn()
        if UI.Checkbox("Reset Unit", { Debug.Unit.ResetEachTime }) then
            Debug.Unit.ResetEachTime = not Debug.Unit.ResetEachTime
        end

        UI.EndTable()
    end

    if Debug.Active_Mode == Debug.Modes.ERROR_LOG then
        Debug.Error.Populate(Debug.Error.ERROR)

        if UI.CollapsingHeader("Warnings") then
            Debug.Error.Populate(Debug.Error.WARNING)
        end

    elseif Debug.Active_Mode == Debug.Modes.DATA_VIEWER then
        Debug.DataView.Populate()

    elseif Debug.Active_Mode == Debug.Modes.DPS then
        Debug.DPS.Populate()

    elseif Debug.Active_Mode == Debug.Modes.UNIT_TESTS then
        Debug.Unit.Populate()

    elseif Debug.Active_Mode == Debug.Modes.JOB_COLORS then
        UI.TextColored(Res.Colors.GetJob(1),  "Warrior")
        UI.TextColored(Res.Colors.GetJob(2),  "Monk")
        UI.TextColored(Res.Colors.GetJob(3),  "White Mage")
        UI.TextColored(Res.Colors.GetJob(4),  "Black Mage")
        UI.TextColored(Res.Colors.GetJob(5),  "Red Mage")
        UI.TextColored(Res.Colors.GetJob(6),  "Thief")
        UI.TextColored(Res.Colors.GetJob(7),  "Paladin")
        UI.TextColored(Res.Colors.GetJob(8),  "Dark Knight")
        UI.TextColored(Res.Colors.GetJob(9),  "Beastmaster")
        UI.TextColored(Res.Colors.GetJob(10), "Bard")
        UI.TextColored(Res.Colors.GetJob(11), "Ranger")
        UI.TextColored(Res.Colors.GetJob(12), "Samurai")
        UI.TextColored(Res.Colors.GetJob(13), "Ninja")
        UI.TextColored(Res.Colors.GetJob(14), "Dragoon")
        UI.TextColored(Res.Colors.GetJob(15), "Summoner")
        UI.TextColored(Res.Colors.GetJob(16), "Blue Mage")
        UI.TextColored(Res.Colors.GetJob(17), "Corsair")
        UI.TextColored(Res.Colors.GetJob(18), "Puppetmaster")
        UI.TextColored(Res.Colors.GetJob(19), "Dancer")
        UI.TextColored(Res.Colors.GetJob(20), "Scholar")
        UI.TextColored(Res.Colors.GetJob(21), "Geomancer")
        UI.TextColored(Res.Colors.GetJob(22), "Runefencer")
    else
        UI.Text("Select a tool.")
    end
end
