M('persistent')
M('events')
M('table')

Items = {}

module.register = function(items)
  table.map(items, function(item) 
    Items[item:getName()] = item
  end)
  
  emit("esx:items:update")
end

Item = Persist('items', 'id', EventEmitter)

Item.define({
  {name = 'id',         field = {name = 'id',         type = 'INT',     length = nil, default = nil, extra = 'NOT NULL AUTO_INCREMENT'}},
  {name = 'name',       field = {name = 'name',       type = 'VARCHAR', length = 128, default = nil, extra = 'NOT NULL'}},
  {name = 'countLimit', field = {name = 'count_limit',type = 'INT',     length = nil, default = nil, extra = nil}},
})

function Item:constructor(data)
  self.super:ctor(data)
end
