local ItemSet = {}
ItemSet.__index = ItemSet
ItemSet.new = function(mapping)
	return setmetatable({mapping=mapping}, ItemSet)
end

-- internal functions
local _useItem = function(self, fn, name)
	local i = self:slot(name)
	turtle.select(i)
	for j = 16, 1, -1 do
		if turtle.compareTo(j) and (i ~= j or turtle.getItemCount(j) > 1) then
			return fn()
		end
	end
	return false
end
local _useItems = function(self, fn, name, n)
	local i = self:slot(name)
	local dropped = 0
	for j = 16, 1, -1 do
		turtle.select(j)
		if turtle.compareTo(i) then
			local count = turtle.getItemCount(j)
			if i == j then count = count - 1 end
			if n and dropped + count > n then
				return fn(n - dropped)
			elseif count > 0 then
				local success = fn(count)
				if not success then return false end
			end

			dropped = dropped + count
		end
	end
	return n == 0 or dropped > 0
end
local _withItems = function(self, fn, name)
	turtle.select(self:slot(name))
	return fn()
end
local _findName = function(self, predicate)
	for name in pairs(self.mapping) do
		if predicate(self, name) then
			return name
		end
	end
end

-- methods
do
	-- get the slot defined in the mapping
	ItemSet.slot = function(self, name)
		return self.mapping[name] or error(('%s is not a known item!'):format(name))
	end

	-- count the number of items of a certain type
	ItemSet.count = function(self, name)
		turtle.select(self:slot(name))
		local count = -1 -- one item must remain to check identity
		for j = 1, 16 do
			if turtle.compareTo(j) then
				count = count + turtle.getItemCount(j)
			end
		end
		return count
	end

	-- returns the name of the block, as a string, or nil
	ItemSet.block     = function(self) return _findName(self, ItemSet.blockIs) end
	ItemSet.blockUp   = function(self) return _findName(self, ItemSet.blockUpIs) end
	ItemSet.blockDown = function(self) return _findName(self, ItemSet.blockDownIs) end

	-- check if the block is of a certain type. `i:blockIs('wood')` is more efficient than `i:block() == 'wood'`
	ItemSet.blockIs     = function(self, name) return _withItems(self, turtle.compare, name) end
	ItemSet.blockUpIs   = function(self, name) return _withItems(self, turtle.compareUp, name) end
	ItemSet.blockDownIs = function(self, name) return _withItems(self, turtle.compareDown, name) end

	-- place a block of a certain type
	ItemSet.place     = function(self, name) return _useItem(self, turtle.place, name) end
	ItemSet.placeUp   = function(self, name) return _useItem(self, turtle.placeUp, name) end
	ItemSet.placeDown = function(self, name) return _useItem(self, turtle.placeDown, name) end

	-- drop a block of a certain type
	ItemSet.drop     = function(self, name, n) return _useItems(self, turtle.drop, name, n) end
	ItemSet.dropUp   = function(self, name, n) return _useItems(self, turtle.dropUp, name, n) end
	ItemSet.dropDown = function(self, name, n) return _useItems(self, turtle.dropDown, name, n) end

	ItemSet.refuelWith = function(self, name) return _useItems(self, turtle.refuel, name, n) end
end

return ItemSet
