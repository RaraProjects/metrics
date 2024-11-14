XP.Chains = T{}

-- Adapted from Points and ASB.
-- https://github.com/Shinzaku/Points
XP.Chains.Max_Times = T{
    {level=10, maxtime={80,  80,  60,  40,  30,  15}},
    {level=20, maxtime={130, 130, 110, 80,  60,  25}},
    {level=30, maxtime={160, 150, 120, 90,  60,  30}},
    {level=40, maxtime={200, 200, 170, 130, 80,  40}},
    {level=50, maxtime={290, 290, 230, 170, 110, 50}},
    {level=99, maxtime={300, 300, 240, 180, 120, 60}},
}

XP.Chains.Is_Active = false
XP.Chains.Start_Time = 0
XP.Chains.Duration = 0
XP.Chains.Current = -1
XP.Chains.Max = 0

-- ------------------------------------------------------------------------------------------------------
-- Sets appropriate data for the start or continuation of a chain.
-- ------------------------------------------------------------------------------------------------------
---@param chain integer
-- ------------------------------------------------------------------------------------------------------
XP.Chains.Start = function(chain)
    if chain > XP.Chains.Current then
        XP.Chains.Is_Active = true
        XP.Chains.Start_Time = os.time()
        XP.Chains.Metrics(chain)
        XP.Chains.Set_Duration()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Ends the chain.
-- ------------------------------------------------------------------------------------------------------
XP.Chains.End = function()
    XP.Chains.Current = -1
    XP.Chains.Duration = 999
    XP.Chains.Start_Time = 0
    XP.Chains.Is_Active = false
end

-- ------------------------------------------------------------------------------------------------------
-- Handles chain metrics.
-- ------------------------------------------------------------------------------------------------------
---@param chain integer
-- ------------------------------------------------------------------------------------------------------
XP.Chains.Metrics = function(chain)
    if not chain then chain = 0 end
    if chain > XP.Metric.Max_Chain then XP.Metric.Max_Chain = chain end
    XP.Chains.Current = chain
end

-- ------------------------------------------------------------------------------------------------------
-- Gets the amount of time left in the current chain.
-- ------------------------------------------------------------------------------------------------------
XP.Chains.Set_Duration = function()
    local player = Ashita.Player.Get()
    if not player then return nil end
    local level = player:GetMainJobLevel()
    local chain = XP.Chains.Current
    if not chain or chain <= 0 then XP.Chains.Duration = 999 end
    chain = chain + 1   -- Chain we are going for is the next chain.
    if chain > 6 then chain = 6 end
    for _, bucket in ipairs(XP.Chains.Max_Times) do
        if level <= bucket.level then
            if bucket.maxtime[chain] then
                XP.Chains.Duration = bucket.maxtime[chain]
                break
            end
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Handles the chain countdown.
-- ------------------------------------------------------------------------------------------------------
XP.Chains.Timer = function()
    local color = Res.Colors.Basic.WHITE
    if not XP.Chains.Is_Active then return UI.TextColored(color, "--:--") end
    local now = os.time()
    local elapsed_time = now - XP.Chains.Start_Time
    local time_remaining = XP.Chains.Duration - elapsed_time
    if time_remaining <=0 then
        color = Res.Colors.Basic.RED
        XP.Chains.End()
    elseif time_remaining <= 10 then
        color = Res.Colors.Basic.RED
    elseif time_remaining <= 30 then
        color = Res.Colors.Basic.YELLOW
    else
        color = Res.Colors.Basic.WHITE
    end
    UI.TextColored(color, Timers.Format(time_remaining, true))
end