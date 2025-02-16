Blog.Dependencies = { }

------------------------------------------------------------------------------------------------------
-- Checks the mask names setting.
------------------------------------------------------------------------------------------------------
Blog.Dependencies.MaskNames = function()
    return Parse.Config.IsMaskingNames()
end

------------------------------------------------------------------------------------------------------
-- Connect to Ashita to see if there is party data for a player.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@return nil|table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.CheckParty = function(playerName)
    return Ashita.Party.GetMember(playerName)
end

------------------------------------------------------------------------------------------------------
-- Element color from the resource file.
------------------------------------------------------------------------------------------------------
---@param elementId integer
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.ElementColor = function(elementId)
    return Res.Colors.GetElement(elementId)
end

------------------------------------------------------------------------------------------------------
-- Job color from the resource file.
------------------------------------------------------------------------------------------------------
---@param jobId integer
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.JobColor = function(jobId)
    return Res.Colors.GetJob(jobId)
end

------------------------------------------------------------------------------------------------------
-- White color from the resource file.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.White = function()
    return Res.Colors.Basic.WHITE
end

------------------------------------------------------------------------------------------------------
-- Dim color from the resource file.
------------------------------------------------------------------------------------------------------
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.Dim = function()
    return Res.Colors.Basic.DIM
end

------------------------------------------------------------------------------------------------------
-- Get job data from the resource file.
------------------------------------------------------------------------------------------------------
---@param jobId integer
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.JobData = function(jobId)
    return Res.Jobs.GetJob(jobId or 0)
end

------------------------------------------------------------------------------------------------------
-- Truncate a string.
------------------------------------------------------------------------------------------------------
---@param originalString string
---@param length         integer
---@param ignoreDot?     boolean
---@return string
------------------------------------------------------------------------------------------------------
Blog.Dependencies.StringTruncate = function(originalString, length, ignoreDot)
    return Column.String.Truncate(originalString, length, ignoreDot)
end

------------------------------------------------------------------------------------------------------
-- Pad a string if necessary.
------------------------------------------------------------------------------------------------------
---@param originalString string
---@param length         integer
---@return string
------------------------------------------------------------------------------------------------------
Blog.Dependencies.StringSetLength = function(originalString, length)
    return Column.String.SetLength(originalString, length)
end

------------------------------------------------------------------------------------------------------
-- Formats a number into a string.
------------------------------------------------------------------------------------------------------
---@param value integer
---@return string
------------------------------------------------------------------------------------------------------
Blog.Dependencies.StringFormatNumber = function(value)
    return Column.String.FormatNumber(value)
end