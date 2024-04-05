--[[
    DESCRIPTION:    Checks to see if a given string matches your character's name.
    PARAMETERS :
        string      Entity data array
    RETURNS    :    TRUE: This is you; FALSE: This is not you
]]
function Is_Me(string)
    local player = windower.ffxi.get_player()

    -- Run-time error prevention
    if (not player) then return false end

    local match = false
    if (player.name == string) then match = true end

    return match
end

--[[
    DESCRIPTION:
    PARAMETERS :
]]
function Build_Arg_String(args)
    local arg_count = Count_Table_Elements(args)
    local arg_string = ""
    local space = ""

    for i = 1, arg_count, 1 do
        if (i == 1) then space = "" else space = " " end
        arg_string = arg_string..space..args[i]
    end

    return arg_string
end

--[[
    DESCRIPTION:    Count the number of elements in the battle log.
]]
function Count_Table_Elements(table)
    local count = 0

    for _, _ in ipairs(table) do
        count = count + 1
    end

    return count
end

