-- game.lua
game = {}

local circle = {
  x = 70,
  y = 125,
  r = 20, -- may be too small
  color = {225, 225, 225, 255},

  -- our circle's collision box
  rect = {
    x = 0,
    y = 0,
    w = 50,
    h = 50,
    pad = 5, -- padding
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
    if x > circle.rect.x + circle.rect.w then -- move right
      circle.x = circle.x + 50
      circle.rect.x = circle.x - circle.r - circle.rect.pad
    elseif x < circle.rect.x then -- move left
      circle.x = circle.x - 50
      circle.rect.x = circle.x - circle.r - circle.rect.pad
    elseif y > circle.rect.y + circle.rect.h then -- move down
      circle.y = circle.y + 50
      circle.rect.y = circle.y - circle.r - circle.rect.pad
    elseif y < circle.rect.y then -- move up
      circle.y = circle.y - 50
      circle.rect.y = circle.y - circle.r - circle.rect.pad
    end

    circle.rect.touched = false
  end
end

function game:touchmoved(id, x, y, dx, dy, pressure)

end

function game:enter()
  -- set up circle
  circle.rect.x = circle.x - circle.r - circle.rect.pad
  circle.rect.y = circle.y - circle.r - circle.rect.pad
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
  love.graphics.rectangle("line", 45, 100, 550, 550) -- outline 540 x 540 1 circle is 50 x 50
  love.graphics.setColor({225, 225, 225, 30})
  love.graphics.rectangle("fill", 45, 100, 550, 550)

  -- invisible grid
  for i = 1, 10 do
    love.graphics.rectangle("line", 45 + i * 50, 100, 1, 550)
    love.graphics.rectangle("line", 45, 100 + i * 50, 550, 1)
  end

  -- object collision space
  love.graphics.setColor(circle.rect.color)
  love.graphics.rectangle(circle.rect.draw, circle.rect.x, circle.rect.y, circle.rect.w, circle.rect.h)

  -- object itself
  love.graphics.setColor(circle.color)
  love.graphics.circle("fill", circle.x, circle.y, circle.r)

  love.graphics.setColor(circle.rect.color)
  if circle.x < circle.y then lowest = circle.x else lowest = circle.y end
  love.graphics.line(circle.x, circle.y, circle.x - lowest, circle.y - lowest)

end
