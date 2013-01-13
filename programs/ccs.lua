-- Name: ccs
-- Source: /cc-scripts/programs/ccs.lua
-- A script to manage cc-script packages.
local installer = cc_scripts.loadAPI("installer")

local tArgs = { ... }

if #tArgs == 0 then
  print("Usage: ccs update [[api|program] NAME]")
  print()
  print("Examples:")
  print("  Install a program from cc-scripts:")
  print("    ccs install program room")
  print()
  print("  Install an api from cc-scripts:")
  print("    ccs install api turtletracker")
  print()
  print("  Update all programs and apis:")
  print("    ccs update")
  print()
  print("  Update the 'room' program:")
  print("    ccs update program room")
  print()
  print("  Update the 'events' api:")
  print("    ccs update api events")
  print()
end

-- Pull a script down from the cc-scripts repository and put it on the local computer.
function install(path, force)
  local url = "https://raw.github.com/damien/cc-scripts/master/" .. path .. ".lua"
  local installPath = "/cc-scripts/" .. path
  return installer.install(url, installPath, force)
end

-- Update one or more named programs or apis
function update(updateArguments)
  local path = ""

  if updateArguments[1] == "api" then
    path = "apis/"
  elseif updateArguments[1] == "program" then
    path = "programs/"
  end

  -- Update each named api or program
  for i = 2, #updateArguments do
    install(path .. updateArguments[i], true)
    print("Updated " .. updateArguments[i])
  end
end

-- Update ALL apis, programs, and associated files
function updateAll()
  local apis = fs.list("/cc-scripts/apis")
  local programs = fs.list("/cc-scripts/programs")

  for _, api in ipairs(apis) do
    install("apis/" .. api, true)
  end

  for _, program in ipairs(programs) do
    install("programs/" .. program, true)
  end

  print("Updated all programs and apis")
end

-- ie: "update"
local subCommand = tArgs[1]

-- ie: "program", "room"
local subCommandArgs = {}

-- Stick all arguments after the first one into
-- the subCommandArgs table.
if #tArgs > 1 then
  for i = 2, #tArgs do
    table.insert(subCommandArgs, tArgs[i])
  end
end

-- "css update ..."
if subCommand == "update" then
  if #tArgs == 1 then
    updateAll()
  else
    update(subCommandArgs)
  end
end

if subCommand == "install" then
  if #subCommandArgs > 2 then
    print("You may only install one item at a time.")
    return
  end

  local path = ""
  if subCommandArgs[1] == "api" then
    path = "apis/"
  elseif subCommandArgs[1] == "program" then
    path = "programs/"
  else
    print("Invalid subcommand '" .. subCommandArgs[1] .. "'")
    print("Valid subcommands are 'install' and 'update'")
    return
  end

  if install(path .. subCommandArgs[2]) then
    print("Successfully installed " .. subCommandArgs[2] .. " " .. subCommandArgs[1])
  else
    print(subCommandArgs[2] .. " " .. subCommandArgs[1] .. " is already installed!")
    print("Try running: ccs update " .. subCommandArgs[1] .. " " .. subCommandArgs[2])
  end
end
