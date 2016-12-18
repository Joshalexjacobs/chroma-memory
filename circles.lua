-- circles.lua

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

function addCircle(x, y)
  local newCircle = copy(circle, newCircle)

  newCircle.rect.x = newCircle.x - newCircle.r - newCircle.rect.pad
  newCircle.rect.y = newCircle.y - newCircle.r - newCircle.rect.pad

  updateVectors(newCircle)

  table.insert(circles, newCircle)
end

--function circles:generate(w, h)
--
--end

function updateCircles()

end

function drawCircles()
  for _, newCircle in ipairs(circles) do
    -- collision rect
    love.graphics.setColor(newCircle.rect.color)
    love.graphics.rectangle(newCircle.rect.draw, newCircle.rect.x, newCircle.rect.y, newCircle.rect.w, newCircle.rect.h)

    -- circle
    love.graphics.setColor(newCircle.color)
    love.graphics.circle("fill", newCircle.x, newCircle.y, newCircle.r)

    -- vectors
    love.graphics.setColor(newCircle.rect.color)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.up.v2.x, newCircle.up.v2.y, newCircle.up.v3.x, newCircle.up.v3.y)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.down.v2.x, newCircle.down.v2.y, newCircle.down.v3.x, newCircle.down.v3.y)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.left.v2.x, newCircle.left.v2.y, newCircle.left.v3.x, newCircle.left.v3.y)
    love.graphics.polygon("line", newCircle.x, newCircle.y, newCircle.right.v2.x, newCircle.right.v2.y, newCircle.right.v3.x, newCircle.right.v3.y)
  end
end
