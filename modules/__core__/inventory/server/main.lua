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

local inventorySavingInterval = ESX.SetInterval(Config.Modules.inventory.inventorySaveInterval, Inventory.saveAll)

-- local inventory = Inventory({
--   id=1,
--   identifier="865234ad-6a92-11e7-8846-b05adad3f0ae",
--   owner="xxxxxxxxxxxxxxxxxxxxxxxxxxxx",
--   ownerType="player",
--   position=nil
-- })

-- Inventory.all[inventory:getId()] = inventory