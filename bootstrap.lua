-- Name: bootstrap
-- Source: /cc-scripts/bootstrap.lua
-- The cc-scripts installer.

-- First thing's first: save the installer to root of the current
-- computer. We want the user to be able to resume this process
-- if the install fails.
local repoUrl = "https://raw.github.com/damien/cc-scripts/master/"
local installRoot = "/cc-scripts/"
local exit = (...) or function() end

fs.makeDir("/cc-scripts")
bootstrap = fs.open(installRoot.."bootstrap", "w")
bootstrapConnection = http.get(repoUrl .. "bootstrap.lua")

assert(bootstrap, "Unable to save installer to disk! Please make sure your in-game computer has space available and try again!")
assert(bootstrapConnection, "Unable to download installer components! Is your internet working? See if you can access "..repoUrl.."bootstrap.lua")

bootstrap.write(bootstrapConnection.readAll())
bootstrapConnection.close()
bootstrap.close()

-- A manifest of all the  programs the installer will include
-- by default.
programs = {
  "floor",
  "room",
  "shaft",
  "startup",
  "treefarm",
  "ccs"
}

-- Clear the screen and reset the cursor position
function nextScreen()
  term.clear()
  term.setCursorPos(1,1)
end

-- Splash screen
nextScreen()
print("cc-scripts installer has been initialized!")
sleep(1)
nextScreen()

-- Show the user what's going to be installed
print("A total of " .. #programs .. " programs will be installed.")

-- Give the user the option to opt-out before we start
-- installing stuff
print()
print("Type 'yes' and hit return to continue,")
print("enter anything else to abort:")

if read() ~= "yes" then
  nextScreen()
  print("You have exited the cc-scripts installer!")
  print()
  print("You can run the installer again from")
  print(installRoot.."bootstrap")
  print()
  print("If you'd like to remove cc-scripts,")
  print("simply delete /cc-scripts")
  return
end
nextScreen()
print("Starting installation...")


print("  Downloading core")
local code
do
  local req = http.get(repoUrl.."apis/cc_scripts.lua")
  if not req then error("Could not download core code") end
  code = req.readAll()
  req.close()
end
cc_scripts = loadstring(code)()
cc_scripts.webRoot = repoUrl
cc_scripts.installRoot = installRoot

print("  Making directories")
do
  fs.makeDir(cc_scripts.api.path(''))
  fs.makeDir(cc_scripts.program.path(''))
  local f = fs.open(cc_scripts.api.path('cc_scripts'), 'w')
  f.write(code)
  f.close()
end

print("  Downloading programs")
for _, program in ipairs(programs) do
  cc_scripts.download(
    cc_scripts.program.webPath(program),
    cc_scripts.program.path(program)
  )
  print(("    %s"):format(program))
end

print("  Configuring startup")
do
  -- put the install paths in the startup script
  local f = fs.open(cc_scripts.program.path("startup"), "a")
  f.write(([[

cc_scripts.webRoot = %q
cc_scripts.installRoot = %q
]]):format(cc_scripts.webRoot, cc_scripts.installRoot))
  f.close()

  local hadStartup = fs.exists("/startup")

  -- Clobber any previous startup script
  if hadStartup then
    fs.delete("/startup")
  end

  fs.copy(cc_scripts.program.path("startup"), "/startup")
end

-- Install the startup script, this ensures that
-- all the newly installed scripts and apis are
-- immidiately available

print()
print("Installation completed! Enjoy!")
print("Run ccs to change the installation")
print()

-- configure the path
os.run(getfenv(3), cc_scripts.program.path("startup"))

-- close the lua shell
exit()
