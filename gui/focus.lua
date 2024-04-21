local f = {}

f.Display = {}
f.Display.Util = {}
f.Display.Flags = {
    Open_Action = -1,
}

f.Enum = {
    OVERFLOW = 100000,
}

------------------------------------------------------------------------------------------------------
-- Resets the focus settings.
------------------------------------------------------------------------------------------------------
f.Reset_Settings = function()
    for index, _ in pairs(Model.Healing_Max) do
        Model.Healing_Max[index] = Model.Enum.HEALING[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the focus data to the screen.
------------------------------------------------------------------------------------------------------
f.Populate = function()
    Window.Widget.Player_Filter()
    UI.SameLine() UI.Text("  ") UI.SameLine()
    Window.Widget.Mob_Filter()
    local player_name = Window.Util.Get_Player_Focus()
    if player_name == Window.Dropdown.Enum.NONE then return nil end

    f.Display.Util.Buttons()
    UI.Text(" Grand Total: ") UI.SameLine() Col.Damage.Total(player_name)
    f.Display.Overall(player_name)
    f.Display.Melee(player_name)
    f.Display.Ranged(player_name)
    f.Display.WS_and_SC(player_name)
    f.Display.Magic(player_name)
    f.Display.Ability(player_name)
    f.Display.Pet(player_name)
end

------------------------------------------------------------------------------------------------------
-- Shows a breakdown of overall player damage by type.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Overall = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Percent
    local columns = 6
    if Team.Settings.Include_SC_Damage then columns = columns + 1 end

    if UI.BeginTable("Overall", columns, table_flags) then
        -- Headers
        UI.TableSetupColumn("Melee %", col_flags, width)
        UI.TableSetupColumn("Ranged %", col_flags, width)
        UI.TableSetupColumn("WS %", col_flags, width)
        if Team.Settings.Include_SC_Damage then UI.TableSetupColumn("SC %", col_flags, width) end
        UI.TableSetupColumn("Magic %", col_flags, width)
        UI.TableSetupColumn("JA %", col_flags, width)
        UI.TableSetupColumn("Pet %", col_flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.RANGED, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.WS, true)
        if Team.Settings.Include_SC_Damage then UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.SC, true) end
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MAGIC, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.ABILITY, true)
        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET, true)
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Melee = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Standard

    local melee_total = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.TOTAL)
    local mob_heal = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.MOB_HEAL)
    local enspell = Model.Get.Data(player_name, Model.Enum.Trackable.ENSPELL, Model.Enum.Metric.TOTAL)
    local shadows = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.SHADOWS)
    local kick_damage = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE_KICK, Model.Enum.Metric.TOTAL)

    if melee_total > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Melee", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Melee 1 ", 3, table_flags) then
                -- Headers
                UI.TableSetupColumn("Damage", col_flags, width)
                UI.TableSetupColumn("Accuracy %", col_flags, width)
                UI.TableSetupColumn("Crit. Rate %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE)
                UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE)
                UI.TableNextColumn() Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE)
                UI.EndTable()
            end

            f.Display.Util.Check_Collapse()
            if UI.TreeNode("Main-Hand & Off-Hand") then
                if UI.BeginTable("Melee 2", 4, table_flags) then
                    -- Headers
                    UI.TableSetupColumn("Main-Hand\nDamage", col_flags, width)
                    UI.TableSetupColumn("Main-Hand\nAccuracy %", col_flags, width)
                    UI.TableSetupColumn("Off-Hand\nDamage", col_flags, width)
                    UI.TableSetupColumn("Off-Hand\nAccuracy %", col_flags, width)
                    UI.TableHeadersRow()

                    -- Data
                    UI.TableNextRow()
                    UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_MAIN)
                    UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_MAIN)
                    UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_OFFH)
                    UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_OFFH)
                    UI.EndTable()
                end
                UI.TreePop()
            end

            f.Display.Util.Check_Collapse()
            if UI.TreeNode("Melee Critical Hits") then
                if UI.BeginTable("Melee Crits", 3, table_flags) then
                    -- Headers
                    UI.TableSetupColumn("Damage", col_flags, width)
                    UI.TableSetupColumn("Damage %T", col_flags, width)
                    UI.TableSetupColumn("Crit Rate", col_flags, width)
                    UI.TableHeadersRow()

                    -- Data
                    UI.TableNextRow()
                    UI.TableNextColumn() Col.Crit.Damage(player_name, Model.Enum.Trackable.MELEE)
                    UI.TableNextColumn() Col.Crit.Damage(player_name, Model.Enum.Trackable.MELEE, true)
                    UI.TableNextColumn() Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE)
                    UI.EndTable()
                end
                UI.TreePop()
            end

            if kick_damage > 0 then
                f.Display.Util.Check_Collapse()
                if UI.TreeNode("Kick Attacks") then
                    if UI.BeginTable("Melee 3", 4, table_flags) then
                        -- Headers
                        UI.TableSetupColumn("Damage", col_flags, width)
                        UI.TableSetupColumn("Damage %T", col_flags, width)
                        UI.TableSetupColumn("Accuracy %", col_flags, width)
                        UI.TableSetupColumn("Kick Rate %", col_flags, width)
                        UI.TableHeadersRow()

                        -- Data
                        UI.TableNextRow()
                        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_KICK)
                        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE_KICK, true)
                        UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_KICK)
                        UI.TableNextColumn() Col.Kick.Rate(player_name)
                        UI.EndTable()
                    end
                    UI.TreePop()
                end
            end

            f.Display.Util.Check_Collapse()
            if UI.TreeNode("Melee Miscellaneous") then
                if UI.BeginTable("Melee Misc.", 3, table_flags) then
                    -- Headers
                    UI.TableSetupColumn("\nMob Heal", col_flags, width)
                    UI.TableSetupColumn("(For Ref.)\nEnspell", col_flags, width)
                    UI.TableSetupColumn("Absorbed by\nShadows", col_flags, width)
                    UI.TableHeadersRow()

                    -- Data
                    UI.TableNextRow()
                    UI.TableNextColumn() UI.Text(Col.String.Format_Number(mob_heal))
                    UI.TableNextColumn() UI.Text(Col.String.Format_Number(enspell))
                    UI.TableNextColumn() UI.Text(Col.String.Format_Number(shadows))
                    UI.EndTable()
                end
                UI.TreePop()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the ranged drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Ranged = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.RANGED

    local ranged_total = Model.Get.Data(player_name, Model.Enum.Trackable.RANGED, Model.Enum.Metric.TOTAL)
    if ranged_total > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Ranged", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ranged", 5, table_flags) then
                -- Headers
                UI.TableSetupColumn("Damage", col_flags, width)
                UI.TableSetupColumn("Accuracy %", col_flags, width)
                UI.TableSetupColumn("Square %", col_flags, width)
                UI.TableSetupColumn("Truestrike %", col_flags, width)
                UI.TableSetupColumn("Crit. Rate %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable)
                UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable, nil, Model.Enum.Metric.SQUARE_COUNT)
                UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable, nil, Model.Enum.Metric.TRUE_COUNT)
                UI.TableNextColumn() Col.Crit.Rate(player_name, trackable)
                UI.EndTable()
            end

            f.Display.Util.Check_Collapse()
            if UI.TreeNode("Ranged Critical Hits") then
                if UI.BeginTable("Ranged Crits", 3, table_flags) then
                    -- Headers
                    UI.TableSetupColumn("Damage", col_flags, width)
                    UI.TableSetupColumn("Damage %T", col_flags, width)
                    UI.TableSetupColumn("Crit. Rate %", col_flags, width)
                    UI.TableHeadersRow()

                    -- Data
                    UI.TableNextRow()
                    UI.TableNextColumn() Col.Crit.Damage(player_name, trackable)
                    UI.TableNextColumn() Col.Crit.Damage(player_name, trackable, true)
                    UI.TableNextColumn() Col.Crit.Rate(player_name, trackable)
                    UI.EndTable()
                end
                UI.TreePop()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the crits drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Crits = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Standard

    local melee_crits = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.CRIT_DAMAGE)
    local ranged_crits = Model.Get.Data(player_name, Model.Enum.Trackable.RANGED, Model.Enum.Metric.CRIT_DAMAGE)
    if melee_crits > 0 or ranged_crits > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Critical Hit Damage", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Crits", 3, table_flags) then
                -- Headers
                UI.TableSetupColumn("\nDamage", col_flags, width)
                UI.TableSetupColumn("\nDamage %T", col_flags, width)
                UI.TableSetupColumn("Total\nCrit Rate %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Crit.Damage(player_name, 'combined')
                UI.TableNextColumn() Col.Crit.Damage(player_name, 'combined', true)
                UI.TableNextColumn() Col.Crit.Rate(player_name, 'combined')
                UI.EndTable()
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the weaponskill and skillchain drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.WS_and_SC = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Standard
    local trackable_ws = Model.Enum.Trackable.WS
    local trackable_sc = Model.Enum.Trackable.SC

    local ws_total = Model.Get.Data(player_name, Model.Enum.Trackable.WS, Model.Enum.Metric.COUNT)
    if ws_total > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Weaponskill and Skillchain", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("WS and SC", 3, table_flags) then
                -- Headers
                UI.TableSetupColumn("WS Damage", col_flags, width)
                UI.TableSetupColumn("WS Acc. %", col_flags, width)
                UI.TableSetupColumn("SC Damage", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable_ws)
                UI.TableNextColumn() Col.Acc.By_Type(player_name, trackable_ws)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable_sc)
                UI.EndTable()
            end
            if Model.Data.Trackable[Model.Enum.Trackable.WS] and Model.Data.Trackable[Model.Enum.Trackable.WS][player_name] then
                f.Display.Single_Data(player_name, Model.Enum.Trackable.WS)
            end
            if Model.Data.Trackable[Model.Enum.Trackable.SC] and Model.Data.Trackable[Model.Enum.Trackable.SC][player_name] then
                f.Display.Single_Data(player_name, Model.Enum.Trackable.SC)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the magic drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Magic = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.MAGIC

    local nuke_total = Model.Get.Data(player_name, Model.Enum.Trackable.NUKE, Model.Enum.Metric.TOTAL)
    local mp_drain = Model.Get.Data(player_name, Model.Enum.Trackable.MP_DRAIN, Model.Enum.Metric.TOTAL)
    local healing_total = Model.Get.Data(player_name, Model.Enum.Trackable.HEALING, Model.Enum.Metric.TOTAL)
    local misc_count = Model.Get.Data(player_name, Model.Enum.Trackable.MAGIC, Model.Enum.Metric.COUNT)

    if nuke_total > 0 or mp_drain > 0 or healing_total > 0 or misc_count > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Magic", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Magic", 5, table_flags) then
                -- Headers
                UI.TableSetupColumn("Magic Damage", col_flags, width)
                UI.TableSetupColumn("MP Spent", col_flags, width)
                UI.TableSetupColumn("Burst Damage", col_flags, width)
                UI.TableSetupColumn("MP Drain", col_flags, width)
                UI.TableSetupColumn("Enspell", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
                UI.TableNextColumn() Col.Spell.MP(player_name, Model.Enum.Trackable.MAGIC)
                UI.TableNextColumn() Col.Damage.Burst(player_name)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.MP_DRAIN)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.ENSPELL)
                UI.EndTable()
            end

            f.Display.Util.Check_Collapse()
            if UI.TreeNode("MP Usage") then
                if UI.BeginTable("MP Usage", 4, table_flags) then
                    -- Headers
                    UI.TableSetupColumn("Overall MP", col_flags, width)
                    UI.TableSetupColumn("Nuke MP", col_flags, width)
                    UI.TableSetupColumn("Healing MP", col_flags, width)
                    UI.TableSetupColumn("Other MP", col_flags, width)
                    UI.TableHeadersRow()

                    -- Data
                    UI.TableNextRow()
                    UI.TableNextColumn() Col.Spell.MP(player_name, Model.Enum.Trackable.MAGIC)
                    UI.TableNextColumn() Col.Spell.MP(player_name, Model.Enum.Trackable.NUKE)
                    UI.TableNextColumn() Col.Spell.MP(player_name, Model.Enum.Trackable.HEALING)
                    UI.TableNextColumn() Col.Spell.MP(player_name, "Other")
                    UI.EndTable()
                end
                UI.TreePop()
            end

            if nuke_total > 0 then
                f.Display.Util.Check_Collapse()
                if UI.TreeNode("Nuking") then
                    if UI.BeginTable("Nuking", 6, table_flags) then
                        -- Headers
                        UI.TableSetupColumn("Nuke\nDamage", col_flags, width)
                        UI.TableSetupColumn("Nuke\nMP Used", col_flags, width)
                        UI.TableSetupColumn("Nuke\nDamage per MP", col_flags, width)
                        UI.TableSetupColumn("Burst\nTotal Damage", col_flags, width)
                        UI.TableSetupColumn("Burst\n% Total Damage", col_flags, width)
                        UI.TableSetupColumn("Burst\n% Magic Damage", col_flags, width)
                        UI.TableHeadersRow()

                        -- Data
                        UI.TableNextRow()
                        UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.NUKE)
                        UI.TableNextColumn() Col.Spell.MP(player_name, Model.Enum.Trackable.NUKE)
                        UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, Model.Enum.Trackable.NUKE)
                        UI.TableNextColumn() Col.Damage.Burst(player_name)
                        UI.TableNextColumn() Col.Damage.Burst(player_name, true)
                        UI.TableNextColumn() Col.Damage.Burst(player_name, true, true)
                        UI.EndTable()
                    end
                    f.Display.Spell_Single(player_name, Model.Enum.Trackable.NUKE)
                    UI.TreePop()
                end
            end

            if healing_total > 0 then
                f.Display.Util.Check_Collapse()
                if UI.TreeNode("Healing") then
                    if UI.BeginTable("Heals", 4, table_flags) then
                        -- Headers
                        UI.TableSetupColumn("Healed HP", col_flags, width)
                        UI.TableSetupColumn("MP Used", col_flags, width)
                        UI.TableSetupColumn("Healing per MP", col_flags, width)
                        UI.TableSetupColumn("Overcure", col_flags, width)
                        UI.TableHeadersRow()

                        -- Data
                        UI.TableNextRow()
                        UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
                        UI.TableNextColumn() Col.Spell.MP(player_name, Model.Enum.Trackable.HEALING)
                        UI.TableNextColumn() Col.Spell.Unit_Per_MP(player_name, Model.Enum.Trackable.HEALING)
                        UI.TableNextColumn() Col.Healing.Overcure(player_name)
                        UI.EndTable()
                    end
                    f.Display.Spell_Single(player_name, Model.Enum.Trackable.HEALING)
                    UI.TreePop()
                end
            end

            if misc_count > 0 then
                if UI.TreeNode("Misc Spells") then
                    f.Display.Spell_Single(player_name, Model.Enum.Trackable.MAGIC)
                    UI.TreePop()
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the ability drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Ability = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.ABILITY

    local ability_total = Model.Get.Data(player_name, Model.Enum.Trackable.ABILITY, Model.Enum.Metric.COUNT)
    if ability_total > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Ability", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ability", 1, table_flags) then
                -- Headers
                UI.TableSetupColumn("Damage", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, trackable)
                UI.EndTable()
            end
            f.Display.Single_Data(player_name, Model.Enum.Trackable.ABILITY)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the pet drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Pet = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.Fixed_Borders
    local damage = Window.Columns.Widths.Standard

    local pet_total = Model.Get.Data(player_name, Model.Enum.Trackable.PET, Model.Enum.Metric.TOTAL)
    if pet_total > 0 then
        f.Display.Util.Check_Collapse()
        if UI.CollapsingHeader("Pets", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Pets Melee", 4, table_flags) then
                -- Headers
                UI.TableSetupColumn("Total Damage", col_flags, damage)
                UI.TableSetupColumn("Melee Damage", col_flags, damage)
                UI.TableSetupColumn("Melee Accuracy", col_flags, damage)
                UI.TableSetupColumn("Ranged Damage", col_flags, damage)
                --UI.TableSetupColumn("Ranged Accuracy", col_flags, damage)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE)
                UI.TableNextColumn() Col.Acc.By_Type(player_name, Model.Enum.Trackable.PET_MELEE_DISCRETE)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED)
                UI.EndTable()
            end
            if UI.BeginTable("Pet Advanced", 3, table_flags) then
                -- Headers
                UI.TableSetupColumn("WS Damage", col_flags, damage)
                UI.TableSetupColumn("Abil. Damage", col_flags, damage)
                --UI.TableSetupColumn("Spell Damage", col_flags, damage)
                UI.TableSetupColumn("Healing", col_flags, damage)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY)
                UI.TableNextColumn() Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_HEAL)
                UI.EndTable()
            end
            f.Display.Pet_Single_Data(player_name)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Single_Data = function(player_name, focus_type)
    if not focus_type then return nil end
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local width = Window.Columns.Widths.Standard

    -- Error Protection
    if not Model.Data.Trackable[focus_type] then return nil end
    if not Model.Data.Trackable[focus_type][player_name] then return nil end

    local acc_string = "Accuracy %"
    local damage_string = "Damage"
    local action_string = "Action"
    local attempt_string = "Attempts"
    if focus_type == Model.Enum.Trackable.MAGIC then
        action_string = "Spell"
        acc_string = "Bursts"
        attempt_string = "Casts (MP)"
    elseif focus_type == Model.Enum.Trackable.HEALING then
        action_string = "Spell"
        acc_string = "Overcure"
        damage_string = "Healing"
        attempt_string = "Casts (MP)"
    elseif focus_type == Model.Enum.Trackable.ABILITY or focus_type == Model.Enum.Trackable.PET_ABILITY or focus_type == Model.Enum.Trackable.PET_WS then
        action_string = "Ability"
    elseif focus_type == Model.Enum.Trackable.WS then
        action_string = "Weaponskill"
    elseif focus_type == Model.Enum.Trackable.SC then
        action_string = "Skillchain"
    end

    f.Display.Util.Check_Collapse()
    if UI.TreeNode(focus_type) then
        if UI.BeginTable(focus_type, 7, table_flags) then
            UI.TableSetupColumn(action_string, col_flags, width)
            UI.TableSetupColumn("Total " .. damage_string, col_flags, width)
            UI.TableSetupColumn(attempt_string, col_flags, width)
            UI.TableSetupColumn(acc_string, col_flags, width)
            UI.TableSetupColumn("Avg. " .. damage_string, col_flags, width)
            UI.TableSetupColumn("Min. " .. damage_string, col_flags, width)
            UI.TableSetupColumn("Max. " .. damage_string, col_flags, width)
            UI.TableHeadersRow()

            Model.Sort.Catalog_Damage(player_name, focus_type)

            -- Data
            local action_name
            for _, data in ipairs(Model.Data.Catalog_Damage_Race) do
                action_name = data[1]
                f.Display.Util.Single_Row(player_name, action_name, focus_type)
            end
            UI.EndTable()
        end
        UI.TreePop()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Util.Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.Attempts(player_name, action_name, focus_type)

    -- Accuracy changes between what the trackable is. Accuracy for spells isn't useful.
    if focus_type == Model.Enum.Trackable.NUKE then
        UI.TableNextColumn() Col.Single.Bursts(player_name, action_name)
    elseif focus_type == Model.Enum.Trackable.HEALING then
        UI.TableNextColumn() Col.Single.Overcure(player_name, action_name)
    else
        UI.TableNextColumn() Col.Single.Acc(player_name, action_name, focus_type)
    end

    UI.TableNextColumn() Col.Single.Average(player_name, action_name, focus_type)
    local min = Model.Get.Catalog(player_name, focus_type, action_name, Model.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Misc.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Show healing spell breakdown.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Spell_Single = function(player_name, focus_type)
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local name_width = Window.Columns.Widths.Standard
    local width = 65

    -- Error Protection
    if not Model.Data.Trackable[focus_type] then return nil end
    if not Model.Data.Trackable[focus_type][player_name] then return nil end

    local acc_string = "\nAcc. %"
    local damage_string = "Damage"
    if focus_type == Model.Enum.Trackable.NUKE then
        acc_string = "\nBursts"
    elseif focus_type == Model.Enum.Trackable.HEALING then
        acc_string = "Over\nCure"
        damage_string = "Healing"
    elseif focus_type == Model.Enum.Trackable.ENFEEBLE then
        acc_string = "\nResists"
    end

    f.Display.Util.Check_Collapse()
    if UI.BeginTable(focus_type, 9, table_flags) then
        UI.TableSetupColumn("\nSpell", col_flags, name_width)
        UI.TableSetupColumn("\n" .. damage_string, col_flags, width)
        UI.TableSetupColumn("\nMP Used", col_flags, width)
        UI.TableSetupColumn(damage_string .. "\nper MP", col_flags, width)
        UI.TableSetupColumn("\nCasts", col_flags, width)
        UI.TableSetupColumn(acc_string, col_flags, width)
        UI.TableSetupColumn("Average\n" .. damage_string, col_flags, width)
        UI.TableSetupColumn("Min.\n" .. damage_string, col_flags, width)
        UI.TableSetupColumn("Max.\n" .. damage_string, col_flags, width)
        UI.TableHeadersRow()

        Model.Sort.Catalog_Damage(player_name, focus_type)

        -- Data
        local action_name
        for _, data in ipairs(Model.Data.Catalog_Damage_Race) do
            action_name = data[1]
            f.Display.Util.Spell_Single_Row(player_name, action_name, focus_type)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a spell based trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param action_name string
---@param focus_type string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Util.Spell_Single_Row = function(player_name, action_name, focus_type)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.MP_Used(player_name, action_name, focus_type)
    UI.TableNextColumn() Col.Single.Damage_Per_MP(player_name, action_name, focus_type)
    UI.TableNextColumn() Col.Single.Attempts(player_name, action_name, focus_type)

    -- Accuracy changes between what the trackable is. Accuracy for spells isn't useful.
    if focus_type == Model.Enum.Trackable.NUKE then
        UI.TableNextColumn() Col.Single.Bursts(player_name, action_name)
    elseif focus_type == Model.Enum.Trackable.HEALING then
        UI.TableNextColumn() Col.Single.Overcure(player_name, action_name)
    else
        UI.TableNextColumn() Col.Single.Acc(player_name, action_name, focus_type)
    end

    UI.TableNextColumn() Col.Single.Average(player_name, action_name, focus_type)
    local min = Model.Get.Catalog(player_name, focus_type, action_name, Model.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Misc.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.MIN)
    end
    UI.TableNextColumn() Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
------------------------------------------------------------------------------------------------------
f.Display.Pet_Single_Data = function(player_name)
    local table_flags = Window.Table.Flags.Fixed_Borders
    local col_flags = Window.Columns.Flags.None
    local damage = Window.Columns.Widths.Standard

    if not Model.Data.Initialized_Pets[player_name] then
        _Debug.Error.Add("Display.Pet_Single_Data: Tried to loop through pets of unitialized player in the focus window.")
        return nil
    end

    for pet_name, _ in pairs(Model.Data.Initialized_Pets[player_name]) do
        -- I considered adding the total damage of the pet to the tree node title,
        -- but the damage changing causes the node to recollapse automatically. Annoying.
        f.Display.Util.Check_Collapse()
        if UI.TreeNode(pet_name) then
            if UI.BeginTable(pet_name, 3, table_flags) then
                UI.TableSetupColumn("Total Damage", col_flags, damage)
                UI.TableSetupColumn("Total Damage %", col_flags, damage)
                UI.TableSetupColumn("Pet Damage %", col_flags, damage)
                UI.TableHeadersRow()

                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET)
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET, true, nil, true)
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET, true)
                UI.EndTable()
            end

            if UI.BeginTable(pet_name, 3, table_flags) then
                UI.TableSetupColumn("Melee Damage", col_flags, damage)
                UI.TableSetupColumn("Melee Accuracy", col_flags, damage)
                UI.TableSetupColumn("Ranged Damage", col_flags, damage)
                --UI.TableSetupColumn("Ranged Accuracy", col_flags, damage)
                UI.TableHeadersRow()

                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_MELEE)
                UI.TableNextColumn() Col.Acc.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_MELEE_DISCRETE)
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_RANGED)
                UI.EndTable()
            end

            if UI.BeginTable(pet_name, 3, table_flags) then
                UI.TableSetupColumn("WS Damage", col_flags, damage)
                UI.TableSetupColumn("Abil. Damage", col_flags, damage)
                --UI.TableSetupColumn("Spell Damage", col_flags, damage)
                UI.TableSetupColumn("Healing", col_flags, damage)
                UI.TableHeadersRow()

                UI.TableNextRow()
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_WS)
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_ABILITY)
                UI.TableNextColumn() Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_HEAL)
                UI.EndTable()
            end

            if UI.BeginTable(pet_name.." single", 7, table_flags) then
                -- Headers
                UI.TableSetupColumn("Action Name", col_flags, damage)
                UI.TableSetupColumn("Total Damage", col_flags, damage)
                UI.TableSetupColumn("Attempts", col_flags, damage)
                UI.TableSetupColumn("Accuracy %", col_flags, damage)
                UI.TableSetupColumn("Avg. Damage", col_flags, damage)
                UI.TableSetupColumn("Min. Damage", col_flags, damage)
                UI.TableSetupColumn("Max. Damage", col_flags, damage)
                UI.TableHeadersRow()

                Model.Sort.Pet_Catalog_Damage(player_name, pet_name)

                -- Data
                local has_data = false
                for _, data in ipairs(Model.Data.Pet_Catalog_Damage_Race) do
                    has_data = true
                    local action_name = data[1]
                    local trackable = data[3]
                    f.Display.Util.Pet_Single_Row(player_name, pet_name, action_name, trackable)
                end
                if not has_data then
                    f.Display.Util.Pet_Blank_Row()
                end
                UI.EndTable()
            end
            UI.TreePop()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to a row for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@param pet_name string
