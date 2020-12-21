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
M('class')
M('table')
M('persistent')
local Cache = M("cache")
local Identity = M("identity")

module.Cache               = {}
module.Cache.Accounts      = {}
module.Cache.AccountsFound = false

Account = {}

Account = Persist('accounts', 'id')

Account.define({
  {name = 'id',    field = {name = 'id',     type = 'INT',     length = nil, default = nil,    extra = 'NOT NULL AUTO_INCREMENT'}},
  {name = 'name',  field = {name = 'name',   type = 'VARCHAR', length = 64,  default = nil,    extra = 'NOT NULL'}},
  {name = 'owner', field = {name = 'owner',  type = 'VARCHAR', length = 64,  default = 'NULL', extra = nil}},
  {name = 'money', field = {name = 'money',  type = 'INT',     length = nil, default = 0,      extra = nil}},
})

Account.AddIdentityMoney = function(account, money, player)
  local accounts = Cache.RetrieveAccounts(player.identifier, player:getIdentityId())
  if accounts then
    if accounts[account] then
      local transaction = Cache.AddMoneyToAccount(player.identifier, player:getIdentityId(), account, money)
      if transaction.type == "success" then
        emitClient('esx:account:notify', player.source, account, money, transaction.value)
        if player then
          emitClient('esx:account:showMoney', player.source, false)
        else
          emitClient('esx:account:showMoney', source, false)
        end
      else
        emitClient('esx:account:transactionError', player.source)
      end
    end
  end
end

Account.RemoveIdentityMoney = function(account, money, player)
  local accounts = Cache.RetrieveAccounts(player.identifier, player:getIdentityId())
  if accounts then
    if accounts[account] then
      local transaction = Cache.RemoveMoneyFromAccount(player.identifier, player:getIdentityId(), account, money)
      if transaction.type == "success" then
        emitClient('esx:account:notify', player.source, account, money, transaction.value)
        if player then
          emitClient('esx:account:showMoney', player.source, true)
        else
          emitClient('esx:account:showMoney', source, false)
        end
      elseif transaction.type == "not_enough_money" then
        emitClient('esx:account:notEnoughMoney', player.source, account, money)
        if player then
          emitClient('esx:account:showMoney', player.source, true)
        else
          emitClient('esx:account:showMoney', source, false)
        end
      else
        emitClient('esx:account:transactionError', player.source, account)
      end
    end
  end
end


----------------------------------------------------------------------------------------------------
--       EVERYTHING BELOW IS FOR SOCIETY ACCOUNTS IN THE FUTURE, PLEASE DO NOT REMOVE             --
----------------------------------------------------------------------------------------------------

-- function Account:setMoney(money)

--   local orig = self.money
--   self.money = money

--   if money < orig then
--     self:emit('remove', orig - money)
--   elseif money > orig then
--     self:emit('add', money - orig)
--   end

-- end

-- function Account:addMoney(money)

--   self.money = self.money + money

--   if money < 0 then
--     self:emit('remove', math.abs(money))
--   elseif money > 0 then
--     self:emit('add', money)
--   end

-- end

-- function Account:removeMoney(money)

--   self.money = self.money - money

--   if money < 0 then
--     self:emit('add', math.abs(money))
--   elseif money > 0 then
--     self:emit('remove', money)
--   end

-- end

--[[
on('esx:db:ready', function()

  local account = Account({
    name  = 'test',
    money = 0,
  })

  account:on('save', function()
    print(account.name .. ' saved => ' .. account:get())
  end)

  account:on('add', function(amount)
    print('add', amount)
  end)

  account:on('remove', function(amount)
    print('remove', amount)
  end)

  account:setMoney(0)

  account:setMoney(1000)
  account:setMoney(250)
  account:setMoney(2000)
  account:removeMoney(5)
  account:removeMoney(-100)
  account:addMoney(5)
  account:addMoney(-100)

  account:save(function(id)
    account:trace(id)
  end)

end)
]]--
