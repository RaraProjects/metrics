local f = {}

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