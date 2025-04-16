-- main.lua

local Scene = require 'src.core.scene'
local pretty = require 'lib.pl.pretty'

-- Scene.register('test-scene-1', require 'src.scenes.test-scene-1')
-- Scene.register('test-scene-2', require 'src.scenes.test-scene-2')
-- Scene.register('setup-input', require 'src.scenes.setup-input')
-- Scene.register('setup-player', require 'src.scenes.setup-player')
-- Scene.register('learn-physics', require 'src.scenes.learn-physics')
-- Scene.register('physics-practice-1', require 'src.scenes.physics-practice-1')
-- Scene.register('physics-practice-2', require 'src.scenes.physics-practice-2')
-- Scene.register('pass-sidequest', require 'src.scenes.pass-sidequest')
-- Scene.register('setup-grab', require 'src.scenes.setup-grab')
-- Scene.register('setup-transform', require 'src.scenes.setup-transform')
-- Scene.register('setup-player-2', require 'src.scenes.setup-player-2') -- WHP: BORKED
-- Scene.register('setup-phong', require 'src.scenes.setup-phong')
-- Scene.register('setup-other-lights', require 'src.scenes.setup-other-lights')
-- Scene.register('setup-materials', require 'src.scenes.setup-materials')
Scene.register('setup-oop', require 'src.scenes.setup-oop')

function lovr.load()
  -- Scene.switch('setup-input')
  -- Scene.switch('setup-player')
  -- Scene.switch('learn-physics')
  -- Scene.switch('physics-practice-1')
  -- Scene.switch('physics-practice-2')
  -- Scene.switch('pass-sidequest')
  -- Scene.switch('setup-grab')
  -- Scene.switch('setup-transform')
  -- Scene.switch('setup-player-2')
  -- Scene.switch('setup-phong')
  -- Scene.switch('setup-other-lights')
  -- Scene.switch('setup-materials')
  Scene.switch('setup-oop')
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
end

function lovr.log(message, level, tag)
  print(pretty.write(message))
end
