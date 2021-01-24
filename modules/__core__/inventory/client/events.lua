M("events")

onServer("esx:inventory:loaded", function(inventory)
  module.Init()
end)

onServer("esx:inventory:update", function(inventory)
  module.UpdateInventory(inventory)
end)