--[[
Description:
  moves the bot by either an absolute direction or absolute position. Requires
  the turtletracker to be loaded. Will wait for its path to be cleared.

Usage:
  move <n[orth]|e[ast]|s[outh]|w[est]|up|down>
  move to <x> <y> <z>
]]
cc_scripts.api.load('turtletracker')

local args = {...}
if #args == 1 then
	turtle.moveAlong(args[1])
elseif args[1] == 'to' then
	turtle.moveTo(
		tonumber(args[2]),
		tonumber(args[3]),
		tonumber(args[4])
	)
end
