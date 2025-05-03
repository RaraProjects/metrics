Debug.Packet = { }
Debug.Packet.Action_Log  = { }      -- Entity, Action, Result
Debug.Packet.Message_Log = { }
Debug.Packet.Item_Log    = { }
Debug.Packet.Timestamps  = { }      -- [mobID][category]
Debug.Packet.Limit       = 100000
Debug.Packet.Size        = 32

Debug.Packet.Actions =
{
    MELEE      = true,
    MELEE_DEF  = true,
    RANGED     = true,
    RANGED_DEF = true,
    SPELL      = true,
    SPELL_DEF  = true,
    TP         = true,
    TP_DEF     = true,
    ABILITY    = true,
}

Debug.Packet.Action_Buffer = { }

------------------------------------------------------------------------------------------------------
-- Resets the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.Reset = function()
    Debug.Packet.Action_Log  = { }
    Debug.Packet.Message_Log = { }
    Debug.Packet.Item_Log    = { }
end

------------------------------------------------------------------------------------------------------
-- Creates an input text box for the action filter.
------------------------------------------------------------------------------------------------------
Debug.Packet.ActionFilterInput = function()
    UI.SetNextItemWidth(150) UI.InputText("Action", Debug.Packet.Action_Buffer, 100, ImGuiInputTextFlags_AutoSelectAll)
end

------------------------------------------------------------------------------------------------------
-- Check to see if the entry contains an action that passes the filter.
------------------------------------------------------------------------------------------------------
---@param entry table
---@return boolean
------------------------------------------------------------------------------------------------------
Debug.Packet.ActionNameFilter = function(entry)
    if not entry or not entry.Action then
        return false
    end

    local actionString = Debug.Packet.Action_Buffer[1]

    if not actionString then
        return true
    end

    return string.find(string.lower(entry.Action), string.lower(actionString)) ~= nil
end

