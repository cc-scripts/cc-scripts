local autorefuel = {}

local patcher = cc_scripts.api.load('turtlepatcher')

local userrefueler = function()
	while true do
		term.write("Out of fuel. Refuel from which slot? ")
		local s = tonumber(read())
		if not pcall(turtle.select, s) then
			print("Invalid slot")
		elseif turtle.refuel() then
			return true
		else
			print("Could not refuel")
		end
	end
end

local handler = userrefueler

autorefuel.custom = function(h)
	handler = h
end
autorefuel.fromSlot = function(s)
	handler = function()
		turtle.select(s)
		local refueled = turtle.refuel(s)
		-- TODO: restore slot
		return refueled
	end
end
autorefuel.withPrompt = function()
	handler = userrefueler
end

-- patch all turtle movements to run the handler
do
	local patchmove = function(name)
		-- patch the move function
		patcher[name] = function(old_f, ...)
			local success = old_f(...)
			-- if it fails to move due to fuel problems
			if not success and turtle.getFuelLevel() == 0 then
				-- try to refuel
				local refueled = handler()
				if refueled then
					-- and move again if we succeed
					return old_f(...)
				end
			end
		end
	end
	
	patchmove('up')
	patchmove('dpwn')
	patchmove('forward')
	patchmove('back')
end

return autorefuel
