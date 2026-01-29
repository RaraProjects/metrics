local menuHandler = { }

menuHandler.Types =
{
    fulllog  = true,    -- Expanded chat log
    equip    = true,    -- Equipment menu
    inventor = true,    -- Inventory
    mnstorag = true,    -- Equip inventory selection
    iuse     = true,    -- Use item
    map0     = true,    -- Regular map
    maplist  = true,    -- Selecting a map from within the regular map
    mapframe = true,    -- Temporary map state while transitioning between maps
    scanlist = true,    -- Widescan
    cnqframe = true,    -- Conquest, Beseiged, Campaign, etc. map
    conf2win = true,    -- Gameplay
    cfilter  = true,    -- Chat Filters
    textcol1 = true,    -- Font Colors -> Chat, For Self, For Others, System
    confyn   = true,    -- Font Colors -> Default
    conf5m   = true,    -- Windows
    conf5win = true,    -- Windows -> Shared
    conf5w1  = true,    -- Windows -> Window 1
    conf5w2  = true,    -- Windows -> Window 2
    conf11m  = true,    -- Log
    conf11l  = true,    -- Log -> Window 1/2
    conf11s  = true,    -- Log -> Window 1/2 -> Chat, For Self, For Others, System
    conf3win = true,    -- Misc
    conf6win = true,    -- Misc 2
    conf12wi = true,    -- Misc 3
    conf13wi = true,    -- Misc 4
    fxfilter = true,    -- Effects
    conf7    = true,    -- Mouse/Cam
    conf4    = true,    -- Global
    link5    = true,    -- Linkshell
    link12   = true,    -- Linkshell list
    link13   = true,    -- Linkshell -> Unequiped linkshell
    link3    = true,    -- Linkshell -> Equipped linkshell
    scresult = true,    -- Search results
    evitem   = true,    -- Curencies
    statcom2 = true,    -- Combat skills
    auc1     = true,    -- AH Bid/Sell
    moneyctr = true,    -- AH Window
    shopsell = true,    -- Sell prompt
    comyn    = true,    -- AH confirm sell
    auclist  = true,    -- AH Sales Status
    auchisto = true,    -- AH History
    auc4     = true,    -- AH Stop Sale
    post1    = true,    -- Delivery Box
    post2    = true,    -- Delivery Box Confirm
    stringdl = true,    -- Delivery Box Send Recipient
    delivery = true,    -- Delivery Box Sending
    mcr1edlo = true,    -- Macro editing row 1
    mcr2edlo = true,    -- Macro editing row 2
    mcrbedit = true,    -- Hitting + to edit macros
    mcresed  = true,    -- Equipset editing
    bank     = true,    -- Mog Satchel
    handover = true,    -- Trade Menu
    itmsortw = true,    -- Item Sort Menu
    sortyn   = true,    -- Item Sort Yes/No
    itemctrl = true,    -- Choosing the number of items to select for transfer in inventory
    loot     = true,    -- Treasure Pool
    lootope  = true,    -- Cast Lot
    meritcat = true,    -- Merit Categories
    merit1   = true,    -- Merit Categories/Mode Switch
    merit2   = true,    -- Merit EXP/Limit Points
    merit3   = true,    -- Merit Raise/Lower
    merityn  = true,    -- Yes/No on the merit upgrades
    shop     = true,    -- Setting bazaar prices
    automato = true,    -- Automaton equipment menu
    bluinven = true,    -- Automaton equipment selection
    bluequip = true,    -- BLU magic spell equip menu
    quest00  = true,    -- Quest menu
    quest01  = true,    -- Quest selection menu
    miss00   = true,    -- Mission submenu
    faqsub   = true,    -- Help Desk
    cmbhlst  = true,    -- Synthesis History
    mapv2    = true,    -- Map marker creation
    mapv3    = true,    -- Map markers
    inspect  = true,    -- Checking equipment
}

menuHandler.Module  = 'FFXiMain.dll'
menuHandler.Pattern = '8B480C85C974??8B510885D274??3B05'
menuHandler.Memory  = nil

-- ------------------------------------------------------------------------------------------------------
-- Gets the name of the upper most menu.
-- Copied from PetMe which got it from XITools.
-- https://github.com/mousseng/xitools
-- https://github.com/m4thmatic/PetMe
-- ------------------------------------------------------------------------------------------------------
---@return string, integer
-- ------------------------------------------------------------------------------------------------------
menuHandler.GetMenuName = function()
    if not menuHandler.Memory then
        menuHandler.Memory = ashita.memory.find(menuHandler.Module, 0, menuHandler.Pattern, 16, 0)
    end

    local menu = menuHandler.Memory

    if not menu or menu == 0 then
        menuHandler.Memory = nil
        return '', 0
    end

    local pointer = ashita.memory.read_uint32(menu)

    if not pointer or pointer == 0 then
        return '', 0
    end

    local pointerValue = ashita.memory.read_uint32(pointer)

    if pointerValue == 0 then
        return '', 0
    end

    local menuHeader = ashita.memory.read_uint32(pointerValue + 4)
    local menuName   = ashita.memory.read_string(menuHeader + 0x46, 16)

    return string.gsub(menuName, '\x00', '')
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a menu is up that we should hide windows for.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
menuHandler.ShouldHideFromMenu = function()
    local menuName = menuHandler.GetMenuName()

    if not menuName then
        return true
    end

    -- Get rid of prefix junk and clip off trailing spaces.
    menuName = string.sub(menuName, 9)
    menuName = string.gsub(menuName, ' ', '')

    return menuHandler.Types[menuName]
end

return menuHandler
