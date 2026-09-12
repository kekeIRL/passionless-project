local Spike = {}
Spike.__index = Spike

function Spike.new(x, y, width, height)
	local spike = {
		x = x,
		y = y,
		width = width or 10,
		height = height or 10,

		message = love.thread.getChannel("event"),
	}
	return setmetatable(spike, Spike)
end

function Spike:update(player)
	if player.x < self.x + self.width and player.x + player.size > self.x then
		if player.y + player.size > self.y and player.y < self.y + self.height then
			self.message:push({ e = "player.dead", pos = { x = player.x, y = player.y } })
		end
	end
end

function Spike:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return Spike
