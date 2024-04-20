_Debug = {}
_Debug.Enabled = false

require("debug.mob_viewer")
require("debug.packet_viewer")
require("debug.error_log")
require("debug.data_viewer")
require("debug.unit_tests._tests")
require("debug.unit_tests.melee")
require("debug.unit_tests.ranged")
require("debug.unit_tests.tp_action")
require("debug.unit_tests.abilities")

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