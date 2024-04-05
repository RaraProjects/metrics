local bl = {}

bl.Window = {
    Name = "Battle Log",
    X = 600,
    Y = 120,
    Alpha = 225,
    Visible = true,
}

bl.Log = {}
bl.Log.Data = {}

bl.Display = {}
bl.Display.Screen = {}
bl.Display.Item = {}

bl.Display.Flags = {
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

bl.Settings = {
    Length = 13
}

bl.Reset = function()
    bl.Log.Data = {}
end

------------------------------------------------------------------------------------------------------
-- Format the name component of the battle log.
------------------------------------------------------------------------------------------------------
bl.Display.Item.Name = function(player_name)
    -- local color = Blog_Default_Color
    -- if Is_Me(player_name) then color = C_Bright_Green end
    -- return Format_String(player_name, 9, color)
    return player_name
end

------------------------------------------------------------------------------------------------------
-- Format the damage component of the battle log.
------------------------------------------------------------------------------------------------------
bl.Display.Item.Damage = function(damage)
    -- Damage threshold colors
    -- local color = Blog_Default_Color
    -- local damage_string Format_Number(0, 6)

    if not damage then
        return 0
        -- Do nothing
    -- elseif (damage >= 70000) then
    --     damage_string = Format_Number(damage, 6, C_Bright_Green)
    -- elseif (damage >= 50000) then
    --     damage_string = Format_Number(damage, 6, C_Green)
    -- elseif (damage >= 30000) then
    --     damage_string = Format_Number(damage, 6, C_Yellow)
    -- elseif (damage >= 10000) then
    --     damage_string = Format_Number(damage, 6, C_Orange)
    -- elseif (damage == 0) then
    --     damage_string = Format_String(' MISS!', 6, C_Red)
    -- else
    --     damage_string = Format_Number(damage, 6)
    end

    return Col.String.Format_Number(damage)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
bl.Display.Item.Action = function(action_name, action_type, action_data)
    -- local color = C_White
    -- if action_type == 'spell' or action_type == 'ability' or action_type == 'ws' then
    --     if not action_data then return "DEBUG" end
    --     color = Elemental_Coloring(action_data)
    -- end
    -- return Format_String(action_name, 15, color)
    return action_name
end

------------------------------------------------------------------------------------------------------
-- Format the TP string for the battle log.
-- tp_value: How much TP was used by the weaponskill
------------------------------------------------------------------------------------------------------
bl.Display.Item.TP = function(tp_value)
    -- local color
    if tp_value then
        -- if (tp_value == 3000) then
        --     color = C_Green
        -- elseif (tp_value >= 2500) then
        --     color = C_Yellow
        -- elseif (tp_value >= 2000) then
        --     color = C_Orange
        -- end
        -- return '('..Format_Number(tp_value, 5, color, nil, nil, true)..')'
        return Col.String.Format_Number(tp_value)
    end
    return " "
end

------------------------------------------------------------------------------------------------------
-- DESCRIPTION:    Add an entry to battle log.
-- PARAMETERS :
-- player_name: Name of the player that took the action
-- action_name: Name of the action the player took (like a weaponskill or ability)
-- damage     : Usually how much damage the action did
-- line_color : The color that this line in the battle log should be
-- tp_value   : How much TP was used by the weaponskill
------------------------------------------------------------------------------------------------------
bl.Log.Add = function(player_name, action_name, damage, line_color, tp_value, action_type, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #bl.Log.Data >= bl.Settings.Length then table.remove(bl.Log.Data, bl.Settings.Length) end

    local entry = {
        Name   = bl.Display.Item.Name(player_name),
        Damage = bl.Display.Item.Damage(damage),
        Action = bl.Display.Item.Action(action_name, action_type, action_data),
        TP     = bl.Display.Item.TP(tp_value)
    }

    -- Need the space at the beginning to keep the color cut off glitch from happening.
    table.insert(bl.Log.Data, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
bl.Populate = function()
    if UI.BeginTable("Blog", 4, Window.Table.Flags.None) then
        bl.Display.Item.Headers()
        for _, entry in ipairs(bl.Log.Data) do
            bl.Display.Item.Rows(entry)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
bl.Display.Item.Headers = function()
    local no_flags = Window.Columns.Flags.None
    local expandable = Window.Columns.Flags.Expandable
    local name = Window.Columns.Widths.Name
    local damage = Window.Columns.Widths.Damage
    UI.TableSetupColumn("Name", no_flags)
    UI.TableSetupColumn("Damage", no_flags)
    UI.TableSetupColumn("Action", no_flags)
    UI.TableSetupColumn("TP", no_flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------
bl.Display.Item.Rows = function(entry)
    -- ImGui::TextColored(ImVec4(1.0f, 0.0f, 1.0f, 1.0f), "Pink");
    UI.TableNextRow()
    UI.TableNextColumn() UI.Text(entry.Name)
    UI.TableNextColumn() UI.Text(tostring(entry.Damage))
    UI.TableNextColumn() UI.Text(entry.Action)
    UI.TableNextColumn() UI.Text(tostring(entry.TP))
end

return bl




-- --[[
--     DESCRIPTION:    Refresh the battle log.
-- ]]
-- function Refresh_Blog()
--     if (Show_Blog) then Blog_Window:show() else Blog_Window:hide() end
--     Blog_Content.token = Concat_Strings(Blog)
--     Blog_Window:update(Blog_Content)
-- end




-- --[[
--     DESCRIPTION:
-- ]]
-- function Elemental_Coloring(action_data)
--     if (not action_data) then return end

--     local color = Elemental_Colors[action_data.element]

--     if (not color) then
--         Add_Message_To_Chat('W', 'Spell_Coloring^battle_log', 'Unable to map spell coloring for '..action_data.name)
--     end

--     return color
-- end

-- --[[
--     DESCRIPTION:
-- ]]
-- function Set_Log_Show_Defaults()
--     Log_Melee    = false
--     Log_Ranged   = false
--     Log_WS       = true
--     Log_SC       = true
--     Log_Magic    = true
--     Log_Abiilty  = false
--     Log_Pet      = false
--     Log_Healing  = false
--     Log_Deaths   = false
-- end

-- --[[
--     DESCRIPTION:
-- ]]
-- function Set_Log_Show_All()
--     Log_Melee    = true
--     Log_Ranged   = true
--     Log_WS       = true
--     Log_SC       = true
--     Log_Magic    = true
--     Log_Abiilty  = true
--     Log_Pet      = true
--     Log_Healing  = true
--     Log_Deaths   = true
-- end