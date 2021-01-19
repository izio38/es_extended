local utils = M("utils")

on("esx:db:ready", function()
  Item.find({}, function(itemResults)
    if itemResults ~= nil then
      module.register(itemResults)
    end
  end)
end)