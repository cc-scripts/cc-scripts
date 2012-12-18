local tArgs = {...}

if #tArgs ~= 1 then
  print("Usage: shaft <length>")
  print("Note: If length isn't an even number, it will be rounded up.")
  return
end

local length = tonumber( tArgs[1] )

-- We dig columns 2 at a time,
-- so we only need to count up
-- to half the desired length
if length % 2 ~= 0 then
  length = (length + 1) /2
else
  length = length / 2
end

function dig()
  while turtle.detect() do
    turtle.dig()
    sleep(0.5)
  end
end

function digUp()
  while turtle.detectUp() do
    turtle.digUp()
    sleep(0.5)
  end
end

function digDown()
  turtle.digDown()
end

function digColumnUp(height)
  dig()
  turtle.forward()
  
  for i = 1, height do
    dig()
    if i ~= height then digUp() end
    turtle.up()
  end
end

function digColumnDown(height)
  dig()
  turtle.forward()
  
  for i = 1, height do
    dig()
    if i~= height then digDown() end
    turtle.down()
  end
end

for distance = 1, length do
  if distance % 2 == 1 then
    digColumnUp(4)
  else
    digColumnDown(4)
  end
  
  dig()
  turtle.forward()
end

-- Return to our starting position
turtle.turnLeft()
turtle.turnLeft()
for i=1, (length * 2) do
  if not turtle.forward() then
    while not turtle.forward() do
      sleep(0.5)
    end
  end

  if length % 2 ~= 0 then
    for i = 1, 4 do turtle.down() end
  end
end
