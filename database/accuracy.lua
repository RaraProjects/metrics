DB.Accuracy = { }

------------------------------------------------------------------------------------------------------
-- Keeps a tally of the last running accuracy limit amount of hit attempts.
-- This is called by the action handling functions.
------------------------------------------------------------------------------------------------------
---@param playerName string  primary index for the Running_Accuracy_Data table
---@param hit        boolean if true then there was a hit; miss otherwise
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Accuracy.Update = function(playerName, hit)
	local accuracyData = DB.Tracking.RunningAccuracy[playerName]

	if not accuracyData then
		local errorMessage = string.format("Player {%s} is missing in accuracy tracker.", tostring(playerName))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Accuracy.Update", errorMessage)
		return false
	end

    if #accuracyData >= Metrics.Model.Running_Accuracy_Limit then
		table.remove(accuracyData)
	end

	table.insert(accuracyData, 1, hit)

	return true
end

------------------------------------------------------------------------------------------------------
-- Returns the players accuracy for the last running accuracy limit amount of attempts.
------------------------------------------------------------------------------------------------------
---@param playerName string primary index for the Running_Accuracy_Data table
---@return table {hits, count}
------------------------------------------------------------------------------------------------------
DB.Accuracy.Get = function(playerName)
	local accuracyData = DB.Tracking.RunningAccuracy[playerName]

	-- This error can occur in mini mode when trying to load data before the player has been initialized. Not a big deal.
	if not accuracyData then
		local errorMessage = string.format("Player {%s} is missing in accuracy tracker.", tostring(playerName))
		Debug.Error.Add(Debug.Error.ERROR, "DB.Accuracy.Get", errorMessage)
		return { 0, 0 }
	end

	local hits  = 0
	local count = 0

	-- Tally how hits the player had in the last {running accuracy limit} amount of attempts.
	for _, value in pairs(accuracyData) do
		if value then
			hits = hits + 1
		end
		count = count + 1
	end

	return { hits, count }
end