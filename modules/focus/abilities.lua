Focus.Abilities = {}

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param hide_publish? boolean
------------------------------------------------------------------------------------------------------
Focus.Abilities.Display = function(player_name, hide_publish)
    local ability_total = DB.Data.Get(player_name, DB.Trackable.ABILITY_DAMAGING,    DB.Metric.ATTEMPTS_ON_USE)
    local healing_total = DB.Data.Get(player_name, DB.Trackable.ABILITY_HEALING,     DB.Metric.ATTEMPTS_ON_USE)
    local mp_recovery   = DB.Data.Get(player_name, DB.Trackable.ABILITY_MP_RECOVERY, DB.Metric.ATTEMPTS_ON_USE)
    local maneuvers     = DB.Data.Get(player_name, DB.Trackable.MANEUVER,            DB.Metric.ATTEMPTS_ON_USE)
    local rolls         = DB.Data.Get(player_name, DB.Trackable.PHANTOM_ROLL,        DB.Metric.ATTEMPTS_ON_USE)
    local misc_count    = DB.Data.Get(player_name, DB.Trackable.ABILITY_OVERALL,     DB.Metric.ATTEMPTS_ON_USE)

    Focus.Abilities.Total(player_name)
    UI.Separator()

    if rolls > 0 then Focus.Overview.Phantom_Roll(player_name, true) end
    if maneuvers > 0     then
        Focus.Overview.Overload(player_name)
        Focus.Overview.Maneuvers(player_name)
    end
    if ability_total > 0 then Focus.Catalog.Abilities(player_name, DB.Trackable.ABILITY_DAMAGING, "Damaging") end
    if healing_total > 0 then Focus.Catalog.Abilities(player_name, DB.Trackable.ABILITY_HEALING, "Healing") end
    if mp_recovery > 0   then Focus.Catalog.Abilities(player_name, DB.Trackable.ABILITY_MP_RECOVERY, "MP Recover") end
    if misc_count > 0 and Metrics.Focus.Show_Misc_Actions then Focus.Catalog.Abilities_General(player_name) end

    if not hide_publish then Focus.Abilities.Publish(player_name, ability_total, healing_total) end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the ability table inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Abilities.Total = function(player_name)
    local col_flags   = Focus.Column_Flags
    local table_flags = Focus.Table_Flags
    local name_width  = Column.Widths.Name
    local width       = Column.Widths.Standard

    local row = 1
    if UI.BeginTable("Ability", 2, table_flags) then
        UI.TableSetupColumn("Type", col_flags, name_width)
        UI.TableSetupColumn("Total", col_flags, width)
        UI.TableHeadersRow()

        local ability_types = {
            [1] = {header = "Damaging", trackable = DB.Trackable.ABILITY_DAMAGING},
            [2] = {header = "Healing",  trackable = DB.Trackable.ABILITY_HEALING},
            [3] = {header = "Damaging", trackable = DB.Trackable.ABILITY_MP_RECOVERY},
        }

        for _, data in ipairs(ability_types) do
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(data.header)
            UI.TableNextColumn() Column.Damage.By_Type(player_name, data.trackable)
            Window_Manager.Table_Row_Color(row)
            row = row + 1
        end

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
        Report.Widgets.Button(player_name, DB.Trackable.ABILITY_DAMAGING, "Publish Abilities")
    end
    if healing_total > 0 then
        if ability_total > 0 then UI.SameLine() UI.Text(" ") UI.SameLine() end
        Report.Widgets.Button(player_name, DB.Trackable.ABILITY_HEALING, "Publish Healing")
    end
end