Files = require('files')

CSV_Log = {}
Log_CSV = false
Log_Ticks = false
Last_Tick = 0
Tick_Period = 5

CSV_Defaults = {
    ["Actor Name"] = "System",
    ["Action Name"] = "Tick",
    ["Melee"] = 0,
    ["Ranged"] = 0,
    ["WS"] = 0,
    ["SC"] = 0,
    ["Ability"] = 0,
    ["Magic"] = 0,
    ["Pet"] = 0,
    ["Enspell"] = 0,
}

function Add_CSV_Entry(data)
    local now = os.date("*t")
    local timestamp = now.month..'-'..now.day..' '..now.hour..':'..now.min..':'..now.sec

    data = Format_CSV_Data(data)

    local filename = 'test'
    local file = Files.new(('../../logs/%s.log'):format(filename))
    if not file:exists() then
        file:create()
    end

    file:append(timestamp..','..Create_CSV_Row(data)..'\n')
end

function CSV_Tick()
    local now = os.time()

    local data = {
        ["Actor Name"] = "System",
        ["Action Name"] = "Tick",
    }
    data = Format_CSV_Data(data)

    if ((now - Last_Tick) >= Tick_Period) then
        Add_CSV_Entry(data)
        Last_Tick = now
    end
end

function Format_CSV_Data(data)
    local formatted_data = {}
    for i, v in pairs(CSV_Defaults) do
        formatted_data[i] = data[i] or v
    end
    return formatted_data
end

function Create_CSV_Row(data)
    local ret = data["Actor Name"]..','
    ret = ret..data["Action Name"]..','
    ret = ret..data["Melee"]..','
    ret = ret..data["Ranged"]..','
    ret = ret..data["WS"]..','
    ret = ret..data["SC"]..','
    ret = ret..data["Ability"]..','
    ret = ret..data["Magic"]..','
    ret = ret..data["Pet"]..','
    ret = ret..data["Enspell"]
    return ret
end