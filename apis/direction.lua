local vmt = getmetatable(vector.new(0, 0, 0))

for k, v in pairs(vmt) do
	module[k] = v
end

__tostring = function(self)
	return ("%s (%s)"):format(self.name, vmt.__tostring(self))
end

vmt.__eq = function(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

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
	setmetatable(dir, module)
	module[name] = dir
end

leftOf = {
	[north] = west,
	[east ] = north,
	[south] = east,
	[west ] = south
}

rightOf = {
	[north] = east,
	[east ] = south,
	[south] = west,
	[west ] = north
}

behind = {
	[north] = south,
	[east ] = west,
	[south] = north,
	[west ] = east
}

fromCompassPoint = function(s)
	if s == 'n' or s == 'north' then
		return north
	elseif s == 's' or s == 'south' then
		return south
	elseif s == 'e' or s == 'east' then
		return east
	elseif s == 'w' or s == 'west' then
		return west
	end
end

along = function(v)
	local ax = math.abs(v.x)
	local ay = math.abs(v.y)
	local az = math.abs(v.z)

	if ax == 0 and az == 0 and ay == 0 then
		return nil
	elseif ay >= az and ay >= ax then
		return v.y > 0 and up or down
	elseif ax >= az then
		return v.x > 0 and north or south
	else
		return v.z > 0 and east or west
	end
end