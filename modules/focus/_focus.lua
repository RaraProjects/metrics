Focus = {}

Focus.Name   = "Focus"
Focus.Title  = "Metrics - Focus"
Focus.Module = "Focus"
Focus.Window = Window:New({
    Name   = Focus.Name,
    Title  = Focus.Title,
    Module = Focus.Module,
    Show_Title = true,
})

Focus.Tabs = {}
Focus.Tabs.Names = {
    OVERVIEW  = "Overview",
    MELEE     = "Melee",
    RANGED    = "Ranged",
    WS        = "Weaponskills",
    MAGIC     = "Magic",
    ABILITIES = "Abilities",
    PETS      = "Pets",
    DEFENSE   = "Defense",
}
Focus.Tabs.Switch = {
    [Focus.Tabs.Names.OVERVIEW]  = nil,
    [Focus.Tabs.Names.MELEE]     = nil,
    [Focus.Tabs.Names.RANGED]    = nil,
    [Focus.Tabs.Names.WS]        = nil,
    [Focus.Tabs.Names.MAGIC]     = nil,
    [Focus.Tabs.Names.ABILITIES] = nil,
    [Focus.Tabs.Names.PETS]      = nil,
    [Focus.Tabs.Names.DEFENSE]   = nil,
}

Focus.Column_Flags = Column.Flags.None
Focus.Table_Flags  = Window_Manager.Table.Flags.Fixed_Borders

Focus.Screenshot_Flags = bit.bor(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoNav)
Focus.Screenshot_Mode = {false}

-- Load dependencies
require("modules.focus.config")
require("modules.focus.melee")
require("modules.focus.ranged")
require("modules.focus.weaponskills")
require("modules.focus.magic")
require("modules.focus.abilities")
require("modules.focus.pets")
require("modules.focus.defense")
require("modules.focus.cataloged")
require("modules.focus.overview")
require("modules.focus.dependencies")

------------------------------------------------------------------------------------------------------
-- Resets the focus settings.
------------------------------------------------------------------------------------------------------
Focus.Reset_Settings = function()
    for index, _ in pairs(DB.Healing_Max) do
        DB.Healing_Max[index] = DB.Healing_Max_Defaults[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the focus data to the screen.
------------------------------------------------------------------------------------------------------
Focus.Content = function()
    local unselected = false
    local player_name = DB.Widgets.Util.Get_Player_Focus()
    if player_name == DB.Widgets.Dropdown.Enum.NONE then unselected = true end

    -- Toolbar buttons
    -- Focus.Config.Settings_Button()                           -- Settings (No settings to display so removed)
    -- UI.SameLine() UI.Text(" ") UI.SameLine()
    Focus.Config.Percent_Details()                              -- % Details
    UI.SameLine() UI.Text(" ") UI.SameLine()
    Focus.Config.Misc_Actions()                                 -- Misc Actions
    if not unselected then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        Overview.Screenshot_Button()                            -- Screenshot
    end

    -- Filters
    DB.Widgets.Player_Filter() UI.SameLine() UI.Text("  ") UI.SameLine()
    DB.Widgets.Mob_Filter()

    -- Quit early if no player is currently being focused.
    if unselected then
        UI.Separator()
        UI.Text("No player selected.")
        if Debug.Is_Enabled() then UI.SameLine() UI.Text(Window_Manager.Menu.Get_Menu_Name()) end
        return nil
    end

    -- Proceed to display if a player is selected
    Column.String.Job(player_name)
    UI.Separator() Focus.Overall_Damage_Breakdown(player_name) UI.Separator()

    -- Load tab bar and tab content.
    if UI.BeginTabBar("Focus Tabs", Window_Manager.Tabs.Flags) then

        local tabs = {}
        table.insert(tabs, {tab = Focus.Tabs.Names.OVERVIEW,  display_function = Focus.Overview.Display})
        table.insert(tabs, {tab = Focus.Tabs.Names.MELEE,     display_function = Focus.Melee.Display})
        table.insert(tabs, {tab = Focus.Tabs.Names.RANGED,    display_function = Focus.Ranged.Display})
        table.insert(tabs, {tab = Focus.Tabs.Names.MAGIC,     display_function = Focus.Magic.Display})
        table.insert(tabs, {tab = Focus.Tabs.Names.DEFENSE,   display_function = Focus.Defense.Display})
        table.insert(tabs, {tab = Focus.Tabs.Names.WS,        display_function = Focus.WS.Display})
        table.insert(tabs, {tab = Focus.Tabs.Names.ABILITIES, display_function = Focus.Abilities.Display})

        -- Load tabs
        for _, data in ipairs(tabs) do
            if UI.BeginTabItem(data.tab, false, Focus.Tabs.Switch[data.tab]) then
                Focus.Tabs.Switch[data.tab] = nil
                data.display_function(player_name)
                UI.EndTabItem()
            end
        end

        -- Conditionally show pets.
        if DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL) > 0 or
           DB.Data.Get(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL) > 0 or
           DB.Data.Get(player_name, DB.Trackable.PET_HEALING, DB.Metric.TOTAL) > 0 then
            if UI.BeginTabItem(Focus.Tabs.Names.PETS, false, Focus.Tabs.Switch[Focus.Tabs.Names.PETS]) then
                Focus.Tabs.Switch[Focus.Tabs.Names.PETS] = nil
                Focus.Pets.Display(player_name)
                UI.EndTabItem()
            end
        end

        UI.EndTabBar()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows a breakdown of overall player damage by type.
-- This is displayed at the top of the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overall_Damage_Breakdown = function(player_name)
    local col_flags   = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local width       = Column.Widths.Percent

    local pet = DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    local including_skillchain = Parse.Config.Include_SC_Damage()

    local columns = 7
    if pet > 0 then columns = columns + 1 end
    if including_skillchain then columns = columns + 1 end

    if UI.BeginTable("Overall", columns, table_flags) then
        UI.TableSetupColumn("Type",    col_flags, width)
        UI.TableSetupColumn("Total",   col_flags, width)
        UI.TableSetupColumn("Melee",   col_flags, width)
        UI.TableSetupColumn("Ranged",  col_flags, width)
        UI.TableSetupColumn("WS",      col_flags, width)
        if including_skillchain then UI.TableSetupColumn("SC", col_flags, width) end
        UI.TableSetupColumn("Magic",   col_flags, width)
        UI.TableSetupColumn("Ability", col_flags, width)
        if pet > 0 then UI.TableSetupColumn("Pet", col_flags, width) end
        UI.TableHeadersRow()

        local total_trackable = DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN
        if including_skillchain then total_trackable = DB.Trackable.TOTAL_DAMAGE end

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Percent")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, total_trackable, nil, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL, nil, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.RANGED_OVERALL, nil, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.WEAPONSKILL, nil, nil, true)
        if including_skillchain then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SKILLCHAIN, nil, nil, true) end
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SPELLS_OVERALL, nil, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.ABILITY_DAMAGING, nil, nil, true)
        if pet > 0 then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_OVERALL, nil, nil, true) end
        Window_Manager.Table_Row_Color(1)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Raw")
        UI.TableNextColumn() Column.Damage.Total(player_name)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.RANGED_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.WEAPONSKILL)
        if including_skillchain then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SKILLCHAIN) end
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SPELLS_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.ABILITY_DAMAGING)
        if pet > 0 then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_OVERALL) end
        Window_Manager.Table_Row_Color(0)

        UI.EndTable()
    end
end