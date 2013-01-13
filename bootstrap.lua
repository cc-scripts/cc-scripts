-- Name: bootstrap
-- Source: /cc-scripts/bootstrap.lua
-- The cc-scripts installer.

-- First thing's first: save the installer to root of the current
-- computer. We want the user to be able to resume this process
-- if the install fails.
local repoUrl = "https://raw.github.com/damien/cc-scripts/master/"

fs.makeDir("/cc-scripts")
bootstrap = fs.open("/cc-scripts/bootstrap", "w")
bootstrapConnection = http.get(repoUrl .. "bootstrap.lua")

assert(bootstrap, "Unable to save installer to disk! Please make sure your in-game computer has space available and try again!")
assert(bootstrapConnection, "Unable to download installer components! Is your internet working? See if you can access "..repoUrl.."bootstrap.lua")

bootstrap.write(bootstrapConnection.readAll())
bootstrapConnection.close()
bootstrap.close()

-- A manifest of all the APIs and programs the installer will include
-- by default.
apis = {
  "cc_scripts",
  "installer"
}

programs = {
  "ccs",
  "floor",
  "room",
  "shaft",
  "startup",
  "treefarm"
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
print("A total of " .. #apis .. " apis and " .. #programs .. " programs will be installed.")

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
  print("/cc-scripts/bootstrap")
  print()
  print("If you'd like to remove cc-scripts,")
  print("simply delete /cc-scripts")
  return
end

-- Install all the things!
--
-- This is pretty much just a selective copy from the latest
-- code on Github.
function install(path)
  local url = repoUrl  .. path .. ".lua"
  local installPath = "/cc-scripts/" .. path
  local updated = fs.exists(installPath)

  print("Downloading " .. path .. " ...")
  local conn = http.get(repoUrl .. path .. ".lua")
  local file = fs.open(installPath, "w")

  assert(conn, "Unable to download " .. path .. " - aborting!")
  assert(file, "Unable to save " .. path .. " to " .. installPath .. " - aborting!")

  file.write(conn.readAll())

  file.close()
  conn.close()

  if updated then
    print("Updated " .. path)
  else
    print("Installed " .. path)
  end
end

function configureStartup()
  local hadStartup = fs.exists("/startup")

  -- Clobber any previous startup script
  if hadStartup then
    fs.delete("/startup")
  end

  fs.copy("/cc-scripts/programs/startup", "/startup")
end

nextScreen()
print("Starting installation...")
print()
-- Install all our APIs
fs.makeDir("/cc-scripts/apis")
for i = 1, #apis do
  install("apis/"..apis[i])
end

-- Install all of our programs
fs.makeDir("/cc-scripts/programs")
for i = 1, #programs do
  install("programs/"..programs[i])
end

-- Install the startup script, this ensures that
-- all the newly installed scripts and apis are
-- immidiately available
configureStartup()

print()
print("Installation completed! Enjoy cc-scripts!")
print()
print("Your computer will reboot in 3 seconds!")
sleep(3)
os.reboot()
