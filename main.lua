-- main.lua
local lovr = require 'lovr'

local Scene = require 'src.core.scene'
local Input = require 'src.core.input'

-- Load my first scene (that has ecs in it!)
Scene.register('test-scene-1', require 'src.scenes.test-scene-1')
Scene.register('test-scene-2', require 'src.scenes.test-scene-2')
Scene.register('setup-input', require 'src.scenes.setup-input')

function lovr.load()
  Scene.switch('setup-input')
end

function lovr.update(dt)
  -- update the scene every frame
  Scene.update(dt)

  -- If Escape is pressed quit the game
  if Input.isPressed("quit") then
    lovr.event.quit()
  end
end

function lovr.draw(pass)
  Scene.draw(pass)
end
