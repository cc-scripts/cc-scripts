--[[
This module monkeypatches the turtle API to include dead-reckoning - every move
command will update turtle.position or turtle.location
]]

os.loadAPI('apis/direction.lua')

-- Returns a wrapped function that calls a handler with the result
-- before returning
local intercept = function(f, oninvoked)
    return function(...)
        local ret = f(...)
        oninvoked(ret)
        return ret
    end
end

-- Wrap all the movement functions to keep track of position
local t = turtle
t.position = vector.new(0, 0, 0)
t.orientation = direction.north
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
	if success then	t.position = t.position - direction.down end
end)
t.turnLeft = intercept(t.turnLeft, function(success)
	if success then t.orientation = direction.leftOf[t.orientation] end
end)
t.turnRight = intercept(t.turnRight, function(success)
	if success then t.orientation = direction.RightOf[t.orientation] end
end)