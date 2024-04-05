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
    Trackable = "ws",
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
        UI.TableSetupColumn("Melee", flags, width)
        UI.TableSetupColumn("% Damage", flags, width)
        UI.TableSetupColumn("T Acc", flags, width)
        UI.TableSetupColumn("P Acc", flags, width)
        UI.TableSetupColumn("S Acc", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'melee'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'melee', true))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, 'melee'))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, 'melee primary'))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, 'melee secondary'))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Ranged = function(player_name, ranged_total)
    local flags = f.Display.Columns.Flags
    local width = f.Display.Columns.Width.Standard
    local percent = f.Display.Columns.Width.Percent

    if ranged_total > 0 then
        -- Headers
        UI.TableSetupColumn("Raw\nDamage", flags, width)
        UI.TableSetupColumn("Total\nDamage %", flags, width)
        UI.TableSetupColumn("Total\nAcc %", flags, width)
        UI.TableSetupColumn("Crit\nDamage", flags, width)
        UI.TableSetupColumn("Crit\nDamage %", flags, width)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'ranged'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'ranged', true))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, 'ranged'))
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'ranged'))
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'ranged', true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Crits = function(player_name, melee_crits, ranged_crits)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent

    if melee_crits > 0 or ranged_crits > 0 then
        -- Headers
        UI.TableSetupColumn("Crits", flags, damage)
        UI.TableSetupColumn("% Damage", flags, damage)
        UI.TableSetupColumn("Total %", flags, damage)
        UI.TableSetupColumn("Melee %", flags, damage)
        UI.TableSetupColumn("Ranged %", flags, damage)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'combined'))
        UI.TableNextColumn() UI.Text(Col.Crit.Damage(player_name, 'combined', true))
        UI.TableNextColumn() UI.Text(Col.Crit.Focus_Rate(player_name, 'combined'))
        UI.TableNextColumn() UI.Text(Col.Crit.Focus_Rate(player_name, 'melee'))
        UI.TableNextColumn() UI.Text(Col.Crit.Focus_Rate(player_name, 'ranged'))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.WS_and_SC = function(player_name, ws_total)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent

    if ws_total > 0 then
        -- Headers
        UI.TableSetupColumn("WS", flags, damage)
        UI.TableSetupColumn("% Damage", flags, damage)
        UI.TableSetupColumn("% Acc", flags, damage)
        UI.TableSetupColumn("SC", flags, damage)
        UI.TableSetupColumn("% SC", flags, damage)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'ws'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'ws', true))
        UI.TableNextColumn() UI.Text(Col.Acc.By_Type(player_name, 'ws'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'sc'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'sc', true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Magic = function(player_name, magic_total)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent

    if magic_total > 0 then
        -- Headers
        UI.TableSetupColumn("Magic", flags, damage)
        UI.TableSetupColumn("% Damage", flags, percent)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'magic'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'magic', true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Ability = function(player_name, ability_total)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent

    if ability_total > 0 then
        -- Headers
        UI.TableSetupColumn("Ability", flags, damage)
        UI.TableSetupColumn("% Damage", flags, percent)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'ability'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'ability', true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Healing = function(player_name, healing_total)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent

    if healing_total > 0 then
        -- Headers
        UI.TableSetupColumn("Healing", flags, damage)
        UI.TableSetupColumn("% Total", flags, percent)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'healing'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'healing', true))
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Pet = function(player_name, pet_total)
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent

    if pet_total > 0 then
        -- Headers
        UI.TableSetupColumn("Total", flags, damage)
        UI.TableSetupColumn("% Damage", flags, damage)
        UI.TableSetupColumn("Melee", flags, damage)
        UI.TableSetupColumn("Ranged", flags, damage)
        UI.TableSetupColumn("Weaponskill", flags, damage)
        UI.TableSetupColumn("Ability", flags, damage)
        UI.TableHeadersRow()

        -- Data
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'pet'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'pet', true))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'pet_melee'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'pet_ranged'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'pet_ws'))
        UI.TableNextColumn() UI.Text(Col.Damage.By_Type(player_name, 'pet_ability'))
    end
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
                UI.TableSetupColumn("Total", flags, damage)
                UI.TableSetupColumn("% Damage", flags, damage)
                UI.TableSetupColumn("Melee", flags, damage)
                UI.TableSetupColumn("Ranged", flags, damage)
                UI.TableSetupColumn("Weaponskill", flags, damage)
                UI.TableSetupColumn("Ability", flags, damage)
                UI.TableHeadersRow()

                UI.TableNextRow()
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, 'pet'))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, 'pet', true))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, 'pet_melee'))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, 'pet_ranged'))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, 'pet_ws'))
                UI.TableNextColumn() UI.Text(Col.Damage.Pet_By_Type(player_name, pet_name, 'pet_ability'))
                UI.EndTable()
            end


            if UI.BeginTable(pet_name.." single", 7, f.Display.Table.Flags) then
                -- Headers
                UI.TableSetupColumn("Action Name", flags, name)
                UI.TableSetupColumn("Total", flags, damage)
                UI.TableSetupColumn("Count", flags, damage)
                UI.TableSetupColumn("Acc", flags, damage)
                UI.TableSetupColumn("Avg", flags, damage)
                UI.TableSetupColumn("Min", flags, damage)
                UI.TableSetupColumn("Max", flags, damage)
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
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, 'total'))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Attempts(player_name, pet_name, action_name, trackable))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Acc(player_name, pet_name, action_name, trackable))
    UI.TableNextColumn() UI.Text(Col.Single.Pet_Average(player_name, pet_name, action_name, trackable))

    local min = Model.Get.Pet_Catalog(player_name, pet_name, trackable, action_name, 'min')
    if min == 100000 then
        UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, 'ignore'))
    else
        UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, 'min'))
    end

    UI.TableNextColumn() UI.Text(Col.Single.Pet_Damage(player_name, pet_name, action_name, trackable, 'max'))
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Single_Data = function(player_name)
    if not f.Settings.Trackable then f.Settings.Trackable = 'ws' end
    local flags = f.Display.Columns.Flags
    local damage = f.Display.Columns.Width.Damage
    local percent = f.Display.Columns.Width.Percent
    local name = f.Display.Columns.Width.Name
    local single = f.Display.Columns.Width.Single

    -- Error Protection
    if not Model.Data.Trackable[f.Settings.Trackable] then return nil end
    if not Model.Data.Trackable[f.Settings.Trackable][player_name] then return nil end

    -- Headers
    UI.TableSetupColumn("Name", flags, name)
    UI.TableSetupColumn("Total", flags, damage)
    UI.TableSetupColumn("Count", flags, damage)
    UI.TableSetupColumn("Acc", flags, damage)
    UI.TableSetupColumn("Avg", flags, damage)
    UI.TableSetupColumn("Min", flags, damage)
    UI.TableSetupColumn("Max", flags, damage)
    UI.TableHeadersRow()

    Model.Sort.Catalog_Damage(player_name)

    -- Data
    local action_name
    for _, data in ipairs(Model.Data.Catalog_Damage_Race) do
        action_name = data[1]
        f.Display.Item.Single_Row(player_name, action_name)
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Item.Single_Row = function(player_name, action_name)
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(action_name)
    UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, 'total'))
    UI.TableNextColumn() UI.Text(Col.Single.Attempts(player_name, action_name))
    UI.TableNextColumn() UI.Text(Col.Single.Acc(player_name, action_name))
    UI.TableNextColumn() UI.Text(Col.Single.Average(player_name, action_name))

    local min = Model.Get.Catalog(player_name, f.Settings.Trackable, action_name, 'min')
    if min == 100000 then
        UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, 'ignore'))
    else
        UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, 'min'))
    end

    UI.TableNextColumn() UI.Text(Col.Single.Damage(player_name, action_name, 'max'))
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Display.Item.Player_Filter = function()
    local list = Model.Data.Player_List_Sorted
    local flags = ImGuiComboFlags_None
    if list[1] then
        if UI.BeginCombo("Focused Entity", list[f.Display.Dropdown.Index], flags) then
            for n = 1, #list, 1 do
                local is_selected = f.Display.Dropdown.Index == n
                if UI.Selectable(list[n], is_selected) then
                    f.Display.Dropdown.Index = n
                    f.Display.Dropdown.Focus = list[n]
                end
                -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo("Focused Entity", "!NONE", flags) then
            UI.EndCombo()
        end
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
f.Populate = function()
    f.Display.Item.Player_Filter()
    local player_name = f.Display.Dropdown.Focus
    -- Focus_Window.Add_Line(player_name..' ('..Col_Grand_Total(player_name)..')')

    --A.Chat.Message("Populate " .. player_name)

    local melee_total = Model.Get.Data(player_name, 'melee', 'total')
    local ranged_total = Model.Get.Data(player_name, 'ranged', 'total')
    local melee_crits = Model.Get.Data(player_name, 'melee', 'crits')
    local ranged_crits = Model.Get.Data(player_name, 'ranged', 'crits')
    local ws_total = Model.Get.Data(player_name, 'ws', 'total')
    local magic_total = Model.Get.Data(player_name, 'magic', 'total')
    local ability_total = Model.Get.Data(player_name, 'ability', 'total')
    local healing_total = Model.Get.Data(player_name, 'healing', 'total')
    local pet_total = Model.Get.Data(player_name, 'pet', 'total')

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
        if UI.CollapsingHeader("Crits", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Crits", 5, f.Display.Table.Flags) then
                f.Display.Crits(player_name, melee_crits, ranged_crits)
                UI.EndTable()
            end
        end
    end

    if ws_total > 0 then
        if UI.CollapsingHeader("WS and SC", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("WS and SC", 5, f.Display.Table.Flags) then
                f.Display.WS_and_SC(player_name, ws_total)
                UI.EndTable()
            end
        end
    end

    if magic_total > 0 then
        if UI.CollapsingHeader("Magic", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Magic", 2, f.Display.Table.Flags) then
                f.Display.Magic(player_name, magic_total)
                UI.EndTable()
            end
        end
    end

    if ability_total > 0 then
        if UI.CollapsingHeader("Ability", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Ability", 2, f.Display.Table.Flags) then
                f.Display.Ability(player_name, ability_total)
                UI.EndTable()
            end
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

    if Model.Data.Trackable[f.Settings.Trackable] and Model.Data.Trackable[f.Settings.Trackable][player_name] then
        if UI.CollapsingHeader("Catalog", ImGuiTreeNodeFlags_None) then
            if UI.BeginTable("Single", 7, f.Display.Table.Flags) then
                f.Display.Single_Data(player_name)
                UI.EndTable()
            end
        end
    end

    -- Pet/Avatar Specific Catalogs
end

return f