-- API: cc_scripts
-- Source: /cc-scripts/apis/cc_scripts.lua
-- Description: An API that provides information about the local cc-scripts installation,
--   as well as some utility functions for loading cc-scripts APIs.

-- This is where we set the current version of cc-scripts in use.
-- Reference: http://semver.org/

-- Take a version table and stringify it
local function stringifyVersion(v)
	if v.identifier and v.identifier ~= "" then
		return ("%s.%s.%s-%s"):format(v.major, v.minor, v.patch, v.identifier)
	else
		return ("%s.%s.%s"):format(v.major, v.minor, v.patch)
	end
end

-- String/table duality on the version
version = setmetatable({
	major = 0,
	minor = 0,
	patch = 1,
	identifier = ""
}, {__tostring = stringifyVersion})



function loadAPI(name)
	os.loadAPI("/cc-scripts/apis/" .. name)
end