---@param action_name string
---@param trackable string a trackable from the data model.
------------------------------------------------------------------------------------------------------
f.Display.Util.Pet_Single_Row = function(player_name, pet_name, action_name, trackable)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.TOTAL)
    UI.TableNextColumn() Col.Single.Pet_Attempts(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Col.Single.Pet_Acc(player_name, pet_name, action_name, trackable)
    UI.TableNextColumn() Col.Single.Pet_Average(player_name, pet_name, action_name, trackable)

    local min = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, Model.Enum.Metric.MIN)
    if min == f.Enum.OVERFLOW then
        UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Misc.IGNORE)
    else
        UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MIN)
    end

    UI.TableNextColumn() Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MAX)
end

------------------------------------------------------------------------------------------------------
-- Creates a blank table row for when pets haven't done ability yet, but you can still see their data.
------------------------------------------------------------------------------------------------------
f.Display.Util.Pet_Blank_Row = function()
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text("None")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
    UI.TableNextColumn() UI.Text("0")
end

------------------------------------------------------------------------------------------------------
-- Display a graph of damage types.
-- NOT IMPLEMENTED due to lack of labels on the bar graphs. :(
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Graph = function(player_name)
    local total = Col.Util.Total_Damage(player_name)
    if total <= 0 then return nil end
    local melee = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.MELEE) / total
    local ranged = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.RANGED) / total
    local ws = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.WS) / total
    local sc = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.SC) / total
    local magic = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.MAGIC) / total
    local ability = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.ABILITY) / total
    local pet = Col.Damage.By_Type_Raw(player_name, Model.Enum.Trackable.PET) / total
    local graph_data = {melee, ranged, ws, sc, magic, ability, pet}
    UI.PlotHistogram("Damage Distribution", graph_data, #graph_data, 0, nil, 0, nil, {0, 30})
end

------------------------------------------------------------------------------------------------------
-- Collapse header buttons.
------------------------------------------------------------------------------------------------------
f.Display.Util.Buttons = function()
    f.Display.Flags.Open_Action = -1
    if UI.Button("Expand all") then
        f.Display.Flags.Open_Action = 1
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    if UI.Button("Collapse all") then
        f.Display.Flags.Open_Action = 0
    end
end

------------------------------------------------------------------------------------------------------
-- Works in conjunction with collapse all or expand all.
------------------------------------------------------------------------------------------------------
f.Display.Util.Check_Collapse = function()
    if f.Display.Flags.Open_Action ~= -1 then UI.SetNextItemOpen(f.Display.Flags.Open_Action ~= 0) end
end

return f