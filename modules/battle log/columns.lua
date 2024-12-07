Blog.Columns = T{}

------------------------------------------------------------------------------------------------------
-- Creates a name string for display in the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Name = function(player_name, pet_name)
    if Blog.Settings.Mask_Names then player_name = Blog.Columns.Job(player_name) end
    if pet_name ~= Blog.Enum.NO_PET then
        local combined_string = player_name .. " (" .. pet_name .. ")"
        if string.len(combined_string) > Blog.Enum.TRUNCATE_TOTAL then
            local truncated_pet = Blog.Dependencies.String_Truncate(pet_name, Blog.Enum.TRUNCATE_PET, true)
            local truncated_player = Blog.Dependencies.String_Truncate(player_name, Blog.Enum.TRUNCATE_PLAYER)
            combined_string = truncated_player .. " (" .. truncated_pet .. ")"
        end
        return Blog.Dependencies.String_Set_Length(combined_string, Blog.Enum.TRUNCATE_TOTAL)
    end
    player_name = Blog.Dependencies.String_Set_Length(player_name, Blog.Enum.TRUNCATE_TOTAL)
    return player_name
end

------------------------------------------------------------------------------------------------------
-- Gets the player's job for name masking.
-- Don't need the color because it gets saved when the entry is saved.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Job = function(player_name)
    local anon_string = "NON0/NON0"
    local hide_subjob = Blog.Settings.Hide_Subjobs
    local player_info = Blog.Dependencies.Check_Party(player_name)
    if hide_subjob then anon_string = "NON0" end

    if not player_name or not player_info then return anon_string end

    local main = Blog.Dependencies.Job_Data(player_info.main)
    local main_level = player_info.main_level
    if not main then main = Blog.Dependencies.Job_Data(0) end
    local main_string = string.format("%s%02d", main.ens, main_level)

    local sub_string = ""
    if not hide_subjob then
        local sub = Blog.Dependencies.Job_Data(player_info.sub)
        local sub_level = player_info.sub_level
        if not sub then sub = Blog.Dependencies.Job_Data(0) end
        sub_string = "/" .. string.format("%s%02d", sub.ens, sub_level)
    end

    return main_string .. sub_string
end

------------------------------------------------------------------------------------------------------
-- Formats the damage string.
------------------------------------------------------------------------------------------------------
---@param damage string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Damage = function(damage)
    return Blog.Dependencies.String_Set_Length(damage, Blog.Enum.TRUNCATE_DAMAGE)
end

------------------------------------------------------------------------------------------------------
-- Formats the action name.
------------------------------------------------------------------------------------------------------
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Action = function(action_name)
    action_name = Blog.Dependencies.String_Truncate(action_name, Blog.Enum.TRUNCATE_ACTION)
    return action_name
end

------------------------------------------------------------------------------------------------------
-- Formats the note.
------------------------------------------------------------------------------------------------------
---@param note string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Notes = function(note)
    note = Blog.Dependencies.String_Truncate(note, Blog.Enum.TRUNCATE_ACTION)
    note = Blog.Dependencies.String_Set_Length(note, Blog.Enum.TRUNCATE_ACTION)
    return note
end
