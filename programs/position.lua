--[[
Description:
  Used to get the absolute position of the bot, or to define it

Usage:
  position
  position <x> <y> <z>
]]

if not turtle.position then
  os.loadAPI('cc-scripts/apis/betterapi.lua')
  os.loadAPI('turtletracker.lua')
end
local args = {...}
if #args == 3 then
  turtle.position = vector.new(
    tonumber(args[1]),
    tonumber(args[2]),
    tonumber(args[3])
  )
else
  print(turtle.position)
end
