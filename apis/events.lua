-- API: events
-- Source: /cc-scripts/apis/events.lua
-- Some syntactic sugar to take the pain out of `os.pullEvent`.

local events = {}
function events.listen()
  while true do
    os.pullEvent()
  end
end

function events.terminate()
  error()
  print("Terminated")
end

return events
