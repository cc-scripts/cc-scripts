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

-- Configure directions - set by startup script, defined by bootloader
cc_scripts.webRoot = nil
cc_scripts.installRoot = nil

-- String/table duality on the version
cc_scripts.version = setmetatable({
	major = 0,
	minor = 0,
	patch = 1,
	identifier = ""
}, {__tostring = stringifyVersion})

-- Download a file
function cc_scripts.download(from, to)
	if not http then error("No HTTP API") end
	local conn = http.get(from)
	if conn then
		local file = fs.open(to, "w")
		if file then
			file.write(conn.readAll())
			file.close()
		end
		conn.close()
		if not file then
			error(("Could not create destination file %q"):format(to))
		end
	else error(("Could not reach %q"):format(from)) end
end

-- Api management
cc_scripts.api = {}
do
	local _apis = {}
	function cc_scripts.api.path(name)
		return cc_scripts.installRoot.."apis/"..name
	end
	function cc_scripts.api.webPath(name)
		return cc_scripts.webRoot.."apis/"..name..'.lua'
	end

	local __tostring = function(api)
		return ("<api '%s'>"):format(api.__name)
	end

	-- return the API with a certain name
	cc_scripts.loadAPI = function(name)
		local localPath = cc_scripts.api.path(name)
		if __ccsForceReload or not fs.exists(localPath) then
			-- Get the file from the server
			local webPath = cc_scripts.api.webPath(name)
			print(("Downloading api %q..."):format(name))
			cc_scripts.download(webPath, localPath)
		end
		if not _apis[name] then
			-- Api not yet loaded - execute it
			local api = dofile(localPath) or {}

			-- And wrap it to make it stringify
			local mt = getmetatable(api)
			if not mt then
				api.__name = name
				setmetatable(api, {__tostring = __tostring})
			elseif not mt.__tostring then
				api.__name = name
				mt.__tostring = __tostring
			end

			-- Cache it
			_apis[name] = api
		end
		return _apis[name]
	end
end

-- programs
cc_scripts.program = {}
do
	function cc_scripts.program.path(name)
		return cc_scripts.installRoot.."programs/"..name
	end
	function cc_scripts.program.webPath(name)
		return cc_scripts.webRoot.."programs/"..name..'.lua'
	end
end


return cc_scripts
