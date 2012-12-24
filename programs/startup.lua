-- Name: startup
-- Source: /cc-scripts/programs/startup.lua
-- A simple startup script that adds cc-scripts to the load path.

-- These are additional paths that will be searched when you enter
-- a program name into your in-game computer
--
-- See also: http://en.wikipedia.org/wiki/Path_(computing)
local pathsToLoad = {
  "/cc-scripts/apis",
  "/cc-scripts/programs"
}

local path = shell.path()
shell.setPath(path .. ":/cc-scripts/apis:/cc-scripts/programs")

-- Print the version of cc-scripts in use on startup
print("cc-scripts v" .. cc_scripts.versionString())
