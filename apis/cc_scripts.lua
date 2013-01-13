-- API: cc_scripts
-- Source: /cc-scripts/apis/cc_scripts.lua
-- Description: An API that provides information about the local cc-scripts installation,
--   as well as some utility functions for loading cc-scripts APIs.

-- This is where we set the current version of cc-scripts in use.
-- Reference: http://semver.org/
local VERSION = {
	major = 0,
	minor = 0,
	patch = 1,
	identifier = ""
}

function version()
	return VERSION
end

function versionString()
	local string = VERSION.major .. "." .. VERSION.minor .. "." .. VERSION.patch
	if VERSION.identifier ~= "" then string = string .. "-" .. identifier end
	return string
end

function loadAPI(name)
	os.loadAPI("/cc-scripts/apis/" .. name)
end
