_Debug.Packet = {}
_Debug.Packet.Log = {}      -- Entity, Action, Result
_Debug.Packet.Limit = 100
_Debug.Packet.Size = 32

------------------------------------------------------------------------------------------------------
-- Resets the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Reset = function()
    _Debug.Packet.Log = {}
end

------------------------------------------------------------------------------------------------------
-- Adds a packet entry to the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Add = function(entity, target, action, result)
    if #_Debug.Packet.Log >= _Debug.Packet.Limit then table.remove(_Debug.Packet.Log, _Debug.Packet.Limit) end
    local entry = {
        Time   = os.date("%X"),
        Entity = entity,
        Target = target,
        Action = action,
        Result = result,
    }
    table.insert(_Debug.Packet.Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Populate = function()
    local table_size = {0, _Debug.Packet.Size * 8}
    if UI.BeginTable("Action Packet Log", 21, Window.Table.Flags.Scrollable, table_size) then
        _Debug.Packet.Headers()
        for _, data in ipairs(_Debug.Packet.Log) do
            _Debug.Packet.Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
_Debug.Packet.Headers = function()
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
_Debug.Packet.Rows = function(data)
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