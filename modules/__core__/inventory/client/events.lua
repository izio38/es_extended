M("events")

onServer("esx:inventory:loaded", function(inventory)
  module.Init()
end)