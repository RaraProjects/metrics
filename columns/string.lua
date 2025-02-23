Column.String = { }

------------------------------------------------------------------------------------------------------
-- Formats the player name string.
------------------------------------------------------------------------------------------------------
---@param playerName string
------------------------------------------------------------------------------------------------------
Column.String.FormatName = function(playerName)
    playerName = playerName or "Player"

    if Parse.Config.IsMaskingNames() then
        return Column.String.Job(playerName, Parse.Config.IsHidingSubjob())
    end

    local job   = Res.Jobs.GetJob(Ashita.Party.Jobs[playerName] and Ashita.Party.Jobs[playerName].main) or Res.Jobs.List[0]
    local color = Parse.Config.IsColoredName() and Res.Colors.GetJob(job.id) or Res.Colors.Basic.WHITE

    UI.TextColored(color, playerName)
end

------------------------------------------------------------------------------------------------------
-- Formats the player job string.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param hideSubjob? boolean
------------------------------------------------------------------------------------------------------
Column.String.Job = function(playerName, hideSubjob)
    local color      = Res.Colors.Basic.WHITE
    local anonString = hideSubjob and "NON0" or "NON0/NON0"
    local jobData    = playerName and Ashita.Party.Jobs[playerName]

    if not jobData then
        UI.TextColored(color, anonString)
        return nil
    end

    local main = Res.Jobs.GetJob(jobData.main) or Res.Jobs.List[0]
    UI.TextColored(Res.Colors.GetJob(main.id), string.format("%s%02d", main.ens, jobData.main_level))

    if not hideSubjob then
        UI.SameLine() UI.Text("/") UI.SameLine()
        local sub = Res.Jobs.GetJob(jobData.sub) or Res.Jobs.List[0]
        UI.TextColored(Res.Colors.GetJob(sub.id), string.format("%s%02d", sub.ens, jobData.sub_level))
    end
end

------------------------------------------------------------------------------------------------------
-- Create a nicely formatted number string.
-- I floor the number to get rid of any decimals. Decimals were a problem with the average column.
------------------------------------------------------------------------------------------------------
---@param number   number this should be an actual number and not a string.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.String.FormatNumber = function(number, justify)
    local format = justify and "%8d" or "%d"

    if Parse.Config.CondensedNumbers() then
        return Column.String.CompactNumber(number, justify)
    end

    return string.format(format, math.floor(number))
end

------------------------------------------------------------------------------------------------------
-- Create a nicely formatted decimal string.
-- I floor the number to get rid of any decimals. Decimals were a problem with the average column.
------------------------------------------------------------------------------------------------------
---@param number   number this should be an actual number and not a string.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.String.FormatDecimal = function(number, justify)
    local format = justify and "%8.2f" or "%2f"

    return string.format(format, number)
end

------------------------------------------------------------------------------------------------------
-- Calculates and formats a percent.
------------------------------------------------------------------------------------------------------
---@param numerator   number  The numerator for the percent.
---@param denominator number  The denominator for the percent.
---@param justify?    boolean whether or not to right justify the text
---@param noScaling?  boolean do not scale the fraction by 100.
---@return string
------------------------------------------------------------------------------------------------------
Column.String.FormatPercent = function(numerator, denominator, justify, noScaling)
    local format   = justify and "%8.1f" or "%.1f"
    local percent  = 0
    local scaling  = noScaling and 1 or 100
    local retValue = string.format(format, 0)

    if denominator and denominator ~= 0 then
        percent = (numerator / denominator) * scaling
    end

    if percent ~= 0 then
        retValue = string.format(format, percent)
    end

    if Focus.Config.ShowPercentDetails and not Report.Publishing.Lock then
        local top    = string.format("%d", numerator)
        local bottom = string.format("%d", denominator)

        return Column.String.SetLength(tostring(top) .. "/" .. tostring(bottom), 8)
    end

    return retValue
end

------------------------------------------------------------------------------------------------------
-- Calculates and returns a raw percent as a number.
------------------------------------------------------------------------------------------------------
---@param numerator   number The numerator for the percent.
---@param denominator number The denominator for the percent.
---@return number
------------------------------------------------------------------------------------------------------
Column.String.RawPercent = function(numerator, denominator)
    if not denominator or denominator == 0 then
        return 0
    end

    return numerator / denominator
end

------------------------------------------------------------------------------------------------------
-- Handles formatting numbers into a more compact easier to read mode (with rounding).
-- Mode examples: Compact = 2.5M; Regular = 2,500,000
------------------------------------------------------------------------------------------------------
---@param number   number this should be an actual number and not a string.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.String.CompactNumber = function(number, justify)
    local displayNumber, suffix
    local length = 6
    number = number or 0

    -- Millions
    if number >= 1000000 then
        displayNumber = number / 1000000
        suffix = " M"
        length = length - 2

    -- Thousands
    elseif number >= 1000 then
        displayNumber = number / 1000
        suffix = " K"
        length = length - 2

    -- No adjustments necessary
    else
        displayNumber = number
        suffix = ""
    end

    local format = justify and "%" .. length .. "d" or "%d"

    if number == 0 then
        return string.format(format, number)
    end

    return string.format(format, displayNumber) .. suffix
end

------------------------------------------------------------------------------------------------------
-- Truncates a string if it is too long.
------------------------------------------------------------------------------------------------------
---@param string     string
---@param limit      number
---@param ignoreDot? boolean
---@return string
------------------------------------------------------------------------------------------------------
Column.String.Truncate = function(string, limit, ignoreDot)
    local length = string.len(string)

    if length <= limit then
        return string
    end

    if ignoreDot then
        return string.sub(string, 1, limit)
    end

    return string.sub(string, 1, limit - 1) .. "."
end

------------------------------------------------------------------------------------------------------
-- Makes zero values dim.
------------------------------------------------------------------------------------------------------
---@param value number
---@return table
------------------------------------------------------------------------------------------------------
Column.String.ColorZero = function(value)
    return value == 0 and Res.Colors.Basic.DIM or Res.Colors.Basic.WHITE
end

------------------------------------------------------------------------------------------------------
-- Adds extra spaces to the end of a string to make it a certain length.
-- Assumes the string input has been truncated already.
------------------------------------------------------------------------------------------------------
---@param string string
---@param limit  number
---@return string
------------------------------------------------------------------------------------------------------
Column.String.SetLength = function(string, limit)
    local length = string.len(string)

    if length >= limit then
        return string
    end

    local charsNeeded = limit - length

    return string .. string.rep(" ", charsNeeded)
end