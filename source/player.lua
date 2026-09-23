local Player = {}
Player.__index = Player

function Player.new(x, y, size, sprite)
	local player = {
		x = x or 0,
		y = y or 0,
		size = size or 2,
		velocity = { x = 0, y = 0 },

		jumps = 2,
		accel = 2,
		speed = 100,
		vspeed = 300,

		alive = true,
		grounded = false,
		lastframejump = false,

		sprite = sprite,
	}
	return setmetatable(player, Player)
end

function Player:jump()
	if self.jumps > 0 then
		self.velocity.y = -self.vspeed
		self.jumps = self.jumps - 1
		self.grounded = false
	end
end

function Player:die()
	self.alive = false
end

function Player:update(dt)
	if self.grounded then
		self.jumps = 2
		self.velocity.y = 0
	else
		if self.jumps == 2 then
			self.jumps = 1
		end

		self.velocity.y = self.velocity.y + self.vspeed * self.accel * dt
	end
	if self.velocity.y > self.vspeed then
		self.velocity.y = self.vspeed
	end

	if love.keyboard.isDown("a") then
		self.velocity.x = -self.speed
	elseif love.keyboard.isDown("d") then
		self.velocity.x = self.speed
	else
		self.velocity.x = 0
	end

	if love.keyboard.isDown("space") and not self.lastframejump then
		self:jump()
		self.lastframejump = true
	elseif not love.keyboard.isDown("space") then
		self.lastframejump = false
	end

	self.grounded = false
	self.x = self.x + dt * self.velocity.x
	self.y = self.y + dt * self.velocity.y
end

function Player:draw(scale)
	love.graphics.draw(self.sprite, self.x, self.y, 0)
	--[[
	local vertices = {
		self.x,
		self.y,
		self.x + self.size,
		self.y,
		self.x + self.size,
		self.y + self.size,
		self.x,
		self.y + self.size,
	}
	if self.velocity.x > 0 then
		vertices[1] = vertices[1] + self.size / 2
		vertices[3] = vertices[3] + self.size / 2
	elseif self.velocity.x < 0 then
		vertices[1] = vertices[1] - self.size / 2
		vertices[3] = vertices[3] - self.size / 2
	end

	if scale then
		for i, v in ipairs(vertices) do
			vertices[i] = vertices[i] * scale
		end
	end

	love.graphics.polygon("fill", vertices)
  ]]
end

return Player
