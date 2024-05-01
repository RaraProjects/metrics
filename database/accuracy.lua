DB.Accuracy = T{}

------------------------------------------------------------------------------------------------------
-- Keeps a tally of the last running accuracy limit amount of hit attempts.
-- This is called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param player_name string primary index for the Running_Accuracy_Data table
---@param hit boolean if true then there was a hit; miss otherwise
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Accuracy.Update = function(player_name, hit)
	if not DB.Tracking.Running_Accuracy[player_name] then
		_Debug.Error.Add("Update.Running_Accuracy: {" .. tostring(player_name) .. "} is missing in Data.Running_Accuracy.")
		return false
	end
	local max = #DB.Tracking.Running_Accuracy[player_name]
    if max >= Metrics.Model.Running_Accuracy_Limit then table.remove(DB.Tracking.Running_Accuracy[player_name], Metrics.Model.Running_Accuracy_Limit) end
	table.insert(DB.Tracking.Running_Accuracy[player_name], 1, hit)
	return true
end

------------------------------------------------------------------------------------------------------
-- Returns the players accuracy for the last running accuracy limit amount of attempts.
------------------------------------------------------------------------------------------------------
---@param player_name string primary index for the Running_Accuracy_Data table
---@return table {hits, count}
------------------------------------------------------------------------------------------------------
DB.Accuracy.Get = function(player_name)
	-- This error can occur in mini mode when trying to load data before the player has been initialized. Not a big deal.
	if not DB.Tracking.Running_Accuracy[player_name] then
		_Debug.Error.Add("Get.Running_Accuracy: Attempt to get {" .. tostring(player_name) .. "} running accuracy, but it didn't exist.")
		return {0, 0}
	end
	local hits = 0
	local count = 0

	-- Tally how hits the player had in the last {running accuracy limit} amount of attempts.
	for _, value in pairs(DB.Tracking.Running_Accuracy[player_name]) do
		if value then hits = hits + 1 end
		count = count + 1
	end

	return {hits, count}
end