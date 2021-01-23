M('events')
M('item')
M('table')

-- on("esx:items:update", function()
--   print("receiving esx:items:update")
-- end)

-- register an event handler when a player laod
on("esx:player:load", function(player)
  -- register an even handler on the loaded player and wait
  -- for its identity to be laoded
  player:on("identity:loaded", function(identity)
    print(json.encode(identity:serialize()))
    local identityOwner = identity:getIdentifier()
    Inventory.ensure({
      owner = "identity:" .. identityOwner
    }, {
      owner = "identity:" .. identityOwner,
    }, function(inventory)
      print("Loaded identity inventory " .. identity:getFirstName() .. " " identity:getLastName())
      Inventory.all[inventory.owner] = inventory
      identity:field("inventory", inventory)
    end)
  end)
end)