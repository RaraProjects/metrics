XP.Dedication = T{}

XP.Dedication.Is_Active = true
XP.Dedication.Need_Defaulting = false
XP.Dedication.Need_Clear      = false
XP.Dedication.Zone_Delay      = 10

-- ------------------------------------------------------------------------------------------------------
-- Checks if dedication is active.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Check = function()
    XP.Dedication.Is_Active = Ashita.Player.Has_Buff(Ashita.Player.Buffs.DEDICATION)

    if not XP.Dedication.Is_Active and not Ashita.States.Zoning and XP.Dedication.Need_Clear
    and Timers.Get_Duration(Timers.Enum.Names.ZONE) > XP.Dedication.Zone_Delay then
        XP.Dedication.Clear()

    elseif XP.Dedication.Is_Active and XP.Dedication.Need_Defaulting then
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
    local bonus_xp = Metrics.XP.Boost_EXP
    local max_xp = Metrics.XP.Boost_Item_Max
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
        Metrics.XP.Boost_Item_Name = item.name
        Metrics.XP.Boost_Item_Rate = item.boost
        Metrics.XP.Boost_Item_Max  = item.max
        if from_packet then XP.Dedication.Need_Defaulting = false end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Clears dedication flags.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Clear = function()
    Metrics.XP.Boost_Item_Name = "None"
    Metrics.XP.Boost_Item_Rate = 0
    Metrics.XP.Boost_Item_Max  = 0
    Metrics.XP.Boost_EXP       = 0
    XP.Dedication.Need_Defaulting = true
    XP.Dedication.Need_Clear = false
    Window.Set_Bar_Delay()
end