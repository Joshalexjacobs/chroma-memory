-- game.lua
game = {}

local circle = {
  x = 100,
  y = 100,
  r = 50,
  isActive = false
}

function game:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  end
end

function game:touchpressed(id, x, y, dx, dy, pressure)
  if circle.isActive == false then
    circle.isActive = true
  end

  circle.x = x
  circle.y = y
end

function game:touchmoved(id, x, y, dx, dy, pressure)
  if circle.isActive == false then
    circle.isActive = true
  end

  circle.x = x
  circle.y = y
end

function game:enter()
  love.graphics.setLineWidth(10)
end

function game:update(dt)

end

function game:draw()
  love.graphics.setColor(150, 150, 150, 255)
  love.graphics.rectangle("line", 5, 5, 1126, 630)

  love.graphics.setColor(255, 255, 255, 255)
  if circle.isActive then
    love.graphics.circle("fill", circle.x, circle.y, circle.r)
  end
end
