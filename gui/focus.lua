local f = {}

f.Window = {
    Name = "Focus",
    X = 600,
    Y = 120,
    Alpha = 225,
    Visible = true,
}

f.Log = {}
f.Log.Data = {}

f.Display = {}
f.Display.Screen = {}
f.Display.Item = {}
f.Display.Columns = {}
f.Display.Columns.Flags = bit.bor(
    ImGuiTableColumnFlags_None
)
f.Display.Columns.Width = {
    Damage = 80,
    Percent = 60,
    Name = 200,
    Single = 40,
    Standard = 100,
}
f.Display.Dropdown = {
    Focus = "!NONE",
    Index = 1,
}

f.Display.Table = {}
f.Display.Table.Flags =bit.bor(
    ImGuiTableFlags_PadOuterX,
    ImGuiTableFlags_Borders
)

f.Display.Flags = {
    Melee   = true,
    Ranged  = true,
    WS      = true,
    SC      = true,
    Magic   = true,
    Ability = true,
    Pet     = true,
    Healing = true,
    Deaths  = true,
}

f.Settings = {
    Trackable = "magic",
    Focus = "!NONE",
}

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Melee = function(player_name, melee_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard
    local percent = f.Display.Columns.Width.Percent

    if melee_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableSetupColumn("Total\nAccuracy %", flags, width)
        UI.TableSetupColumn("Main\nAccuracy %", flags, width)
        UI.TableSetupColumn("Offhand\nAccuracy %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.MELEE, true))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_MAIN))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, Model.Enum.Trackable.MELEE_OFFH))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Ranged = function(player_name, ranged_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard
    local percent = f.Display.Columns.Width.Percent

    local trackable = Model.Enum.Trackable.RANGED

    if ranged_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableSetupColumn("Total\nAccuracy %", flags, width)
        UI.TableSetupColumn("Crit\nDamage", flags, width)
        UI.TableSetupColumn("Crit\nDamage %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, trackable))
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, trackable))
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, trackable, true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Crits = function(player_name, melee_crits, ranged_crits)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard

    if melee_crits > 0 or ranged_crits > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableSetupColumn("Total\nCrit Rate %", flags, width)
        UI.TableSetupColumn("Melee\nCrit Rate %", flags, width)
        UI.TableSetupColumn("Ranged\nCrit Rate %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'combined'))
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'combined', true))
        UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, 'combined'))
        UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, Model.Enum.Trackable.MELEE))
        UI.TableNextColumn() UI.Text(Col.Crit.Rate(player_name, Model.Enum.Trackable.RANGED))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.WS_and_SC = function(player_name, ws_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard

    local trackable_ws = Model.Enum.Trackable.WS
    local trackable_sc = Model.Enum.Trackable.SC

    if ws_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw WS\nDamage", flags, width)
        UI.TableSetupColumn("Total WS\nDamage %", flags, width)
        UI.TableSetupColumn("Total\nAccuracy %", flags, width)
        UI.TableSetupColumn("Raw SC\nDamage", flags, width)
        UI.TableSetupColumn("Total SC\nDamage %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_ws))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_ws, true))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, trackable_ws))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_sc))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable_sc, true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Magic = function(player_name, magic_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard

    local trackable = Model.Enum.Trackable.MAGIC

    if magic_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Ability = function(player_name, ability_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard

    local trackable = Model.Enum.Trackable.ABILITY

    if ability_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Healing = function(player_name, healing_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard

    local trackable = Model.Enum.Trackable.HEALING

    if healing_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nHealing", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, trackable, true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Pet = function(player_name, pet_total)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage

    if pet_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, damage)
        UI.TableSetupColumn("Total\nDamage %", flags, damage)
        UI.TableSetupColumn("Melee\nDamage", flags, damage)
        UI.TableSetupColumn("Ranged\nDamage", flags, damage)
        UI.TableSetupColumn("Weaponskill\nDamage", flags, damage)
        UI.TableSetupColumn("Ability\nAbility", flags, damage)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET, true))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_MELEE))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_RANGED))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_WS))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, Model.Enum.Trackable.PET_ABILITY))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Single_Data = function(player_name, focus_type)
    if not focus_type then return nil end
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local name = f.Display.Columns.Width.Name

    -- Error Protection
    if not Model.Data.Trackable[focus_type] then return nil end
    if not Model.Data.Trackable[focus_type][player_name] then return nil end

    if UI.CollapsingHeader(" >>> " .. focus_type .. " - Catalog", ImGuiTreeNodeFlags_None) then
        if UI.BeginTable(focus_type, 7, f.Display.Table.Flags) then
            UI.TableSetupColumn("Action Name", flags, name)
            UI.TableSetupColumn("Total\nDamage", flags, damage)
            UI.TableSetupColumn("Attempts", flags, damage)
            UI.TableSetupColumn("Accuracy %", flags, damage)
            UI.TableSetupColumn("Average\nDamage", flags, damage)
            UI.TableSetupColumn("Minimum\nDamage", flags, damage)
            UI.TableSetupColumn("Maximum\nDamage", flags, damage)
            UI.TableHeadersRow()

            Model.Sort.Catalog_Damage(player_name, focus_type)

            -- Data
            local action_name
            for _, data in ipairs(Model.Data.Catalog_Damage_Race) do
                action_name = data[1]
                f.Display.Item.Single_Row(player_name, action_name, focus_type)
            end
            UI.EndTable()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Item.Single_Row = function(player_name, action_name, focus_type)
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
-- 
------------------------------------------------------------------------------------------------------
f.Display.Pet_Single_Data = function(player_name)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local name = f.Display.Columns.Width.Name

    for pet_name, _ in pairs(Model.Data.Initialized_Pets[player_name]) do
        if UI.CollapsingHeader(pet_name, ImGuiTreeNodeFlags_None) then
            if UI.BeginTable(pet_name, 6, f.Display.Table.Flags) then
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


            if UI.BeginTable(pet_name.." single", 7, f.Display.Table.Flags) then
                -- Headers
                UI.TableSetupColumn("Action Name", flags, name)
                UI.TableSetupColumn("Total\nDamage", flags, damage)
                UI.TableSetupColumn("Attempts", flags, damage)
                UI.TableSetupColumn("Accuracy %", flags, damage)
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
                    f.Display.Item.Pet_Single_Row(player_name, pet_name, action_name, trackable)
                end
                UI.EndTable()
            end

        end
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Item.Pet_Single_Row = function(player_name, pet_name, action_name, trackable)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.TOTAL))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Attempts(player_name, pet_name, action_name, trackable))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Acc(player_name, pet_name, action_name, trackable))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Average(player_name, pet_name, action_name, trackable))

    local min = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, Model.Enum.Metric.MIN)
    if min == 100000 then
        UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Misc.IGNORE))
    else
        UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MIN))
    end

    UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, Model.Enum.Metric.MAX))
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Populate = function()
    Window.Dropdown.Player_Filter()
    UI.SameLine()
    Window.Dropdown.Mob_Filter()
    local player_name = f.Display.Dropdown.Focus
    -- Focus_Window.Add_Line(player_name..' ('..Col_Grand_Total(player_name)..')')

    local melee_total = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.TOTAL)
    local ranged_total = Model.Get.Data(player_name, Model.Enum.Trackable.RANGED, Model.Enum.Metric.TOTAL)
    local melee_crits = Model.Get.Data(player_name, Model.Enum.Trackable.MELEE, Model.Enum.Metric.CRIT_DAMAGE)
    local ranged_crits = Model.Get.Data(player_name, Model.Enum.Trackable.RANGED, Model.Enum.Metric.CRIT_DAMAGE)
    local ws_total = Model.Get.Data(player_name, Model.Enum.Trackable.WS, Model.Enum.Metric.TOTAL)
    local magic_total = Model.Get.Data(player_name, Model.Enum.Trackable.MAGIC, Model.Enum.Metric.TOTAL)
    local ability_total = Model.Get.Data(player_name, Model.Enum.Trackable.ABILITY, Model.Enum.Metric.TOTAL)
    local healing_total = Model.Get.Data(player_name, Model.Enum.Trackable.HEALING, Model.Enum.Metric.TOTAL)
    local pet_total = Model.Get.Data(player_name, Model.Enum.Trackable.PET, Model.Enum.Metric.TOTAL)

    if melee_total > 0 then
        if UI.CollapsingHeader("Melee", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Melee", 5, f.Display.Table.Flags) then
                f.Display.Melee(player_name, melee_total)
                UI.EndTable()
            end
        end
    end

    if ranged_total > 0 then
        if UI.CollapsingHeader("Ranged", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ranged", 5, f.Display.Table.Flags) then
                f.Display.Ranged(player_name, ranged_total)
                UI.EndTable()
            end
        end
    end

    if melee_crits > 0 or ranged_crits > 0 then
        if UI.CollapsingHeader("Critical Hits", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Crits", 5, f.Display.Table.Flags) then
                f.Display.Crits(player_name, melee_crits, ranged_crits)
                UI.EndTable()
            end
        end
    end

    if ws_total > 0 then
        if UI.CollapsingHeader("Weaponskill and Skillchain", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("WS and SC", 5, f.Display.Table.Flags) then
                f.Display.WS_and_SC(player_name, ws_total)
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

    if magic_total > 0 then
        if UI.CollapsingHeader("Magic", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Magic", 2, f.Display.Table.Flags) then
                f.Display.Magic(player_name, magic_total)
                UI.EndTable()
            end
            f.Display.Single_Data(player_name, Model.Enum.Trackable.MAGIC)
        end
    end

    if ability_total > 0 then
        if UI.CollapsingHeader("Ability", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ability", 2, f.Display.Table.Flags) then
                f.Display.Ability(player_name, ability_total)
                UI.EndTable()
            end
            f.Display.Single_Data(player_name, Model.Enum.Trackable.ABILITY)
        end
    end

    if healing_total > 0 then
        if UI.CollapsingHeader("Healing", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Healing", 2, f.Display.Table.Flags) then
                f.Display.Healing(player_name, healing_total)
                UI.EndTable()
            end
        end
    end

    if pet_total > 0 then
        if UI.CollapsingHeader("Pets", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Pets", 6, f.Display.Table.Flags) then
                f.Display.Pet(player_name, pet_total)
                UI.EndTable()
            end
            f.Display.Pet_Single_Data(player_name)
        end
    end
end

return f