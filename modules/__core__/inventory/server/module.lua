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

M('persistent')

module.Inventories = {}

Inventory = Persist('iventory', 'id', Enrolable)

Inventory.define({
  {name = 'id',         field = {name = 'id',         type = 'INT',        length = nil, default = nil,                extra = 'NOT NULL AUTO_INCREMENT'}},
  {name = 'identifier', field = {name = 'identifier', type = 'VARCHAR',    length = 64,  default = 'UUID()',           extra = 'NOT NULL'}},
  {name = 'owner',      field = {name = 'owner',      type = 'VARCHAR',    length = 64,  default = nil,                extra = 'NOT NULL'}},
  {name = 'ownerType',  field = {name = 'owner_type', type = 'VARCHAR',    length = 64,  default = "player",           extra = 'NOT NULL'}},
  {name = 'position',   field = {name = 'position',   type = 'VARCHAR',    length = 255, default = nil,                extra = nil}, encode = json.encode, decode = json.decode},
  {name = 'content',    field = {name = 'content',    type = 'LONGTEXT',   length = nil, default = '[]',               extra = nil}, encode = json.encode, decode = json.decode},
})

Inventory.all = setmetatable({}, {
  __index    = function(t, k) return rawget(t, tostring(k)) end,
  __newindex = function(t, k, v) rawset(t, tostring(k), v) end,
})

Inventory.fromId = function(id)
  return Inventory.all[id]
end

-- @TODO: make a queue that consume each inventory one by one
-- to avoid burning the SQL queries (maybe a pool of 5 by 5 saves)
Inventory.saveAll = function(cb)
  for id, inventory in pairs(Inventory.all) do
    inventory:save()
  end
end

function Inventory.isItemDefined(name)
  return table.indexOf(Inventory.ItemDefs, name) ~= -1
end

-- we can use this constructor to add non-persistant datas
-- linked to the constructed inventory
function Inventory:constructor(data)
  self.super:ctor(data)
end

function Inventory:add(name, count)

  if not Inventory.isItemDefined(name) then
    error('item [' .. name .. '] is not defined in config')
  end

  if self.items[name] == nil then
    self.items[name] = 0
  end

  self.items[name] = self.items[name] + count

  if self.items[name] == 0 then
    self.items[name] = nil
  end

  if count < 0 then
    self:emit('remove', name, math.abs(count))
  elseif count > 0 then
    self:emit('add', name, count)
  end

end

function Inventory:remove(name, count)

  if not Inventory.isItemDefined(name) then
    error('item [' .. name .. '] is not defined in config')
  end

  if self.items[name] == nil then
    self.items[name] = 0
  end

  self.items[name] = self.items[name] - count

  if self.items[name] == 0 then
    self.items[name] = nil
  end

  if count < 0 then
    self:emit('add', name, math.abs(count))
  elseif count > 0 then
    self:emit('remove', name, count)
  end

end
