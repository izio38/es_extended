M('events')
M('item')
M('table')
M('string')

-- on("esx:items:update", function()
--   print("receiving esx:items:update")
-- end)

-- register an event handler when a player laod
on("esx:player:load", function(player)
  -- register an even handler on the loaded player and wait
  -- for its identity to be laoded
  player:on("identity:loaded", function(identity)
    local identityOwner = identity:getIdentifier()
    Inventory.ensure({
      owner = "identity:" .. identityOwner
    }, {
      owner = "identity:" .. identityOwner,
    }, function(inventory)
      Inventory.all[inventory.owner] = inventory
      identity:field("inventory", inventory)

      emitClient("esx:inventory:loaded", player:getSource(), inventory:serialize())
    end)
  end)
end)

onClient('esx:inventory:reorder', function(items)
  local inventory = Player.fromId(source):getIdentity():getInventory()

  -- reorder check if items is included in the current content.
  inventory:reorder(items)
end)

onClient('esx:inventory:give', function(payload)
  local sourcePlayer = Player.fromId(source)
  local sourceInventory = sourcePlayer:getIdentity():getInventory()

  local itemName = payload.name
  local quantity = payload.quantity
  local target = payload.target

  local splittedTarget = string.split(target, ":")

  local targetType = splittedTarget[1]
  local targetId = splittedTarget[2]

  if (targetType == "player") then
    local targetPlayer = Player.fromId(targetId)

    -- @TODO: check targetPlayer exists
    -- @TODO: check targetPlayer is near the sourcePlayer

    local targetInventory = targetPlayer:getIdentity():getInventory()

    -- verify source has requested item quantity
    local hasItemQuantity = sourceInventory:has(itemName, quantity)
    if not(hasItemQuantity) then
      print("doesn't has item quantity")
      return
    end

    print("giving x" .. quantity .. " " .. itemName .. " to " .. targetId .. " from " .. source)

    -- transaction
    sourceInventory:remove(itemName, quantity)
    targetInventory:add(itemName, quantity)

    -- notify changed
    emitClient("esx:inventory:update", source, sourceInventory:serialize())
    emitClient("esx:inventory:update", targetId, targetInventory:serialize())
  end
end)


onRequest('esx:inventory:get', function(source, cb)
  local inventory = Player.fromId(source):getIdentity():getInventory()

  cb(inventory:serialize())
end)