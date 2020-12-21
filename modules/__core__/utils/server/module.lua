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

module.game.createVehicle = function (model, coords, heading, cb)
  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)

  if vehicle and cb then
    cb(vehicle)
  end
end

module.game.createLocalVehicle = function(model, coords, heading, cb)
  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

  if vehicle and cb then
    cb(vehicle)
  end
end

module.game.AddPlayerToHideList = function(player)
  emitClient('utils:AddPlayerToHideList', -1, player)
end

module.game.RemovePlayerFromHideList = function(player)
  emitClient('utils:RemovePlayerFromHideList', -1, player)
end