-- src/scenes/setup-teleportation.lua

-- TODO: this whole Scene setup seems like a great opportunity to use OOP!
--      The Scene class can have all of these components and systems
--      already setup, so all i need to do is create an instance
--      of the Scene class whenever I want to create a new level

-- lib
local tiny = require 'lib.tiny'
local Settings = require 'config.settings'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'
local InputDebug = require 'src.entities.input-debug-entity'
local Player = require 'src.entities.player'
local leftController
local rightController
-- components
-- systems
local RenderSystem = require 'src.systems.render-system'

function Scene.init()
  for i, system in ipairs(require 'src.core.system-registry') do
    Scene.world:add(system[1])
    tiny.setSystemIndex(Scene.world, system[1], i)
  end

  leftController = Controller('left')
  rightController = Controller('right')
  Scene.world:add(leftController, rightController)
  Scene.world:add(Player())
  Scene.world:add(table.unpack(InputDebug().entities))
  Scene.world:add(Grid())
end

function Scene.update(dt)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  RenderSystem.draw(pass)
end

return Scene
