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
M('serializable')
M('cache')
M('ui.menu')

local HUD   = M('game.hud')
local utils = M("utils")

module.Init()

ESX.SetInterval(0, function()
  if module.inMarker then
    if IsControlJustReleased(0, 38) then
      module.CurrentAction()
    end

    if module.isInGarageMenu then
      DisableControlAction(0,51,true)
    end
  end
end)