Default_String_Length = 15

--[[
    DESCRIPTION:    Create a nicely formatted string.
    PARAMETERS :
]]
function Format_String(str, length, color, line_color, align)
    local display_string

    -- Default coloring
    if not color then color = C_White end
    if not line_color then line_color = C_White end

    display_string = String_Length(str, length, align)
    display_string = color..display_string..line_color

    return display_string
end

--[[
    DESCRIPTION:    Create a nicely formatted number string.
    PARAMETERS :
        number          : Original number; this should be an actual number and not a string
]]
function Format_Number(number)
    -- Compact = 2.5M; Regular = 2,500,000
    if Monitor.Settings.Compact_Mode then
        return Compact_Number(number)
    end
    return Add_Comma(Remove_Zero(number))
end

---Calculates and formats a percent.
---@param num        number The numerator for the percent.
---@param denom      number The denominator for the percent.
function Format_Percent(num, denom)
    -- Can't divide by zero
    if not denom or denom == 0 then return "0" end

    local percent = (num / denom) * 100

    -- Zero should just be zero without any decimal points
    if percent == 0 then return "0" end

    -- Five total characters with one decimal precision (100.0)
    local percent_string = string.format("%.1f", percent)

    return tostring(percent_string)
end

--[[
    DESCRIPTION:
    PARAMETERS :
]]
function Compact_Number(number)
    number = number or 0

    local display_number
    local suffix
    local format = true

    -- Millions
    if number >= 1000000 then
        display_number = (number / 1000000)
        suffix = ' M'

    -- Thousands
    elseif number >= 1000 then
        display_number = (number / 1000)
        suffix = ' K'

    -- No adjustments necessary
    else
        display_number = number
        suffix = ''
        format = false
    end

    if number == 0 then return tostring(number) end

    -- Total length of 5 with one decimal point
    if format then display_number = string.format('%.1f', display_number) end
    display_number = display_number..suffix

    return tostring(display_number)
end

--[[
    DESCRIPTION:    Make a string be a certain length by adding spaces at the beginning or the end.
    PARAMETERS :
        str   : Original string (Default: 'BLANK')
        limit : Final string length
        align : TRUE = Right aligned; FALSE = Left aligned (Default: Left Aligned)
]]
function String_Length(str, limit, align)

    if (not str) then str = 'BLANK' end
    if (not limit) or (limit < 1) then limit = Default_String_Length end

    local string_length = string.len(str)
    local arg = '%.'..limit..'s'

    -- Truncate if too long
    if (string_length >= limit) then
        str = string.format(arg, str)

    -- Add spaces if too short
    else
        local fill_length = limit-string_length
        str = Fill_String(str, fill_length, ' ', align) end

    return str
end

--[[
    DESCRIPTION:    By default this fills the beginning or end of a string with blanks to make the
                    string a certain length.
    PARAMETERS :
        str        : Original string
        fill_length: How many spaces should be added
        char       : Character to use in the fill string (DEFAULT: ' ')
        align      : TRUE = Right aligned; FALSE = Left aligned (Default: Left Aligned)
]]
function Fill_String(str, fill_length, char, align) 

    if (not char) then char = ' ' end

    local fill_string   = string.rep(char, fill_length)
    local return_string = str..fill_string

    if align then return_string = fill_string..str end

    return return_string
end

--[[
    DESCRIPTION:    Adds commas to large numbers for easier readability.
    PARAMETERS :
        number      The number to be formatted with commas.
]] 
function Add_Comma(number)
    -- Take the string apart
    local str     = tostring(number)
    local length  = string.len(str)
    local numbers = {}
    for i = 1, length, 1 do numbers[i] = string.byte(str, i) end

    -- Rebuild adding a comma after every third number
    local new_str = ''
    local count = 0
    for i = length, 1, -1 do
        if count > 0 and (count % 3) == 0 then new_str = ','..new_str end
        new_str = string.char(numbers[i])..new_str
        count = count + 1
    end

    return new_str
end

--[[
    DESCRIPTION:    Makes zeroes invisible.
    PARAMETERS :
        number      The number to be checked if it is zero.
]] 
function Remove_Zero(number)
    if number == 0 or number == 999999 then
        return " "
    end
    return number
end