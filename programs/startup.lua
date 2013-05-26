-- Name: startup
-- Source: /cc-scripts/programs/startup.lua
-- A simple startup script that adds cc-scripts to the load path.

-- These are additional paths that will be searched when you enter
-- a program name into your in-game computer
--
-- See also: http://en.wikipedia.org/wiki/Path_(computing)
local path = shell.path()
shell.setPath(path .. ":/cc-scripts/programs")

-- While we did set the load path, we can't take advantage of
-- it while this file is being parsed, so we need to reference
-- the cc_scripts API using it's full file path.
cc_scripts = dofile("/cc-scripts/apis/cc_scripts")

-- Print the version of cc-scripts in use on startup
print("cc-scripts v" .. tostring(cc_scripts.version))
