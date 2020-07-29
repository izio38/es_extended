-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

M('events')
M('table')

on("esx:db:ready", function()
  -- load all items to server memory.
  Item.find({}, function(items)
    if items ~= nil then
      -- @DEBUG: remove
      print(json.encode(items))

      table.map(items, function(item)
        -- for each items, store it globally in this module
        Item.all[item:getName()] = item
      end)
    end
    
  end)
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  Inventory.saveAll()
end)

on('esx:player:load', function(player)
  player:on('identity:loaded', function(identity)
    -- load inventory
    player:emit('inventory:loaded')
  end)
end)
