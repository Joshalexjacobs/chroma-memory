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

  up = {
    v2 = {x = 0, y = 0},
    v3 = {x = 0, y = 0}
  },

  down = {
    v2 = {x = 0, y = 0},
    v3 = {x = 0, y = 0}
  },

  left = {
    v2 = {x = 0, y = 0},
    v3 = {x = 0, y = 0}
  },

  right = {
    v2 = {x = 0, y = 0},
    v3 = {x = 0, y = 0}
  }
}

function circle:checkDir(x2, y2, x3, y3, xPos, yPos)
  v1 = {x = 0, y = 0}
  v2 = {x = 0, y = 0}

  -- x1/y1 are circle.x/circle.y
  x1, y1 = circle.x, circle.y

  -- bool b0 = (Vector(P.x - A.x, P.y - A.y) * Vector(A.y - B.y, B.x - A.x) > 0);
  v1.x, v1.y = xPos - x1, yPos - y1
  v2.x, v2.y = y1 - y2, x2 - x1

  b0 = v1.x * v2.x + v1.y * v2.y
  b0 = b0 > 0

  -- bool b1 = (Vector(P.x - B.x, P.y - B.y) * Vector(B.y - C.y, C.x - B.x) > 0);
  v1.x, v1.y = xPos - x2, yPos - y2
  v2.x, v2.y = y2 - y3, x3 - x2

  b1 = v1.x * v2.x + v1.y * v2.y
  b1 = b1 > 0

  -- bool b2 = (Vector(P.x - C.x, P.y - C.y) * Vector(C.y - A.y, A.x - C.x) > 0);
  v1.x, v1.y = xPos - x3, yPos - y3
  v2.x, v2.y = y3 - y1, x1 - x3

  b2 = v1.x * v2.x + v1.y * v2.y
  b2 = b2 > 0

  if b0 == b1 and b1 == b2 then
    return true
  else
    return false
  end
end

function circle:updateVectors()
  local lowest = 800
  circle.up.v2.x, circle.up.v2.y = circle.x - lowest, circle.y - lowest
  circle.up.v3.x, circle.up.v3.y = circle.x + lowest, circle.y - lowest

  circle.down.v2.x, circle.down.v2.y = circle.x + lowest, circle.y + lowest
  circle.down.v3.x, circle.down.v3.y = circle.x - lowest, circle.y + lowest

  circle.left.v2.x, circle.left.v2.y = circle.x - lowest, circle.y + lowest
  circle.left.v3.x, circle.left.v3.y = circle.x - lowest, circle.y - lowest

  circle.right.v2.x, circle.right.v2.y = circle.x + lowest, circle.y + lowest
  circle.right.v3.x, circle.right.v3.y = circle.x + lowest, circle.y - lowest
end

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
    if circle:checkDir(circle.right.v2.x, circle.right.v2.y, circle.right.v3.x, circle.right.v3.y, x, y) then -- move right
      circle.x = circle.x + 50
      circle.rect.x = circle.x - circle.r - circle.rect.pad
    elseif circle:checkDir(circle.left.v2.x, circle.left.v2.y, circle.left.v3.x, circle.left.v3.y, x, y) then -- move left
      circle.x = circle.x - 50
      circle.rect.x = circle.x - circle.r - circle.rect.pad
    elseif circle:checkDir(circle.down.v2.x, circle.down.v2.y, circle.down.v3.x, circle.down.v3.y, x, y) then -- move down
      circle.y = circle.y + 50
      circle.rect.y = circle.y - circle.r - circle.rect.pad
    elseif circle:checkDir(circle.up.v2.x, circle.up.v2.y, circle.up.v3.x, circle.up.v3.y, x, y) then -- move up
      circle.y = circle.y - 50
      circle.rect.y = circle.y - circle.r - circle.rect.pad
    end

    circle.rect.touched = false
    circle:updateVectors()
  end
end

function game:touchmoved(id, x, y, dx, dy, pressure)

end

function game:enter()
  -- set up circle
  circle.rect.x = circle.x - circle.r - circle.rect.pad
  circle.rect.y = circle.y - circle.r - circle.rect.pad

  circle:updateVectors()
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

  --[[
  love.graphics.setColor(circle.rect.color)
  love.graphics.polygon("line", circle.x, circle.y, circle.up.v2.x, circle.up.v2.y, circle.up.v3.x, circle.up.v3.y)
  love.graphics.polygon("line", circle.x, circle.y, circle.down.v2.x, circle.down.v2.y, circle.down.v3.x, circle.down.v3.y)
  love.graphics.polygon("line", circle.x, circle.y, circle.left.v2.x, circle.left.v2.y, circle.left.v3.x, circle.left.v3.y)
  love.graphics.polygon("line", circle.x, circle.y, circle.right.v2.x, circle.right.v2.y, circle.right.v3.x, circle.right.v3.y)
  ]]
end
