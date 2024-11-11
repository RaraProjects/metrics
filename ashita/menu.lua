Ashita.Menu = T{}

Ashita.Menu.Module  = "FFXiMain.dll"
Ashita.Menu.Pattern = "8B480C85C974??8B510885D274??3B05"

Ashita.Menu.Types = T{
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
}

-- ------------------------------------------------------------------------------------------------------
-- Gets the name of the upper most menu.
-- Copied from PetMe which got it from XITools.
-- https://github.com/mousseng/xitools
-- https://github.com/m4thmatic/PetMe
-- ------------------------------------------------------------------------------------------------------
---@return string, integer
-- ------------------------------------------------------------------------------------------------------
function Ashita.Menu.Get_Menu_Name()
    local menu = ashita.memory.find(Ashita.Menu.Module, 0, Ashita.Menu.Pattern, 16, 0)
    local pointer = ashita.memory.read_uint32(menu)
    local pointer_value = ashita.memory.read_uint32(pointer)
    if pointer_value == 0 then return "", 0 end
    local menu_header = ashita.memory.read_uint32(pointer_value + 4)
    local menu_name = ashita.memory.read_string(menu_header + 0x46, 16)
    return string.gsub(menu_name, "\x00", "")
end

-- ------------------------------------------------------------------------------------------------------
-- Checks whether a menu is up that we should hide Metrics for.
-- ------------------------------------------------------------------------------------------------------
---@return boolean
-- ------------------------------------------------------------------------------------------------------
function Ashita.Menu.Hide()
    local menu_name = Ashita.Menu.Get_Menu_Name()
    if not menu_name then return true end

    -- Get rid of prefix junk and clip off trailing spaces.
    menu_name = string.sub(menu_name, 9)
    menu_name = string.gsub(menu_name, " ", "")

    return Ashita.Menu.Types[menu_name]
end