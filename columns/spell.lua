Column.Spell = T{}

------------------------------------------------------------------------------------------------------
-- Shows MP a player has used.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param magic_type string
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.MP = function(player_name, magic_type, justify)
    if not magic_type then magic_type = Column.Trackable.MAGIC end
    local mp = 0
    if magic_type == "Other" then
        local total = DB.Data.Get(player_name, Column.Trackable.MAGIC, Column.Metric.MP_SPENT)
        local healing = DB.Data.Get(player_name, Column.Trackable.HEALING, Column.Metric.MP_SPENT)
        local nuke = DB.Data.Get(player_name, Column.Trackable.NUKE, Column.Metric.MP_SPENT)
        local enfeeble = DB.Data.Get(player_name, Column.Trackable.ENFEEBLE, Column.Metric.MP_SPENT)
        local enspell = DB.Data.Get(player_name, Column.Trackable.ENSPELL, Column.Metric.MP_SPENT)
        local mp_drain = DB.Data.Get(player_name, Column.Trackable.MP_DRAIN, Column.Metric.MP_SPENT)
        mp = total - healing - nuke - enfeeble - enspell - mp_drain
    else
        mp = DB.Data.Get(player_name, magic_type, Column.Metric.MP_SPENT)
    end
    local color = Column.String.Color_Zero(mp)
    return UI.TextColored(color, Column.String.Format_Number(mp, justify))
end

------------------------------------------------------------------------------------------------------
-- Shows many much MP is used per damage or healing done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param magic_type string
---@return string
------------------------------------------------------------------------------------------------------
Column.Spell.Unit_Per_MP = function(player_name, magic_type)
    local mp = DB.Data.Get(player_name, magic_type, Column.Metric.MP_SPENT)
    local unit = DB.Data.Get(player_name, magic_type, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(unit)
    return UI.TextColored(color, string.format("%.1f", Column.String.Raw_Percent(unit, mp)))
end