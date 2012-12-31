local tArgs = { ... }

if #tArgs ~= 2 then
  print("Usage: floor <length> <width>")
  return
end

local length = tonumber( tArgs[1] )
local width  = tonumber( tArgs[2] )

function forward()
  while turtle.detect() do
    turtle.dig()
    sleep(0.5)
  end
  
  turtle.forward()
end

function placeItemFromInventory()
  for i = 1, 16 do
    local itemCount = turtle.getItemCount(i)

    if itemCount > 0 then
      turtle.select(i)
      turtle.placeDown()
      return true
    end
  end

  -- No items to place
  return false
end

function placeRow(length)
  for i = 1, length do
    if turtle.detectDown() then turtle.digDown() end
    placeItemFromInventory()
    if i ~= length then forward() end
  end
end

for currentWidth = 1, width do
  if currentWidth == 1 then
    forward()
  else
    if currentWidth % 2 == 0 then
      turtle.turnRight()
      forward()
      turtle.turnRight()
    else
      turtle.turnLeft()
      forward()
      turtle.turnLeft()
    end
  end
  
  placeRow(length)
end
