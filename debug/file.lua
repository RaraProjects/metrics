local f = {}

-- ------------------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------------------
f.Ability_Loop = function()
    local ability_data
    f.Write("abilities.lua", "local ashita_abilities = {")
    for i = 1, 4000 do
        ability_data = A.Ability.ID(i)
        if ability_data then
            local index = "[" .. tostring(i) .. "] = {id = "
            local name = ", name = \"" .. tostring(ability_data.Name[1]) .. "\""
            local type = ", type = " .. tostring(ability_data.Type)
            local element = ", element = " .. tostring(ability_data.Element)
            local mana = ", mana = " .. tostring(ability_data.ManaCost)
            local tp = ", tp = " .. tostring(ability_data.TPCost)
            local line = index .. i .. name .. type .. element .. mana .. tp .. "},"
            if string.len(name) > 11 then
                f.Write("abilities.lua", line)
            end
        end
    end
    f.Write("abilities.lua", "}")
    f.Write("abilities.lua", "return ashita_abilities")
end

-- ------------------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------------------
f.Write = function(name, data)
    -- Initial setup.
    local path = f.Path()
    f.File_Exists(path)

    -- Write the data.
    local file = io.open(('%s/%s'):fmt(path, name), 'a')
    if file ~= nil then
        file:write(data .. "\n")
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------------------
f.Path = function()
    local directory = tostring(AshitaCore:GetInstallPath()) .. "config\\Metrics"
    return ('%s/'):fmt(directory)
end

-- ------------------------------------------------------------------------------------------------------
-- 
-- ------------------------------------------------------------------------------------------------------
f.File_Exists = function(path)
    if not ashita.fs.exists(path) then
        ashita.fs.create_dir(path)
    end
end

return f