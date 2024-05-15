_Debug.Error = {}
_Debug.Error.Log = {}   -- Error, Count
_Debug.Error.Count = 0
_Debug.Error.Util = {}

------------------------------------------------------------------------------------------------------
-- Adds an entry to the error log.
-- Example Call: _Debug.Error.Add("Function: Error")
------------------------------------------------------------------------------------------------------
---@param error string error string and index to the error log.
---@return boolean whether or not this is a new error.
------------------------------------------------------------------------------------------------------
_Debug.Error.Add = function(error)
    _Debug.Error.Count = _Debug.Error.Count + 1
    if not _Debug.Error.Log[error] then
        _Debug.Error.Log[error] = {
            Error = error,
            Count = 1,
        }
        return true
    end
    _Debug.Error.Log[error].Count = _Debug.Error.Log[error].Count + 1
    return false
end

------------------------------------------------------------------------------------------------------
-- Resets the error log.
------------------------------------------------------------------------------------------------------
_Debug.Error.Reset = function()
    _Debug.Error.Log = {}
    _Debug.Error.Count = 0
end

------------------------------------------------------------------------------------------------------
-- Populates the error log tab.
------------------------------------------------------------------------------------------------------
_Debug.Error.Populate = function()
    if UI.BeginTable("Error Log", 2, Window.Table.Flags.Borders) then
        _Debug.Error.Headers()
        for _, data in pairs(_Debug.Error.Log) do
            _Debug.Error.Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Handles setting up the headers for the error log.
------------------------------------------------------------------------------------------------------
_Debug.Error.Headers = function()
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
_Debug.Error.Rows = function(entry)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(entry.Count))
    UI.TableNextColumn() UI.Text(tostring(entry.Error))
end

------------------------------------------------------------------------------------------------------
-- Returns how many errors are currently in the error log.
------------------------------------------------------------------------------------------------------
_Debug.Error.Util.Error_Count = function()
    return _Debug.Error.Count
end