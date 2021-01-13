M('events')

onRequest('esx:atm:deposit', function(source, cb, amount, bank)
  if module.DepositMoney(amount, bank) then
    cb(true)
  else
    cb(false)
  end
end)

onRequest('esx:atm:withdraw', function(source, cb, amount, bank)
  if module.WithdrawMoney(amount, bank) then
    cb(true)
  else
    cb(true)
  end
end)
