M('events')
local utils = M('utils');

module.Ready = false
module.Frame = nil


onServer('esx:atm:open', function()
  module.Frame:postMessage({
    method = 'setVisibility',
    visibility = true
  })
  module.Frame:focus(true)
end)

onServer('esx:atm:close', function()
  print("hello it actaully closed")
  module.Frame:postMessage({
    method = 'setVisibility',
    visibility = false
  })
  SetNuiFocus(false, false)
end)

-- Listen for NUI callbacks

RegisterNUICallback('esx:atm:close', function()
  module.Frame:postMessage({
    method = 'setVisibility',
    visibility = false
  })
  SetNuiFocus(false, false)
end)


--[[RegisterNUICallback('esx:atm:deposit', function(data)
  emitServer('esx:atm:deposit', data)
end)

RegisterNUICallback('esx:atm:withdraw', function(data)
  emitServer('esx:atm:withdraw', data)
end)]]

module.ShowAtmNotification = function(message)
  utils.ui.showNotification(message)
end
