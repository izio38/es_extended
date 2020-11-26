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
module.Ready = false
module.Frame = nil


RegisterNUICallback('esx:atm:close', function()
  module.Frame:postMessage({
    method = 'setVisibility',
    data = false
  })

  SetNuiFocus(false, false)
end)

onServer('esx:atm:display', function()
  module.Frame:postMessage({
    method = 'setVisibility',
    data = true
  })

  module.Frame:focus()
  SetNuiFocus(true, true)
end)

-- Callbacks for each function

RegisterNUICallback('esx:atm:deposit', function(data)
  emitServer('esx:atm:depositMoney', data.amount)
end)

RegisterNUICallback('esx:atm:deposit', function(data)
  emitServer('esx:atm:withdrawMoney', data.amount)
end)


