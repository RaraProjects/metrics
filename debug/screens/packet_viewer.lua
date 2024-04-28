_Debug.Packet = {}
_Debug.Packet.Action_Log = {}      -- Entity, Action, Result
_Debug.Packet.Message_Log = {}
_Debug.Packet.Item_Log = {}
_Debug.Packet.Limit = 100
_Debug.Packet.Size = 32

------------------------------------------------------------------------------------------------------
-- Resets the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Reset = function()
    _Debug.Packet.Action_Log = {}
    _Debug.Packet.Message_Log = {}
    _Debug.Packet.Item_Log = {}
end

------------------------------------------------------------------------------------------------------
-- Adds a packet entry to the packet viewer.
------------------------------------------------------------------------------------------------------
---@param entity string
---@param target string
---@param action string
---@param result table
------------------------------------------------------------------------------------------------------
_Debug.Packet.Add_Action = function(entity, target, action, result)
    if #_Debug.Packet.Action_Log >= _Debug.Packet.Limit then table.remove(_Debug.Packet.Action_Log, _Debug.Packet.Limit) end
    local entry = {
        Time   = os.date("%X"),
        Entity = entity,
        Target = target,
        Action = action,
        Result = result,
    }
    table.insert(_Debug.Packet.Action_Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Populate_Action = function()
    local table_size = {0, _Debug.Packet.Size * 8}
    if UI.BeginTable("Action Packet Log", 21, Window.Table.Flags.Scrollable, table_size) then
        _Debug.Packet.Action_Headers()
        for _, data in ipairs(_Debug.Packet.Action_Log) do
            _Debug.Packet.Action_Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Action_Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("\nTime", flags)
    UI.TableSetupColumn("\nEntity", flags)
    UI.TableSetupColumn("\nTarget", flags)
    UI.TableSetupColumn("\nAction", flags)
    UI.TableSetupColumn("\nReaction", flags)
    UI.TableSetupColumn("\nAnimation", flags)
    UI.TableSetupColumn("\nEffect", flags)
    UI.TableSetupColumn("\nStagger", flags)
    UI.TableSetupColumn("\nParam", flags)
    UI.TableSetupColumn("\nMessage", flags)
    UI.TableSetupColumn("\nUnknown", flags)
    UI.TableSetupColumn("Additional\nEffect", flags)
    UI.TableSetupColumn("Effect\nAnimation", flags)
    UI.TableSetupColumn("Effect\nEffect", flags)
    UI.TableSetupColumn("Effect\nParam", flags)
    UI.TableSetupColumn("Effect\nMessage", flags)
    UI.TableSetupColumn("Has Spike\nEffect", flags)
    UI.TableSetupColumn("Spike\nAnimation", flags)
    UI.TableSetupColumn("Spike\nEffect", flags)
    UI.TableSetupColumn("Spike\nParam", flags)
    UI.TableSetupColumn("Spike\nMessage", flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Action_Rows = function(data)
    local result = data.Result
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(data.Time))
    UI.TableNextColumn() UI.Text(tostring(data.Entity))
    UI.TableNextColumn() UI.Text(tostring(data.Target))
    UI.TableNextColumn() UI.Text(tostring(data.Action))
    UI.TableNextColumn() UI.Text(tostring(result.reaction))
    UI.TableNextColumn() UI.Text(tostring(result.animation))
    UI.TableNextColumn() UI.Text(tostring(result.effect))
    UI.TableNextColumn() UI.Text(tostring(result.stagger))
    UI.TableNextColumn() UI.Text(tostring(result.param))
    UI.TableNextColumn() UI.Text(tostring(result.message))
    UI.TableNextColumn() UI.Text(tostring(result.unknown))
    UI.TableNextColumn() UI.Text(tostring(result.has_add_effect))
    UI.TableNextColumn() UI.Text(tostring(result.add_effect_animation))
    UI.TableNextColumn() UI.Text(tostring(result.add_effect_effect))
    UI.TableNextColumn() UI.Text(tostring(result.add_effect_param))
    UI.TableNextColumn() UI.Text(tostring(result.add_effect_message))
    UI.TableNextColumn() UI.Text(tostring(result.has_spike_effect))
    UI.TableNextColumn() UI.Text(tostring(result.spike_effect_animation))
    UI.TableNextColumn() UI.Text(tostring(result.spike_effect_effect))
    UI.TableNextColumn() UI.Text(tostring(result.spike_effect_param))
    UI.TableNextColumn() UI.Text(tostring(result.spike_effect_message))
end

------------------------------------------------------------------------------------------------------
-- Adds a packet entry to the packet viewer for message packets.
------------------------------------------------------------------------------------------------------
---@param data table
------------------------------------------------------------------------------------------------------
_Debug.Packet.Add_Message = function(data)
    if #_Debug.Packet.Message_Log >= _Debug.Packet.Limit then table.remove(_Debug.Packet.Message_Log, _Debug.Packet.Limit) end
    local entry = {
        Time    = os.date("%X"),
        Actor   = A.Mob.Get_Mob_By_Index(data.actor_index).name,
        Target  = A.Mob.Get_Mob_By_Index(data.target_index).name,
        Message = data.message,
        Data    = data,
    }
    table.insert(_Debug.Packet.Message_Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Populate_Message = function()
    local table_size = {0, _Debug.Packet.Size * 8}
    if UI.BeginTable("Message Packet Log", 11, Window.Table.Flags.Scrollable, table_size) then
        _Debug.Packet.Message_Headers()
        for _, data in ipairs(_Debug.Packet.Message_Log) do
            _Debug.Packet.Message_Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Message_Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Time", flags)
    UI.TableSetupColumn("Message ID", flags)
    UI.TableSetupColumn("Actor Name", flags)
    UI.TableSetupColumn("Actor ID", flags)
    UI.TableSetupColumn("Actor Index", flags)
    UI.TableSetupColumn("Target Name", flags)
    UI.TableSetupColumn("Target ID", flags)
    UI.TableSetupColumn("Target Index", flags)
    UI.TableSetupColumn("Param 1", flags)
    UI.TableSetupColumn("Param 2", flags)
    UI.TableSetupColumn("Unknown", flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Message_Rows = function(data)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(data.Time))
    UI.TableNextColumn() UI.Text(tostring(data.Data.message))
    UI.TableNextColumn() UI.Text(tostring(data.Actor))
    UI.TableNextColumn() UI.Text(tostring(data.Data.actor))
    UI.TableNextColumn() UI.Text(tostring(data.Data.actor_index))
    UI.TableNextColumn() UI.Text(tostring(data.Target))
    UI.TableNextColumn() UI.Text(tostring(data.Data.target))
    UI.TableNextColumn() UI.Text(tostring(data.Data.target_index))
    UI.TableNextColumn() UI.Text(tostring(data.param1))
    UI.TableNextColumn() UI.Text(tostring(data.param2))
    UI.TableNextColumn() UI.Text(tostring(data.unknown))
end

------------------------------------------------------------------------------------------------------
-- Adds a packet entry to the packet viewer for message packets.
------------------------------------------------------------------------------------------------------
---@param data table
------------------------------------------------------------------------------------------------------
_Debug.Packet.Add_Item = function(data)
    if #_Debug.Packet.Item_Log >= _Debug.Packet.Limit then table.remove(_Debug.Packet.Item_Log, _Debug.Packet.Limit) end
    local entry = {
        Time    = os.date("%X"),
        Data    = data,
    }
    table.insert(_Debug.Packet.Item_Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Populate_Item = function()
    local table_size = {0, _Debug.Packet.Size * 8}
    if UI.BeginTable("Item Packet Log", 12, Window.Table.Flags.Scrollable, table_size) then
        _Debug.Packet.Item_Headers()
        for _, data in ipairs(_Debug.Packet.Item_Log) do
            _Debug.Packet.Item_Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Item_Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Time", flags)
    UI.TableSetupColumn("Highest Lotter", flags)
    UI.TableSetupColumn("Current Lotter", flags)
    UI.TableSetupColumn("HL Index", flags)
    UI.TableSetupColumn("Highest Lot", flags)
    UI.TableSetupColumn("CL Index", flags)
    UI.TableSetupColumn("Unknown", flags)
    UI.TableSetupColumn("Current Lot", flags)
    UI.TableSetupColumn("Index", flags)
    UI.TableSetupColumn("Drop", flags)
    UI.TableSetupColumn("HL Name", flags)
    UI.TableSetupColumn("CL Name", flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Item_Rows = function(data)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(data.Time))
    UI.TableNextColumn() UI.Text(tostring(data.Data.highest_lotter))
    UI.TableNextColumn() UI.Text(tostring(data.Data.current_lotter))
    UI.TableNextColumn() UI.Text(tostring(data.Data.highest_lotter_index))
    UI.TableNextColumn() UI.Text(tostring(data.Data.highest_lot))
    UI.TableNextColumn() UI.Text(tostring(data.Data.current_lotter_index))
    UI.TableNextColumn() UI.Text(tostring(data.Data.unknown))
    UI.TableNextColumn() UI.Text(tostring(data.Data.current_lot))
    UI.TableNextColumn() UI.Text(tostring(data.Data.index))
    UI.TableNextColumn() UI.Text(tostring(data.Data.drop))
    UI.TableNextColumn() UI.Text(tostring(data.Data.highest_lotter_name))
    UI.TableNextColumn() UI.Text(tostring(data.Data.current_lotter_name))
end