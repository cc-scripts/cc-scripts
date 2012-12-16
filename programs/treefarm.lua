if not turtle then
  print("This program will only run on a turtle.")
  return
end

if turtle.getFuelLevel() == 0 then
  print("Please refuel the turtle before running this program.")
end

if turtle.getItemCount(1) == 0 then
  print("You must put the type of sapling you wish to farm in the first slot before running this program.")
  return
end

if turtle.getItemCount(2) == 0 then
  print("You must put the type of log you wish to farm in the second slot before running this program.")
  return
end

-- Attempt to refuel if under a given fuel level
function refuelAt(fuelLevel)
  local fuelRemaining = turtle.getFuelLevel()
  
  if fuelRemaining == "unlimited" then
    return true
  end
  
  if turtle.getFuelLevel() > fuelLevel then
    return true
  end

  -- Never refuel using the slots 1 and 2, which contain
  -- the type of log we're harvesting as well as the sapling
  -- we'll be replanting
  for i = 3, 16 do
    local itemsLeft = turtle.getItemSpace(i)
    
    turtle.select(i)
    if turtle.refuel(itemsLeft) then
      return true
    end
  end
end

function chopTree()
  local height = 1

  turtle.dig()
  turtle.forward()
  
  -- Dig up the trunk of the tree
  turtle.select(2)
  while turtle.compareUp() do
    turtle.digUp()
    turtle.up()
    height = height + 1
  end

  -- Return to where we started
  for i = 1, height do
    turtle.down()
  end
  
  turtle.back()
end

while true do
  print("Tree farm initiated!")
  print("This turtle will now wait for a sapling in front of it to grow!")
  print("Plant a sapling in front of the turtle and come back later to collect any wood your turtle has harvested.")
  print()
  print("To exit, press and hold CTRL+T")

  -- Wait for a sapling to grow
  turtle.select(2)
  while not turtle.compare()
    do sleep(1)
  end

  chopTree()
  refuelAt(500)

  -- Plant the next sapling to harvest
  turtle.select(1)
  turtle.place()
end
