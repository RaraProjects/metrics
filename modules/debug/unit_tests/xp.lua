Debug.Unit.Tests.XP = { }
Debug.Unit.Reset()

Debug.Unit.Tests.XP.XpNoChain = function()
    local packet = { message_id = 100, xp_amount = 100, chain = 0 }

    XP.OnXpGained(packet)
end