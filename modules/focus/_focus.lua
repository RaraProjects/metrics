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
    Focus.Config.Settings_Button()                              -- Settings
    UI.SameLine() UI.Text(" ") UI.SameLine()
    Focus.Config.Percent_Details()                              -- % Details
    UI.SameLine() UI.Text(" ") UI.SameLine()
    if not unselected then Overview.Screenshot_Button() end     -- Screenshot

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

    if UI.BeginTabBar("Focus Tabs", Window_Manager.Tabs.Flags) then

        if UI.BeginTabItem(Focus.Tabs.Names.OVERVIEW, false, Focus.Tabs.Switch[Focus.Tabs.Names.OVERVIEW]) then
            Focus.Tabs.Switch[Focus.Tabs.Names.OVERVIEW] = nil
            Focus.Overview.Job_Selection(player_name)
            UI.EndTabItem()
        end

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

        if DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL) > 0 or DB.Data.Get(player_name, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, DB.Metric.TOTAL) > 0 then
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
-- This is displayed at the top of the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
Focus.Overall_Damage_Breakdown = function(player_name)
    local col_flags = Column.Flags.None
    local table_flags = Window_Manager.Table.Flags.Fixed_Borders
    local width = Column.Widths.Percent

    local columns = 8
    local pet = DB.Data.Get(player_name, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    if pet > 0 then columns = columns + 1 end

    if UI.BeginTable("Overall", columns, table_flags) then
        UI.TableSetupColumn("Type",    col_flags, width)
        UI.TableSetupColumn("Total",   col_flags, width)
        UI.TableSetupColumn("Melee",   col_flags, width)
        UI.TableSetupColumn("Ranged",  col_flags, width)
        UI.TableSetupColumn("WS",      col_flags, width)
        UI.TableSetupColumn("SC",      col_flags, width)
        UI.TableSetupColumn("Magic",   col_flags, width)
        UI.TableSetupColumn("Ability", col_flags, width)
        if pet > 0 then UI.TableSetupColumn("Pet", col_flags, width) end
        UI.TableHeadersRow()

        local total_trackable = DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN
        if Parse.Config.Include_SC_Damage() then total_trackable = DB.Trackable.TOTAL_DAMAGE end

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Percent")
        UI.TableNextColumn() Column.Damage.By_Type(player_name, total_trackable, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.RANGED_OVERALL, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.WEAPONSKILL, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SKILLCHAIN, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SPELLS_OVERALL, nil, true)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.ABILITY_DAMAGING, nil, true)
        if pet > 0 then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_OVERALL, nil, true) end
        Window_Manager.Table_Row_Color(1)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Raw")
        UI.TableNextColumn() Column.Damage.Total(player_name)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.RANGED_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.WEAPONSKILL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SKILLCHAIN)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.SPELLS_OVERALL)
        UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.ABILITY_DAMAGING)
        if pet > 0 then UI.TableNextColumn() Column.Damage.By_Type(player_name, DB.Trackable.PET_OVERALL) end
        Window_Manager.Table_Row_Color(0)

        UI.EndTable()
    end
end