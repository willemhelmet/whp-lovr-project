-- TODO: BORKED
-- src/scenes/setup-player-2.lua
-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
local pretty = require 'lib.pl.pretty'
-- entities
local Grid = require 'src.entities.grid'
local VRRig = require 'src.entities.vr-rig-entity'
local InputDebug = require 'src.entities.input-debug-entity'
local Controller = require 'src.entities.controller'
-- components
local TransformComponent = require 'src.components.transform-component'
-- systems
local Systems = require 'src.core.system-registry'
-- assets
-- scene
local Scene = {}
Scene.world = tiny.world()
Scene.systems = {}
utils.import(Systems, Scene.systems)

-- vr rig
local vrRig = { VRRig }

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
  pass:transform(Scene.systems.TransformSystem.toMat4(vrRig[1].Transform):invert())
  Scene.systems.RenderSystem.draw(pass)
end

return Scene
