-- main.lua
local lovr = require 'lovr'

local Scene = require 'src.core.scene'
-- Load ECS-enabled scenes
Scene.register('test-scene-1', require 'src.scenes.test-scene-1')

function lovr.load()
  Scene.switch('test-scene-1')
end

function lovr.update(dt)
  Scene.update(dt)
end

function lovr.draw(pass)
  -- pass:cube(0, 1.7, -1, .5, lovr.headset.getTime(), 0, 1, 0, 'line')
  Scene.draw(pass)
end

function lovr.keypressed(key)
  if key == 'escape' then
    lovr.event.quit()
  end
end
