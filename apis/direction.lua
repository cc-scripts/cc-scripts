-- get and patch the vector metatable
local vmt = getmetatable(vector.new(0, 0, 0))
vmt.__eq = function(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

-- copy that metatable to direction
local direction = {}
for k, v in pairs(vmt) do
	direction[k] = v
end
direction.__tostring = function(self)
	return ("%s (%s)"):format(self.name, vmt.__tostring(self))
end

-- declare and process cardinal directions
local dirs = {
	north = vector.new( 1,  0,  0),
	east  = vector.new( 0,  0,  1),
	south = vector.new(-1,  0,  0),
	west  = vector.new( 0,  0, -1),
	up    = vector.new( 0,  1,  0),
	down  = vector.new( 0, -1,  0)
}
for name, dir in pairs(dirs) do
	dir.name = name
	setmetatable(dir, direction)
	direction[name] = dir
end

direction.leftOf = {
	[direction.north] = direction.west,
	[direction.east ] = direction.north,
	[direction.south] = direction.east,
	[direction.west ] = direction.south
}

direction.rightOf = {
	[direction.north] = direction.east,
	[direction.east ] = direction.south,
	[direction.south] = direction.west,
	[direction.west ] = direction.north
}

direction.behind = {
	[direction.north] = direction.south,
	[direction.east ] = direction.west,
	[direction.south] = direction.north,
	[direction.west ] = direction.east
}

function direction.fromCompassPoint(s)
	if s == 'n' or s == 'north' then
		return direction.north
	elseif s == 's' or s == 'south' then
		return direction.south
	elseif s == 'e' or s == 'east' then
		return direction.east
	elseif s == 'w' or s == 'west' then
		return direction.west
	end
end

function direction.along(v)
	local ax = math.abs(v.x)
	local ay = math.abs(v.y)
	local az = math.abs(v.z)

	if ax == 0 and az == 0 and ay == 0 then
		return nil
	elseif ay >= az and ay >= ax then
		return v.y > 0 and direction.up or direction.down
	elseif ax >= az then
		return v.x > 0 and direction.north or direction.south
	else
		return v.z > 0 and direction.east or direction.west
	end
end

return direction
