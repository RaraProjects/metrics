Focus.Abilities = T{}

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Abilities.Display = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local name_width = Column.Widths.Standard

    local ability_total = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, DB.Enum.Metric.COUNT)
    local healing_total = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_HEALING, DB.Enum.Metric.COUNT)
    local mp_recovery = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_MP_RECOVERY, DB.Enum.Metric.COUNT)
    local misc_count = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY, DB.Enum.Metric.COUNT)

    if UI.BeginTable("Ability", 2, table_flags) then
        UI.TableSetupColumn("Damage", col_flags, name_width)
        UI.TableSetupColumn("Healing", col_flags, name_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_DAMAGING)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_HEALING)

        UI.EndTable()
    end

    if ability_total > 0 then Focus.Catalog.Single(player_name, DB.Enum.Trackable.ABILITY_DAMAGING) end
    if healing_total > 0 then Focus.Catalog.Single(player_name, DB.Enum.Trackable.ABILITY_HEALING) end
    if mp_recovery > 0 then Focus.Catalog.Single(player_name, DB.Enum.Trackable.ABILITY_MP_RECOVERY) end
    if misc_count > 0 and Metrics.Focus.Show_Misc_Actions then Focus.Catalog.Single(player_name, DB.Enum.Trackable.ABILITY) end

    -- Publish buttons
    if ability_total > 0 then
        Report.Widgets.Button(player_name, DB.Enum.Trackable.ABILITY, "Publish Abilities")
    end
end