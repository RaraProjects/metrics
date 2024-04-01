Column_Widths = {
    ['name']     = 15,
    ['dmg']      = 11,
    ['comp dmg'] = 7,
    ['percent']  = 8,
    ['small']    = 8,
    ['single']   = 4
}

--[[
    DESCRIPTION:    Gets some data about who is taking the action.
    PARAMETERS :
        entity_id   ID of the entity.
    RETURNS    :    Table containing discrete data about the entity.
]] 
function Get_Entity_Data(entity_id)
    if (entity_id == nil) then return end

    local entity = windower.ffxi.get_mob_by_id(entity_id)
    if (entity == nil) then return end

    local entity_data = {}
    entity_data['name']        = entity.name
    entity_data['is_npc']      = entity.is_npc
    entity_data['is_party']    = entity.in_party
    entity_data['is_alliance'] = entity.in_alliance
    entity_data['mob_type']    = entity.entity_type
    entity_data['spawn_type']  = entity.spawn_type
    entity_data['pet_index']   = entity.pet_index

    return entity_data
end

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

--[[
    DESCRIPTION:
]]
function Get_Discrete_Melee_Type(animation_id)

    if (animation_id == 0) then
        return 'melee primary'

    elseif (animation_id == 1) then
        return 'melee secondary'

    elseif (animation_id == 2) or (animation_id == 3) then
        return 'melee kicks'

    elseif (animation_id == 4) then
        return 'throwing'

    else
        return 'default'
    end

end