local f = {}

f.Display = {}
f.Display.Util = {}

f.Enum = {
    OVERFLOW = 100000,
}

------------------------------------------------------------------------------------------------------
-- Loads the focus data to the screen.
------------------------------------------------------------------------------------------------------
f.Populate = function()
    Window.Widget.Player_Filter()
    UI.SameLine()
    Window.Widget.Mob_Filter()
    local player_name = Window.Util.Get_Player_Focus()
    UI.Text("Grand Total: " .. Col.Damage.Total(player_name))
    f.Display.Melee(player_name)
    f.Display.Ranged(player_name)
    f.Display.Crits(player_name)
    f.Display.WS_and_SC(player_name)
    f.Display.Magic(player_name)
    f.Display.Ability(player_name)
    f.Display.Healing(player_name)
    f.Display.Pet(player_name)
end

------------------------------------------------------------------------------------------------------
-- Loads data to the melee drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Melee = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard

    local melee_total = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.TOTAL)
    if melee_total > 0 then
        if UI.CollapsingHeader("Melee", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Melee", 5, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nDamage", col_flags, width)
                UI.TableSetupColumn("Total\nDamage %", col_flags, width)
                UI.TableSetupColumn("Total\nAccuracy %", col_flags, width)
                UI.TableSetupColumn("Main\nAccuracy %", col_flags, width)
                UI.TableSetupColumn("Offhand\nAccuracy %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE, true))
                UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE))
                UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_MAIN))
                UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_OFFH))
                UI.EndTable()
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
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.RANGED

    local ranged_total = Model.Get.Data(player_name, Model.Enum.Trackable.RANGED, Model.Enum.Metric.TOTAL)
    if ranged_total > 0 then
        if UI.CollapsingHeader("Ranged", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ranged", 5, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nDamage", col_flags, width)
                UI.TableSetupColumn("Total\nDamage %", col_flags, width)
                UI.TableSetupColumn("Total\nAccuracy %", col_flags, width)
                UI.TableSetupColumn("Crit\nDamage", col_flags, width)
                UI.TableSetupColumn("Crit\nDamage %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
                UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, trackable))
                UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, trackable))
                UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, trackable, true))
                UI.EndTable()
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
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard

    local melee_crits = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.CRIT_DAMAGE)
    local ranged_crits = Model.Get.Data(player_name, Model.Enum.Trackable.RANGED, Model.Enum.Metric.CRIT_DAMAGE)
    if melee_crits > 0 or ranged_crits > 0 then
        if UI.CollapsingHeader("Critical Hits", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Crits", 5, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nDamage", col_flags, width)
                UI.TableSetupColumn("Total\nDamage %", col_flags, width)
                UI.TableSetupColumn("Total\nCrit Rate %", col_flags, width)
                UI.TableSetupColumn("Melee\nCrit Rate %", col_flags, width)
                UI.TableSetupColumn("Ranged\nCrit Rate %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'combined'))
                UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'combined', true))
                UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, 'combined'))
                UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE))
                UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, Model.Enum.Trackable.RANGED))
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
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard
    local trackable_ws = Model.Enum.Trackable.WS
    local trackable_sc = Model.Enum.Trackable.SC

    local ws_total = Model.Get.Data(player_name, Model.Enum.Trackable.WS, Model.Enum.Metric.TOTAL)
    if ws_total > 0 then
        if UI.CollapsingHeader("Weaponskill and Skillchain", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("WS and SC", 5, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw WS\nDamage", col_flags, width)
                UI.TableSetupColumn("Total WS\nDamage %", col_flags, width)
                UI.TableSetupColumn("Total\nAccuracy %", col_flags, width)
                UI.TableSetupColumn("Raw SC\nDamage", col_flags, width)
                UI.TableSetupColumn("Total SC\nDamage %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_ws))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_ws, true))
                UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, trackable_ws))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_sc))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_sc, true))
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
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.MAGIC

    local magic_total = Model.Get.Data(player_name, Model.Enum.Trackable.MAGIC, Model.Enum.Metric.TOTAL)
    if magic_total > 0 then
        if UI.CollapsingHeader("Magic", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Magic", 2, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nDamage", col_flags, width)
                UI.TableSetupColumn("Total\nDamage %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
                UI.EndTable()
            end
            f.Display.Single_Data(player_name, Model.Enum.Trackable.MAGIC)
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
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.ABILITY

    local ability_total = Model.Get.Data(player_name, Model.Enum.Trackable.ABILITY, Model.Enum.Metric.TOTAL)
    if ability_total > 0 then
        if UI.CollapsingHeader("Ability", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ability", 2, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nDamage", col_flags, width)
                UI.TableSetupColumn("Total\nDamage %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
                UI.EndTable()
            end
            f.Display.Single_Data(player_name, Model.Enum.Trackable.ABILITY)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Loads data to the healing drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string
------------------------------------------------------------------------------------------------------
f.Display.Healing = function(player_name)
    local col_flags = Window.Columns.Flags.None
    local table_flags = Window.Table.Flags.None
    local width = Window.Columns.Widths.Standard
    local trackable = Model.Enum.Trackable.HEALING

    local healing_total = Model.Get.Data(player_name, Model.Enum.Trackable.HEALING, Model.Enum.Metric.TOTAL)
    if healing_total > 0 then
        if UI.CollapsingHeader("Healing", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Healing", 2, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nHealing", col_flags, width)
                UI.TableSetupColumn("Total\nDamage %", col_flags, width)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
                UI.EndTable()
            end
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
    local table_flags = Window.Table.Flags.None
    local damage = Window.Columns.Widths.Damage

    local pet_total = Model.Get.Data(player_name, Model.Enum.Trackable.PET, Model.Enum.Metric.TOTAL)
    if pet_total > 0 then
        if UI.CollapsingHeader("Pets", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Pets", 6, table_flags) then
                -- Headers
                UI.TableSetupColumn("Raw\nDamage", col_flags, damage)
                UI.TableSetupColumn("Total\nDamage %", col_flags, damage)
                UI.TableSetupColumn("Melee\nDamage", col_flags, damage)
                UI.TableSetupColumn("Ranged\nDamage", col_flags, damage)
                UI.TableSetupColumn("Weaponskill\nDamage", col_flags, damage)
                UI.TableSetupColumn("Ability\nDamage", col_flags, damage)
                UI.TableHeadersRow()

                -- Data
                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET, true))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS))
                UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY))
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
    local flags = Window.Columns.Flags.None
    local damage = Window.Columns.Widths.Damage
    local name = Window.Columns.Widths.Name

    -- Error Protection
    if not Model.Data.Trackable[focus_type] then return nil end
    if not Model.Data.Trackable[focus_type][player_name] then return nil end

    if UI.CollapsingHeader(" >>> " .. focus_type .. " - Catalog", ImGuiTreeNodeFlags_None) then
        if UI.BeginTable(focus_type, 7, flags) then
            UI.TableSetupColumn("\nAction Name", flags, name)
            UI.TableSetupColumn("Total\nDamage", flags, damage)
            UI.TableSetupColumn("\nAttempts", flags, damage)
            UI.TableSetupColumn("\nAccuracy %", flags, damage)
            UI.TableSetupColumn("Average\nDamage", flags, damage)
            UI.TableSetupColumn("Minimum\nDamage", flags, damage)
            UI.TableSetupColumn("Maximum\nDamage", flags, damage)
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
    UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.TOTAL))
    UI.TableNextColumn() UI.Text(Col.Single.Attempts(player_name, action_name, focus_type))
    UI.TableNextColumn() UI.Text(Col.Single.Acc(player_name, action_name, focus_type))
    UI.TableNextColumn() UI.Text(Col.Single.Average(player_name, action_name, focus_type))
    local min = Model.Get.Catalog(player_name, focus_type, action_name, Model.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Misc.IGNORE))
    else
        UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.MIN))
    end
    UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, focus_type, Model.Enum.Metric.MAX))
