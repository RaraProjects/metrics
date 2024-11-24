Debug.Performance = {}

Debug.Performance.Players = {
    "Player1",
    "Player2",
    "Player3",
    "Player4",
    "Player5",
    "Player6",
    "Player7",
    "Player8",
    "Player9",
    "Player10",
    "Player11",
    "Player12",
    "Player13",
    "Player14",
    "Player15",
    "Player16",
    "Player17",
    "Player18",
}

Debug.Performance.Mobs = {
    "Mob1",
    "Mob2",
    "Mob3",
    "Mob4",
    "Mob5",
    "Mob6",
    "Mob7",
    "Mob8",
    "Mob9",
    "Mob10",
    "Mob11",
    "Mob12",
    "Mob13",
}

------------------------------------------------------------------------------------------------------
-- Adds a lot of players and mobs that need to be sorted through to test performance.
------------------------------------------------------------------------------------------------------
Debug.Performance.Add_Load = function()
    for _, player in pairs(Debug.Performance.Players) do
        for _, mob in pairs(Debug.Performance.Mobs) do
            DB.Data.Update("inc", 25, {player_name = player,  target_name = mob}, "No SC Total", "Total")
        end
    end
end