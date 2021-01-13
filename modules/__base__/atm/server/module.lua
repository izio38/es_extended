M('events')
M('command')
M('account')

module.Init = function()
  module.openAtmCommand()
  module.closeAtmCommand()
end

module.openAtmCommand = function()
  local atmCommand = Command('atm', 'user', 'Open the bank display')
  atmCommand:setHandler(function(player)
    print(player.identifier)
    print("please work now")
    emitClient('esx:atm:open', player.source)
  end)
  atmCommand:register()
end

module.closeAtmCommand = function()
  local atmCloseCommand = Command('atm:close', 'user', 'Open the bank display')
  atmCloseCommand:setHandler(function(player)
    print(player.identifier)
    print("please work now")
    emitClient('esx:atm:close', player.source)
  end)
  atmCloseCommand:register()
end

-- deposit money
module.DepositMoney = function(amount, bankName)
  print(amount)
  local player = Player.fromId(source)
  local wallet = Account.RetrieveIdentityMoney("wallet", player)

  if wallet >= tonumber(amount) then
    Account.RemoveIdentityMoney("wallet", amount, player)
    Account.AddIdentityMoney('maze', amount, player)
    return true
  else
    emitClient('esx:atm:notification', source, "You do not have enough money")
    return false
  end

  local currentBank = Account.RetrieveIdentityMoney("maze", player)
  local currentWallet = Account.RetrieveIdentityMoney("wallet", player)
  print("BANK", currentBank)
  print('WALLET', currentWallet)
end

-- withdraw money
module.WithdrawMoney = function(amount, bankName)
  local player = Player.fromId(source)
  local bank = Account.RetrieveIdentityMoney("maze", player)

  if bank >= tonumber(amount) then
    Account.RemoveIdentityMoney("maze", amount, player)
    Account.AddIdentityMoney("wallet", amount, player)
    return true
  else
    emitClient('esx:atm:notification', source, "You dont have enough money in the bank")
    return false
  end

  local currentBank = Account.RetrieveIdentityMoney("maze", player)
  local currentWallet = Account.RetrieveIdentityMoney("wallet", player)
  print("BANK", currentBank)
  print('WALLET', currentWallet)
end


