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

-- Build the module to export
local cc_scripts = {}

-- String/table duality on the version
cc_scripts.version = setmetatable({
	major = 0,
	minor = 0,
	patch = 1,
	identifier = ""
}, {__tostring = stringifyVersion})

-- Api management
do
	local _apis = {}

	-- return the API with a certain name
	cc_scripts.loadAPI = function(name)
		local localPath = "/cc-scripts/apis/"..name
		if __ccsForceReload or not fs.exists(localPath) then
			-- Get the file from the server
			-- ...
		end
		if not _apis[name] then
			-- Api not yet loaded - execute it
			local api = dofile(localPath) or {}
			-- Cache it
			_apis[name] = api
		end
		return _apis[name]
	end
end

return cc_scripts
