local turtlepatcher = {}

-- builds a handler which fires after executing the method
local _afterpatcher = function(handler)
	return function(old_f, ...)
		local ret = old_f(...)
		handler(ret, ...)
		return ret
	end
end
-- builds a handler which fires before executing the method
local _beforepatcher = function(handler)
	return function(old_f, ...)
		local ret = handler(...)
		if ret ~= nil then
			return ret
		else
			return old_f(...)
		end
	end
end

setmetatable(turtlepatcher, {
	__index = function(_, prop)
		return setmetatable({}, {
			__newindex = function(_, mode, handler)
				if mode == 'after' then
					turtlepatcher[prop] = _afterpatcher(handler)
				elseif mode == 'before' then
					turtlepatcher[prop] = _beforepatcher(handler)
				end
			end
		})
	end,
	__newindex = function(_, prop, f)
		local old_f = turtle[prop]
		turtle[prop] = function(...)
			return f(old_f, ...)
		end
	end
})

return turtlepatcher
