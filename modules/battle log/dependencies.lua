Blog.Dependencies = {}

------------------------------------------------------------------------------------------------------
-- Checks the mask names setting.
------------------------------------------------------------------------------------------------------
Blog.Dependencies.Mask_Names = function()
    return Parse.Config.Is_Masking_Names()
end

------------------------------------------------------------------------------------------------------
-- Connect to Ashita to see if there is party data for a player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return nil|table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.Check_Party = function(player_name)
    return Ashita.Party.GetMember(player_name)
end

------------------------------------------------------------------------------------------------------
-- Element color from the resource file.
------------------------------------------------------------------------------------------------------
---@param element_id integer
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.Element_Color = function(element_id)
    return Res.Colors.Get_Element(element_id)
end

------------------------------------------------------------------------------------------------------
-- Job color from the resource file.
------------------------------------------------------------------------------------------------------
---@param job_id integer
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.Job_Color = function(job_id)
    return Res.Colors.Get_Job(job_id)
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
---@param job_id integer
---@return table
------------------------------------------------------------------------------------------------------
Blog.Dependencies.Job_Data = function(job_id)
    if not job_id then job_id = 0 end
    return Res.Jobs.Get_Job(job_id)
end

------------------------------------------------------------------------------------------------------
-- Truncate a string.
------------------------------------------------------------------------------------------------------
---@param original_string string
---@param length integer
---@param ignore_dot? boolean
---@return string
------------------------------------------------------------------------------------------------------
Blog.Dependencies.String_Truncate = function(original_string, length, ignore_dot)
    return Column.String.Truncate(original_string, length, ignore_dot)
end

------------------------------------------------------------------------------------------------------
-- Pad a string if necessary.
------------------------------------------------------------------------------------------------------
---@param original_string string
---@param length integer
---@return string
------------------------------------------------------------------------------------------------------
Blog.Dependencies.String_Set_Length = function(original_string, length)
    return Column.String.Set_Length(original_string, length)
end

------------------------------------------------------------------------------------------------------
-- Formats a number into a string.
------------------------------------------------------------------------------------------------------
---@param value integer
---@return string
------------------------------------------------------------------------------------------------------
Blog.Dependencies.String_Format_Number = function(value)
    return Column.String.Format_Number(value)
end