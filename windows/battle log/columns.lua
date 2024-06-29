Blog.Columns = T{}

------------------------------------------------------------------------------------------------------
-- Creates a name string for display in the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@return string
------------------------------------------------------------------------------------------------------
Blog.Columns.Name = function(player_name, pet_name)
    player_name = Column.String.Truncate(player_name, Blog.Settings.Truncate_Length)
    if pet_name == Blog.Enum.Text.NO_PET then
        return player_name
    end
    pet_name = " (" .. Column.String.Truncate(pet_name, Blog.Settings.Pet_Name_Truncate_Length) .. ")"
    return player_name .. pet_name
end

------------------------------------------------------------------------------------------------------
-- Formats the action name.
------------------------------------------------------------------------------------------------------
---@param action_name string
------------------------------------------------------------------------------------------------------
Blog.Columns.Action = function(action_name)
    if Metrics.Blog.Flags.Truncate_Actions then
        action_name = Column.String.Truncate(action_name, Blog.Settings.Action_Truncate_Length)
    end
    return action_name
end