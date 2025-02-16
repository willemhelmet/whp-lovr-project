-- /src/scenes/setup-input.lua
local SetupInput = {}
local Input = require 'src.core.input'

local text = 'test';
function SetupInput.init()
end

function SetupInput.update(dt)
  if Input.isPressed('one') then
    text = 'one'
  elseif Input.isPressed('two') then
    text = 'two'
  else
    text = 'test'
  end
end

function SetupInput.draw(pass)
  pass:setColor(1, 1, 1)
  pass:text(text, 0, 1.5, -2, 1)
end

return SetupInput
