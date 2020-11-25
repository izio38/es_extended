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


M('command')

module.init = function()
    module.registerDepositCommand()
    module.registerATMCommand()
    module.closeATMCommand()
end

module.registerDepositCommand = function()
    local depositCommand = Command('deposit', 'user', "Deposit an amout to your account")

    depositCommand:setHandler(function(player)
        emitClient('esx:atm:deposit', player.source)
    end)
    depositCommand:register()
end

module.registerATMCommand = function()
    local ATMCommand = Command('atm', 'user', "Open atm")
    ATMCommand:setHandler(function(player)
        emitClient('esx:atm:display', player.source)
    end)
    ATMCommand:register()
end

module.closeATMCommand = function()
    local ATMCloseCommand = Command('atm:close', 'user', 'Close the ATM')
    ATMCloseCommand:setHandler(function(player)
        emitClient('esx:atm:close', player.source)
    end)
    ATMCloseCommand:register()
end