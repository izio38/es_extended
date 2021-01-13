M('events')
M('ui.hud')

module.Frame = Frame('atm', 'nui://' .. __RESOURCE__ .. '/modules/__base__/atm/data/html/index.html')

module.Frame:on('load', function()
  module.Ready = true
end)

module.Frame:on('message', function(msg)
  if (msg.action == 'esx.deposit') then
    request('esx:atm:deposit', function(callback)
      if callback then
        print("yeah")
      else
        print("fuck you")
      end
    end, msg.amount)
  end

  if (msg.action == 'esx.withdraw') then
    request('esx:atm:withdraw', function(callback)
      if callback then
        print("yeah")
      else
        print("fuck you")
      end
    end, msg.amount)
  end
end)

onServer('esx:atm:notification', function(message)
  module.ShowAtmNotification(message)
end)




