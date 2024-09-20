Parse.Config = T{}

-- Default settings are saved to file.
Parse.Config.Defaults = T{
    X = 100,
    Y = 100,
    Visible           = {true},
    Show_Clock        = true,
    Show_DPS_Graph    = false,
    Include_SC_Damage = false,
    Condensed_Numbers = false,
    Rank_Cutoff       = 6,
    DPS_Graph_Height  = 50,
    Lurk_Mode    = false,
    Focus        = false,
    Jobs         = false,
    Hide_Subjob  = false,
    Hide_Name    = false,
    Total_Acc    = false,
    Running_Acc  = true,
    Melee_Acc    = false,
    Ranged_Acc   = false,
    DPS          = true,
    Attack_Speed = true,
    Ranged_Dist  = false,
    Melee        = true,
    Average_WS   = false,
    Weaponskill  = true,
    WS_Accuracy  = false,
    WS_TP        = false,
    Ranged       = false,
    Magic        = true,
    Ability      = false,
    Crit         = false,
    Melee_Crit   = false,
    Ranged_Crit  = false,
    Pet_Melee    = false,
    Pet_Ranged   = false,
    Pet_Acc      = false,
    Pet_WS       = false,
    Pet_Ability  = false,
    Healing      = false,
    Damage_Taken = false,
    Deaths       = false,
    Grand_Totals = false,
    Global_DPS   = false,
    Show_Filter  = false,
    Name_Colors  = true,
    Display_Mode = Parse.Enum.Display_Mode.FULL,
}

Parse.Config.Column_Flags = Column.Flags.None
Parse.Config.Column_Width = Column.Widths.Settings
Parse.Config.Slider_Width = 100

Parse.Config.DPS_Graph_Window_Flags = bit.bor(ImGuiWindowFlags_NoTitleBar, ImGuiWindowFlags_NoBackground,
                                              ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_AlwaysAutoResize)

------------------------------------------------------------------------------------------------------
-- Resets the Parse window to default settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Reset = function()
    for setting, value in pairs(Parse.Config.Defaults) do
        Metrics.Parse[setting] = value
    end
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Shows settings that affect the Parse screens.
------------------------------------------------------------------------------------------------------
Parse.Config.Display = function()
    Parse.Config.General()
    UI.Separator() Parse.Config.Column_Selection()
end

