Debug.Performance = {}

Debug.Performance.Players_To_Add = 18
Debug.Performance.Mobs_To_Add = 100

------------------------------------------------------------------------------------------------------
-- Adds a lot of players and mobs to test performance under heavy load.
------------------------------------------------------------------------------------------------------
Debug.Performance.Add_Load = function()
    local player_name, mob_name
    for x = 1, Debug.Performance.Players_To_Add do
        for y = 1,  Debug.Performance.Mobs_To_Add do
            player_name = "Player " .. tostring(x)
            mob_name = "Mob " .. tostring(y)
            DB.Data.Update(DB.UpdateMode.INC, 25, {player_name = player_name,  target_name = mob_name}, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
        end
    end
end