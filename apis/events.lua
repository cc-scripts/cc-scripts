-- API: events
-- Source: /cc-scripts/apis/events.lua
-- Some syntactic sugar to take the pain out of `os.pullEvent`.

function listen()
  while true do
    os.pullEvent()
  end
end

function terminate()
  error()
  print("Terminated")
end