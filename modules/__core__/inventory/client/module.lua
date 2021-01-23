module.Frame = nil
module.isOpeningInventory = false

module.Init = function()
  module.Frame = Frame('inventory', 'nui://' .. __RESOURCE__ .. '/modules/__core__/inventory/data/build/index.html', false)

  module.Frame:on('close', function()
    module.CloseInventory()
  end)
end

module.OpenInventory = function()
  -- if inventory isn't inited yet, exit
  if module.Frame == nil then return end

  -- if we're already loading players, exit
  if module.isOpeningInventory then return end

  module.isOpeningInventory = true

  -- @TODO: do not query server on each open but rather
  -- store the last inventory state client side
  request("esx:inventory:get", function(inventory)
    if not(inventory == nil) then

      print(json.encode(inventory))

      module.Frame:postMessage({
        action = 'openSelfInventory',
        -- @TODO: only map properties that are required on the ui side
        -- for now, we're sending all the datas we have on inventory
        data = inventory
      })

      module.Frame:show()
      module.Frame:focus(true)
    end
    module.isOpeningInventory = false
  end)
end

module.CloseInventory = function()
  module.Frame:hide()
  module.Frame:unfocus()
end