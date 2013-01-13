--[[
Description:
  Makes the bot dig in an absolute direction or dig to an absolute position.
  Requires the turtletracker to be loaded. Will dig if a block is in the way,
  else will wait for mobs to clear off

Usage:
  dig <n[orth]|e[ast]|s[outh]|w[est]|up|down>
  dig to <x> <y> <z>
]]

cc_scripts.loadAPI('turtletracker')

local args = {...}
if #args == 1 then
	turtle.digAlong(args[1])
elseif args[1] == 'to' then
	turtle.digTo(
		tonumber(args[2]),
		tonumber(args[3]),
		tonumber(args[4])
	)
end