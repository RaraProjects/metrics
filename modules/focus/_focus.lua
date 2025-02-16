Focus = { }

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

Focus.Name   = "Focus"
Focus.Title  = "Metrics - Focus"
Focus.Module = "Focus"
Focus.File   = "focus"

Focus.Tabs = { }
Focus.Tabs.Names =
{
    OVERVIEW  = "Overview",
    MELEE     = "Melee",
    RANGED    = "Ranged",
    WS        = "Weaponskills",
    MAGIC     = "Magic",
    ABILITIES = "Abilities",
    PETS      = "Pets",
    DEFENSE   = "Defense",
}

-- Used to switch to different tabs via text commands.
Focus.Tabs.Switch =
{
    [Focus.Tabs.Names.OVERVIEW]  = nil,
    [Focus.Tabs.Names.MELEE]     = nil,
    [Focus.Tabs.Names.RANGED]    = nil,
    [Focus.Tabs.Names.WS]        = nil,
    [Focus.Tabs.Names.MAGIC]     = nil,
    [Focus.Tabs.Names.ABILITIES] = nil,
    [Focus.Tabs.Names.PETS]      = nil,
    [Focus.Tabs.Names.DEFENSE]   = nil,
}

Focus.ColumnFlags = Column.Flags.None
Focus.TableFlags  = WindowManager.Table.Flags.Fixed_Borders

Focus.ScreenshotFlags = bit.bor
(
    ImGuiWindowFlags_AlwaysAutoResize,
    ImGuiWindowFlags_NoSavedSettings,
    ImGuiWindowFlags_NoNav
)

Focus.ScreenshotMode = { false }

------------------------------------------------------------------------------------------------------
-- Initializes the Focus screen.
------------------------------------------------------------------------------------------------------
---@param settings? table settings that come from the Ashita settings_update event.
------------------------------------------------------------------------------------------------------
Focus.Initialize = function(settings)
    -- Get saved settings from file.
    Focus.Settings = settings or Settings_File.load(Focus.Config.Defaults, Focus.File)

    -- Create the Focus Window.
    Focus.Window = Window:New
    ({
        Name       = Focus.Name,
        Title      = Focus.Title,
        Module     = Focus.Module,
        Settings   = Focus.Settings,
        Show_Title = true,
    })
end

