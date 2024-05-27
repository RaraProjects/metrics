Focus = T{}

Focus.Tab_Name = "Focus"

Focus.Tabs = {}
Focus.Tabs.Names = {
    MELEE     = "Melee",
    RANGED    = "Ranged",
    WS        = "Weaponskills",
    MAGIC     = "Magic",
    ABILITIES = "Abilities",
    PETS      = "Pets",
    DEFENSE   = "Defense",
}
Focus.Tabs.Switch = {
    [Focus.Tabs.Names.MELEE]     = nil,
    [Focus.Tabs.Names.RANGED]    = nil,
    [Focus.Tabs.Names.WS]        = nil,
    [Focus.Tabs.Names.MAGIC]     = nil,
    [Focus.Tabs.Names.ABILITIES] = nil,
    [Focus.Tabs.Names.PETS]      = nil,
    [Focus.Tabs.Names.DEFENSE]   = nil,
}

Focus.Column_Flags = Column.Flags.None
Focus.Table_Flags  = Window.Table.Flags.Fixed_Borders
Focus.Screenshot_Mode = false

-- Load dependencies
require("tabs.focus.config")
require("tabs.focus.melee")
require("tabs.focus.ranged")
require("tabs.focus.weaponskills")
require("tabs.focus.magic")
require("tabs.focus.abilities")
require("tabs.focus.pets")
require("tabs.focus.defense")
require("tabs.focus.cataloged")

------------------------------------------------------------------------------------------------------
-- Resets the focus settings.
------------------------------------------------------------------------------------------------------
Focus.Reset_Settings = function()
    for index, _ in pairs(DB.Healing_Max) do
        DB.Healing_Max[index] = DB.Enum.HEALING[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the focus data to the screen.
------------------------------------------------------------------------------------------------------
Focus.Populate = function()
    DB.Widgets.Player_Filter()
    UI.SameLine() UI.Text("  ") UI.SameLine()
    DB.Widgets.Mob_Filter()

    local unselected = false
    local player_name = DB.Widgets.Util.Get_Player_Focus()
    if player_name == DB.Widgets.Dropdown.Enum.NONE then unselected = true end

    Focus.Config.Settings_Button()
    if not unselected then UI.SameLine() UI.Text(" ") UI.SameLine() Focus.Config.Screenshot_Button() end
    if Focus.Config.Show_Settings then Focus.Config.Display() end

    if unselected then return nil end

    UI.Separator()
    Focus.Overall(player_name)
    UI.Separator()

    if UI.BeginTabBar("Focus Tabs", Window.Tabs.Flags) then
        if UI.BeginTabItem(Focus.Tabs.Names.MELEE, false, Focus.Tabs.Switch[Focus.Tabs.Names.MELEE]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.MELEE] = nil
            Focus.Melee.Display(player_name)
            UI.EndTabItem()
        end

        if DB.Data.Get(player_name, DB.Enum.Trackable.RANGED, DB.Enum.Metric.COUNT) > 0 then
            if UI.BeginTabItem(Focus.Tabs.Names.RANGED, false, Focus.Tabs.Switch[Focus.Tabs.Names.RANGED]) then
                Focus.Tabs.Switch[Focus.Tabs.Names.RANGED] = nil
                Focus.Ranged.Display(player_name)
                UI.EndTabItem()
            end
        end

        if DB.Data.Get(player_name, DB.Enum.Trackable.WS, DB.Enum.Metric.TOTAL) > 0 then
            if UI.BeginTabItem(Focus.Tabs.Names.WS, false, Focus.Tabs.Switch[Focus.Tabs.Names.WS]) then
                Focus.Tabs.Switch[Focus.Tabs.Names.WS] = nil
                Focus.WS.Display(player_name)
                UI.EndTabItem()
            end
        end

        if UI.BeginTabItem(Focus.Tabs.Names.MAGIC, false, Focus.Tabs.Switch[Focus.Tabs.Names.MAGIC]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.MAGIC] = nil
            Focus.Magic.Display(player_name)
            UI.EndTabItem()
        end

        if UI.BeginTabItem(Focus.Tabs.Names.ABILITIES, false, Focus.Tabs.Switch[Focus.Tabs.Names.ABILITIES]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.ABILITIES] = nil
            Focus.Abilities.Display(player_name)
            UI.EndTabItem()
        end

        if DB.Data.Get(player_name, DB.Enum.Trackable.PET, DB.Enum.Metric.TOTAL) > 0 then
            if UI.BeginTabItem(Focus.Tabs.Names.PETS, false, Focus.Tabs.Switch[Focus.Tabs.Names.PETS]) then
                Focus.Tabs.Switch[Focus.Tabs.Names.PETS] = nil
                Focus.Pets.Display(player_name)
                UI.EndTabItem()
            end
        end

        if UI.BeginTabItem(Focus.Tabs.Names.DEFENSE, false, Focus.Tabs.Switch[Focus.Tabs.Names.DEFENSE]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.DEFENSE] = nil
            Focus.Defense.Display(player_name)
            UI.EndTabItem()
        end
        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a breakdown of overall player damage by type.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overall = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Column.Widths.Percent

    local melee   = DB.Data.Get(player_name, DB.Enum.Trackable.MELEE,   DB.Enum.Metric.TOTAL)
    local ranged  = DB.Data.Get(player_name, DB.Enum.Trackable.RANGED,  DB.Enum.Metric.TOTAL)
    local ws      = DB.Data.Get(player_name, DB.Enum.Trackable.WS,      DB.Enum.Metric.TOTAL)
    local sc      = DB.Data.Get(player_name, DB.Enum.Trackable.SC,      DB.Enum.Metric.TOTAL)
    local magic   = DB.Data.Get(player_name, DB.Enum.Trackable.MAGIC,   DB.Enum.Metric.TOTAL)
    local ability = DB.Data.Get(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, DB.Enum.Metric.TOTAL)
    local pet     = DB.Data.Get(player_name, DB.Enum.Trackable.PET,     DB.Enum.Metric.TOTAL)

    local show_sc = false
    local columns = 2
    if melee > 0   then columns = columns + 1 end
    if ranged > 0  then columns = columns + 1 end
    if ws > 0      then columns = columns + 1 end
    if magic > 0   then columns = columns + 1 end
    if ability > 0 then columns = columns + 1 end
    if pet > 0     then columns = columns + 1 end
    if sc > 0 and Parse.Config.Include_SC_Damage() then
        show_sc = true
        columns = columns + 1
    end

    if UI.BeginTable("Overall", columns, table_flags) then
        UI.TableSetupColumn("Type", col_flags, width)
        UI.TableSetupColumn("Total", col_flags, width)
        if melee > 0   then UI.TableSetupColumn("Melee", col_flags, width) end
        if ranged > 0  then UI.TableSetupColumn("Ranged", col_flags, width) end
        if ws > 0      then UI.TableSetupColumn("WS", col_flags, width) end
        if show_sc     then UI.TableSetupColumn("SC", col_flags, width) end
        if magic > 0   then UI.TableSetupColumn("Magic", col_flags, width) end
        if ability > 0 then UI.TableSetupColumn("Ability", col_flags, width) end
        if pet > 0     then UI.TableSetupColumn("Pet", col_flags, width) end
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Percent")
        UI.TableNextColumn() Column.Damage.Total(player_name, true)
        if melee > 0   then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, true) end
        if ranged > 0  then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.RANGED, true) end
        if ws > 0      then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.WS, true) end
        if show_sc     then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.SC, true) end
        if magic > 0   then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, true) end
        if ability > 0 then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_DAMAGING, true) end
        if pet > 0     then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET, true) end

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Raw")
        UI.TableNextColumn() Column.Damage.Total(player_name)
        if melee > 0   then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE) end
        if ranged > 0  then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.RANGED) end
        if ws > 0      then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.WS) end
        if show_sc     then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.SC) end
        if magic > 0   then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC) end
        if ability > 0 then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY_DAMAGING) end
        if pet > 0     then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Enum.Trackable.PET) end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Opens a new window to show all tabs as a vertical column.
