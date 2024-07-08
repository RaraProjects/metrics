XP = T{}
-- ASB Code: /src/map/utils/charutils.cpp->AddExperiencePoints
-- ASB Code: /src/map/utils/charutils.cpp->DistributeExperiencePoints
-- https://github.com/Shinzaku/Points

XP.Type = T{
    ERROR      = 0,
    EXPERIENCE = 1,
    LIMIT      = 2,
}

XP.Messages = T{}
XP.Messages.EXP = T{
    [8]   = true,   -- No chain
    [253] = true,   -- Chain
}
XP.Messages.LP = T{
    [371] = true,   -- No chain
    [372] = true,   -- Chain
}
XP.Messages.Chain = T{
    [253] = true,   -- Experience points
    [372] = true,   -- Limit points
}

XP.Metric = T{
    Experience_Total = 0,
    Limit_Total      = 0,
    Max_Chain        = 0,
}

XP.Global = T{}

XP.Display_Mode = XP.Type.EXPERIENCE
XP.Show_Additional_Info = false

require("windows.exp.window")
require("windows.exp.local_tracking")
require("windows.exp.chains")

-- ------------------------------------------------------------------------------------------------------
-- Primary XP driving function.
-- ------------------------------------------------------------------------------------------------------
---@param data any
-- ------------------------------------------------------------------------------------------------------
XP.Parse = function(data)
    if not data then return nil end
    local parsed = Ashita.Packets.EXP(data)
    if not parsed then return nil end

    local xp_amount = parsed.xp_amount
    local chain = parsed.chain_count
    local message_id = parsed.message_id

    local xp_type = XP.Get_XP_Type(message_id)
    XP.Add_Total_XP(xp_amount, xp_type)         -- Add XP to sum total.
    XP.Chains.Start(chain)                      -- Handle chains.
    XP.Local.Add_XP(xp_amount, xp_type)         -- XP per hour tracking.
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the XP window.
-- ------------------------------------------------------------------------------------------------------
XP.Populate = function()
    local flags = Column.Flags.None

    XP.EXP_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() XP.Limit_Button()
    UI.SameLine() UI.Text(" ") UI.SameLine() UI.SameLine() XP.Tracking_Button()

    if XP.Display_Mode == XP.Type.EXPERIENCE then
        XP.EXP_Points()
    else
        XP.Limit_Points()
    end

    XP.Tracking()
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the experience points rows.
-- ------------------------------------------------------------------------------------------------------
XP.EXP_Points = function()
    local flags = Column.Flags.None
    if UI.BeginTable("EXP Metrics", 5, XP.Window.Table_Flags) then
        UI.TableSetupColumn("Chain", flags)
        UI.TableSetupColumn("XP/hr", flags)
        UI.TableSetupColumn("TTL", flags)
        UI.TableSetupColumn("TNL", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn()
        UI.Text(tostring(XP.Chains.Current) .. "->" .. tostring(XP.Chains.Current + 1))
        UI.SameLine() UI.Text(" " .. tostring(XP.Chains.Timer()))

        UI.TableNextColumn() UI.Text(tostring(XP.Local.Get_XP(XP.Type.EXPERIENCE)))
        UI.TableNextColumn() UI.Text(XP.Time_To_Level(XP.Type.EXPERIENCE))
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.Exp_TNL()))
        UI.TableNextColumn() UI.Text(tostring(XP.Metric.Experience_Total))

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the limit points rows.
-- ------------------------------------------------------------------------------------------------------
XP.Limit_Points = function()
    local flags = Column.Flags.None
    if UI.BeginTable("LP Metrics", 5, XP.Window.Table_Flags) then
        UI.TableSetupColumn("Chain", flags)
        UI.TableSetupColumn("LP/hr", flags)
        UI.TableSetupColumn("TTM", flags)
        UI.TableSetupColumn("TNM", flags)
        UI.TableSetupColumn("Total", flags)
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn()
        UI.Text(tostring(XP.Chains.Current) .. "->" .. tostring(XP.Chains.Current + 1))
        UI.SameLine() UI.Text(" " .. tostring(XP.Chains.Timer()))

        UI.TableNextColumn() UI.Text(tostring(XP.Local.Get_XP(XP.Type.LIMIT)))
        UI.TableNextColumn() UI.Text(XP.Time_To_Level(XP.Type.LIMIT))
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.Exp_TNM()))
        UI.TableNextColumn() UI.Text(tostring(XP.Metric.Limit_Total))

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows XP tracking information.
-- ------------------------------------------------------------------------------------------------------
XP.Tracking = function()
    if not XP.Local.Show_Windows then return nil end
    local flags = Column.Flags.None
    if XP.Display_Mode == XP.Type.EXPERIENCE then
        if UI.BeginTable("EXP Tracking", 5, XP.Window.Table_Flags) then
            UI.TableSetupColumn("Cycle", flags)
            UI.TableSetupColumn("Scaling", flags)
            UI.TableSetupColumn("Total", flags)
            UI.TableSetupColumn("History", flags)
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))
            UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.EXPERIENCE)))
            UI.TableNextColumn() UI.Text(XP.Local.Bucket_View(XP.Type.EXPERIENCE))

            UI.EndTable()
        end
    else
        if UI.BeginTable("LP Tracking", 5, XP.Window.Table_Flags) then
            UI.TableSetupColumn("Cycle", flags)
            UI.TableSetupColumn("Scaling", flags)
            UI.TableSetupColumn("Total", flags)
            UI.TableSetupColumn("History", flags)
            UI.TableHeadersRow()

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))
            UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.LIMIT)))
            UI.TableNextColumn() UI.Text(XP.Local.Bucket_View(XP.Type.LIMIT))

            UI.EndTable()
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the additional information rows.
-- ------------------------------------------------------------------------------------------------------
XP.Additional_Info = function()
    if XP.Show_Additional_Info then
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Max Chain")
        UI.TableNextColumn() UI.Text(tostring(XP.Metric.Max_Chain))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Chain Time")
        UI.TableNextColumn() UI.Text(tostring(XP.Chains.Duration))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Addon Runtime")
        UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.METRICS))
    end
