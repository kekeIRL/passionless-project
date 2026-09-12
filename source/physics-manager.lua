local Manager = {}
Manager.__index = Manager

function Manager.new(Level)
	local manager = {
		level = Level,
		message = love.thread.getChannel("physics"),
	}
	return setmetatable(manager, Manager)
end

function Manager:update(dt)
	local event = self.message:pop()
	while event do
		if event.e == "player.grounded" then
			self.level.player.grounded = true
			self.level.player.y = event.pos.y - self.level.player.size
		elseif event.e == "player.clip" then
			self.level.player.x = event.pos.x
			self.level.player.velocity.x = 0
		elseif event.e == "player.bash" then
			self.level.player.velocity.y = 0
			self.level.player.y = event.pos.y
		end
		event = self.message:pop()
	end
end

return Manager
