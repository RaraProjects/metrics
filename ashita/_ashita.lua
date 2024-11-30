Ashita = T{}

-- ------------------------------------------------------------------------------------------------------
-- https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/Ashita.h
-- Memory Manager Functions
-- IAutoFollow* GetAutoFollow(void)
-- ICastBar* GetCastBar(void)
-- IEntity* GetEntity(void)
-- IInventory* GetInventory(void)
-- IParty* GetParty(void)
-- IPlayer* GetPlayer(void)
-- IRecast* GetRecast(void)
-- ITarget* GetTarget(void)
-- ------------------------------------------------------------------------------------------------------
-- TO DO
-- 1. Finish the pet portion in a.Mob.Get_Mob_By_Target
-- ------------------------------------------------------------------------------------------------------

Ashita.States = {
    Zoning = false,
}

require("ashita._enums")
require("ashita.mob")           -- Getting data related to mobs.
require("ashita.player")        -- Getting data related to the player.
require("ashita.party")         -- Getting data related to the party.
require("ashita.ability")       -- Getting data related to abilities.
require("ashita.spell")         -- Getting data related to spells.
require("ashita.weaponskill")   -- Getting data related to weaponskills.
require("ashita.item")          -- Getting data related to items.
require("ashita.chat")          -- Chat functions.
require("ashita.packets")       -- Packet functions.