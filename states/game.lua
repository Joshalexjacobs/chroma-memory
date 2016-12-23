-- game.lua
game = {}

require "circles"

local playArea = {
  x = 45,
  y = 100,
  w = 550,
  h = 962.5,
  cSize = 68.75
}

local circleSize = 68.75

function game:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  end
end

function game:touchpressed(id, x, y, dx, dy, pressure)
  -- if touch is inside playArea...
  if x >= playArea.x and x <= playArea.x + playArea.w and
  y >= playArea.y and y <= playArea.y + playArea.h then
    circlePressed(x, y)
  end
end

function game:touchreleased(id, x, y, dx, dy, pressure)
  circleReleased(x, y, playArea)
end

function game:touchmoved(id, x, y, dx, dy, pressure)

end

function game:enter()
  local colors = {
    {225, 50, 50, 150}, -- 1 light red
    {225, 225, 50, 150}, -- 2 light yellow
    {100, 255, 100, 150}, -- 3 light green
    {50, 150, 225, 150}, -- 4 light blue
    {255, 135, 0, 150}, -- 5 orange
    {0, 0, 0, 150}, -- 6 black/dark gray
  }

  generateCircles(11.25, 66.25, playArea.w, playArea.h, playArea.cSize, colors)
end

function game:update(dt)
  updateCircles()
end

function game:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  -- play area
  love.graphics.setColor(0, 0, 0, 150)
  love.graphics.rectangle("line", playArea.x, playArea.y, playArea.w, playArea.h) -- outline 550 x 550 1 circle is 50 x 50
  love.graphics.setColor({225, 225, 225, 30})
  love.graphics.rectangle("fill", playArea.x, playArea.y, playArea.w, playArea.h)

  -- invisible grid
  --for i = 1, 8 do
    --love.graphics.rectangle("line", playArea.x + i * 68.75, playArea.y, 1, playArea.h) -- vertical
    --love.graphics.rectangle("line", playArea.x, playArea.y + i * 68.75, playArea.w, 1) -- horizontal
  --end

  drawCircles()
end
