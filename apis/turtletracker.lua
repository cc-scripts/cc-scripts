--[[
This module monkeypatches the turtle API to include dead-reckoning - every move
command will update t.position or turtle.location
]]

os.loadAPI('apis/direction.lua')

local t = turtle
t.position = vector.new(0, 0, 0)
t.orientation = direction.north

-- Wrap all functions to keep track of any state they change
do
	-- Returns a wrapped function that calls a handler with the result
	-- before returning
	local intercept = function(f, oninvoked)
	    return function(...)
	        local ret = f(...)
	        oninvoked(ret, ...)
	        return ret
	    end
	end
	t.forward = intercept(t.forward, function(success)
		if success then t.position = t.position + t.orientation end
	end)
	t.back = intercept(t.back, function(success)
		if success then t.position = t.position - t.orientation end
	end)
	t.up = intercept(t.up, function(success)
		if success then t.position = t.position + direction.up end
	end)
	t.down = intercept(t.down, function(success)
		if success then	t.position = t.position + direction.down end
	end)
	t.turnLeft = intercept(t.turnLeft, function(success)
		if success then t.orientation = direction.leftOf[t.orientation] end
	end)
	t.turnRight = intercept(t.turnRight, function(success)
		if success then t.orientation = direction.rightOf[t.orientation] end
	end)
	t.select = intercept(t.select, function(_, slot)
		t.slot = slot
	end)
end

-- Functions taking absolute directions
do
	-- allow strings to be passed directly as well as directions
	local directionTaker = function(f)
		return function(d)
			if type(d) == "string" then
				d = direction[d]
			end
			return d and f(d) or false
		end
	end

	t.turnTo = directionTaker(function(dir)
		local left = direction.leftOf[t.orientation]
		local right = direction.rightOf[t.orientation]
		local back = direction.behind[t.orientation]

		if right == dir then
			t.turnRight()
		elseif left == dir then
			t.turnLeft()
		elseif back == dir then
			t.turnLeft()
			t.turnLeft()
		end
		return true
	end)

	t.moveAlong = directionTaker(function(dir)
		if dir == direction.up then
			return t.up()
		elseif dir == direction.down then
			return t.down()
		elseif dir == direction.behind[t.orientation] then
			-- special case - reverse when moving
			return t.back()
		else
			t.turnTo(dir)
			return t.forward()
		end
	end)
	t.digAlong = directionTaker(function(dir)
		if dir == direction.up then
			return t.digUp()
		elseif dir == direction.down then
			return t.digDown()
		else
			t.turnTo(dir)
			return t.dig()
		end
	end)
	t.attackAlong = directionTaker(function(dir)
		if dir == direction.up then
			return t.attackUp()
		elseif dir == direction.down then
			return t.attackDown()
		else
			t.turnTo(dir)
			return t.attack()
		end
	end)
	t.detectAlong = directionTaker(function(dir)
		if dir == direction.up then
			return t.detectUp()
		elseif dir == direction.down then
			return t.detectDown()
		else
			t.turnTo(dir)
			return t.detect()
		end
	end)
end

-- Functions taking absolute positions
do
	-- allow numbers to be passed directly as well as vectors
	local vectorTaker = function(f)
		return function(x, y, z)
			if x and not y and not z then
				return f(x)
			else
				return f(vector.new(x, y, z))
			end
		end
	end

	t.moveTo = vectorTaker(function(pos)
		repeat
			local dir = direction.along(pos - t.position)
			t.moveAlong(dir)
		until not dir
	end)

	t.digTo = vectorTaker(function(pos)
		repeat
			local dir = direction.along(pos - t.position)
			if not t.moveAlong(dir) then t.digAlong(dir) end
		until not dir
	end)

	t.attackTo = vectorTaker(function(pos)
		repeat
			local dir = direction.along(pos - t.position)
			if not t.moveAlong(dir) then t.attackAlong(dir) end
		until not dir
	end)
end