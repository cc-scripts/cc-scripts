--[[
Description:
  Used to get the absolute position of the bot, or to define it

Usage:
  direction
  direction <n[orth]|e[ast]|s[outh]|w[est]|up|down>
]]
local args = {...}
if #args == 1 then
	dir = direction.fromCompassPoint(args[1])
	if dir then
		turtle.orientation = dir
	else
		printError("Invalid orientation")
	end
else
	print(turtle.orientation)
end
