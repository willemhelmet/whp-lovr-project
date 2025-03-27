-- src/scenes/setup-phong.lua

-- lovr
local lovr = require 'lovr'
local Quat = lovr.math.newQuat
local Vec3 = lovr.math.newVec3
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

local box = Box.new({
  Transform = Scene.components.TransformComponent.new(
    Vec3(0, 0, 0),
    Quat(),
    Vec3(50, 0.1, 40)
  ),
  Material = Scene.components.MaterialComponent.new(
    PhongMaterial, {
      lightColor = { 1.0, 1.0, 1.0, 1.0 },
      lightPos = { 1.0, 3.0, -1.0 },
      ambience = { 0.0, 0.0, 0.0, 1.0 },
      specularStrength = 0,
      metallic = 32.0
    }
  )
})

local PointLightAttLinearValues = { 0.7, 0.35, 0.22, 0.14, 0.09, 0.07, 0.045, 0.027, 0.022, 0.014, 0.007, 0.0014 }
local PointLightAttQuadraticValues = { 1.8, 0.44, 0.20, 0.07, 0.032, 0.017, 0.0075, 0.0028, 0.0019, 0.0007, 0.0002, 0.000007 }
local PointLightAttCounter = 2

local pointLight = {
  Transform = Scene.components.TransformComponent.new(
    Vec3(0, 1, -3)
  ),
  Light = Scene.components.LightComponent.new()
}
function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  -- Scene.world:add(Grid.new())
  Scene.world:add(VrRig.new())
  Scene.world:add(pointLight)
  Scene.world:add(box)
end

function Scene.update(dt)
  Scene.systems.RenderSystem.setUniform(box.Material, 'lightColor',
    Vec4(
      0.5 * math.sin(lovr.headset.getTime()) + 0.5,
      0.0,
      1.0,
      1.0
    )
  )
  Scene.systems.RenderSystem.setUniform(box.Material, 'lightPos',
    Vec3(
      math.sin(lovr.headset.getTime()),
      0.5 * math.sin(lovr.headset.getTime()) + 0.7,
      -3 + math.cos(lovr.headset.getTime())
    )
  )
  Scene.systems.TransformSystem.setPosition(pointLight.Transform,
    Vec3(
      math.sin(lovr.headset.getTime()),
      0.5 * math.sin(lovr.headset.getTime()) + 0.7,
      -3 + math.cos(lovr.headset.getTime())
    ))
  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
  pass:setShader()
  pass:setColor(
    0.5 * math.sin(lovr.headset.getTime()) + 0.5,
    0.0,
    1.0
  )
  pass:sphere(
    pointLight.Transform.position.x,
    pointLight.Transform.position.y,
    pointLight.Transform.position.z,
    0.1,
    Quat()
  )
end

return Scene
