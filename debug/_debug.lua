_Debug = {}
_Debug.Enabled = false

require("debug.screens.mob_viewer")
require("debug.screens.packet_viewer")
require("debug.screens.error_log")
require("debug.screens.data_viewer")
require("debug.unit_tests._tests")
require("debug.unit_tests.melee")
require("debug.unit_tests.ranged")
require("debug.unit_tests.tp_action")
require("debug.unit_tests.abilities")
require("debug.unit_tests.spells")

------------------------------------------------------------------------------------------------------
-- Is debug mode enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
_Debug.Is_Enabled = function()
    return _Debug.Enabled
end

------------------------------------------------------------------------------------------------------
-- Toggles debug mode.
------------------------------------------------------------------------------------------------------
_Debug.Toggle = function()
    _Debug.Enabled = not _Debug.Enabled
end

-- ------------------------------------------------------------------------------------------------------
-- Adds a message in game chat if the debug mode is enabled.
-- ------------------------------------------------------------------------------------------------------
---@param message string
-- ------------------------------------------------------------------------------------------------------
_Debug.Message = function(message)
    if _Debug.Enabled then print("METRICS DEBUG: " .. message) end
end

------------------------------------------------------------------------------------------------------
-- Poplates the debug screen to show debug tools.
------------------------------------------------------------------------------------------------------
_Debug.Populate = function()
    if UI.BeginTabBar("Debug Tabs", Window.Tabs.Flags) then
        if UI.BeginTabItem(Window.Tabs.Names.MOBVIEW) then
            _Debug.Mob.Populate(Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.TARGET))
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.ACTIONS) then
            _Debug.Packet.Populate_Action()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.MESSAGES) then
            _Debug.Packet.Populate_Message()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.ITEMS) then
            _Debug.Packet.Populate_Item()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.ERRORS) then
            _Debug.Error.Populate()
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Window.Tabs.Names.DATAVIEW) then
            _Debug.Data_View.Populate()
            UI.EndTabItem()
        end
        UI.EndTabBar()
    end
end