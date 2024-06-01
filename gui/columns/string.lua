Column.String = T{}

------------------------------------------------------------------------------------------------------
-- Create a nicely formatted number string.
-- I floor the number to get rid of any decimals. Decimals were a problem with the average column.
------------------------------------------------------------------------------------------------------
---@param number number this should be an actual number and not a string.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.String.Format_Number = function(number, justify)
    local format = "%d"
    if justify then format = "%6d" end
    if Parse.Config.Condensed_Numbers() then return Column.String.Compact_Number(number, justify) end
    number = math.floor(number)
    return string.format(format, number)
end

------------------------------------------------------------------------------------------------------
-- Calculates and formats a percent.
------------------------------------------------------------------------------------------------------
---@param numerator number The numerator for the percent.
---@param denominator number The denominator for the percent.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.String.Format_Percent = function(numerator, denominator, justify)
    local format = "%.1f"
    if justify then format = "%5.1f" end

    local percent = 0
    local ret_value = string.format(format, 0)
    if denominator and denominator ~= 0 then percent = (numerator / denominator) * 100 end
    if percent ~= 0 then ret_value = string.format(format, percent) end

    if Focus.Config.Show_Percent_Details and not Report.Publishing.Lock then
        format = "%d"
        local top = "N: " .. string.format(format, numerator)
        local bottom = "D: " .. string.format(format, denominator)
        return tostring(ret_value) .. "\n" .. tostring(top) .. "\n" .. tostring(bottom)
    end

    return ret_value
end

------------------------------------------------------------------------------------------------------
-- Calculates and returns a raw percent as a number.
------------------------------------------------------------------------------------------------------
---@param numerator number The numerator for the percent.
---@param denominator number The denominator for the percent.
---@return number
------------------------------------------------------------------------------------------------------
Column.String.Raw_Percent = function(numerator, denominator)
    if not denominator or denominator == 0 then return 0 end
    return numerator / denominator
end

------------------------------------------------------------------------------------------------------
-- Handles formatting numbers into a more compact easier to read mode (with rounding).
-- Mode examples: Compact = 2.5M; Regular = 2,500,000
------------------------------------------------------------------------------------------------------
---@param number number this should be an actual number and not a string.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.String.Compact_Number = function(number, justify)
    number = number or 0

    local display_number, suffix
    local length = 6

    -- Millions
    if number >= 1000000 then
        display_number = (number / 1000000)
        suffix = " M"
        length = length - 2
    -- Thousands
    elseif number >= 1000 then
        display_number = (number / 1000)
        suffix = " K"
        length = length - 2
    -- No adjustments necessary
    else
        display_number = number
        suffix = ""
    end

    local format = "%d"
    if justify then format = "%" .. length .. "d" end

    if number == 0 then return string.format(format, number) end

    return string.format(format, display_number) .. suffix
end

------------------------------------------------------------------------------------------------------
-- Truncates a string if it is too long.
------------------------------------------------------------------------------------------------------
---@param string string
---@param limit number
---@return string
------------------------------------------------------------------------------------------------------
Column.String.Truncate = function(string, limit)
    local length = string.len(string)
    if length <= limit then return string end
    return string.sub(string, 1, limit) .. "."
end

------------------------------------------------------------------------------------------------------
-- Makes zero values dim.
------------------------------------------------------------------------------------------------------
---@param value number
---@return table
------------------------------------------------------------------------------------------------------
Column.String.Color_Zero = function(value)
    if value == 0 then return Res.Colors.Basic.DIM end
    return Res.Colors.Basic.WHITE
end