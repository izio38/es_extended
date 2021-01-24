M('class')
M('persistent')
M('events')
M('table')
M('item')

local InventoryMixin = Extends(nil, 'InventoryMixin')

function InventoryMixin:constructor()
  self.test = "nil"
end

-- @TODO: metadata
function InventoryMixin:add(itemName, quantity, metadata)
  if not(Items[itemName]) then
    ESX.LogWarning(("Cannot add %i %s, %s isn't registered."):format(quantity, itemName, itemName))
    return self
  end

  -- find if the item already exists in the inventory content
  local existingItem = table.find(self.content, function(item) 
    return item.name == itemName
  end)

  if existingItem ~= nil then
    -- add quantity
    existingItem.quantity = existingItem.quantity + quantity
  else
    -- create new item with quantity
    table.insert(self.content, { name = itemName, quantity = quantity})
  end

  return self
end

-- @TODO: metadata
function InventoryMixin:remove(itemName, quantity, metadata)
  if not(Items[itemName]) then
    ESX.LogWarning(("Cannot remove %i %s, %s isn't registered."):format(quantity, itemName, itemName))
    return self
  end

  -- find if the item already exists in the inventory content
  local existingItemIndex = table.findIndex(self.content, function(item) 
    return item.name == itemName
  end)
  local existingItem = self.content[existingItemIndex]

  if existingItem ~= nil then

    local endCount = existingItem.quantity - quantity

    if endCount < 0 then
      ESX.LogWarning(("Removed %i %s, endCount is < 0."):format(quantity, itemName))
      existingItem.quantity = endCount
    elseif (endCount == 0) then
      -- remove item from the content
      table.remove(self.content, existingItemIndex)
    else
      existingItem.quantity = endCount
    end

  else
    -- create new item with quantity
    table.insert(self.content, { name = itemName, quantity = quantity})
  end

  return self
end

function InventoryMixin:has(itemName, quantity)
  if not(Items[itemName]) then
    ESX.LogWarning(("Cannot say if inventory has %i %s, %s isn't registered."):format(quantity, itemName, itemName))
    return self
  end

  quantity = quantity or 0

  local existingItem = table.find(self.content, function(item) 
    return item.name == itemName
  end)

  return (existingItem and existingItem.quantity >= quantity)
end

function InventoryMixin:hasExactly(itemName, quantity)
  if not(Items[itemName]) then
    ESX.LogWarning(("Cannot say if inventory has %i %s, %s isn't registered."):format(quantity, itemName, itemName))
    return self
  end

  quantity = quantity or 0

  local existingItem = table.find(self.content, function(item) 
    return item.name == itemName
  end)

  return (existingItem and existingItem.quantity == quantity)
end

function InventoryMixin:reorder(items)
  local isAuthorizeToReorder = true

  for i=1,#items do
    if not(self:hasExactly(items[i].name, items[i].quantity)) then
      isAuthorizeToReorder = false
      break
    end
  end

  if not(isAuthorizeToReorder) then
    ESX.LogWarning(("Someone tried to cheat (give item) when reordering inventory, identory identifier: %s, owner: %s."):format(self.identifier, self.owner))
    return
  end

  -- we're safe to reorder here
  self.content = items
end

Inventory = Persist('inventories', 'id', EventEmitter, InventoryMixin)

Inventory.define({
  {name = 'id',         field = {name = 'id',         type = 'INT',        length = nil, default = nil,                   extra = 'NOT NULL AUTO_INCREMENT'}},
  {name = 'identifier', field = {name = 'identifier', type = 'VARCHAR',    length = 64,  default = 'UUID()',              extra = 'NOT NULL'}},
  {name = 'owner',      field = {name = 'owner',      type = 'VARCHAR',    length = 64,  default  = nil,                  extra = 'NOT NULL'}},
  {name = 'content',    field = {name = 'content',    type = 'JSON',       length = nil, default = json.encode({}),       extra = 'NOT NULL'}, encode = json.encode, decode = json.decode},
})

Inventory.all = setmetatable({}, {
  __index    = function(t, k) return rawget(t, tostring(k)) end,
  __newindex = function(t, k, v) rawset(t, tostring(k), v) end,
})

Inventory.fromOwner = function(owner)
  return Identity.all[owner]
end