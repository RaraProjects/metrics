Blog.Columns = T{}

------------------------------------------------------------------------------------------------------
-- Creates a name string for display in the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Name = function(player_name, pet_name)
    if Metrics.Parse.Hide_Name then player_name = Blog.Columns.Job(player_name) end
    if pet_name ~= Blog.Enum.Text.NO_PET then
        local combined_string = player_name .. " (" .. pet_name .. ")"
        if string.len(combined_string) > Blog.Settings.Truncate_Length then
            local truncated_pet = Column.String.Truncate(pet_name, Blog.Settings.Pet_Name_Truncate_Length, true)
            local truncated_player = Column.String.Truncate(player_name, Blog.Settings.Player_Name_Truncate_Length)
            combined_string = truncated_player .. " (" .. truncated_pet .. ")"
        end
        return Column.String.Set_Length(combined_string, Blog.Settings.Truncate_Length)
    end
    player_name = Column.String.Set_Length(player_name, Blog.Settings.Truncate_Length)
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
    local hide_subjob = Metrics.Parse.Hide_Subjob
    if hide_subjob then anon_string = "NON0" end
    if not player_name or not Ashita.Party.Jobs[player_name] then return anon_string end

    local main = Res.Jobs.Get_Job(Ashita.Party.Jobs[player_name].main)
    local main_level = Ashita.Party.Jobs[player_name].main_level
    if not main then main = Res.Jobs.List[0] end
    local main_string = string.format("%s%02d", main.ens, main_level)

    local sub_string = ""
    if not hide_subjob then
        local sub = Res.Jobs.Get_Job(Ashita.Party.Jobs[player_name].sub)
        local sub_level = Ashita.Party.Jobs[player_name].sub_level
        if not sub then sub = Res.Jobs.List[0] end
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
    return Column.String.Set_Length(damage, Blog.Settings.Damage_Truncate_Length)
end

------------------------------------------------------------------------------------------------------
-- Formats the action name.
------------------------------------------------------------------------------------------------------
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Action = function(action_name)
    action_name = Column.String.Truncate(action_name, Blog.Settings.Action_Truncate_Length)
    action_name = Column.String.Set_Length(action_name, Blog.Settings.Action_Truncate_Length)
    return action_name
end

------------------------------------------------------------------------------------------------------
-- Formats the note.
------------------------------------------------------------------------------------------------------
---@param note string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Notes = function(note)
    note = Column.String.Truncate(note, Blog.Settings.Action_Truncate_Length)
    note = Column.String.Set_Length(note, Blog.Settings.Action_Truncate_Length)
    return note
end
