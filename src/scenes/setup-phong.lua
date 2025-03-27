-- src/scenes/setup-phong.lua

-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local VrRig = require 'src.entities.vr-rig-entity'
local Box = require 'src.entities.box'
-- components
Scene.components = {}
local componentRegistry = require 'src.core.component-registry'
utils.import(componentRegistry, Scene.components)
-- systems
Scene.systems = {}
local systemRegistry = require 'src.core.system-registry'
utils.import(systemRegistry, Scene.systems)
-- assets
local PhongMaterial = require 'assets.materials.phong-material'

function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  Scene.world:add(Grid.new())
  Scene.world:add(VrRig.new())
  Scene.world:add(Box.new({
    Transform = Scene.components.TransformComponent.new(
      Vec3(0, 1.5, -5),
      Quat(),
      Vec3(1, 1, 1)
    ),
    Material = Scene.components.MaterialComponent.new(
      PhongMaterial, {
        lightColor = { 1.0, 0.5, 0.25, 1.0 },
        lightPos = { 1.0, 3.0, -5.0 },
        ambience = { 0.1, 0.1, 0.1, 1.0 },
        specularStrength = 0.5,
        metallic = 32.0
      }
    )
  }))
end

function Scene.update(dt)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
end

return Scene
