love.window.setMode(1280, 720)

require("./requires")

local physics
local event
local player
local level

function love.load()
	player = Player.new(200, 0, 16, love.image.newImageData("./sprites/player"))
	level = Level.new({
		Block.new(200, 200, 200, 100),
		Block.new(100, 350, 500, 10),
		Block.new(100, 250, 30, 20),

		Spike.new(500, 340),
	}, player, { x = 200, y = 0 })
	physics = Physics.new(level)
	event = Event.new(level)
end

function love.update(dt)
	level:update(dt)
	physics:update(dt)
	event:update(dt)
end

function love.draw()
	level:draw()
end