------------------------------------------------------------------------------------------------------
-- Shows general settings.
------------------------------------------------------------------------------------------------------
Parse.Config.General = function()
    local col_flags = Parse.Config.Column_Flags
    local width = Parse.Config.Column_Width

    UI.Text("General Settings")
    if UI.BeginTable("Parse General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        -- Row 1
        UI.TableNextColumn()
        if UI.Checkbox("Run Time", {Metrics.Parse.Show_Clock}) then
            Metrics.Parse.Show_Clock = not Metrics.Parse.Show_Clock
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Show a timer of how long actions have been taking place.")
        UI.TableNextColumn() Parse.Widgets.SC_Damage()
        UI.TableNextColumn() Parse.Widgets.Condensed_Numbers()

        UI.TableNextColumn()
        if UI.Checkbox("Show Jobs", {Metrics.Parse.Jobs}) then
            Metrics.Parse.Jobs = not Metrics.Parse.Jobs
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Hide Sub Job", {Metrics.Parse.Hide_Subjob}) then
            Metrics.Parse.Hide_Subjob = not Metrics.Parse.Hide_Subjob
        end

        UI.TableNextColumn()
        if UI.Checkbox("Job Colors", {Metrics.Parse.Name_Colors}) then
            Metrics.Parse.Name_Colors = not Metrics.Parse.Name_Colors
        end

        UI.TableNextColumn()
        if UI.Checkbox("Mask Names", {Metrics.Parse.Hide_Name}) then
            Metrics.Parse.Hide_Name = not Metrics.Parse.Hide_Name
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker(
        "Sometimes you want to take a screenshot but are concerned about other player's privacy. " ..
        "Use this setting to use the player's job instead of their name in name columns.")

        UI.TableNextColumn()
        if UI.Checkbox("Total Row", {Metrics.Parse.Grand_Totals}) then
            Metrics.Parse.Grand_Totals = not Metrics.Parse.Grand_Totals
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Lurk Mode", {Metrics.Parse.Lurk_Mode}) then
            Metrics.Parse.Lurk_Mode = not Metrics.Parse.Lurk_Mode
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker(
        "!!! POSSIBLE NEGATIVE PERFORMANCE IMPACT !!!\n" ..
        "Track actions from entities outside of your party/alliance.")

        UI.EndTable()
    end
    Parse.Widgets.Player_Limit()
end

------------------------------------------------------------------------------------------------------
-- Shows column selection settings.
------------------------------------------------------------------------------------------------------
Parse.Config.Column_Selection = function()
    local col_flags = Parse.Config.Column_Flags
    local width = Parse.Config.Column_Width
    Parse.Config.General_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Accuracy_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Physical_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Weaponskill_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Magic_Flags(col_flags, width)
    UI.Separator()
    Parse.Config.Pet_Flags(col_flags, width)
end

------------------------------------------------------------------------------------------------------
-- Shows the general column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.General_Flags = function(col_flags, width)
    Parse.Config.General_Buttons()
    UI.SameLine() UI.Text(" General")
    if UI.BeginTable("Parse General", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Focus Jump", {Metrics.Parse.Focus}) then
            Metrics.Parse.Focus = not Metrics.Parse.Focus
            Parse.Util.Calculate_Column_Flags()
        end
        UI.SameLine() Window_Manager.Widgets.HelpMarker("Provides a button that allows you to quickly jump to the Focus window to look into "
                                                     .. "the specified player's stats more.")

        UI.TableNextColumn()
        if UI.Checkbox("DPS", {Metrics.Parse.DPS}) then
            Metrics.Parse.DPS = not Metrics.Parse.DPS
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Damage Taken", {Metrics.Parse.Damage_Taken}) then
            Metrics.Parse.Damage_Taken = not Metrics.Parse.Damage_Taken
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Deaths", {Metrics.Parse.Deaths}) then
            Metrics.Parse.Deaths = not Metrics.Parse.Deaths
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
    DB.DPS.Dropdown(Parse.Config.Slider_Width)
end

------------------------------------------------------------------------------------------------------
-- Shows the accuracy column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Accuracy_Flags = function(col_flags, width)
    Parse.Config.Accuracy_Buttons()
    UI.SameLine() UI.Text(" Accuracy")
    if UI.BeginTable("Physical Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Acc. Recent", {Metrics.Parse.Running_Acc}) then
            Metrics.Parse.Running_Acc = not Metrics.Parse.Running_Acc
            Parse.Util.Calculate_Column_Flags()
        end
        UI.TableNextColumn()
        UI.TableNextColumn()

        UI.TableNextColumn()
        if UI.Checkbox("Acc. Melee", {Metrics.Parse.Melee_Acc}) then
            Metrics.Parse.Melee_Acc = not Metrics.Parse.Melee_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Acc. Ranged", {Metrics.Parse.Ranged_Acc}) then
            Metrics.Parse.Ranged_Acc = not Metrics.Parse.Ranged_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Acc. Combined", {Metrics.Parse.Total_Acc}) then
            Metrics.Parse.Total_Acc = not Metrics.Parse.Total_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
    Parse.Widgets.Acc_Limit()
end

------------------------------------------------------------------------------------------------------
-- Shows the physical column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Physical_Flags = function(col_flags, width)
    Parse.Config.Physical_Buttons()
    UI.SameLine() UI.Text(" Physical")
    if UI.BeginTable("Physical Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Melee Damage", {Metrics.Parse.Melee}) then
            Metrics.Parse.Melee = not Metrics.Parse.Melee
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Melee Delay", {Metrics.Parse.Attack_Speed}) then
            Metrics.Parse.Attack_Speed = not Metrics.Parse.Attack_Speed
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Melee Crit", {Metrics.Parse.Melee_Crit}) then
            Metrics.Parse.Melee_Crit = not Metrics.Parse.Melee_Crit
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Ranged Damage", {Metrics.Parse.Ranged}) then
            Metrics.Parse.Ranged = not Metrics.Parse.Ranged
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Shot Distance", {Metrics.Parse.Ranged_Dist}) then
            Metrics.Parse.Ranged_Dist = not Metrics.Parse.Ranged_Dist
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Ranged Crit", {Metrics.Parse.Ranged_Crit}) then
            Metrics.Parse.Ranged_Crit = not Metrics.Parse.Ranged_Crit
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Total Crit", {Metrics.Parse.Crit}) then
            Metrics.Parse.Crit = not Metrics.Parse.Crit
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Abilities", {Metrics.Parse.Ability}) then
            Metrics.Parse.Ability = not Metrics.Parse.Ability
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the weaponskill column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Weaponskill_Flags = function(col_flags, width)
    Parse.Config.Weaponskill_Buttons()
    UI.SameLine() UI.Text(" Weaponskills")
    if UI.BeginTable("Physical Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("WS Total", {Metrics.Parse.Weaponskill}) then
            Metrics.Parse.Weaponskill = not Metrics.Parse.Weaponskill
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("WS Average", {Metrics.Parse.Average_WS}) then
            Metrics.Parse.Average_WS = not Metrics.Parse.Average_WS
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("WS ~TP", {Metrics.Parse.WS_TP}) then
            Metrics.Parse.WS_TP = not Metrics.Parse.WS_TP
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("WS Accuracy", {Metrics.Parse.WS_Accuracy}) then
            Metrics.Parse.WS_Accuracy = not Metrics.Parse.WS_Accuracy
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the magic column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Magic_Flags = function(col_flags, width)
    Parse.Config.Magic_Buttons()
    UI.SameLine() UI.Text(" Magic")
    if UI.BeginTable("Magic Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Nukes", {Metrics.Parse.Magic}) then
            Metrics.Parse.Magic = not Metrics.Parse.Magic
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Healing", {Metrics.Parse.Healing}) then
            Metrics.Parse.Healing = not Metrics.Parse.Healing
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Shows the pet column flags table.
------------------------------------------------------------------------------------------------------
---@param col_flags any
---@param width any
------------------------------------------------------------------------------------------------------
Parse.Config.Pet_Flags = function(col_flags, width)
    Parse.Config.Pet_Buttons()
    UI.SameLine() UI.Text(" Pets")
    if UI.BeginTable("Pet Parse Flags", 3) then
        UI.TableSetupColumn("Col 1", col_flags, width)
        UI.TableSetupColumn("Col 2", col_flags, width)
        UI.TableSetupColumn("Col 3", col_flags, width)

        UI.TableNextColumn()
        if UI.Checkbox("Pet Accuracy", {Metrics.Parse.Pet_Acc}) then
            Metrics.Parse.Pet_Acc = not Metrics.Parse.Pet_Acc
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet Melee", {Metrics.Parse.Pet_Melee}) then
            Metrics.Parse.Pet_Melee = not Metrics.Parse.Pet_Melee
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet Ranged", {Metrics.Parse.Pet_Ranged}) then
            Metrics.Parse.Pet_Ranged = not Metrics.Parse.Pet_Ranged
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet WS", {Metrics.Parse.Pet_WS}) then
            Metrics.Parse.Pet_WS = not Metrics.Parse.Pet_WS
            Parse.Util.Calculate_Column_Flags()
        end

        UI.TableNextColumn()
        if UI.Checkbox("Pet Ability", {Metrics.Parse.Pet_Ability}) then
            Metrics.Parse.Pet_Ability = not Metrics.Parse.Pet_Ability
            Parse.Util.Calculate_Column_Flags()
        end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all optional columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_All_Columns = function(bool)
    Parse.Config.Set_General_Columns(bool)
    Parse.Config.Set_Accuracy_Columns(bool)
    Parse.Config.Set_Physical_Columns(bool)
    Parse.Config.Set_Weaponskill_Columns(bool)
    Parse.Config.Set_Magic_Columns(bool)
    Parse.Config.Set_Pet_Columns(bool)
    Metrics.Parse.DPS = bool
    Metrics.Parse.Deaths = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the general columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_General_Columns = function(bool)
    Metrics.Parse.Focus = bool
    Metrics.Parse.DPS = bool
    Metrics.Parse.Damage_Taken = bool
    Metrics.Parse.Deaths = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the accuracy columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Accuracy_Columns = function(bool)
    Metrics.Parse.Running_Acc = bool
    Metrics.Parse.Total_Acc = bool
    Metrics.Parse.Melee_Acc = bool
    Metrics.Parse.Ranged_Acc = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the physical columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Physical_Columns = function(bool)
    Metrics.Parse.Melee = bool
    Metrics.Parse.Attack_Speed = bool
    Metrics.Parse.Melee_Crit = bool
    Metrics.Parse.Ranged = bool
    Metrics.Parse.Ranged_Dist = bool
    Metrics.Parse.Ranged_Crit = bool
    Metrics.Parse.Crit = bool
    Metrics.Parse.Ability = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the weaponskill columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Weaponskill_Columns = function(bool)
    Metrics.Parse.Weaponskill = bool
    Metrics.Parse.Average_WS = bool
    Metrics.Parse.WS_TP = bool
    Metrics.Parse.WS_Accuracy = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the magic columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Magic_Columns = function(bool)
    Metrics.Parse.Magic = bool
    Metrics.Parse.Healing = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Activates or clears all of the pet columns.
------------------------------------------------------------------------------------------------------
---@param bool boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Set_Pet_Columns = function(bool)
    Metrics.Parse.Pet_Acc = bool
    Metrics.Parse.Pet_Melee = bool
    Metrics.Parse.Pet_Ranged = bool
    Metrics.Parse.Pet_WS = bool
    Metrics.Parse.Pet_Ability = bool
    Parse.Util.Calculate_Column_Flags()
end

------------------------------------------------------------------------------------------------------
-- Checks if a pet column is currently enabled.
------------------------------------------------------------------------------------------------------
---@return boolean
------------------------------------------------------------------------------------------------------
Parse.Config.Is_Pet_Column_Enabled = function()
    return Metrics.Parse.Pet_Acc
    or Metrics.Parse.Pet_Melee
    or Metrics.Parse.Pet_Ranged
    or Metrics.Parse.Pet_WS
    or Metrics.Parse.Pet_Ability
end

------------------------------------------------------------------------------------------------------
-- Displays general All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.General_Buttons = function()
    UI.PushID("General All")
    if UI.SmallButton("All") then
        Parse.Config.Set_General_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("General None")
    if UI.SmallButton("None") then
        Parse.Config.Set_General_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays accuracy All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Accuracy_Buttons = function()
    UI.PushID("Physical All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Accuracy_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Physical None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Accuracy_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays physical All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Physical_Buttons = function()
    UI.PushID("Physical All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Physical_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Physical None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Physical_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays weaponskill All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Weaponskill_Buttons = function()
    UI.PushID("Physical All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Weaponskill_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Physical None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Weaponskill_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays magic All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Magic_Buttons = function()
    UI.PushID("Magic All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Magic_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Magic None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Magic_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Displays pet All and None column buttons.
------------------------------------------------------------------------------------------------------
Parse.Config.Pet_Buttons = function()
    UI.PushID("Pet All")
    if UI.SmallButton("All") then
        Parse.Config.Set_Pet_Columns(true)
    end
    UI.SameLine() UI.Text(" ") UI.SameLine()
    UI.PushID("Pet None")
    if UI.SmallButton("None") then
        Parse.Config.Set_Pet_Columns(false)
    end
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not the DPS graph window should show.
------------------------------------------------------------------------------------------------------
Parse.Config.Show_DPS_Graph = function()
    return Metrics.Parse.Show_DPS_Graph
end

------------------------------------------------------------------------------------------------------
-- Returns whether or not Skillchain damage is being taken into account.
------------------------------------------------------------------------------------------------------
Parse.Config.Include_SC_Damage = function()
    return Metrics.Parse.Include_SC_Damage
end

------------------------------------------------------------------------------------------------------
-- Returns what number of players should show on the Parse window.
------------------------------------------------------------------------------------------------------
Parse.Config.Rank_Cutoff = function()
    return Metrics.Parse.Rank_Cutoff
end

------------------------------------------------------------------------------------------------------
-- Returns whether to show condensed numbers or not.
------------------------------------------------------------------------------------------------------
Parse.Config.Condensed_Numbers = function()
    return Metrics.Parse.Condensed_Numbers
end

------------------------------------------------------------------------------------------------------
-- Toggles pet column flags.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Pet = function()
    Parse.Config.Set_Pet_Columns(not Parse.Config.Is_Pet_Column_Enabled())
end

------------------------------------------------------------------------------------------------------
-- Toggles the clock.
------------------------------------------------------------------------------------------------------
Parse.Config.Toggle_Clock = function()
    Metrics.Parse.Show_Clock = not Metrics.Parse.Show_Clock
end