------------------------------------------------------------------------------------------------------
-- Resets the focus settings.
------------------------------------------------------------------------------------------------------
Focus.ResetSettings = function()
    for index, _ in pairs(DB.HealingMax) do
        DB.HealingMax[index] = DB.HealingMaxDefaults[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the focus data to the screen.
------------------------------------------------------------------------------------------------------
Focus.Content = function()
    local playerName = DB.Widgets.GetPlayerFocus()
    local unselected = playerName == DB.Enum.NONE

    -- Toolbar Buttons
    Focus.Config.PercentDetails()                   -- % Details
    UI.SameLine() UI.Text(" ") UI.SameLine()
    Focus.Config.MiscActions()                      -- Misc Actions

    if not unselected then
        UI.SameLine() UI.Text(" ") UI.SameLine()
        Overview.ScreenshotButton()                 -- Screenshot
    end

    -- Filters
    DB.Widgets.DropdownPlayerFilter() UI.SameLine() UI.Text("  ") UI.SameLine()
    DB.Widgets.DropdownMobFilter()

    -- Quit early if no player is currently being focused.
    if unselected then
        UI.Separator()
        UI.Text("No player selected.")

        if Debug.Is_Enabled() then
            UI.SameLine() UI.Text(WindowManager.Menu.GetMenuName())
        end

        return nil
    end

    -- Proceed to display if a player is selected
    Column.String.Job(playerName)
    UI.Separator() Focus.OverallDamageBreakdown(playerName) UI.Separator()

    -- Load tab bar and tab content.
    if UI.BeginTabBar("Focus Tabs", WindowManager.Tabs.Flags) then

        local tabs = { }
        table.insert(tabs, { tab = Focus.Tabs.Names.OVERVIEW,  display_function = Focus.Overview.Display  })
        table.insert(tabs, { tab = Focus.Tabs.Names.MELEE,     display_function = Focus.Melee.Display     })
        table.insert(tabs, { tab = Focus.Tabs.Names.RANGED,    display_function = Focus.Ranged.Display    })
        table.insert(tabs, { tab = Focus.Tabs.Names.MAGIC,     display_function = Focus.Magic.Display     })
        table.insert(tabs, { tab = Focus.Tabs.Names.DEFENSE,   display_function = Focus.Defense.Display   })
        table.insert(tabs, { tab = Focus.Tabs.Names.WS,        display_function = Focus.WS.Display        })
        table.insert(tabs, { tab = Focus.Tabs.Names.ABILITIES, display_function = Focus.Abilities.Display })
        table.insert(tabs, { tab = Focus.Tabs.Names.PETS,      display_function = Focus.Pets.Display      })

        -- Load tabs
        for _, data in ipairs(tabs) do
            if UI.BeginTabItem(data.tab, false, Focus.Tabs.Switch[data.tab]) then
                Focus.Tabs.Switch[data.tab] = nil
                data.display_function(playerName)
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
---@param playerName string
------------------------------------------------------------------------------------------------------
Focus.OverallDamageBreakdown = function(playerName)
    local colFlags   = Column.Flags.None
    local tableFlags = WindowManager.Table.Flags.Fixed_Borders
    local width      = Column.Widths.Percent

    local pet                 = DB.Data.Get(playerName, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    local includingSkillchain = Parse.Config.IncludeSkillchainDamage()
    local columns             = 7 + (pet > 0 and 1 or 0) + (includingSkillchain and 1 or 0)

    if UI.BeginTable("Overall", columns, tableFlags) then
        -- Headers
        UI.TableSetupColumn("Type",    colFlags, width)
        UI.TableSetupColumn("Total",   colFlags, width)
        UI.TableSetupColumn("Melee",   colFlags, width)
        UI.TableSetupColumn("Ranged",  colFlags, width)
        UI.TableSetupColumn("WS",      colFlags, width)

        if includingSkillchain then
            UI.TableSetupColumn("SC",  colFlags, width)
        end

        UI.TableSetupColumn("Magic",   colFlags, width)
        UI.TableSetupColumn("Ability", colFlags, width)

        if pet > 0 then
            UI.TableSetupColumn("Pet", colFlags, width)
        end
        UI.TableHeadersRow()

        local totalTrackable = includingSkillchain and DB.Trackable.TOTAL_DAMAGE or DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN

        -- Percentages
        UI.TableNextColumn() UI.Text("Percent")
        UI.TableNextColumn() Column.Damage.ByType(playerName, totalTrackable, nil, nil, true)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.MELEE_OVERALL, nil, nil, true)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.RANGED_OVERALL, nil, nil, true)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.WEAPONSKILL, nil, nil, true)

        if includingSkillchain then
            UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.SKILLCHAIN, nil, nil, true)
        end

        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.SPELLS_OVERALL, nil, nil, true)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.ABILITY_DAMAGING, nil, nil, true)

        if pet > 0 then
            UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.PET_OVERALL, nil, nil, true)
        end
        WindowManager.TableRowColor(1)

        -- Raw Values
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Raw")
        UI.TableNextColumn() Column.Damage.Total(playerName)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.MELEE_OVERALL)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.RANGED_OVERALL)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.WEAPONSKILL)

        if includingSkillchain then
            UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.SKILLCHAIN)
        end

        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.SPELLS_OVERALL)
        UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.ABILITY_DAMAGING)

        if pet > 0 then
            UI.TableNextColumn() Column.Damage.ByType(playerName, DB.Trackable.PET_OVERALL)
        end

        WindowManager.TableRowColor(0)

        UI.EndTable()
    end
end