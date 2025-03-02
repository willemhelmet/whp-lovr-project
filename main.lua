-- main.lua
local lovr = require 'lovr'

local Scene = require 'src.core.scene'
local Input = require 'src.core.input'

-- Scene.register('test-scene-1', require 'src.scenes.test-scene-1')
-- Scene.register('test-scene-2', require 'src.scenes.test-scene-2')
-- Scene.register('setup-input', require 'src.scenes.setup-input')
-- Scene.register('setup-player', require 'src.scenes.setup-player')
-- Scene.register('learn-physics', require 'src.scenes.learn-physics')
-- Scene.register('physics-practice-1', require 'src.scenes.physics-practice-1')
-- Scene.register('physics-practice-2', require 'src.scenes.physics-practice-2')
Scene.register('pass-sidequest', require 'src.scenes.pass-sidequest')

function lovr.load()
  -- Scene.switch('physics-practice-2')
  Scene.switch('pass-sidequest')
end

function lovr.update(dt)
  -- get keypresses
  Input.update(dt)

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
