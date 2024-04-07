local bl = {}

bl.Log = {}
bl.Display = {}
bl.Util = {}

bl.Flags = {
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
bl.Flags.Defaults = {
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

bl.Enum = {}
bl.Enum.Thresholds = {
    WS    = 600,
    MAGIC = 1000,
    MAX   = 99999,
}
bl.Enum.Text = {
    MISS = "MISS!",
    NA = "---"
}

-- FUTURE CONSIDERATIONS
-- Highlight damage if the damage is higher than the average for that weaponskill.

------------------------------------------------------------------------------------------------------
-- Resets the battle log.
------------------------------------------------------------------------------------------------------
bl.Reset_Log = function()
    bl.Log = {}
end

------------------------------------------------------------------------------------------------------
-- Resets the battle log settings.
------------------------------------------------------------------------------------------------------
bl.Reset_Settings = function()
    for index, _ in pairs(bl.Flags) do
        bl.Flags[index] = bl.Flags.Defaults[index]
    end
end

------------------------------------------------------------------------------------------------------
-- Loads the battle log data to the screen.
------------------------------------------------------------------------------------------------------
bl.Populate = function()
    if UI.BeginTable("Blog", 4, Window.Table.Flags.None) then
        bl.Display.Headers()
        for _, entry in ipairs(bl.Log) do
            bl.Display.Rows(entry)
        end
        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Add an entry to battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string name of the player that took the action
---@param action_name string name of the action the player took (like a weaponskill or ability).
---@param damage? number usually how much damage the action did.
---@param tp_value? number how much TP was used by the weaponskill.
---@param action_type? string a trackable from the data model.
---@param action_data? table additional information about the action to help with text formatting.
------------------------------------------------------------------------------------------------------
bl.Add = function(player_name, action_name, damage, tp_value, action_type, action_data)
    -- If the blog is at max length then we will need to remove the last element
    if #bl.Log >= bl.Settings.Length then table.remove(bl.Log, bl.Settings.Length) end
    local entry = {
        Name   = bl.Util.Name(player_name),
        Damage = bl.Util.Damage(damage),
        Action = bl.Util.Action(action_name, action_type, action_data),
        TP     = bl.Util.TP(tp_value)
    }
    table.insert(bl.Log, 1, entry)
end

------------------------------------------------------------------------------------------------------
-- Format the name component of the battle log.
------------------------------------------------------------------------------------------------------
---@param player_name string
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
bl.Util.Name = function(player_name)
    local color = Window.Colors.White
    if A.Mob.Is_Me(player_name) then color = Window.Colors.Green end
    return {Value = player_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the damage component of the battle log.
------------------------------------------------------------------------------------------------------
---@param damage? number
---@param action_type? string a trackable from the data model.
---@return table {Damage, Color}
------------------------------------------------------------------------------------------------------
bl.Util.Damage = function(damage, action_type)
    -- Change the color of the text if the damage is over a certain threshold.
    local threshold = bl.Enum.Thresholds.MAX
    if action_type == Model.Enum.Trackable.WS then
        threshold = bl.Enum.Thresholds.WS
    elseif action_type == Model.Enum.Trackable.MAGIC then
        threshold = bl.Enum.Thresholds.MAGIC
    end
    -- Generate damage string.
    if not damage then
        return {Value = bl.Enum.Text.NA, Color = Window.Colors.Dim}
    elseif damage == 0 then
        return {Value = bl.Enum.Text.MISS, Color = Window.Colors.Red}
    elseif damage >= threshold then
        return {Value = Col.String.Format_Number(damage), Color = Window.Colors.Purple}
    end
    return {Value = Col.String.Format_Number(damage), Color = Window.Colors.White}
end

------------------------------------------------------------------------------------------------------
-- Format the action component of the battle log.
------------------------------------------------------------------------------------------------------
---@param action_name string
---@param action_type string a trackable from the data model.
---@param action_data table additional information about the action to help with text formatting.
---@return table {Name, Color}
------------------------------------------------------------------------------------------------------
bl.Util.Action = function(action_name, action_type, action_data)
    local color = Window.Colors.White
    if action_type == Model.Enum.Trackable.MAGIC then
        local element = action_data.Element
        color = Window.Colors.Elements[element]
    end
    return {Value = action_name, Color = color}
end

------------------------------------------------------------------------------------------------------
-- Format the TP component of the battle log.
------------------------------------------------------------------------------------------------------
---@param tp_value number how much TP was used by the weaponskill
---@return string
------------------------------------------------------------------------------------------------------
bl.Util.TP = function(tp_value)
    if tp_value then return Col.String.Format_Number(tp_value) end
    return " "
end

------------------------------------------------------------------------------------------------------
-- Build the header component of the battle log table.
------------------------------------------------------------------------------------------------------
bl.Display.Headers = function()
    local no_flags = Window.Columns.Flags.None
    UI.TableSetupColumn("Name", no_flags)
    UI.TableSetupColumn("Damage", no_flags)
    UI.TableSetupColumn("Action", no_flags)
    UI.TableSetupColumn("TP", no_flags)
    UI.TableHeadersRow()
end

------------------------------------------------------------------------------------------------------
-- Build a row of the battle log table.
------------------------------------------------------------------------------------------------------
bl.Display.Rows = function(entry)
    UI.TableNextRow()
    UI.TableNextColumn() UI.TextColored(entry.Name.Color, entry.Name.Value)
    UI.TableNextColumn() UI.TextColored(entry.Damage.Color, entry.Damage.Value)
    UI.TableNextColumn() UI.TextColored(entry.Action.Color, entry.Action.Value)
    UI.TableNextColumn() UI.Text(tostring(entry.TP))
end

return bl