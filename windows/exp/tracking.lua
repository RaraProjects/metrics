XP.Local = T{}
XP.Local.EXP_Buckets = T{}
XP.Local.EXP_Base_Buckets = T{}
XP.Local.LP_Buckets = T{}
XP.Local.LP_Base_Buckets = T{}
XP.Local.Bucket_Length = 30 -- seconds
XP.Local.Bucket_Max    = 16  -- Total average window of 8 minutes (30 seconds * 16 buckets)
XP.Local.EXP_Rate = 0
XP.Local.LP_Rate = 0
XP.Local.Show_Windows = false

-- ------------------------------------------------------------------------------------------------------
-- Initializes the local XP tracking table.
-- ------------------------------------------------------------------------------------------------------
XP.Local.Initialize = function()
    XP.Local.EXP_Buckets = T{}
    XP.Local.EXP_Base_Buckets = T{}
    XP.Local.LP_Buckets = T{}
    XP.Local.LP_Base_Buckets = T{}
    for i = 1, XP.Local.Bucket_Max do
        table.insert(XP.Local.EXP_Buckets, 0)
        table.insert(XP.Local.EXP_Base_Buckets, 0)
        table.insert(XP.Local.LP_Buckets, 0)
        table.insert(XP.Local.LP_Base_Buckets, 0)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Add XP to current window. More recent XP goes earlier on in the table.
-- ------------------------------------------------------------------------------------------------------
---@param base_xp integer
---@param bonus_xp integer
---@param type string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Add_XP = function(base_xp, bonus_xp, type)
    if not base_xp then base_xp = 0 end
    if not bonus_xp then bonus_xp = 0 end
    if type == XP.Type.EXPERIENCE then
        XP.Local.EXP_Buckets[1] = XP.Local.EXP_Buckets[1] + base_xp + bonus_xp
        XP.Local.EXP_Base_Buckets[1] = XP.Local.EXP_Base_Buckets[1] + base_xp
    elseif type == XP.Type.LIMIT then
        XP.Local.LP_Buckets[1] = XP.Local.LP_Buckets[1] + base_xp + bonus_xp
        XP.Local.LP_Base_Buckets[1] = XP.Local.LP_Base_Buckets[1] + base_xp
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Gets rid of old data in the current XP tracking windows.
-- ------------------------------------------------------------------------------------------------------
XP.Local.Cycle_Window = function()
    table.remove(XP.Local.EXP_Buckets)        -- Get rid of the last element (oldest XP).
    table.insert(XP.Local.EXP_Buckets, 1, 0)  -- Add a new blank element at index [1].
    table.remove(XP.Local.EXP_Base_Buckets)
    table.insert(XP.Local.EXP_Base_Buckets, 1, 0)
    table.remove(XP.Local.LP_Buckets)
    table.insert(XP.Local.LP_Buckets, 1, 0)
    table.remove(XP.Local.LP_Base_Buckets)
    table.insert(XP.Local.LP_Base_Buckets, 1, 0)
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the local XP tracking value.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@param base? boolean
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Get_XP_Rate = function(type, base)
    local total_xp = XP.Local.XP_In_Window(type, base)
    local average_xp = (total_xp / XP.Local.Window_Length()) * 3600
    XP.Local.Set_Rate(average_xp, type)
    local return_string = string.format("%d", average_xp)
    if not base and XP.Dedication.Is_Active then return_string = return_string .. "*" end
    return return_string
end

-- ------------------------------------------------------------------------------------------------------
-- Shows how much XP is in each bucket.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Bucket_View = function(type)
    local string = ""
    local total_xp = 0
    if type == XP.Type.EXPERIENCE then
        for _, window_xp in ipairs(XP.Local.EXP_Buckets) do
            string = string .. "|" .. tostring(window_xp)
            total_xp = total_xp + window_xp
        end
    elseif type == XP.Type.LIMIT then
        for _, window_xp in ipairs(XP.Local.LP_Buckets) do
            string = string .. "|" .. tostring(window_xp)
            total_xp = total_xp + window_xp
        end
    end
    return string
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the total amount of XP from within the window.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@param base? boolean
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Local.XP_In_Window = function(type, base)
    local total_xp = 0
    if type == XP.Type.EXPERIENCE then
        if base then
            for _, window_xp in ipairs(XP.Local.EXP_Base_Buckets) do total_xp = total_xp + window_xp end
        else
            for _, window_xp in ipairs(XP.Local.EXP_Buckets) do total_xp = total_xp + window_xp end
        end
    elseif type == XP.Type.LIMIT then
        if base then
            for _, window_xp in ipairs(XP.Local.LP_Base_Buckets) do total_xp = total_xp + window_xp end
        else
            for _, window_xp in ipairs(XP.Local.LP_Buckets) do total_xp = total_xp + window_xp end
        end
    end
    return total_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Returns window length in seconds.
-- ------------------------------------------------------------------------------------------------------
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Local.Window_Length = function()
    local length = XP.Local.Bucket_Length * XP.Local.Bucket_Max
    if length == 0 then length = 1 end
    return length
end

-- ------------------------------------------------------------------------------------------------------
-- Sets the xp/hr rate.
-- ------------------------------------------------------------------------------------------------------
---@param rate number
---@param type string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Set_Rate = function(rate, type)
    if not rate then rate = 0 end
    if     type == XP.Type.EXPERIENCE then XP.Local.EXP_Rate = rate
    elseif type == XP.Type.LIMIT      then XP.Local.LP_Rate = rate
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the xp/hr rate.
-- ------------------------------------------------------------------------------------------------------
---@param type string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Get_Rate = function(type)
    if     type == XP.Type.EXPERIENCE then return XP.Local.EXP_Rate
    elseif type == XP.Type.LIMIT      then return XP.Local.LP_Rate
    else   return 0
    end
end