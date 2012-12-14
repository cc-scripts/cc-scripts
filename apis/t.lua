-- API: t
-- Source: /cc-scripts/apis/t.lua
-- Description: A wrapper around the `turtle` API that handles common problems
--   and pitfalls involving moving turtles and having them interact with
--   the environment.
--
--   Note that the `t` API can be treated __exactly__ like the `turtle` API.
--   Any methods not handled by `t` will be passed along to `turtle`
--
-- See also: http://computercraft.info/wiki/Turtle_(API)

t = {}

-- This is where the magic happens. Any functions not available in `t`
-- will be delegated to `turtle`.
t.setmetatable(__index, turtle)


-- Interaction
-- ===========

-- Whenever a turtle needs to move and is blocked, we call this method.
-- Turtles that can dig will attempt to dig past an obstruction,
-- turtles that can attack will try to kill anything that block their path,
-- and turtles that can do neither will sit and wait until the obstruction
-- is gone.
function t.pushOrWait()
  if turtle.dig then
    turtle.dig()
  elseif turtle.attack then
    turtle.attack()
  else
    sleep(0.5)
  end
end

function t.pushOrWaitUp()
  if turtle.digUp then
    turtle.digUp()
  elseif turtle.attackUp then
    turtle.attackUp()
  else
    sleep(0.5)
  end
end

function t.pushOrWaitDown()
  if turtle.digDown then
    turtle.digDown()
  elseif turtle.attackDown then
    turtle.attackDown()
  else
    sleep(0.5)
  end
end

-- Movement
-- ========
--
-- All movement functions function like their `turtle` counterparts, with a few
-- minor differences:
--
-- 1. When moving up(), down(), forward(), and backward() may be passed a
--    number. When a number is provided, the turtle will move that may blocks
--    in the corresponding direction.
-- 2. Turtles will attempt to clear any obstructions that prevent them from
--    moving. A Mining turtle will dig anything that falls in front of it if
--    a block is preventing it from moving forward.
-- 3. When moving backwards, a turtle will instead turn around and move in the
--    opposite direction. This allows the turtle to aggressively make it's way
--    to it's intended destination.

function t.forward(distance)
  if distance then
    assert(type(distance) == "number", "t.forward only accepts numbers")
  else
    distance = 1
  end

  local moved = false

  for i = 1, distance do
    moved = turtle.forward()
    while not moved do
      t.pushOrWait()
      moved = turtle.forward()
    end
  end

  return moved
end

function t.backward(distance)
  t.reverse()
end

function t.turnRight(times)
  if times then
    assert(type(times) == "number", "t.turnRight only accepts numbers")
  else
    times = 1
  end

  for i = 1, times do
    turtle.turnRight()
  end

  return true
end

function t.turnLeft(times)
  if times then
    assert(type(times) == "number", "t.turnRight only accepts numbers")
  else
    times = 1
  end

  for i = 1, times do
    turtle.turnLeft()
  end

  return true
end

function t.reverse()
  if math.random(0,1) > 0 then
    t.turnLeft(2)
  else
    t.turnRight(2)
  end
end
