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

-- on('esx:startCache', function()
--   if Config.Modules.cache.cachedTables then
--     for k,v in pairs(Config.Modules.cache.cachedTables) do
--       MySQL.Async.fetchAll('SELECT * FROM ' .. v, {}, function(result)
--         if result then
--           for i=1, #result, 1 do
--             if i then
--               print("^3" .. v .. " - ^2RESULT ^1" .. i .. "^7")
--               for j,r in pairs(result[i]) do
--                 print(j .. " | " .. r)
--               end
--             end
--           end
--         else
--           print(false)
--         end
--       end)
--     end
--   end
-- end)
