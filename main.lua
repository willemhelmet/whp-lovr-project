-- main.lua

local SceneManager = require 'src.core.scene-manager'
local pretty = require 'lib.pl.pretty'

-- SceneManager.register('test-scene-1', require 'src.scenes.test-scene-1')
-- SceneManager.register('test-scene-2', require 'src.scenes.test-scene-2')
-- SceneManager.register('setup-input', require 'src.scenes.setup-input')
-- SceneManager.register('setup-player', require 'src.scenes.setup-player')
-- SceneManager.register('learn-physics', require 'src.scenes.learn-physics')
-- SceneManager.register('physics-practice-1', require 'src.scenes.physics-practice-1')
-- SceneManager.register('physics-practice-2', require 'src.scenes.physics-practice-2')
-- SceneManager.register('pass-sidequest', require 'src.scenes.pass-sidequest')
-- SceneManager.register('setup-grab', require 'src.scenes.setup-grab')
-- SceneManager.register('setup-transform', require 'src.scenes.setup-transform')
-- SceneManager.register('setup-player-2', require 'src.scenes.setup-player-2')
-- SceneManager.register('setup-phong', require 'src.scenes.setup-phong')
-- SceneManager.register('setup-other-lights', require 'src.scenes.setup-other-lights')
-- SceneManager.register('setup-materials', require 'src.scenes.setup-materials')
-- SceneManager.register('setup-oop', require 'src.scenes.setup-oop')
SceneManager.register('setup-teleportation', require 'src.scenes.setup-teleportation')

function lovr.load()
  -- SceneManager.switch('setup-input')
  -- SceneManager.switch('setup-player')
  -- SceneManager.switch('learn-physics')
  -- SceneManager.switch('physics-practice-1')
  -- SceneManager.switch('physics-practice-2')
  -- SceneManager.switch('pass-sidequest')
  -- SceneManager.switch('setup-grab')
  -- SceneManager.switch('setup-transform')
  -- SceneManager.switch('setup-player-2')
  -- SceneManager.switch('setup-phong')
  -- SceneManager.switch('setup-other-lights')
  -- SceneManager.switch('setup-materials')
  -- SceneManager.switch('setup-oop')
  SceneManager.switch('setup-teleportation')
end

function lovr.update(dt)
  -- update the scene every frame
  SceneManager.update(dt)
end

function lovr.draw(pass)
  SceneManager.draw(pass)
end

function lovr.keypressed(key)
  if key == 'escape' then
    lovr.event.quit()
  end
end

function lovr.log(message, level, tag)
  print(pretty.write(message))
end
