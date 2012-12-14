-- Name: startup
-- Source: /cc-scripts/programs/startup.lua
-- A simple startup script that adds cc-scripts to the load path.

-- These are additional paths that will be searched when you enter
-- a program name into your in-game computer
--
-- See also: http://en.wikipedia.org/wiki/Path_(computing)
pathsToLoad = {
  "/cc-scripts/apis",
  "/cc-scripts/programs"
}

path = shell.path()
shell.setPath(path .. ":/cc-scripts/apis:/cc-scripts/programs")
