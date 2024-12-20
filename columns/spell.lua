Column.Spell = {}

------------------------------------------------------------------------------------------------------
-- Shows MP a player has used.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.MP_Used = function(player_name, trackable, justify)
    if not trackable then trackable = DB.Trackable.SPELLS_OVERALL end

    local mp = 0
    if trackable == "Other" then
        local total    = DB.Data.Get(player_name, DB.Trackable.SPELLS_OVERALL,    DB.Metric.MP_SPENT)
        local healing  = DB.Data.Get(player_name, DB.Trackable.SPELLS_HEALING,    DB.Metric.MP_SPENT)
        local nuke     = DB.Data.Get(player_name, DB.Trackable.SPELLS_NUKING,     DB.Metric.MP_SPENT)
        local enfeeble = DB.Data.Get(player_name, DB.Trackable.SPELLS_ENFEEBLING, DB.Metric.MP_SPENT)
        local enspell  = DB.Data.Get(player_name, DB.Trackable.MELEE_ENSPELL,     DB.Metric.MP_SPENT)
        local mp_drain = DB.Data.Get(player_name, DB.Trackable.SPELLS_MP_DRAIN,   DB.Metric.MP_SPENT)
        mp = total - healing - nuke - enfeeble - enspell - mp_drain
    else
        mp = DB.Data.Get(player_name, trackable, DB.Metric.MP_SPENT)
    end

    local color = Column.String.Color_Zero(mp)

    return Column.Output.Number(mp, color, justify)
end

------------------------------------------------------------------------------------------------------
-- This is for cataloged actions.
-- Returns how much total MP was used for a specific spell.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string a trackable from the model.
---@param action_name string
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.MP_Used_Catalog = function(player_name, trackable, action_name)
    local mp = DB.Catalog.Get(player_name, trackable, action_name, DB.Metric.MP_SPENT)
    local color = Column.String.Color_Zero(mp)
    return UI.TextColored(color, Column.String.Format_Number(mp))
end

------------------------------------------------------------------------------------------------------
-- Shows many much MP is used per damage or healing done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param trackable string
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.Unit_Per_MP = function(player_name, trackable)
    local mp = DB.Data.Get(player_name, trackable, DB.Metric.MP_SPENT)
    local unit = DB.Data.Get(player_name, trackable, DB.Metric.TOTAL)
    local color = Column.String.Color_Zero(unit)
    return UI.TextColored(color, Column.String.Format_Percent(unit, mp, false, true))
end