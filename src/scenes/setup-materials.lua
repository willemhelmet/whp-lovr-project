-- src/scenes/setup-materials.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'
local utils = require 'lib.pl.utils'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- lovr
local Grid = require 'src.entities.grid'
local VrRig = require 'src.entities.vr-rig-entity'
-- components
Scene.components = {}
local componentRegistry = require 'src.core.component-registry'
utils.import(componentRegistry, Scene.components)
-- systems
Scene.systems = {}
local systemRegistry = require 'src.core.system-registry'
utils.import(systemRegistry, Scene.systems)

function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  Scene.world:add(VrRig.new())
  Scene.world:add(Grid.new())
end

function Scene.update(dt)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
  pass:setShader()
  pass:text('setup materials', 0, 1.5, -3, 0.25)
end

return Scene
