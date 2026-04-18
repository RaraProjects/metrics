Column.Spell = { }

------------------------------------------------------------------------------------------------------
-- Shows MP a player has used.
------------------------------------------------------------------------------------------------------
---@param playerName  string
---@param trackable   string
---@param actionName? string
---@param burst?      boolean
---@param justify?    boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.MpUsed = function(playerName, trackable, actionName, burst, justify)
    local mp = 0
    trackable = trackable or DB.Trackable.SPELLS_OVERALL

    if trackable == "Other" then
        local total    = DB.Data.Get(playerName, DB.Trackable.SPELLS_OVERALL,    DB.Metric.MP_SPENT)
        local healing  = DB.Data.Get(playerName, DB.Trackable.SPELLS_HEALING,    DB.Metric.MP_SPENT)
        local nuke     = DB.Data.Get(playerName, DB.Trackable.SPELLS_NUKING,     DB.Metric.MP_SPENT)
        local enfeeble = DB.Data.Get(playerName, DB.Trackable.SPELLS_ENFEEBLING, DB.Metric.MP_SPENT)
        local enspell  = DB.Data.Get(playerName, DB.Trackable.MELEE_ENSPELL,     DB.Metric.MP_SPENT)
        local mpDrain  = DB.Data.Get(playerName, DB.Trackable.SPELLS_MP_DRAIN,   DB.Metric.MP_SPENT)

        mp = total - healing - nuke - enfeeble - enspell - mpDrain

    elseif actionName then
        mp = DB.Catalog.Get(playerName, trackable, actionName, DB.Metric.MP_SPENT)

    else
        mp = DB.Data.Get(playerName, trackable, DB.Metric.MP_SPENT)
    end

    local finalMP = mp

    if burst then
        local nukeTargets   = DB.Data.Get(playerName, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
        local burstAttempts = DB.Data.Get(playerName, trackable, DB.Metric.CRITICAL_COUNT)
        local mpPerTarget   = mp / nukeTargets
        local burstMP       = mpPerTarget * burstAttempts
        finalMP             = burstMP
    end

    local color = Column.String.ColorZero(finalMP)

    return Column.Output.Number(finalMP, color, justify)
end

------------------------------------------------------------------------------------------------------
-- Shows many much MP is used per damage or healing done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param trackable  DB.Trackable
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.UnitPerMP = function(playerName, trackable)
    local mp    = DB.Data.Get(playerName, trackable, DB.Metric.MP_SPENT)
    local unit  = DB.Data.Get(playerName, trackable, DB.Metric.TOTAL)
    local color = Column.String.ColorZero(unit)

    return UI.TextColored(color, Column.String.FormatPercent(unit, mp, false, true))
end