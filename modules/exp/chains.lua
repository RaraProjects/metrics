XP.Chains = { }

-- Adapted from Points and ASB.
-- https://github.com/Shinzaku/Points
XP.Chains.MaxTimes =
{
    { level = 10, maxtime = { 80,  80,  60,  40,  30,  15 } },
    { level = 20, maxtime = { 130, 130, 110, 80,  60,  25 } },
    { level = 30, maxtime = { 160, 150, 120, 90,  60,  30 } },
    { level = 40, maxtime = { 200, 200, 170, 130, 80,  40 } },
    { level = 50, maxtime = { 290, 290, 230, 170, 110, 50 } },
    { level = 99, maxtime = { 300, 300, 240, 180, 120, 60 } },
}

-- ------------------------------------------------------------------------------------------------------
-- Sets appropriate data for the start or continuation of a chain.
-- ------------------------------------------------------------------------------------------------------
---@param chainNumber integer
-- ------------------------------------------------------------------------------------------------------
XP.Chains.OnChain = function(chainNumber)
    chainNumber  = chainNumber or 0
    local player = Ashita.Player.Get()
    local chains = XP.Tracking.Chains

    if not player or chainNumber <= chains.Current then
        return nil
    end

    chains.IsActive     = true
    chains.Current      = chainNumber
    chains.StartInstant = os.time()
    chains.Max          = math.max(chains.Max, chainNumber)

    local playerLevel = player:GetMainJobLevel()
    local nextChain   = math.min(chainNumber + 1, 6)

    for _, bucket in ipairs(XP.Chains.MaxTimes) do
        if playerLevel <= bucket.level then
            chains.Duration = bucket.maxtime[nextChain] or chains.Duration
            break
        end
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Ends the chain.
-- ------------------------------------------------------------------------------------------------------
XP.Chains.End = function()
    local chains = XP.Tracking.Chains

    chains.Current      = -1
    chains.Duration     = 999
    chains.StartInstant = 0
    chains.IsActive     = false
end

-- ------------------------------------------------------------------------------------------------------
-- Handles the chain countdown.
-- ------------------------------------------------------------------------------------------------------
XP.Chains.Timer = function()
    local chains = XP.Tracking.Chains
    local color  = Res.Colors.Basic.WHITE

    if not chains.IsActive then
        return UI.TextColored(color, "--:--")
    end

    local elapsedTime   = os.time() - chains.StartInstant
    local timeRemaining = chains.Duration - elapsedTime

    if timeRemaining <= 0 then
        color = Res.Colors.Basic.RED
        XP.Chains.End()

    elseif timeRemaining <= 10 then
        color = Res.Colors.Basic.RED

    elseif timeRemaining <= 30 then
        color = Res.Colors.Basic.YELLOW
    end

    UI.TextColored(color, Timers.Format(timeRemaining, true))
end