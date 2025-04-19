-- src/scenes/setup-player-2.lua

-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local VRRig = require 'src.entities.vr-rig-entity'
local InputDebug = require 'src.entities.input-debug-entity'
local Controller = require 'src.entities.controller'
-- components
Scene.components = {}
local componentRegistry = require 'src.core.component-registry'
utils.import(componentRegistry, Scene.components)
-- systems
Scene.systems = {}
local systemRegistry = require 'src.core.system-registry'
utils.import(systemRegistry, Scene.systems)
-- assets

function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:addSystem(system)
  end
  Scene.world:add(InputDebug.new())
  Scene.world:add(table.unpack(vrRig))
  Scene.world:add(Grid())
end

function Scene.update(dt)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.RenderSystem.draw(pass)
end

return Scene
