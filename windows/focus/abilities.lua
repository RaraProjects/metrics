Focus.Abilities = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Display = function(player_name, hide_publish)
    local ability_total = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, DB.Enum.Metric.COUNT)
    local healing_total = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_HEALING, DB.Enum.Metric.COUNT)
    local mp_recovery = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_MP_RECOVERY, DB.Enum.Metric.COUNT)
    local misc_count = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY, DB.Enum.Metric.COUNT)

    Focus.Abilities.Total(player_name)
    UI.Separator()

    if ability_total > 0 then Focus.Catalog.Abilities(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, "Damaging") end
    if healing_total > 0 then Focus.Catalog.Abilities(player_name, DB.Enum.Trackable.ABILITY_HEALING, "Healing") end
    if mp_recovery > 0   then Focus.Catalog.Abilities(player_name, DB.Enum.Trackable.ABILITY_MP_RECOVERY, "MP Recover") end
    if misc_count > 0 and Metrics.Focus.Show_Misc_Actions then Focus.Catalog.Abilities(player_name, DB.Enum.Trackable.ABILITY, "Ability") end

    if not hide_publish then Focus.Abilities.Publish(player_name, ability_total, healing_total) end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the ability table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Abilities.Total = function(player_name)
    local col_flags = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width = Column.Widths.Name
    local width = Column.Widths.Standard

    if UI.BeginTable("Ability", 2, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Total", col_flags, width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Damaging")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_DAMAGING)

        UI.TableNextRow()
        UI.TableNextColumn()UI.Text("Healing")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_HEALING)

        UI.TableNextRow()
        UI.TableNextColumn()UI.Text("MP Recovery")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_MP_RECOVERY)

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up ability publishing buttons from within the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param ability_total number
---@param healing_total number
------------------------------------------------------------------------------------------------------
Focus.Abilities.Publish = function(player_name, ability_total, healing_total)
    if ability_total > 0 then
        Report.Widgets.Button(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, "Publish Abilities")
    end
    if healing_total > 0 then
        if ability_total > 0 then UI.SameLine() UI.Text(" ") UI.SameLine() end
        Report.Widgets.Button(player_name, DB.Enum.Trackable.ABILITY_HEALING, "Publish Healing")
    end
end