XP.Dedication = {}

XP.Dedication.Is_Active       = true
XP.Dedication.Need_Defaulting = false
XP.Dedication.Need_Clear      = false
XP.Dedication.Zone_Delay      = 10

-- ------------------------------------------------------------------------------------------------------
-- Checks if dedication is active.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Check = function()
    XP.Dedication.Is_Active = Ashita.Player.HasBuff(Ashita.Player.Buffs.DEDICATION)

    -- There is a zone delay to prevent checking boost status while buffs are temporarily gone after zoning.
    if not XP.Dedication.Is_Active and not Ashita.States.Zoning and XP.Dedication.Need_Clear and
    Timers.GetDuration(Timers.Enum.Names.ZONE) > XP.Dedication.Zone_Delay then
        XP.Dedication.Clear()

    -- If dedication buff is active, but we don't know what boost item was used, fall back to the default if configured.
    elseif XP.Dedication.Is_Active and XP.Dedication.Need_Defaulting then
        local default_item = Res.Items.Dedication[0]    -- Default to Unknown item.
        if XP.Settings.Boost_Defaulting_Enabled then
            local default_item_id = Res.Items.Get_Dedication_ID_From_Name(XP.Settings.Boost_Item_Default_Name)
            default_item = Res.Items.Dedication[default_item_id]
        end
        XP.Dedication.Set(default_item)

    -- Base dedication is active state.
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

    local bonus_xp = XP.Settings.Boost_XP_Acquired
    local max_xp   = XP.Settings.Boost_Item_Max
    if not max_xp or max_xp == 0 then max_xp = 1 end

    return bonus_xp / max_xp
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much boost XP remains before wearing off.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.XP_Remaining = function()
    if not XP.Dedication.Is_Active then return 0 end

    local bonus_xp = XP.Settings.Boost_XP_Acquired
    local max_xp   = XP.Settings.Boost_Item_Max

    local remaining_boost = max_xp - bonus_xp
    if remaining_boost < 0 then remaining_boost = 0 end

    return remaining_boost
end

-- ------------------------------------------------------------------------------------------------------
-- Sets dedication flags.
-- ------------------------------------------------------------------------------------------------------
---@param item? table
---@param from_packet? boolean if the call comes from a packet then a real item was used.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Set = function(item, from_packet)
    if item and item.name then
        XP.Dedication.Is_Active = true              -- Need to set manually when item is used.
        XP.Settings.Boost_Item_Name = item.name
        XP.Settings.Boost_Item_Rate = item.boost
        XP.Settings.Boost_Item_Max  = item.max

        -- Real item was used. Don't need to rely on defaults.
        if from_packet then XP.Dedication.Need_Defaulting = false end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Clears dedication flags.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Clear = function()
    XP.Settings.Boost_Item_Name   = "None"
    XP.Settings.Boost_Item_Rate   = 0
    XP.Settings.Boost_Item_Max    = 0
    XP.Settings.Boost_XP_Acquired = 0
    XP.Dedication.Need_Defaulting = true
    XP.Dedication.Need_Clear      = false
    Window_Manager.Set_Bar_Delay()
end