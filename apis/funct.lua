-- API: funct
-- Source: /cc-scripts/apis/funct.lua
-- Description: A collection of useful helpers for dealing with functions.


local funct = {}
-- Coerce all arguments into an array
--
-- Useful if you're dealing with functions that give
-- a variable number of elements as their return value(s)
--
-- Example:
--   eventData = collect(os.pullEvent())
--   for i = 1, 5 do
--     print(eventData[i], " - ", type(eventData[i]))
--   end
--
--   # Results in:
--   # "key - string"
--   # "29 - number"
--   # " - nil"
--   # " - nil"
--   # " - nil"
--
-- See also: http://www.emmanueloga.com/2010/12/09/lua-select.html
--
-- Returns a Array.
function funct.collect(...)
  return {...}
end

-- Execute the provided string
--
-- Take the provided string and run it as Lua code.
--
-- Note that this function is a wrapper around Lua's `pcall`
-- method.
--
-- If successful, the return value of this method
-- will include the return value of the executed code.
--
-- In the event of a failure, the return values will
-- include an error message.
--
-- See also: http://www.lua.org/manual/5.1/manual.html#pdf-pcall
--
-- Returns an Array whos first value is a boolean
-- indicating if an error occurred when executing
-- the provided string.
function funct.exec(string)
  local method = loadstring(string)
  return pcall(method)
end

return funct
