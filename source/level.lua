local Level = {}
Level.__index = Level

function Level.new(objects, player, start, size, name)
	local level = {
		objects = objects,
		player = player,
		size = size or 64,

		start = start or { x = 0, y = 0 },
		name = name or "debug",
	}
	return setmetatable(level, Level)
end

function Level:restart()
	self.player.x = self.start.x
	self.player.y = self.start.y
	love.thread.getChannel("physics"):clear()
	love.thread.getChannel("event"):clear()
end

function Level:update(dt)
	self.player:update(dt)
	for _, o in ipairs(self.objects) do
		o:update(self.player, dt)
	end

	if not self.player.alive then
		self.player.alive = true
		self.player.x = self.start.x
		self.player.y = self.start.y
	end
end

function Level:draw()
	for _, o in ipairs(self.objects) do
		o:draw()
	end
	self.player:draw()
end

return Level
