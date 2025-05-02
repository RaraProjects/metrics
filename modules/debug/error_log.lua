Debug.Error = {}
Debug.Error.Log = {}   -- Error, Count
Debug.Error.Count = 0
Debug.Error.Util = {}
Debug.Error.WARNING = "Warning"
Debug.Error.ERROR   = "Error"

------------------------------------------------------------------------------------------------------
-- Adds an entry to the error log.
-- Example Call: _Debug.Error.Add("Function: Error")
------------------------------------------------------------------------------------------------------
---@param type string the type of error.
---@param tag string the calling function.
---@param error string error string and index to the error log.
---@return boolean whether or not this is a new error.
------------------------------------------------------------------------------------------------------
Debug.Error.Add = function(type, tag, error)
    Debug.Error.Count = Debug.Error.Count + 1
    if not Debug.Error.Log[error] then
        Debug.Error.Log[error] = {
            Type  = type,
            Tag   = tag,
            Error = error,
            Count = 1,
        }
        return true
    end
    Debug.Error.Log[error].Count = Debug.Error.Log[error].Count + 1
    return false
end

------------------------------------------------------------------------------------------------------
-- Resets the error log.
------------------------------------------------------------------------------------------------------
Debug.Error.Reset = function()
    Debug.Error.Log = {}
    Debug.Error.Count = 0
end

------------------------------------------------------------------------------------------------------
-- Populates the error log tab.
------------------------------------------------------------------------------------------------------
---@param type string the type of error.
------------------------------------------------------------------------------------------------------
Debug.Error.Populate = function(type)
    table.sort(Debug.Error.Log, function(a, b) return a.Tag < b.Tag end)
    if UI.BeginTable("Error Log", 3, WindowManager.Table.Flags.Borders) then
        Debug.Error.Headers(type)
        for _, data in pairs(Debug.Error.Log) do
            if data.Type == type then Debug.Error.Rows(data) end
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the error log.
------------------------------------------------------------------------------------------------------
---@param type string the type of error.
------------------------------------------------------------------------------------------------------
Debug.Error.Headers = function(type)
    local flags = Column.Flags.None
    UI.TableSetupColumn("Tag", flags, 200)
    UI.TableSetupColumn("Count", flags, 50)
    UI.TableSetupColumn(tostring(type), flags, 800)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the error log.
------------------------------------------------------------------------------------------------------
---@param entry table
------------------------------------------------------------------------------------------------------
Debug.Error.Rows = function(entry)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(entry.Tag))
    UI.TableNextColumn() UI.Text(tostring(entry.Count))
    UI.TableNextColumn() UI.Text(tostring(entry.Error))
end

------------------------------------------------------------------------------------------------------
-- Returns how many errors are currently in the error log.
------------------------------------------------------------------------------------------------------
Debug.Error.Util.Error_Count = function()
    return Debug.Error.Count
end