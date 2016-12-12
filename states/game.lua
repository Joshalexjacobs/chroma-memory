-- game.lua
game = {}

local circle = {
  x = 300,
  y = 400,
  r = 20, -- may be too small
  color = {225, 225, 225, 255},

  -- our circle's collision box
  rect = {
    x = 280,
    y = 380,
    w = 40,
    h = 40,
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

  -- object itself
  love.graphics.setColor(circle.color)
  love.graphics.circle("fill", circle.x, circle.y, circle.r)

  -- object collision space
  --love.graphics.setColor(circle.rect.color)
  --love.graphics.rectangle(circle.rect.draw, circle.rect.x, circle.rect.y, circle.rect.w, circle.rect.h)

  -- play area
  --love.graphics.setColor({225, 225, 225, 255})
  --love.graphics.rectangle("fill", 0, 0, 1, 1)

  -- invisible grid
  --love.graphics.rectangle("line", 40, 0, 1, 1136)
end
