--[[
An improved API loader that doesn't break closures
This allows APIs to declare properties and modify their own metatable, since
instead of copying members from the function environment to the API object,
it actually uses the same table for both

Simply add `os.loadAPI('betterAPI')` to the top of your main script to make
this work (including it in the api itself is too late).

This should maybe be added in a startup script or something.
]]
LOADING = {}
_G.apis = {}
function os.loadAPI(_sPath)
  -- load the name
	local sName = fs.getName(_sPath)
	if _G.apis[sName] == LOADING then
		printError("API "..sName.." is currently loading")
		return false
	elseif _G.apis[sName] then
		printError("API "..sName.." is already loaded")
		return false
	end

	-- mark it as loading using our sentinel value
	_G.apis[sName] = LOADING
		
	-- set up a function environment with access to _G
	local tAPI = setmetatable({}, { __index = _G })
	local fnAPI, err = loadfile(_sPath)
	if fnAPI then
		setfenv(fnAPI, tAPI)()
	else
		printError(err)
		tAPIsLoading[sName] = nil
		return false
	end
	
	-- put it in the apis table for easy iteration
	_G[sName] = tAPI
	_G.apis[sName] = tAPI
	return true
end

function os.unloadAPI(_sName)
	if _G.apis[_sName] then
		_G[_sName] = nil
		_G.apis[_sName] = nil
	end
end