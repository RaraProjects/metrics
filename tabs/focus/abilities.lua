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
    local trackable = DB.Enum.Trackable.ABILITY

    local ability_total = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY, DB.Enum.Metric.COUNT)

    if UI.BeginTable("Ability", 1, table_flags) then
        UI.TableSetupColumn("Ability Damage", col_flags, name_width)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Column.Damage.By_Type(player_name, trackable)
        UI.EndTable()
    end

    if ability_total > 0 then
        Focus.Catalog.Single(player_name, DB.Enum.Trackable.ABILITY)
    end

    -- Publish buttons
    if ability_total > 0 then
        Report.Widgets.Button(player_name, DB.Enum.Trackable.ABILITY, "Publish Abilities")
    end
end