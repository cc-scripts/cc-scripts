local tArgs = { ... }

if #tArgs ~= 3 then
  print("Usage: room <length> <width> <height>")
  print("Example: room 9 9 5")
  return
end

local nLength = tonumber( tArgs[1] )
local nWidth  = tonumber( tArgs[2] )
local nHeight = tonumber( tArgs[3] )

-- Detects the presence of a block in the provided direction.
--
-- Valid directions are "forward", "down", or "up".
-- Providing no direction will default to the direction "forward".
-- Providing an invalid or mistyped direction will raise an error.
--
-- Returns a boolean (true or false).
--
-- Examples:
--
--   detect("up")      --> true
--   detect()          --> true
--   detect("invalid") --> error
function detect(direction)
  local tDetectDirections = {
    forward = turtle.detect,
    down    = turtle.detectDown,
    up      = turtle.detectUp
  }

  if type(direction) == "nil" then
    -- default to detecting the block in front of us
    fDetect = tDetectDirections["forward"]
  elseif type(tDetectDirections[direction]) == "nil" then
    -- raise an error when provided an invalid direction
    error("Invalid direction passed to detect(), valid directions are 'forward', 'up', or 'down'")
  else
    fDetect = tDetectDirections[direction]
  end

  return fDetect()
end

-- Digs a number of blocks in the provided direction.
--
-- Valid directions are "forward", "down", or "up".
-- Providing no direction will default to the direction "forward".
-- Providing an invalid or mistyped direction will raise an error.
--
-- Paramaters:
--
--  * distance (number, optional, default: 1)
--    The number of blocks to dig
--
--  * direction (string, optional, default: "forward")
--    The direction in which to dig. If provided, must be
--    one of "forward", "up", or "down". 
--
-- Returns a boolean (true or false).
--
-- Examples:
--
--   dig()          --> dig forward one block
--   dig(3)         --> dig forward three blocks
--   dig("up")      --> dig up one block
--   dig("down", 3) --> dig down three blocks
--   dig(5, "up")   --> dig up five blocks
function dig(...)
  local tArgs = {...}

  if #tArgs > 2 then
    error("Too many arguments passed to dig() (min 0, max 2)")
  end

  local tDigDirections = {
    forward = turtle.dig,
    down    = turtle.digDown,
    up      = turtle.digUp
  }

  -- Determine if we were provided a distance,
  -- a direction, or both. Additionally,
  -- figure out what order they were provided in.
  local nDistance  = 1         -- default to 1 block
  local sDirection = "forward" -- default to forward

  -- detect distance
  if type(tArgs[1]) == "number" then
    nDistance = tArgs[1]
  else
    nDistance = tArgs[2] or nDistance
  end

  -- detect direction
  if type(tArgs[1]) == "string" then
    sDirection = tArgs[1]
  else
    sDirection = tArgs[2] or sDirection
  end

  -- Ensure we have a valid distance
  if not (nDistance > 0) then
    error("Invalid distance passed to dig(), distance must be a number greater than 0")
  end

  -- Ensure we have a valid direction
  if type(tDigDirections[sDirection]) ~= "function" then
    error("Invalid direction passed to dig(), valid directions are 'forward', 'up', or 'down'")
  end

  -- Pull the out dig function we want and
  -- reference it with fDig()
  local fDig = tDigDirections[sDirection]

  local bSuccess = false

  for _ = 1, nDistance do
    -- if there is a block in direction we're going
    if detect(direction) then
      -- attempt to break the block, throw an error
      -- if we fail
      if fDig() == false then
        -- We ran into something we can't dig, possibly
        -- bedrock, a protected block, or a mod block.
        error("Encountered an un-diggable block")
      end
    end

    -- Wait a bit to see if digging caused blocks
    -- around the block we dug to move around.
    -- This can happen if we're dealing with sand,
    -- gravel, or anvils.
    sleep(0.5)

    -- If something fell in our way...
    while detect(direction) do
      -- keep digging until the way is clear.
      fDig()
      -- Give blocks time to fall before we continue
      sleep(0.5)
    end

    -- Nothing there, we have succeeded!
    bSuccess = true
  end

  return bSuccess
end
