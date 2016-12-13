-- game.lua
game = {}

local circle = {
  x = 75,
  y = 75,
  r = 20, -- may be too small
  color = {225, 225, 225, 255},

  -- our circle's collision box
  rect = {
    x = 50,
    y = 50,
    w = 50,
    h = 50,
    draw = "line",
    color = {0, 0, 0, 255},
    touched = false
  },

}

function game:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  end
end

function game:touchpressed(id, x, y, dx, dy, pressure)
  if x > circle.rect.x and x < circle.rect.x + circle.rect.w and
  y > circle.rect.y and y < circle.rect.y + circle.rect.h then
    circle.rect.touched = true
  elseif circle.rect.touched then
    circle.rect.touched = false
  end
end

function game:touchreleased(id, x, y, dx, dy, pressure)
  if circle.rect.touched then
    circle.rect.touched = false
  end
end

function game:touchmoved(id, x, y, dx, dy, pressure)

end

function game:enter()

end

function game:update(dt)
  if circle.rect.touched == true then
    circle.color = {0, 0, 255, 100}
  elseif circle.rect.touched == false then
    circle.color = {225, 225, 225, 255}
  end
end

function game:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  -- play area
  love.graphics.setColor(0, 0, 0, 150)
  love.graphics.rectangle("line", 50, 50, 540, 540) -- outline
  love.graphics.setColor({225, 225, 225, 30})
  love.graphics.rectangle("fill", 50, 50, 540, 540)

  -- object collision space
  love.graphics.setColor(circle.rect.color)
  love.graphics.rectangle(circle.rect.draw, circle.rect.x, circle.rect.y, circle.rect.w, circle.rect.h)

  -- object itself
  love.graphics.setColor(circle.color)
  love.graphics.circle("fill", circle.x, circle.y, circle.r)

  -- invisible grid
  --love.graphics.rectangle("line", 40, 0, 1, 1136)
end
