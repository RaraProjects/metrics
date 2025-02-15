XP.Dedication = { }

XP.Dedication.IsActive       = true
XP.Dedication.NeedDefaulting = false
XP.Dedication.AwaitingClear  = false
XP.Dedication.ZoneDelay      = 10       -- It takes a moment for the dedication buff to load after zoning.

-- ------------------------------------------------------------------------------------------------------
-- Checks if dedication is active.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Refresh = function()
    local dedication = XP.Dedication

    dedication.IsActive = Ashita.Player.HasBuff(Ashita.Player.Buffs.DEDICATION)

    -- There is a zone delay to prevent checking boost status while buffs are temporarily gone after zoning.
    if not dedication.IsActive then
        if not Ashita.States.Zoning and Timers.GetDuration(Timers.Enum.Names.ZONE) > dedication.ZoneDelay and dedication.AwaitingClear then
            dedication.Clear()
        end

        return nil
    end

    -- If dedication buff is active, but we don't know what boost item was used, fall back to the default if configured.
    if dedication.NeedDefaulting then
        local defaultItemId = XP.Settings.Boost_Defaulting_Enabled and Res.Items.DedicationItemNameToId[XP.Settings.Boost_Item_Default_Name] or 0
        local defaultItem   = Res.Items.Dedication[defaultItemId] or Res.Items.Dedication[0]

        return dedication.Set(defaultItem)
    end

    dedication.AwaitingClear = true
end

-- ------------------------------------------------------------------------------------------------------
-- Checks dedication progress.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.GetProgress = function()
    if not XP.Dedication.IsActive then
        return 0
    end

    local bonusXp = XP.Settings.Boost_XP_Acquired
    local maxXp   = XP.Settings.Boost_Item_Max or 1

    if maxXp == 0 then
        maxXp = 1
    end

    return bonusXp / maxXp
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much boost XP remains before wearing off.
-- ------------------------------------------------------------------------------------------------------
---@return number
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.XpRemaining = function()
    if not XP.Dedication.IsActive then
        return 0
    end

    local bonusXp = XP.Settings.Boost_XP_Acquired or 0
    local maxXp   = XP.Settings.Boost_Item_Max or 0

    return math.max(maxXp - bonusXp, 0)
end

-- ------------------------------------------------------------------------------------------------------
-- Sets dedication flags.
-- ------------------------------------------------------------------------------------------------------
---@param item? table
---@param fromPacket? boolean if the call comes from a packet then a real item was used.
-- ------------------------------------------------------------------------------------------------------
XP.Dedication.Set = function(item, fromPacket)
    if item and item.name then
        XP.Dedication.IsActive      = true          -- Need to set manually when item is used.
        XP.Settings.Boost_Item_Name = item.name
        XP.Settings.Boost_Item_Rate = item.boost
        XP.Settings.Boost_Item_Max  = item.max

        -- Real item was used. Don't need to rely on defaults.
        if fromPacket then
            XP.Dedication.NeedDefaulting = false
        end
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
    XP.Dedication.NeedDefaulting  = true
    XP.Dedication.AwaitingClear   = false
    Window_Manager.SetBarDelay()
end