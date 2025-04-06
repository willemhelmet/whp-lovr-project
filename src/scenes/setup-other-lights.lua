-- src/scenes/setup-other-lights.lua
local Scene = {}
-- lib
local lovr = require 'lovr'
local Vec3 = lovr.math.newVec3
local Quat = lovr.math.newQuat
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
-- entities
local Grid = require 'src.entities.grid'
local VrRig = require 'src.entities.vr-rig-entity'
local Box = require 'src.entities.box'
local light
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

Scene.world = tiny.world()


function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  Scene.world:add(VrRig.new())
  Scene.world:addEntity(Grid.new())

  -- Add some random boxes
  local numBoxes = 15
  local placementRadius = 6.0
  local maxHeight = 3.0
  local minHeight = 0.5

  for i = 1, numBoxes do
    local angle = math.random() * math.pi * 2
    local dist = math.random() * placementRadius
    local x = -2 + math.cos(angle) * dist
    local z = -3 + math.sin(angle) * dist
    local y = minHeight + math.random() * (maxHeight - minHeight)

    local box = Box.new({
      Transform = Scene.components.TransformComponent.new(
        Vec3(x, y, z),
        Quat(
          math.random(),
          math.random(),
          math.random(),
          math.random()
        ):normalize()
      ),
      Material = Scene.components.MaterialComponent.new(
        PhongMaterial, {
          ambience = { 0.0, 0.0, 0.0, 1.0 },
          specularStrength = 0.0,
          metallic = 32.0,
        }
      )
    })
    Scene.world:addEntity(box)
  end

  -- point light
  -- light = {
  --   Transform = Scene.components.TransformComponent.new(
  --     Vec3(0, 1, -3)
  --   ),
  --   Light = Scene.components.LightComponent.new({
  --     type = 'point'
  --   })
  -- }
  -- directional light
  light = {
    Transform = Scene.components.TransformComponent.new(
      Vec3(0, 0, 0),
      Quat(1, 0, 0, 0)
    ),
    Light = Scene.components.LightComponent.new({
      type = 'directional'
    })
  }
  print(light.Transform.orientation:direction())
  -- spotlight
  Scene.world:add(light)
end

function Scene.update(dt)
  Scene.systems.TransformSystem.setOrientation(light.Transform, Quat(lovr.headset.getTime(), 0, 1, 0))
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
  pass:setShader()
  pass:text('setup other lights', 0, 1.5, -4, 0.25)
end

return Scene
