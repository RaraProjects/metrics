XP.Local = T{}
XP.Local.EXP_Buckets = T{}
XP.Local.LP_Buckets = T{}
XP.Local.Bucket_Length = 30 -- seconds
XP.Local.Bucket_Max    = 16  -- Total average window of 8 minutes (30 seconds * 16 buckets)
XP.Local.EXP_Rate = 0
XP.Local.LP_Rate = 0
XP.Local.Show_Windows = false

-- ------------------------------------------------------------------------------------------------------
-- Initializes the local XP tracking table.
-- ------------------------------------------------------------------------------------------------------
XP.Local.Initialize = function()
    for i = 1, XP.Local.Bucket_Max do
        table.insert(XP.Local.EXP_Buckets, 0)
        table.insert(XP.Local.LP_Buckets, 0)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Add XP to current window. More recent XP goes earlier on in the table.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@param type string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Add_XP = function(amount, type)
    if not amount then amount = 0 end
    if type == XP.Type.EXPERIENCE then
        XP.Local.EXP_Buckets[1] = XP.Local.EXP_Buckets[1] + amount
    elseif type == XP.Type.LIMIT then
        XP.Local.LP_Buckets[1] = XP.Local.LP_Buckets[1] + amount
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Gets rid of old data in the current XP tracking windows.
-- ------------------------------------------------------------------------------------------------------
XP.Local.Cycle_Window = function()
    table.remove(XP.Local.EXP_Buckets)        -- Get rid of the last element (oldest XP).
    table.insert(XP.Local.EXP_Buckets, 1, 0)  -- Add a new blank element at index [1].
    table.remove(XP.Local.LP_Buckets)
    table.insert(XP.Local.LP_Buckets, 1, 0)
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the local XP tracking value.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Get_XP = function(type)
    local total_xp = XP.Local.XP_In_Window(type)
    local average_xp = (total_xp / XP.Local.Window_Length()) * 3600
    XP.Local.Set_Rate(average_xp, type)
    return string.format("%d", average_xp)
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
---@return integer
-- ------------------------------------------------------------------------------------------------------
XP.Local.XP_In_Window = function(type)
    local total_xp = 0
    if type == XP.Type.EXPERIENCE then
        for _, window_xp in ipairs(XP.Local.EXP_Buckets) do total_xp = total_xp + window_xp end
    elseif type == XP.Type.LIMIT then
        for _, window_xp in ipairs(XP.Local.LP_Buckets) do total_xp = total_xp + window_xp end
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
    if type == XP.Type.EXPERIENCE then
        XP.Local.EXP_Rate = rate
    elseif type == XP.Type.LIMIT then
        XP.Local.LP_Rate = rate
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the xp/hr rate.
-- ------------------------------------------------------------------------------------------------------
---@param type string
-- ------------------------------------------------------------------------------------------------------
XP.Local.Get_Rate = function(type)
    if type == XP.Type.EXPERIENCE then
        return XP.Local.EXP_Rate
    elseif type == XP.Type.LIMIT then
        return XP.Local.LP_Rate
    else
        return 0
    end
end