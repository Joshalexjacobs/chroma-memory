-- circles.lua

local circle = {
  x = 70,
  y = 125,
  r = 25, -- may be too small
  color = {225, 225, 225, 255}, -- the current color
  baseColor = {225, 225, 225, 255},
  connected = false,

  -- our circle's collision box
  rect = {
    x = 0,
    y = 0,
    w = 68.75, --55 --50
    h = 68.75, --55 --50
    pad = 10, -- padding --7.5 --5
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

local circles = {}

function updateVectors(obj)
  local lowest = 800
  obj.up.v2.x, obj.up.v2.y = obj.x - lowest, obj.y - lowest
  obj.up.v3.x, obj.up.v3.y = obj.x + lowest, obj.y - lowest

  obj.down.v2.x, obj.down.v2.y = obj.x + lowest, obj.y + lowest
  obj.down.v3.x, obj.down.v3.y = obj.x - lowest, obj.y + lowest

  obj.left.v2.x, obj.left.v2.y = obj.x - lowest, obj.y + lowest
  obj.left.v3.x, obj.left.v3.y = obj.x - lowest, obj.y - lowest

  obj.right.v2.x, obj.right.v2.y = obj.x + lowest, obj.y + lowest
  obj.right.v3.x, obj.right.v3.y = obj.x + lowest, obj.y - lowest
end

function addCircle(x, y, colors)
  local newCircle = copy(circle, newCircle)
  newCircle.x, newCircle.y = x, y
  newCircle.rect.x = newCircle.x - newCircle.r - newCircle.rect.pad
  newCircle.rect.y = newCircle.y - newCircle.r - newCircle.rect.pad

  newCircle.color = colors[love.math.random(1, #colors)]

  updateVectors(newCircle)

  table.insert(circles, newCircle)
end

function generateCircles(x, y, w, h, cSize, colors)
  local rows = w / cSize
  local cols = h / cSize

  for i = 1, cols do
    for j = 1, rows do
      addCircle(x + cSize * j, y + cSize * i, colors)
    end
  end
  print(#circles)
end

local function checkDir(x2, y2, x3, y3, xPos, yPos, obj)
  v1 = {x = 0, y = 0}
  v2 = {x = 0, y = 0}

  -- x1/y1 are circle.x/circle.y
  x1, y1 = obj.x, obj.y

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

function circlePressed(x, y)
  for _, newCircle in ipairs(circles) do
    if x > newCircle.rect.x and x < newCircle.rect.x + newCircle.rect.w and
    y > newCircle.rect.y and y < newCircle.rect.y + newCircle.rect.h then
      newCircle.rect.touched = true
    else --elseif newCircle.rect.touched then
      newCircle.rect.touched = false
    end
  end
end

function circleReleased(x, y, playArea)
  for i, newCircle in ipairs(circles) do
    if newCircle.rect.touched then

      if x > newCircle.rect.x and x < newCircle.rect.x + newCircle.rect.w and y > newCircle.rect.y and y < newCircle.rect.y + newCircle.rect.h then
        -- do nothing
      elseif checkDir(newCircle.right.v2.x, newCircle.right.v2.y, newCircle.right.v3.x, newCircle.right.v3.y, x, y, newCircle) then -- move right
        if newCircle.x + newCircle.rect.w < playArea.w + playArea.x then
          circles[i + 1].x, circles[i + 1].y, circles[i + 1].rect.x = newCircle.x, newCircle.y, newCircle.rect.x
          newCircle.x = newCircle.x + newCircle.rect.w
          newCircle.rect.x = newCircle.x - newCircle.r - newCircle.rect.pad

          -- swap index as well
          local temp = circles[i]
          circles[i] = circles[i + 1]
          circles[i + 1] = temp
        end
      elseif checkDir(newCircle.left.v2.x, newCircle.left.v2.y, newCircle.left.v3.x, newCircle.left.v3.y, x, y, newCircle) then -- move left
        if newCircle.x - newCircle.rect.w > playArea.x then
          circles[i - 1].x, circles[i - 1].y, circles[i - 1].rect.x = newCircle.x, newCircle.y, newCircle.rect.x
          newCircle.x = newCircle.x - newCircle.rect.w
          newCircle.rect.x = newCircle.x - newCircle.r - newCircle.rect.pad

          -- swap index as well
          local temp = circles[i]
          circles[i] = circles[i - 1]
          circles[i - 1] = temp
        end
      elseif checkDir(newCircle.down.v2.x, newCircle.down.v2.y, newCircle.down.v3.x, newCircle.down.v3.y, x, y, newCircle) then -- move down
        if newCircle.y + newCircle.rect.h < playArea.h + playArea.y then
          circles[i + 8].x, circles[i + 8].y, circles[i + 8].rect.y = newCircle.x, newCircle.y, newCircle.rect.y
          newCircle.y = newCircle.y + newCircle.rect.h
          newCircle.rect.y = newCircle.y - newCircle.r - newCircle.rect.pad

          -- swap index as well
          local temp = circles[i]
          circles[i] = circles[i + 8]
          circles[i + 8] = temp
        end
      elseif checkDir(newCircle.up.v2.x, newCircle.up.v2.y, newCircle.up.v3.x, newCircle.up.v3.y, x, y, newCircle) then -- move up
        if newCircle.y - newCircle.rect.h > playArea.y then
          circles[i - 8].x, circles[i - 8].y, circles[i - 8].rect.y = newCircle.x, newCircle.y, newCircle.rect.y
          newCircle.y = newCircle.y - newCircle.rect.h
          newCircle.rect.y = newCircle.y - newCircle.r - newCircle.rect.pad

          -- swap index as well
          local temp = circles[i]
          circles[i] = circles[i - 8]
          circles[i - 8] = temp
        end
      end

      newCircle.rect.touched = false
      updateVectors(newCircle)

    end
  end
end

function updateCircles()
  --[[
  for _, newCircle in ipairs(circles) do
    if newCircle.rect.touched == true then
      newCircle.color = {0, 0, 255, 100}
    elseif newCircle.rect.touched == false then
      newCircle.color = newCircle.baseColor
    end
  end
  ]]
end

function drawCircles()
  for i, newCircle in ipairs(circles) do
    -- collision rect
    --love.graphics.setColor(newCircle.rect.color)
    --love.graphics.rectangle(newCircle.rect.draw, newCircle.rect.x, newCircle.rect.y, newCircle.rect.w, newCircle.rect.h)

    if newCircle.rect.touched then
      love.graphics.setColor({newCircle.color[1], newCircle.color[2], newCircle.color[3], 50})
      love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r + 5)
      love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r + 10)
      love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r + 15)
      --love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r + 20)
      --love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r + 25)
    end

    -- circle
    love.graphics.setColor(newCircle.color)
    love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r)

    love.graphics.setColor({0, 0, 0, 255})
    love.graphics.printf(i, newCircle.rect.x, newCircle.y - 5, newCircle.rect.w, "center")

    --if newCircle.touched then

    --end

    --[[ vectors
    love.graphics.setColor(newCircle.rect.color)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.up.v2.x, newCircle.up.v2.y, newCircle.up.v3.x, newCircle.up.v3.y)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.down.v2.x, newCircle.down.v2.y, newCircle.down.v3.x, newCircle.down.v3.y)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.left.v2.x, newCircle.left.v2.y, newCircle.left.v3.x, newCircle.left.v3.y)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.right.v2.x, newCircle.right.v2.y, newCircle.right.v3.x, newCircle.right.v3.y)
    ]]
  end
end
