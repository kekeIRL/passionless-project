local Manager = {}
Manager.__index = Manager

function Manager.new(Level)
	local manager = {
		level = Level,
		message = love.thread.getChannel("event"),
	}
	return setmetatable(manager, Manager)
end

function Manager:update(dt)
	local event = self.message:pop()
	while event do
		if event.e == "player.dead" then
			self.level.player:die()
		end
		event = self.message:pop()
	end
end

return Manager