------------------------------------------------------------------------------------------------------
-- Adds a packet entry to the packet viewer.
------------------------------------------------------------------------------------------------------
---@param entity      string
---@param target      string
---@param actionLabel string
---@param actionData  table
---@param id          integer
---@param name        string
------------------------------------------------------------------------------------------------------
Debug.Packet.AddAction = function(entity, target, actionLabel, actionData, id, name)
    if #Debug.Packet.Action_Log >= Debug.Packet.Limit then
        table.remove(Debug.Packet.Action_Log, Debug.Packet.Limit)
    end

    local entry =
    {
        Time   = os.date("%X"),
        Entity = entity,
        Target = target,
        Action = actionLabel,
        Result = actionData,
        ID     = id or 0,
        Name   = name or "",
    }

    table.insert(Debug.Packet.Action_Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
Debug.Packet.PopulateAction = function()
    Debug.Packet.ActionFilterInput()

    local tableSize = { 0, Debug.Packet.Size * 8 }

    if UI.BeginTable("Action Packet Log", 23, WindowManager.Table.Flags.Scrollable, tableSize) then
        Debug.Packet.ActionHeaders()

        for _, data in ipairs(Debug.Packet.Action_Log) do
            if Debug.Packet.ActionNameFilter(data) then
                Debug.Packet.ActionRows(data)
            end
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.ActionHeaders = function()
    local flags = Column.Flags.None

    UI.TableSetupColumn("\nTime",             flags)
    UI.TableSetupColumn("\nEntity",           flags)
    UI.TableSetupColumn("\nTarget",           flags)
    UI.TableSetupColumn("\nAction",           flags)
    UI.TableSetupColumn("\nID",               flags)
    UI.TableSetupColumn("\nName",             flags)
    UI.TableSetupColumn("\nReaction",         flags)
    UI.TableSetupColumn("\nAnimation",        flags)
    UI.TableSetupColumn("\nEffect",           flags)
    UI.TableSetupColumn("\nStagger",          flags)
    UI.TableSetupColumn("\nParam",            flags)
    UI.TableSetupColumn("\nMessage",          flags)
    UI.TableSetupColumn("\nUnknown",          flags)
    UI.TableSetupColumn("Additional\nEffect", flags)
    UI.TableSetupColumn("Effect\nAnimation",  flags)
    UI.TableSetupColumn("Effect\nEffect",     flags)
    UI.TableSetupColumn("Effect\nParam",      flags)
    UI.TableSetupColumn("Effect\nMessage",    flags)
    UI.TableSetupColumn("Has Spike\nEffect",  flags)
    UI.TableSetupColumn("Spike\nAnimation",   flags)
    UI.TableSetupColumn("Spike\nEffect",      flags)
    UI.TableSetupColumn("Spike\nParam",       flags)
    UI.TableSetupColumn("Spike\nMessage",     flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.ActionRows = function(data)
    local result = data.Result

    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(data.Time))
    UI.TableNextColumn() UI.Text(tostring(data.Entity))
    UI.TableNextColumn() UI.Text(tostring(data.Target))
    UI.TableNextColumn() UI.Text(tostring(data.Action))
    UI.TableNextColumn() UI.Text(tostring(data.ID))
    UI.TableNextColumn() UI.Text(tostring(data.Name))
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
Debug.Packet.AddMessage = function(data)
    if #Debug.Packet.Message_Log >= Debug.Packet.Limit then
        table.remove(Debug.Packet.Message_Log, Debug.Packet.Limit)
    end

    local entry =
    {
        Time    = os.date("%X"),
        Actor   = Ashita.Mob.GetMobByIndex(data.actor_index).name,
        Target  = Ashita.Mob.GetMobByIndex(data.target_index).name,
        Message = data.message,
        Data    = data,
    }

    table.insert(Debug.Packet.Message_Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
Debug.Packet.PopulateMessage = function()
    local tableSize = { 0, Debug.Packet.Size * 8 }

    if UI.BeginTable("Message Packet Log", 11, WindowManager.Table.Flags.Scrollable, tableSize) then
        Debug.Packet.MessageHeaders()

        for _, data in ipairs(Debug.Packet.Message_Log) do
            Debug.Packet.MessageRows(data)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.MessageHeaders = function()
    local flags = Column.Flags.None

    UI.TableSetupColumn("Time",         flags)
    UI.TableSetupColumn("Message ID",   flags)
    UI.TableSetupColumn("Actor Name",   flags)
    UI.TableSetupColumn("Actor ID",     flags)
    UI.TableSetupColumn("Actor Index",  flags)
    UI.TableSetupColumn("Target Name",  flags)
    UI.TableSetupColumn("Target ID",    flags)
    UI.TableSetupColumn("Target Index", flags)
    UI.TableSetupColumn("Param 1",      flags)
    UI.TableSetupColumn("Param 2",      flags)
    UI.TableSetupColumn("Unknown",      flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.MessageRows = function(data)
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
Debug.Packet.Add_Item = function(data)
    if #Debug.Packet.Item_Log >= Debug.Packet.Limit then
        table.remove(Debug.Packet.Item_Log, Debug.Packet.Limit)
    end

    local entry =
    {
        Time = os.date("%X"),
        Data = data,
    }

    table.insert(Debug.Packet.Item_Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Populates the Packet Viewer tab.
------------------------------------------------------------------------------------------------------
Debug.Packet.PopulateItem = function()
    local tableSize = { 0, Debug.Packet.Size * 8 }

    if UI.BeginTable("Item Packet Log", 12, WindowManager.Table.Flags.Scrollable, tableSize) then
        Debug.Packet.ItemHeaders()

        for _, data in ipairs(Debug.Packet.Item_Log) do
            Debug.Packet.ItemRows(data)
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.ItemHeaders = function()
    local flags = Column.Flags.None

    UI.TableSetupColumn("Time",           flags)
    UI.TableSetupColumn("Highest Lotter", flags)
    UI.TableSetupColumn("Current Lotter", flags)
    UI.TableSetupColumn("HL Index",       flags)
    UI.TableSetupColumn("Highest Lot",    flags)
    UI.TableSetupColumn("CL Index",       flags)
    UI.TableSetupColumn("Unknown",        flags)
    UI.TableSetupColumn("Current Lot",    flags)
    UI.TableSetupColumn("Index",          flags)
    UI.TableSetupColumn("Drop",           flags)
    UI.TableSetupColumn("HL Name",        flags)
    UI.TableSetupColumn("CL Name",        flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the packet viewer.
------------------------------------------------------------------------------------------------------
Debug.Packet.ItemRows = function(data)
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

------------------------------------------------------------------------------------------------------
-- Keep track of last packet times.
------------------------------------------------------------------------------------------------------
---@param actorMob table
---@param category integer
------------------------------------------------------------------------------------------------------
Debug.Packet.MarkTime = function(actorMob, category)
    if not actorMob then
        return
    end

    Debug.Packet.Timestamps[actorMob.id] = Debug.Packet.Timestamps[actorMob.id] or { }
    Debug.Packet.Timestamps[actorMob.id][category] = Debug.Packet.Timestamps[actorMob.id][category] or { }

    Debug.Packet.Timestamps[actorMob.id][category] = Socket.gettime()
end

------------------------------------------------------------------------------------------------------
-- Get the timestamp for the most recent action packet category for a mob.
------------------------------------------------------------------------------------------------------
---@param actorMob table
---@param category integer
---@return number
------------------------------------------------------------------------------------------------------
Debug.Packet.GetTime = function(actorMob, category)
    if
        not actorMob or
        not Debug.Packet.Timestamps[actorMob.id] or
        not Debug.Packet.Timestamps[actorMob.id][category]
    then
        return 0
    end

    Debug.Packet.Timestamps[actorMob.id][category] = Debug.Packet.Timestamps[actorMob.id][category] or { }

    return Debug.Packet.Timestamps[actorMob.id][category]
end

------------------------------------------------------------------------------------------------------
-- Get the time difference between action packet categories
------------------------------------------------------------------------------------------------------
---@param actorMob      table
---@param startCategory integer
---@param stopCategory  integer
---@return number
------------------------------------------------------------------------------------------------------
Debug.Packet.TimeDiff = function(actorMob, startCategory, stopCategory)
    if
        not actorMob or
        not Debug.Packet.Timestamps[actorMob.id] or
        not Debug.Packet.Timestamps[actorMob.id][startCategory] or
        not Debug.Packet.Timestamps[actorMob.id][stopCategory]
    then
        return 0
    end

    return Debug.Packet.Timestamps[actorMob.id][stopCategory] - Debug.Packet.Timestamps[actorMob.id][startCategory]
end