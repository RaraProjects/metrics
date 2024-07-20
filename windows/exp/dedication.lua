XP.Dedication = T{}

XP.Dedication.Is_Active = true
XP.Dedication.Item  = "None"
XP.Dedication.Rate  = 0
XP.Dedication.Max   = 0
XP.Dedication.Need_Defaulting = true
XP.Dedication.Need_Clear      = true

-- ------------------------------------------------------------------------------------------------------
-- Checks if dedication is active.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Check = function()
    XP.Dedication.Is_Active = Ashita.Player.Has_Buff(Ashita.Player.Buffs.DEDICATION)

    print("Dedication.Check: Is: " .. tostring(XP.Dedication.Is_Active) .. " Default: " .. tostring(XP.Dedication.Need_Defaulting))

    if not XP.Dedication.Is_Active and not Ashita.States.Zoning and XP.Dedication.Need_Clear then
        print("Dedication.Check: Clear")
        XP.Dedication.Clear()

    -- Is active and needs defaulting.
    elseif XP.Dedication.Is_Active and XP.Dedication.Need_Defaulting then
        print("Dedication.Check: Defaulting")
        local default_item = Res.Items.Get_Dedication(0)
        if Metrics.XP.Boost_Default then
            local default_item_id = Res.Items.Get_Dedication_ID_From_Name(Metrics.XP.Boost_Item_Default_Name)
            default_item = Res.Items.Get_Dedication(default_item_id)
        end
        XP.Dedication.Set(default_item)

    elseif XP.Dedication.Is_Active then
        XP.Dedication.Need_Clear = true

    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks dedication progress.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Progress = function()
    if not XP.Dedication.Is_Active then return 0 end
    local bonus_xp = XP.Metric.Experience_Boosted + XP.Metric.Limit_Boosted
    local max_xp = XP.Dedication.Max
    if not max_xp or max_xp == 0 then max_xp = 1 end
    return bonus_xp / max_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Sets dedication flags.
-- ------------------------------------------------------------------------------------------------------
---@param item? table
---@param from_packet? boolean if the call comes from a packet then a real item was used.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Set = function(item, from_packet)
    if item and item.name then
        XP.Dedication.Is_Active = true  -- Need to set manually when item is used.
        XP.Dedication.Item = item.name
        XP.Dedication.Rate = item.boost
        XP.Dedication.Max  = item.max
        if from_packet then XP.Dedication.Need_Defaulting = false end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Clears dedication flags.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Clear = function()
    XP.Dedication.Item = "None"
    XP.Dedication.Rate = 0
    XP.Dedication.Max  = 0
    XP.Dedication.Need_Defaulting = true
    XP.Dedication.Need_Clear = false
end