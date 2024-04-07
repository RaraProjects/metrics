_Debug.Error = {}
_Debug.Error.Log = {}   -- Error, Count

------------------------------------------------------------------------------------------------------
-- 
-- _Debug.Error.Add("Function: Error")
---@return boolean whether or not this is a new error.
------------------------------------------------------------------------------------------------------
_Debug.Error.Add = function(error)
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
-- 
------------------------------------------------------------------------------------------------------
_Debug.Error.Populate = function()
    if UI.BeginTable("Error Log", 2, Window.Table.Flags.Team) then
        _Debug.Error.Headers()
        for _, data in pairs(_Debug.Error.Log) do
            _Debug.Error.Rows(data)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
_Debug.Error.Headers = function()
    local flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Count", flags)
    UI.TableSetupColumn("Error", flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
_Debug.Error.Rows = function(entry)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(tostring(entry.Count))
    UI.TableNextColumn() UI.Text(tostring(entry.Error))
end