end

------------------------------------------------------------------------------------------------------
-- Sets up the table for a pet trackable drop down inside the focus window.
------------------------------------------------------------------------------------------------------
---@param player_name string owner of the pet.
------------------------------------------------------------------------------------------------------
f.Display.Pet_Single_Data = function(player_name)
    local flags = Window.Columns.Flags.None
    local damage = Window.Columns.Widths.Damage
    local name = Window.Columns.Widths.Name

    for pet_name, _ in pairs(Model.Data.Initialized_Pets[player_name]) do
         -- I considered adding the total damage of the pet to the tree node title,
        -- but the damage changing causes the node to recollapse automatically. Annoying.
        if UI.TreeNode(pet_name) then
            if UI.BeginTable(pet_name, 6, flags) then
                UI.TableSetupColumn("Total\nDamage", flags, damage)
                UI.TableSetupColumn("Total\nDamage %", flags, damage)
                UI.TableSetupColumn("Melee\nDamage", flags, damage)
                UI.TableSetupColumn("Ranged\nDamage", flags, damage)
                UI.TableSetupColumn("Weaponskill\nDamage", flags, damage)
                UI.TableSetupColumn("Ability\nDamage", flags, damage)
                UI.TableHeadersRow()

                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET, true))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_MELEE))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_RANGED))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_WS))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, Model.Enum.Trackable.PET_ABILITY))
                UI.EndTable()
            end


            if UI.BeginTable(pet_name.." single", 7, flags) then
                -- Headers
                UI.TableSetupColumn("\nAction Name", flags, name)
                UI.TableSetupColumn("Total\nDamage", flags, damage)
                UI.TableSetupColumn("\nAttempts", flags, damage)
                UI.TableSetupColumn("\nAccuracy %", flags, damage)
                UI.TableSetupColumn("Average\nDamage", flags, damage)
                UI.TableSetupColumn("Minimum\nDamage", flags, damage)
                UI.TableSetupColumn("Maximum\nDamage", flags, damage)
                UI.TableHeadersRow()

                Model.Sort.Pet_Catalog_Damage(player_name, pet_name)

                -- -- Data
                local action_name, trackable
                for _, data in ipairs(Model.Data.Pet_Catalog_Damage_Race) do
                    action_name = data[1]
                    trackable = data[3]
                    f.Display.Util.Pet_Single_Row(player_name, pet_name, action_name, trackable)
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
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.TOTAL))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Attempts(player_name, pet_name, action_name, trackable))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Acc(player_name, pet_name, action_name, trackable))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Average(player_name, pet_name, action_name, trackable))

    local min = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, Model.Enum.Metric.MIN)
    if min == f.Enum.OVERFLOW then
        UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Misc.IGNORE))
    else
        UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MIN))
    end

    UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MAX))
end

return f