Column.Damage = T{}

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.By_Type = function(player_name, damage_type, percent, justify, raw)
    local focused_damage = DB.Data.Get(player_name, damage_type, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(focused_damage)
    if percent then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        if raw then return Column.String.Format_Percent(focused_damage, total_damage) end
        return UI.TextColored(color, Column.String.Format_Percent(focused_damage, total_damage, justify))
    end
    if raw then return Column.String.Format_Number(focused_damage) end
    return UI.TextColored(color, Column.String.Format_Number(focused_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity has done. Returns the raw number.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@return number
------------------------------------------------------------------------------------------------------
Column.Damage.By_Type_Raw = function(player_name, damage_type)
    return DB.Data.Get(player_name, damage_type, Column.Metric.TOTAL)
end

------------------------------------------------------------------------------------------------------
-- Grabs the damage of a certain trackable that the entity's pet has done.
------------------------------------------------------------------------------------------------------
---@param player_name string the entity that owns the pet.
---@param pet_name string the pet that we want the damage for.
---@param damage_type string a trackable from the model.
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param all_total? boolean controls denominator for %; true = pet total; false = all total
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Pet_By_Type = function(player_name, pet_name, damage_type, percent, justify, all_total)
    local focused_damage = DB.Pet_Data.Get(player_name, pet_name, damage_type, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(focused_damage)
    if percent then
        local total_damage = DB.Data.Get(player_name, Column.Trackable.PET, Column.Metric.TOTAL)
        if all_total then total_damage = DB.Data.Get(player_name, Column.Trackable.TOTAL, Column.Metric.TOTAL) end
        return UI.TextColored(color, Column.String.Format_Percent(focused_damage, total_damage, justify))
    end
    return UI.TextColored(color, Column.String.Format_Number(focused_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the magic burst damage for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param magic_only? boolean whether or not the denominator for percent should be total damage or just magic damage.
---@param justify? boolean whether or not to right justify the text
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Burst = function(player_name, percent, magic_only, justify)
    local focused_damage = DB.Data.Get(player_name, Column.Trackable.MAGIC, Column.Metric.BURST_DAMAGE)
    local color = Column.String.Color_Zero(focused_damage)
    if percent then
        local total_damage = Column.Damage.Raw_Total_Player_Damage(player_name)
        if magic_only then
            total_damage = DB.Data.Get(player_name, Column.Trackable.MAGIC, Column.Metric.TOTAL)
        end
        return UI.TextColored(color, Column.String.Format_Percent(focused_damage, total_damage, justify))
    end
    return UI.TextColored(color, Column.String.Format_Number(focused_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param percent? boolean whether or not the damage should be raw or percent.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Total = function(player_name, percent, justify, raw)
    local grand_total = Column.Damage.Raw_Total_Player_Damage(player_name)
    local color = Column.String.Color_Zero(grand_total)

    if percent then
        local party_damage = DB.Team_Damage()
        if raw then return Column.String.Format_Percent(grand_total, party_damage) end
        return UI.TextColored(color, Column.String.Format_Percent(grand_total, party_damage, justify))
    end

    if raw then return Column.String.Format_Number(grand_total) end
    return UI.TextColored(color, Column.String.Format_Number(grand_total, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage percentage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param damage_type string a trackable from the model.
---@param justify? boolean whether or not to right justify the text
---@param raw? boolean true: just output the raw value; false: output a column to a table.
---@return string
------------------------------------------------------------------------------------------------------
Column.Damage.Percent_Total_By_Type = function(player_name, damage_type, justify, raw)
    local total = DB.Data.Get(player_name, damage_type, Column.Metric.TOTAL)
    local color = Column.String.Color_Zero(total)
    local team_damage = DB.Team_Damage_By_Type(damage_type)
    if raw then return Column.String.Format_Percent(total, team_damage) end
    return UI.TextColored(color, Column.String.Format_Percent(total, team_damage, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total running damage for the player.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param justify? boolean whether or not to right justify the text
------------------------------------------------------------------------------------------------------
Column.Damage.DPS = function(player_name, justify)
    local dps = DB.DPS.Get_DPS(player_name)
    local color = Column.String.Color_Zero(dps)
    return UI.TextColored(color, Column.String.Format_Number(dps, justify))
end

------------------------------------------------------------------------------------------------------
-- Grabs the total damage that the entity has done.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return number
------------------------------------------------------------------------------------------------------
Column.Damage.Raw_Total_Player_Damage = function(player_name)
    if player_name then
        if Parse.Config.Include_SC_Damage() then
            return DB.Data.Get(player_name, Column.Trackable.TOTAL, Column.Metric.TOTAL)
        else
            return DB.Data.Get(player_name, Column.Trackable.TOTAL_NO_SC, Column.Metric.TOTAL)
        end
    end
    return 0
end