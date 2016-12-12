-- main.lua

Gamestate = require "lib/gamestate"

require "states/game"

-- global functions
function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function love.load(arg)
  math.randomseed(os.time()) -- seed love.math.rand() using os time
  love.graphics.setDefaultFilter("nearest", "nearest") -- set nearest pixel distance

  -- currently running at the iPhone 5's native resolution (no scaling)
  love.window.setMode(640, 1136, {resizable=false, vsync=true, msaa=0, highdpi=true}) -- set the window mode

  Gamestate.registerEvents()
  Gamestate.switch(game) -- swtich to game screen
end

-- Name ideas:
-- Chromemory
-- Chroma Memory
-- Cro-Memory
-- Colordinate
-- Color Mold
-- CMold
-- Chroma
-- Kroma
-- Croma


-- Helpful iOS Love2d Links:
-- https://www.youtube.com/watch?v=MsYanwcU42E
-- https://love2d.org/wiki/Getting_Started

-- An iOS/Android GUI lib:
-- https://love2d.org/forums/viewtopic.php?f=5&t=79751&start=50

-- Things I should do:
-- Create a simple script that builds a .love file using current directory
-- Make sure this script is in .gitignore
