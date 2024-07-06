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

-- Adapted from Points and ASB.
-- https://github.com/Shinzaku/Points
XP.Chain_Timers = T{
    {level=10, maxtime={80,  80,  60,  40,  30,  15}},
    {level=20, maxtime={130, 130, 110, 80,  60,  25}},
    {level=30, maxtime={160, 150, 120, 90,  60,  30}},
    {level=40, maxtime={200, 200, 170, 130, 80,  40}},
    {level=50, maxtime={290, 290, 230, 170, 110, 50}},
    {level=99, maxtime={300, 300, 240, 180, 120, 60}},
}
XP.Chain_Active   = false
XP.Chain_Start    = 0
XP.Current_Chain  = 0
XP.Chain_Duration = 0

XP.Global = T{}

XP.Show_Additional_Info = false

require("windows.exp.window")
require("windows.exp.local_tracking")

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
    XP.Add_Total_XP(xp_amount, xp_type)

    XP.Chain_Active = true
    XP.Chain_Start = os.time()
    XP.Chains(chain)
    XP.Get_Chain_Time()

    XP.Local.Add_XP(xp_amount, XP.Type.LIMIT)
end

-- ------------------------------------------------------------------------------------------------------
-- Populates the XP window.
-- ------------------------------------------------------------------------------------------------------
XP.Populate = function()
    local flags = Column.Flags.None

    UI.Text("Beta Testing Purposes Only")
    if UI.Checkbox("Additional Info", {XP.Show_Additional_Info}) then
        XP.Show_Additional_Info = not XP.Show_Additional_Info
    end
    if UI.Checkbox("Local Windows", {XP.Local.Show_Windows}) then
        XP.Local.Show_Windows = not XP.Local.Show_Windows
    end

    if UI.BeginTable("XP Metrics", 2, XP.Window.Table_Flags) then
        UI.TableSetupColumn("Metric", flags)
        UI.TableSetupColumn("Value", flags)

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Chain " .. tostring(XP.Current_Chain) .. "->" .. tostring(XP.Current_Chain + 1))
        UI.TableNextColumn() UI.Text(tostring(XP.Chain_Countdown()))

        XP.EXP_Points()
        XP.Limit_Points()
        XP.Additional_Info()

        UI.EndTable()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the experience points rows.
-- ------------------------------------------------------------------------------------------------------
XP.EXP_Points = function()
    if XP.Metric.Experience_Total > 0 then
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Local  XP/hr")
        UI.TableNextColumn() UI.Text(tostring(XP.Local.Get_XP(XP.Type.EXPERIENCE)))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Global XP/hr")
        UI.TableNextColumn() UI.Text(tostring(XP.Global.Calculate(XP.Type.EXPERIENCE)))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("TNL")
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.Exp_TNL()))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Time to Level")
        UI.TableNextColumn() UI.Text(XP.Time_To_Level(XP.Type.EXPERIENCE))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total EXP")
        UI.TableNextColumn() UI.Text(tostring(XP.Metric.Experience_Total))

        if XP.Local.Show_Windows then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Local EXP History")
            UI.TableNextColumn() UI.Text(XP.Local.Bucket_View(XP.Type.EXPERIENCE))

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Local EXP Total")
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.EXPERIENCE)))
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Shows the limit points rows.
-- ------------------------------------------------------------------------------------------------------
XP.Limit_Points = function()
    if XP.Metric.Limit_Total > 0 then
        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Local  LP/hr")
        UI.TableNextColumn() UI.Text(tostring(XP.Local.Get_XP(XP.Type.LIMIT)))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Global LP/hr")
        UI.TableNextColumn() UI.Text(tostring(XP.Global.Calculate(XP.Type.LIMIT)))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("TNLP")
        UI.TableNextColumn() UI.Text(tostring(Ashita.Player.Exp_TNLP()))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Time to LP")
        UI.TableNextColumn() UI.Text(XP.Time_To_Level(XP.Type.LIMIT))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Total Limit")
        UI.TableNextColumn() UI.Text(tostring(XP.Metric.Limit_Total))

        if XP.Local.Show_Windows then
            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Local LP History")
            UI.TableNextColumn() UI.Text(XP.Local.Bucket_View(XP.Type.LIMIT))

            UI.TableNextRow()
            UI.TableNextColumn() UI.Text("Local LP Total")
            UI.TableNextColumn() UI.Text(tostring(XP.Local.XP_In_Window(XP.Type.LIMIT)))
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
        UI.TableNextColumn() UI.Text(tostring(XP.Chain_Duration))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Addon Runtime")
        UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.METRICS))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Local Cycle")
        UI.TableNextColumn() UI.Text(Timers.Check(Timers.Enum.Names.EXP))

        UI.TableNextRow()
        UI.TableNextColumn() UI.Text("Local Scaling")
        UI.TableNextColumn() UI.Text(tostring((1 / XP.Local.Window_Length()) * 3600))
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
-- Handles chain metrics.
-- ------------------------------------------------------------------------------------------------------
---@param chain integer
-- ------------------------------------------------------------------------------------------------------
XP.Chains = function(chain)
    if not chain then chain = 0 end
    if chain > XP.Metric.Max_Chain then XP.Metric.Max_Chain = chain end
    XP.Current_Chain = chain
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the amount of time left in the current chain.
-- ------------------------------------------------------------------------------------------------------
XP.Get_Chain_Time = function()
    local player = Ashita.Player.Get()
    if not player then return nil end
    local level = player:GetMainJobLevel()
    local chain = XP.Current_Chain
    if not chain or chain <= 0 then XP.Chain_Duration = 999 end
    chain = chain + 1   -- Chain we are going for is the next chain.
    if chain > 6 then chain = 6 end
    for _, bucket in ipairs(XP.Chain_Timers) do
        if level <= bucket.level then
            if bucket.maxtime[chain] then
                XP.Chain_Duration = bucket.maxtime[chain]
                break
            end
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Handles the chain countdown.
-- ------------------------------------------------------------------------------------------------------
XP.Chain_Countdown = function()
    if not XP.Chain_Active then return Timers.Format(0, true) end
    local now = os.time()
    local elapsed_time = now - XP.Chain_Start
    local time_remaining = XP.Chain_Duration - elapsed_time
    if time_remaining < 0 then
        XP.Current_Chain = 0
        XP.Chain_Duration = 999
        XP.Chain_Start = 0
        XP.Chain_Active = false
    end
    return Timers.Format(time_remaining, true)
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
    if type == XP.Type.LIMIT then tnl = Ashita.Player.Exp_TNLP() end
    if rate_minute == 0 then return "Forever" end
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