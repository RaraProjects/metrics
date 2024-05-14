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

-- Load dependencies
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
    Window.Widget.Player_Filter()
    UI.SameLine() UI.Text("  ") UI.SameLine()
    Window.Widget.Mob_Filter()
    local player_name = Window.Util.Get_Player_Focus()
    if player_name == Window.Dropdown.Enum.NONE then return nil end

    UI.Separator()
    UI.Text(" Player Total: ") UI.SameLine() Col.Damage.Total(player_name)
    Focus.Overall(player_name)
    UI.Separator()

    if UI.BeginTabBar("Focus Tabs", Window.Tabs.Flags) then
        if UI.BeginTabItem(Focus.Tabs.Names.MELEE, false, Focus.Tabs.Switch[Focus.Tabs.Names.MELEE]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.MELEE] = nil
            Focus.Melee.Display(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Focus.Tabs.Names.RANGED, false, Focus.Tabs.Switch[Focus.Tabs.Names.RANGED]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.RANGED] = nil
            Focus.Ranged.Display(player_name)
            UI.EndTabItem()
        end
        if UI.BeginTabItem(Focus.Tabs.Names.WS, false, Focus.Tabs.Switch[Focus.Tabs.Names.WS]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.WS] = nil
            Focus.WS.Display(player_name)
            UI.EndTabItem()
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
        if UI.BeginTabItem(Focus.Tabs.Names.PETS, false, Focus.Tabs.Switch[Focus.Tabs.Names.PETS]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.PETS] = nil
            Focus.Pets.Display(player_name)
            UI.EndTabItem()
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
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Percent
    local columns = 6
    if Metrics.Team.Settings.Include_SC_Damage then columns = columns + 1 end

    if UI.BeginTable("Overall", columns, table_flags) then
        -- Headers
        UI.TableSetupColumn("Melee %", col_flags, width)
        UI.TableSetupColumn("Ranged %", col_flags, width)
        UI.TableSetupColumn("WS %", col_flags, width)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableSetupColumn("SC %", col_flags, width) end
        UI.TableSetupColumn("Magic %", col_flags, width)
        UI.TableSetupColumn("JA %", col_flags, width)
        UI.TableSetupColumn("Pet %", col_flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.RANGED, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.WS, true)
        if Metrics.Team.Settings.Include_SC_Damage then UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.SC, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.MAGIC, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.ABILITY, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, DB.Enum.Trackable.PET, true)
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Display a graph of damage types.
-- NOT IMPLEMENTED due to lack of labels on the bar graphs. :(
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Graph = function(player_name)
    local total = Col.Util.Total_Damage(player_name)
    if total <= 0 then return nil end
    local melee = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.MELEE) / total
    local ranged = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.RANGED) / total
    local ws = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.WS) / total
    local sc = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.SC) / total
    local magic = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.MAGIC) / total
    local ability = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.ABILITY) / total
    local pet = Col.Damage.By_Type_Raw(player_name, DB.Enum.Trackable.PET) / total
    local graph_data = {melee, ranged, ws, sc, magic, ability, pet}
    UI.PlotHistogram("Damage Distribution", graph_data, #graph_data, 0, nil, 0, nil, {0, 30})
end