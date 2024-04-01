C_Chat = 158

Show_Error   = true
Show_Warning = false

Errors_Suppressed = 0
Warnings_Suppressed = 0

--[[
    DESCRIPTION:
    CALLED BY  :
]]
function Add_Message_To_Chat(message_type, tag, message_string)
    local show_message = true
    local show_header  = false
    local prefix = ''

    if (not message_type) then message_type = 'A' end

    -- Error
    if (message_type:lower() == 'e') then
        show_header = true
        prefix = 'Error: '

        if (not Show_Error) then
            show_message = false
            Errors_Suppressed = Errors_Suppressed + 1
        end

    -- Warning
    elseif (message_type:lower() == 'w') then
        show_header = true
        prefix = 'Warning: '

        if (not Show_Warning) then
            show_message = false
            Warnings_Suppressed = Warnings_Suppressed + 1
        end

    end

    if (show_message) then

        if (show_header) then
            windower.add_to_chat(C_Chat, LUA_Name..' | '..tag)
        end

        windower.add_to_chat(C_Chat, prefix..message_string)
    end
end