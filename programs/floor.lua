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
  
  if not turtle.forward() then
    while not turtle.forward() do
      sleep(1)
    end
  end
end

-- Places a block from the provided slot beneath the turtle,
-- but only if the block beneath the turtle is different than
-- the block in slot 1 OR if the block below is empty (air or liquid).
function placeIfDifferent(slot)
  turtle.select(1)
  if not turtle.compareDown() then
    turtle.select(slot)
    turtle.placeDown()
  end
end

-- Find the first slot with the same block as
-- the one found in slot one, then place it under
-- the turtle. Always leaves at least one block in
-- slot 1.
--
-- Returns true if the turtle couple place a similar block,
-- returns false if there are no additional blocks identical
-- to the block in slot 1 to place.
function placeSimilarBlockFromInventory()
  turtle.select(1)

  -- Place excess blocks from slot 1
  -- before using any other slots
  if turtle.getItemCount(1) > 1 then
    placeIfDifferent(1)
    return true
  end

  -- Attempt to find similar blocks in other slots
  for i = 2, 16 do
    if turtle.compareTo(i) then
      placeIfDifferent(i)
      return true
    end
  end

  -- If we've gotten this far, we're out of blocks to place
  return false
end

function placeRow(length)
  for i = 1, length do
    if turtle.detectDown() then turtle.digDown() end
    placeSimilarBlockFromInventory()
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
  
  if placeRow(length) == false then
    print("Ran out of blocks to place!")
  end
end
