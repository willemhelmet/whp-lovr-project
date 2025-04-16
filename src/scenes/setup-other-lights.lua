-- src/scenes/setup-other-lights.lua
local Scene = {}
-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
local pretty = require 'lib.pl.pretty'
-- entities
local Grid = require 'src.entities.grid'
local VrRig = require 'src.entities.vr-rig-entity'
local Box = require 'src.entities.box'
local Suzanne = require 'src.entities.suzanne'
local pointLight
local directionalLight
local spotLight
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
  -- Scene.world:add(VrRig.new()) -- Borked

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

    local suzanne = Suzanne({
      Transform = Scene.components.TransformComponent(
        Vec3(x, y, z),
        Quat(
          math.random(),
          math.random(),
          math.random(),
          math.random()
        ):normalize(),
        Vec3(0.5, 0.5, 0.5)
      ),
      Material = Scene.components.MaterialComponent(
        PhongMaterial, {
          ambientColor = Vec4(0.0, 0.0, 0.0, 1.0),
          diffuseColor = Vec4(1, 1, 1, 1),
          specularColor = Vec4(1, 1, 1, 1),
          specularStrength = 0.0,
          metallic = 32.0,
        }
      )
    })
    Scene.world:add(suzanne)
  end

  -- floor
  local floor = Box({
    Transform = Scene.components.TransformComponent(
      Vec3(0, 0, 0),
      Quat(),
      Vec3(200, 0.01, 200)
    ),
    Material = Scene.components.MaterialComponent(
      PhongMaterial, {
        ambientColor = Vec4(0.0, 0.0, 0.0, 1.0),
        diffuseColor = Vec4(1, 1, 1, 1),
        specularColor = Vec4(1, 1, 1, 1),
        specularStrength = 0.0,
        metallic = 32.0
      }
    )
  })
  Scene.world:addEntity(floor)

  -- point light
  pointLight = {
    Transform = Scene.components.TransformComponent(
      Vec3(0, 1, -3)
    ),
    Light = Scene.components.LightComponent({
      color = Vec3(1, 1, 1),
      intensity = 0.01,
      type = 'point'
    })
  }
  Scene.world:add(pointLight)

  -- directional light
  directionalLight = {
    Transform = Scene.components.TransformComponent(
      Vec3(0, 0, 0),
      Quat(1, 0, 0, 0)
    ),
    Light = Scene.components.LightComponent({
      color = Vec3(0, 1, 0),
      intensity = 0.01,
      type = 'directional',

    })
  }
  Scene.world:add(directionalLight)

  -- spotlight
  spotLight = {
    Transform = Scene.components.TransformComponent(),
    Light = Scene.components.LightComponent({
      color = Vec3(1, 1, 1),
      intensity = 1.0,
      type = 'spot',
      cutoff = math.pi * 0.0125,
      outerCutoff = math.pi * 0.125
    })
  }
  Scene.world:add(spotLight)
end

local position
local orientation
function Scene.update(dt)
  Scene.systems.TransformSystem.setOrientation(directionalLight.Transform, Quat(lovr.headset.getTime(), 0, 1, 0))
  position = Vec3(lovr.headset.getPosition('left'))
  orientation = Quat(lovr.headset.getOrientation('left'))
  Scene.systems.TransformSystem.setPosition(spotLight.Transform, position)
  Scene.systems.TransformSystem.setOrientation(spotLight.Transform, orientation)
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
  pass:setShader()
  pass:text('setup other lights', 0, 1.5, -4, 0.25)
end

return Scene
