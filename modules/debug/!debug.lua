Debug = {}
Debug.Enabled = false
Debug.Show_Demo = false

Debug.Name   = "Debug"
Debug.Title  = "Metrics - Debug"
Debug.Module = "Debug"
Debug.Window = Window:New({
    Name    = Debug.Name,
    Title   = Debug.Title,
    Module  = Debug.Module,
    Visible = {false},
    Show_Title = true,
})

Debug.Modes = T{
    MOB_VIEWER     = "Mob Viewer    ",
    ACTION_PACKET  = "Action Packet ",
    MESSAGE_PACKET = "Message Packet",
    ERROR_LOG      = "Error Log     ",
    DATA_VIEWER    = "Data Viewer   ",
    JOB_COLORS     = "Job Colors    ",
    UNIT_TESTS     = "Unit Tests    ",
    DEMO           = "Demo Window   ",
}
Debug.Active_Mode = Debug.Modes.MOB_VIEWER

require("modules.debug.performance")
require("modules.debug.screens.mob_viewer")
require("modules.debug.screens.packet_viewer")
require("modules.debug.screens.error_log")
require("modules.debug.screens.data_viewer")
require("modules.debug.unit_tests._tests")
require("modules.debug.unit_tests.melee")
require("modules.debug.unit_tests.ranged")
require("modules.debug.unit_tests.tp_action")
require("modules.debug.unit_tests.abilities")
require("modules.debug.unit_tests.spells")
require("modules.debug.unit_tests.defense")

------------------------------------------------------------------------------------------------------
-- Is debug mode enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Debug.Is_Enabled = function()
    return Debug.Enabled
end

------------------------------------------------------------------------------------------------------
-- Toggles debug mode.
------------------------------------------------------------------------------------------------------
Debug.Toggle = function()
    Debug.Enabled = not Debug.Enabled
    if Debug.Enabled then Debug.Window.Show() else Debug.Window.Hide() end
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat if the debug mode is enabled.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
Debug.Message = function(message)
    if Debug.Enabled then print("METRICS DEBUG: " .. message) end
end

------------------------------------------------------------------------------------------------------
-- Poplates the debug screen to show debug tools.
------------------------------------------------------------------------------------------------------
Debug.Content = function()
    local col_flags = Column.Flags.None
    local width = 150

    if UI.BeginTable("Debug Functions", 3, Window_Manager.Table.Flags.None) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn() if UI.Button(Debug.Modes.MOB_VIEWER) then Debug.Active_Mode = Debug.Modes.MOB_VIEWER end
        UI.TableNextColumn() if UI.Button(Debug.Modes.ACTION_PACKET) then Debug.Active_Mode = Debug.Modes.ACTION_PACKET end
        UI.TableNextColumn() if UI.Button(Debug.Modes.MESSAGE_PACKET) then Debug.Active_Mode = Debug.Modes.MESSAGE_PACKET end
        UI.TableNextColumn() if UI.Button(Debug.Modes.ERROR_LOG) then Debug.Active_Mode = Debug.Modes.ERROR_LOG end
        UI.TableNextColumn() if UI.Button(Debug.Modes.DATA_VIEWER) then Debug.Active_Mode = Debug.Modes.DATA_VIEWER end
        UI.TableNextColumn() if UI.Button(Debug.Modes.JOB_COLORS) then Debug.Active_Mode = Debug.Modes.JOB_COLORS end
        UI.TableNextColumn() if UI.Button(Debug.Modes.UNIT_TESTS) then
            Debug.Active_Mode = Debug.Modes.UNIT_TESTS
            Debug.Unit.Results = T{}
            Debug.Unit.Run_Tests()
        end
        UI.TableNextColumn() if UI.Button(Debug.Modes.DEMO) then Debug.Show_Demo = not Debug.Show_Demo end

        UI.EndTable()
    end

    if     Debug.Active_Mode == Debug.Modes.MOB_VIEWER     then Debug.Mob.Populate(Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.TARGET))
    elseif Debug.Active_Mode == Debug.Modes.ACTION_PACKET  then Debug.Packet.Populate_Action()
    elseif Debug.Active_Mode == Debug.Modes.MESSAGE_PACKET then Debug.Packet.Populate_Message()
    elseif Debug.Active_Mode == Debug.Modes.ERROR_LOG      then Debug.Error.Populate()
    elseif Debug.Active_Mode == Debug.Modes.DATA_VIEWER    then Debug.Data_View.Populate()
    elseif Debug.Active_Mode == Debug.Modes.JOB_COLORS     then
        UI.TextColored(Res.Colors.Get_Job(1),  "Warrior")
        UI.TextColored(Res.Colors.Get_Job(2),  "Monk")
        UI.TextColored(Res.Colors.Get_Job(3),  "White Mage")
        UI.TextColored(Res.Colors.Get_Job(4),  "Black Mage")
        UI.TextColored(Res.Colors.Get_Job(5),  "Red Mage")
        UI.TextColored(Res.Colors.Get_Job(6),  "Thief")
        UI.TextColored(Res.Colors.Get_Job(7),  "Paladin")
        UI.TextColored(Res.Colors.Get_Job(8),  "Dark Knight")
        UI.TextColored(Res.Colors.Get_Job(9),  "Beastmaster")
        UI.TextColored(Res.Colors.Get_Job(10), "Bard")
        UI.TextColored(Res.Colors.Get_Job(11), "Ranger")
        UI.TextColored(Res.Colors.Get_Job(12), "Samurai")
        UI.TextColored(Res.Colors.Get_Job(13), "Ninja")
        UI.TextColored(Res.Colors.Get_Job(14), "Dragoon")
        UI.TextColored(Res.Colors.Get_Job(15), "Summoner")
        UI.TextColored(Res.Colors.Get_Job(16), "Blue Mage")
        UI.TextColored(Res.Colors.Get_Job(17), "Corsair")
        UI.TextColored(Res.Colors.Get_Job(18), "Puppetmaster")
    elseif Debug.Active_Mode == Debug.Modes.UNIT_TESTS     then
        Debug.Unit.Populate()
    else
        UI.Text("Select a tool.")
    end
end