end

------------------------------------------------------------------------------------------------------
-- Sets display mode to experience.
------------------------------------------------------------------------------------------------------
XP.EXP_Button = function()
    if UI.SmallButton("EXP") then
        XP.Display_Mode = XP.Type.EXPERIENCE
    end
end

------------------------------------------------------------------------------------------------------
-- Sets display mode to limit.
------------------------------------------------------------------------------------------------------
XP.Limit_Button = function()
    if UI.SmallButton("Limit") then
        XP.Display_Mode = XP.Type.LIMIT
    end
end

------------------------------------------------------------------------------------------------------
-- Toggles XP tracking information showing.
------------------------------------------------------------------------------------------------------
XP.Tracking_Button = function()
    if UI.SmallButton("Tracking") then
        XP.Local.Show_Windows = not XP.Local.Show_Windows
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether the XP is either XP or limit points.
-- ------------------------------------------------------------------------------------------------------
---@param message_id integer
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Get_XP_Type = function(message_id)
    if not message_id then return XP.Type.ERROR end
    if XP.Messages.EXP[message_id] then return XP.Type.EXPERIENCE end
    if XP.Messages.LP[message_id] then return XP.Type.LIMIT end
    return XP.Type.ERROR
end

-- ------------------------------------------------------------------------------------------------------
-- Tally's total experience / limit points.
-- ------------------------------------------------------------------------------------------------------
---@param amount integer
---@param type string
-- ------------------------------------------------------------------------------------------------------
XP.Add_Total_XP = function(amount, type)
    if not type or type == XP.Type.ERROR then return nil end
    if not amount then amount = 0 end
    if type == XP.Type.EXPERIENCE then
        XP.Metric.Experience_Total = XP.Metric.Experience_Total + amount
    elseif type == XP.Type.LIMIT then
        XP.Metric.Limit_Total = XP.Metric.Limit_Total + amount
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates the estimated time to level given XP rate.
-- ------------------------------------------------------------------------------------------------------
---@param type string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Time_To_Level = function(type)
    if not type then type = XP.Type.EXPERIENCE end
    local rate_minute = XP.Local.Get_Rate(type) / 3600
    local tnl = Ashita.Player.Exp_TNL()
    if type == XP.Type.LIMIT then tnl = Ashita.Player.Exp_TNM() end
    if rate_minute == 0 then return "---" end
    return Timers.Format(tnl / rate_minute)
end

-- ------------------------------------------------------------------------------------------------------
-- Returns how much xp per unit time where time is the total time the Metrics has been active.
-- This will be a really big number early on.
-- ------------------------------------------------------------------------------------------------------
---@param type? string
---@return string
-- ------------------------------------------------------------------------------------------------------
XP.Global.Calculate = function(type)
    local xp = XP.Metric.Experience_Total
    if type == XP.Type.LIMIT then xp = XP.Metric.Limit_Total end
    local addon_active_time = Timers.Get_Duration(Timers.Enum.Names.METRICS)    -- seconds
    if not addon_active_time or addon_active_time == 0 then return tostring(0) end
    addon_active_time = addon_active_time / 3600                                -- convert to hours
    return string.format("%d", xp / addon_active_time)                          -- xp per hour
end