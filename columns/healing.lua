Column.Healing = { }

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param percent?   boolean whether or not the damage should be raw or percent.
---@param justify?   boolean whether or not to right justify the text
---@param raw?       boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Healing.Total = function(playerName, percent, justify, raw)
    local spellHealing   = DB.Data.Get(playerName, DB.Trackable.SPELLS_HEALING, DB.Metric.TOTAL)
    local abilityHealing = DB.Data.Get(playerName, DB.Trackable.ABILITY_HEALING, DB.Metric.TOTAL)
    local totalHealing   = spellHealing + abilityHealing
    local color          = Column.String.ColorZero(totalHealing)

    if percent then
        local totalDamage = Column.Damage.RawTotalPlayerDamage(playerName)

        if raw then
            return Column.String.FormatPercent(totalHealing, totalDamage)
        end

        return UI.TextColored(color, Column.String.FormatPercent(totalHealing, totalDamage, justify))
    end

    if raw then
        return Column.String.FormatNumber(totalHealing)
    end

    return UI.TextColored(color, Column.String.FormatNumber(totalHealing, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the overcure amount for the player.
------------------------------------------------------------------------------------------------------
---@param playerName string
---@param justify?   boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Healing.Overcure = function(playerName, justify)
    local overcure = DB.Data.Get(playerName, DB.Trackable.SPELLS_HEALING, DB.Metric.OVERCURE)
    local color    = Column.String.ColorZero(overcure)

    return UI.TextColored(color, Column.String.FormatNumber(overcure, justify))
end