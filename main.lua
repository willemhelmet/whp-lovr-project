-- main.lua
local lovr = require 'lovr'

local Scene = require 'src.core.scene'

-- Load my first scene (that has ecs in it!)
Scene.register('test-scene-1', require 'src.scenes.test-scene-1')
Scene.register('test-scene-2', require 'src.scenes.test-scene-2')

function lovr.load()
  Scene.switch('test-scene-2')
end

function lovr.update(dt)
  -- update the scene every frame
  Scene.update(dt)
end

function lovr.draw(pass)
  Scene.draw(pass)
end

function lovr.keypressed(key)
  if key == 'escape' then
    lovr.event.quit()
  end
  if key == '1' then
    Scene.switch('test-scene-1')
  end
  if key == '2' then
    Scene.switch('test-scene-2')
  end
end
