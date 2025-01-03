Items = {}

Items.Pool = {}

-- ------------------------------------------------------------------------------------------------------
-- File who obtained the item.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Items.Dropped = function(data)
    local drop_data = Ashita.Packets.Item_Drop(data)
    if not drop_data then return nil end

    local item_name = Ashita.Item.Get_Item_Name(drop_data.Item)
    Items.Pool[drop_data.Index] = item_name

    local mob = Ashita.Mob.Get_Mob_By_Index(drop_data.Dropper_Index)
    if not mob or not mob.name then return nil end
    local mob_name = mob.name

    -- Track total drops.
    if not DB.Tracking.Total_Items[item_name] then DB.Tracking.Total_Items[item_name] = 0 end
    DB.Tracking.Total_Items[item_name] = DB.Tracking.Total_Items[item_name] + 1

    -- Track mob specific drops.
    if not DB.Tracking.Drop_Rates[mob_name] then DB.Tracking.Drop_Rates[mob_name] = {} end
    if not DB.Tracking.Drop_Rates[mob_name][item_name] then DB.Tracking.Drop_Rates[mob_name][item_name] = 0 end
    DB.Tracking.Drop_Rates[mob_name][item_name] = DB.Tracking.Drop_Rates[mob_name][item_name] + 1
end

-- ------------------------------------------------------------------------------------------------------
-- File who obtained the item.
-- ------------------------------------------------------------------------------------------------------
---@param data table
-- ------------------------------------------------------------------------------------------------------
Items.Obtained = function(data)
    local drop_data = Ashita.Packets.Item_Action(data)
    if not drop_data then return nil end

    -- Only care about items being obtained or floored.
    local is_drop = drop_data.Drop

    local recipient_name = "Floor"

    -- Lotting/Passing actions.
    if is_drop == 0 then
        return nil

    -- Player obtains item.
    elseif is_drop == 1 then
        local recipient_index = drop_data.Highest_Lotter_Index
        local recipient_mob = Ashita.Mob.Get_Mob_By_Index(recipient_index)
        if not recipient_mob then return nil end
        recipient_name = recipient_mob.name

    -- Floor obtains item.
    elseif is_drop == 2 then
        -- Do nothing.

    end

    local item_name = Items.Pool[drop_data.Index] or "Unknown"
    Items.Pool[drop_data.Index] = nil

    if not DB.Tracking.Received_Items[recipient_name] then DB.Tracking.Received_Items[recipient_name] = {} end
    if not DB.Tracking.Received_Items[recipient_name][item_name] then DB.Tracking.Received_Items[recipient_name][item_name] = 0 end

    DB.Tracking.Received_Items[recipient_name][item_name] = DB.Tracking.Received_Items[recipient_name][item_name] + 1
    print(tostring(recipient_name) .. " obtained " .. tostring(item_name))
end