------------------------------------------------------------------------------------------------------
Focus.Screenshot = function()
    local player_name = DB.Widgets.Util.Get_Player_Focus()
    if player_name == DB.Widgets.Dropdown.Enum.NONE then return nil end

    UI.Text("Overall") Focus.Overall(player_name)
    UI.Separator() UI.Text("Melee")        Focus.Melee.Display(player_name)
    UI.Separator() UI.Text("Ranged")       Focus.Ranged.Display(player_name)
    UI.Separator() UI.Text("Weaponskills") Focus.WS.Display(player_name, true)
    UI.Separator() UI.Text("Magic")        Focus.Magic.Display(player_name, true)
    UI.Separator() UI.Text("Abilities")    Focus.Abilities.Display(player_name, true)
    UI.Separator() UI.Text("Pets")         Focus.Pets.Display(player_name)
    UI.Separator() UI.Text("Defense")      Focus.Defense.Display(player_name)
end

------------------------------------------------------------------------------------------------------
-- Display a graph of damage types.
-- NOT IMPLEMENTED due to lack of labels on the bar graphs. :(
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Graph = function(player_name)
    local total = Column.Damage.Raw_Total_Player_Damage(player_name)
    if total <= 0 then return nil end
    local melee   = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.MELEE) / total
    local ranged  = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.RANGED) / total
    local ws      = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.WS) / total
    local sc      = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.SC) / total
    local magic   = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.MAGIC) / total
    local ability = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.ABILITY) / total
    local pet     = Column.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.PET) / total
    local graph_data = {melee, ranged, ws, sc, magic, ability, pet}
    UI.PlotHistogram("Damage Distribution", graph_data, #graph_data, 0, nil, 0, nil, {0, 30})
end