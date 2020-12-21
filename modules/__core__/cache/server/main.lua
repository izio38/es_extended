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

ESX.SetInterval(Config.Modules.Cache.ServerSaveInterval * 1000 * 60, function()
  if ESX.Ready and Config.Modules.Cache.UseCache then
    emit('esx:saveCache')
  end
end)

M('command')

local forcesaveCommand = Command("forcesave", "admin", "force a cache save")

forcesaveCommand:setHandler(function(player, args, baseArgs)
  module.SaveCache()
end)
forcesaveCommand:setRconAllowed(true)
forcesaveCommand:register()