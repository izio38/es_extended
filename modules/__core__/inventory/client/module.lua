module.Frame = nil
module.isOpeningInventory = false

module.Init = function()
  module.Frame = Frame('inventory', 'nui://' .. __RESOURCE__ .. '/modules/__core__/inventory/data/build/index.html', false)

  module.Frame:on('close', function()
    module.CloseInventory()
  end)

  module.Frame:on('reorder', function(data)
    emitServer('esx:inventory:reorder', data.items)
  end)

  module.Frame:on('give', function(data)
    emitServer('esx:inventory:give', {
      name = data.name,
      quantity = data.quantity,
      target = "player:" .. data.playerId
    })
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

      -- get near player loop
      Citizen.CreateThread(function()
        while module.Frame.visible do

          local playerCoords = GetEntityCoords(GetPlayerPed(-1))
          local nearPlayers = {}
          for _, playerId in ipairs(GetActivePlayers()) do
            -- do not add the current player
            -- if not(playerId == 0) then
              local otherPlayerCoords = GetEntityCoords(GetPlayerPed(playerId))              

              local distance = #(playerCoords - otherPlayerCoords)
              if (distance) <= 5 then
                table.insert(nearPlayers, {playerId = GetPlayerServerId(playerId), distance = (math.ceil(distance * 100) / 100) })
              end
            -- end
          end

          module.Frame:postMessage({
            action = 'updateNearPlayers',
            -- @TODO: only map properties that are required on the ui side
            -- for now, we're sending all the datas we have on inventory
            data = nearPlayers
          })

          -- avoid lags, but less precise
          Wait(1000)
        end
      end)

      module.Frame:postMessage({
        action = 'updateSelfInventory',
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

module.UpdateInventory = function(inventory)
  module.Frame:postMessage({
    action = 'updateSelfInventory',
    -- @TODO: only map properties that are required on the ui side
    -- for now, we're sending all the datas we have on inventory
    data = inventory
  })
end