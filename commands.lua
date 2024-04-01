-- ******************************************************************************************************
-- *
-- *                                          Universal Settings
-- *
-- ******************************************************************************************************

function Set_Mob_Filter(args)

    if (args[1] == nil) then
        Mob_Filter = nil
        Add_Message_To_Chat('A', 'Set_Mob_Filter^commands', 'Mob filter cleared.')

    else
        Mob_Filter = Build_Arg_String(args)
        Add_Message_To_Chat('A', 'Set_Mob_Filter^commands', 'Mob filter set to '..Mob_Filter)

    end

end

-- ******************************************************************************************************
-- *
-- *                                          Horse Race Window
-- *
-- ******************************************************************************************************

function Set_Horse_Race_Display_Limit(args)

    if (args[1] == nil) then
        Top_Rank = Top_Rank_Default
        Add_Message_To_Chat('A', 'Set_Horse_Race_Display_Limit^commands', 'Setting top ranking limit to the default: '..tostring(Top_Rank_Default))

    else
        Top_Rank = tonumber(args[1])
        Add_Message_To_Chat('A', 'Set_Horse_Race_Display_Limit^commands', 'Setting top ranking limit to: '..args[1])

    end
end

-- ******************************************************************************************************
-- *
-- *                                            Focus Window
-- *
-- ******************************************************************************************************

function Focus_Target(args)

    if (args[1]:lower() == 'ws') then
        Focused_Trackable = 'ws'
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focus type set to: Weaponskill')

    elseif (args[1]:lower() == 'sc') then
        Focused_Trackable = 'sc'
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focus type set to: Skillchain')

    elseif (args[1]:lower() == 'ability') then
        Focused_Trackable = 'ability'
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focus type set to: Ability')

    elseif (args[1]:lower() == 'healing') then
        Focused_Trackable = 'healing'
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focus type set to: Healing')

    elseif (args[1]:lower() == 'magic') then
        Focused_Trackable = 'magic'
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focus type set to: Magic')

    -- Focus on a player
    else
        Focused_Entity = args[1]
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focusing on '..tostring(args[1]))

    end

    Refresh_Focus_Window()

end

-- ******************************************************************************************************
-- *
-- *                                             Battle Log
-- *
-- ******************************************************************************************************

function Set_Battle_Log_Filters(args)

    if (args[1]:lower() == 'melee') then
        Log_Melee = not Log_Melee
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show melee: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'ranged') then
        Log_Ranged = not Log_Ranged
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show ranged: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'ws') then
        Log_WS = not Log_WS
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show weaponskills: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'sc') then
        Log_SC = not Log_SC
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show skillchains: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'magic') then
        Log_Magic = not Log_Magic
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show magic: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'ability') then
        Log_Abiilty = not Log_Abiilty
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show ability: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'pet') then
        Log_Pet = not Log_Pet
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show pet actions: '..tostring(Log_Melee))

    elseif (args[1]:lower() == 'all') then
        Set_Log_Show_All()
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show all actions.')

    elseif (args[1]:lower() == 'reset') then
        Set_Log_Show_Defaults()
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Battle Log will show default actions.')

    -- Focus on a player
    else
        Focused_Entity = args[1]
        Add_Message_To_Chat('A', 'Focus_Target^commands', 'Focusing on '..tostring(args[1]))

    end

    Refresh_Focus_Window()

end
