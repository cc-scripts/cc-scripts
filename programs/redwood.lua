local ItemSet = cc_scripts.api.load('itemset')

local items = ItemSet.new {bonemeal=16, sapling=14, leaves=13, log=2, charcoal=1}

local function tryRefuel()
  if turtle.getFuelLevel() < 1 then
		turtle.select(1)
		turtle.refuel()
	end
end

local function placeSaplings()
	local success = true
	turtle.forward()
	turtle.forward()
	turtle.turnLeft()
	success = success and items:place('sapling')

	turtle.turnRight()
	turtle.back()
	turtle.turnLeft()
	success = success and items:place('sapling')

	turtle.turnRight()
	success = success and items:place('sapling')

	turtle.back()
	success = success and items:place('sapling')

	assert(success, "Could not plant saplings")
end

local function growTree()
	for i = 1, 3 do
		if items:place('bonemeal') then return end
	end
	error('Could not grow tree')
end



placeSaplings()
growTree()

turtle.dig()
turtle.forward()
local h = 0

-- go up
while true do
	if turtle.detect() then
		turtle.dig()
	end
	if turtle.detectUp() then
		turtle.digUp()
		turtle.up()
	else
		break
	end
	tryRefuel()
	h = h + 1
end

-- move across
turtle.turnLeft()
turtle.dig()
turtle.forward()
turtle.turnRight()
turtle.dig()

-- go down
while h > 0 do
	turtle.select(2)
	if turtle.detectDown() then
		turtle.digDown()
	end
	turtle.down()
	if turtle.detect() then
		turtle.dig()
	end
	tryRefuel()
	h = h - 1
end

turtle.back()
turtle.turnRight()
turtle.back()
items:dropDown('log')
turtle.forward()
turtle.forward()
turtle.turnLeft()
