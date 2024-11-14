Debug.Error = {}
Debug.Error.Log = {}   -- Error, Count
Debug.Error.Count = 0
Debug.Error.Util = {}

------------------------------------------------------------------------------------------------------
-- Adds an entry to the error log.
-- Example Call: _Debug.Error.Add("Function: Error")
------------------------------------------------------------------------------------------------------
---@param error string error string and index to the error log.
---@return boolean whether or not this is a new error.
------------------------------------------------------------------------------------------------------
Debug.Error.Add = function(error)
    Debug.Error.Count = Debug.Error.Count + 1
    if not Debug.Error.Log[error] then
        Debug.Error.Log[error] = {
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
Debug.Error.Populate = function()
    if UI.BeginTable("Error Log", 2, Window_Manager.Table.Flags.Borders) then
        Debug.Error.Headers()
        for _, data in pairs(Debug.Error.Log) do
            Debug.Error.Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the error log.
------------------------------------------------------------------------------------------------------
Debug.Error.Headers = function()
    local flags = Column.Flags.None
    UI.TableSetupColumn("Count", flags)
    UI.TableSetupColumn("Error", flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Creates the rows of the error log.
------------------------------------------------------------------------------------------------------
---@param entry table
------------------------------------------------------------------------------------------------------
Debug.Error.Rows = function(entry)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(entry.Count))
    UI.TableNextColumn() UI.Text(tostring(entry.Error))
end

------------------------------------------------------------------------------------------------------
-- Returns how many errors are currently in the error log.
------------------------------------------------------------------------------------------------------
Debug.Error.Util.Error_Count = function()
    return Debug.Error.Count
end