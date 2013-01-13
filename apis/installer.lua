-- API: installer
-- Source: /cc-scripts/apis/installer.lua
-- Description: An API for installing and updating files.
local installer = {}

-- The following are utility functions for use within this API;
-- these functions are inaccessible outside of this file.

-- Returns true if a string looks like a URL (starts with http:// or https://)
local function isUrl(s)
  if string.sub(s, 1, 7) == "http://" then
    return true
  elseif string.sub(s, 1, 8) == "https://" then
    return true
  else
    return false
  end
end

-- The following are functions exposed to the `installer` API:

-- install
--
-- Take a file from `source` and copy it to `destination`.
-- If there is a file or directory at `destination`, fail
-- unless `force` is true.
--
-- If `force` is true, destination will be overwritten by
-- `source`.
--
-- Source may be one of the following:
--
--   1. A file path (/some/path/to/file)
--   2. A HTTP URL: (http://yoursite.com/path/to/file)
--   3. A HTTPS URL: (https://yoursite.com/path/to/file)
function installer.install(source, destination, force)
  local fromUrl = isUrl(source)

  -- If we're installing from a URL, ensure the HTTP API is available,
  -- otherwise just ensure our source file exists.
  if fromUrl then
    assert(http, "Attempted to install from a URL when HTTP API is disabled")
  else
    assert(fs.exists(source), "Attempted to install a file that does not exist")
  end

  -- Fail installation if our desired destination is taken and we don't
  -- want to force overwriting existing files.
  if fs.exists(destination) and force ~= true then
    return false
  end

  -- Simple install, copy the files to where they need to be.
  if fromUrl == false then
    if force == true and fs.exists(destination) then
      fs.delete(destination)
    end

    fs.copy(source, destination)
    return true
  end

  -- At this point we know we're installing from a URL and that
  -- the HTTP API is available. Let's get to it!

  -- Attempt to download our source file
  local conn = http.get(source)
  assert(conn, "Unable to download " .. source)

  local file = fs.open(destination, "w")  
  assert(file, "Unable to save " .. source .. " to " .. destination)

  file.write(conn.readAll())

  -- Clean up after ourselves and avoid leaving any open file handles
  -- or HTTP connections.
  file.close()
  conn.close()

  return true
end

return installer
