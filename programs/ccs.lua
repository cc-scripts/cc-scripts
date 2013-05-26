-- Name: ccs
-- Source: /cc-scripts/programs/ccs.lua
-- A script to manage cc-script packages.

-- update | install
local subCommand = select(1, ...)
-- api | program
local codeType = select(2, ...)
-- {"room", "dig", ...}
local names = {select(3, ...)}

if not subCommand or codeType and #names == 0 or
   (codeType and codeType ~= "program" and codeType ~= "api") then
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

-- Update one or more named programs or apis
function update(codeType, names)
  if codeType == "api" then
    for _, api in ipairs(names) do
      cc_scripts.download(
        cc_scripts.api.webPath(api),
        cc_scripts.api.path(api)
      )
      print("Updated " .. api)
    end
  elseif codeType == "program" then
    for _, program in ipairs(names) do
      cc_scripts.download(
        cc_scripts.program.webPath(program),
        cc_scripts.program.path(program)
      )
      print("Updated " .. program)
    end
  end
end

-- Update ALL apis, programs, and associated files
function updateAll()
  local apis = fs.list("/cc-scripts/apis")
  local programs = fs.list("/cc-scripts/programs")

  for _, api in ipairs(apis) do
    cc_scripts.download(
      cc_scripts.api.webPath(api),
      cc_scripts.api.path(api)
    )
  end

  for _, program in ipairs(programs) do
    cc_scripts.download(
      cc_scripts.program.webPath(program),
      cc_scripts.program.path(program)
    )
  end

  print("Updated all programs and apis")
end

-- "css update ..."
if subCommand == "update" then
  if not codeType then
    updateAll()
  else
    update(codeType, names)
  end
end

if subCommand == "install" then
  for _, name in ipairs(names) do
    local path, webPath
    if codeType == "api" then
      webPath = cc_scripts.api.webPath(name)
      path = cc_scripts.api.path(name)
    elseif codeType == "program" then
      webPath = cc_scripts.program.webPath(name)
      path = cc_scripts.program.path(name)
    end
    if fs.exists(path) then
      print(("%s %q is already installed!"):format(codeType, name))
      print(("Try running: ccs update %s %s"):format(codeType, name))
    else
      cc_scripts.download(webPath, path)
      print(("Successfully installed %s %q"):format(codeType, name))
    end
  end
end
