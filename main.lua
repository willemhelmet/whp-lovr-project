-- main.lua
local lovr = require 'lovr'

local Scene = require 'src.core.scene'
local Input = require 'src.core.input'

-- Load my first scene (that has ecs in it!)
Scene.register('test-scene-1', require 'src.scenes.test-scene-1')
Scene.register('test-scene-2', require 'src.scenes.test-scene-2')
Scene.register('setup-player', require 'src.scenes.setup-player')
Scene.register('setup-input', require 'src.scenes.setup-input')

function lovr.load()
  Scene.switch('setup-player')
end

function lovr.update(dt)
  -- update the scene every frame
  Scene.update(dt)

  -- global quitting functionality
  if Input.getValue("quit") then
    lovr.event.quit()
  end
end

function lovr.draw(pass)
  Scene.draw(pass)
end
