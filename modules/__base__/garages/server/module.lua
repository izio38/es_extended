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

local Cache   = M("cache")
local utils   = M("utils")

module.Cache = {}

module.Config  = run('data/config.lua', {vector3 = vector3})['Config']

module.Init = function()
  local translations = run('data/locales/' .. Config.Locale .. '.lua')['Translations']
  LoadLocale('garages', Config.Locale, translations)
end
