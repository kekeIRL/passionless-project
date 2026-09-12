local Block = {}
Block.__index = Block

function Block.new(x, y, width, height)
	local block = {
		x = x or 0,
		y = y or 0,

		width = width or 4,
		height = height or 4,

		message = love.thread.getChannel("physics"),
	}
	return setmetatable(block, Block)
end

function Block:update(player, dt)
	local sent = false
	-- right-left logic
	if player.y + player.size > self.y and player.y < self.y + self.height then
		if player.x + player.size > self.x then
			-- player is on the left: if they are doing too far right, they don't.
			if player.x < self.x then
				self.message:push({ e = "player.clip", pos = { x = self.x - player.size, y = player.y } })
				sent = true
			end
		end
		if player.x < self.x + self.width then
			-- player is on the right, same story
			if player.x + player.size > self.x + self.width then
				self.message:push({ e = "player.clip", pos = { x = self.x + self.width, y = player.y } })
				sent = true
			end
		end
	end
	-- up-down logic
	if not sent and player.x + player.size > self.x and player.x < self.x + self.width then
		if player.y < self.y and player.y + player.size + player.velocity.y * dt >= self.y then
			-- player is right on top, proceed with whatever the fuck
			self.message:push({ e = "player.grounded", pos = { x = player.x, y = self.y } })
		end
		if player.y + player.size > self.y + self.height then
			if player.y + player.velocity.y * dt < self.y + self.height then
				-- player bashed their head, reset velocity.y
				self.message:push({ e = "player.bash", pos = { x = player.x, y = self.y + self.height } })
			end
		end
	end
end

function Block:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Block
