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

module.Config  = run('data/config.lua', {vector3 = vector3})['Config']

moduel.CreateStatus = function(xPlayer, name, default, color, visible, tickCallback, clientAction)

	local self = {}

	self.val          = default
	self.xPlayer      = xPlayer
	self.name         = name
	self.default      = default
	self.color        = color
	self.visible      = visible
	self.tickCallback = tickCallback
	self.clientAction = clientAction

	self._set = function(k, v)
		self[k] = v
	end

	self._get = function(k)
		return self[k]
	end

	self.onTick = function()
		self.tickCallback(self)
	end

	self.set = function(val)
		self.val = val
	end

	self.add = function(val)
		if self.val + val > module.Config.StatusMax then
			self.val = module.Config.StatusMax
		else
			self.val = self.val + val
		end
	end

	self.remove = function(val)
		if self.val - val < 0 then
			self.val = 0
		else
			self.val = self.val - val
		end
	end

	self.getPercent = function()
		return (self.val / module.Config.StatusMax) * 100
	end

	self.updateClient = function()
		emit('status:updateClient', self.xPlayer.source)
	end

	return self

end

module.SaveData = function()
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local status  = xPlayer.get('status')

		MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
			['@status']     = json.encode(status),
			['@identifier'] = xPlayer.identifier
		})
	end

	SetTimeout(10 * 60 * 1000, SaveData)
end