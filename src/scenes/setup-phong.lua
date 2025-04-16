-- src/scenes/setup-phong.lua

-- lib
local tiny = require 'lib.tiny'
local utils = require 'lib.pl.utils'
local pretty = require 'lib.pl.pretty'
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

local box = Box({
  Transform = Scene.components.TransformComponent(
    Vec3(0, 0, 0),
    Quat(),
    Vec3(500, 0.1, 500)
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

local box2 = Box({
  Transform = Scene.components.TransformComponent(
    Vec3(-2, 5, -5),
    Quat(),
    Vec3(1, 10, 1)
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
local box3 = Box({
  Transform = Scene.components.TransformComponent(
    Vec3(2, 5, -5),
    Quat(),
    Vec3(1, 10, 1)
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

local box4 = Box({
  Transform = Scene.components.TransformComponent(
    Vec3(2, 5, -10),
    Quat(),
    Vec3(1, 10, 1)
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

local box5 = Box({
  Transform = Scene.components.TransformComponent(
    Vec3(-2, 5, -10),
    Quat(),
    Vec3(1, 10, 1)
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

local linear = { 0.71, 0.35, 0.22, 0.14, 0.09, 0.07, 0.045, 0.027, 0.022, 0.014, 0.007, 0.0014 }
local quadratic = { 0.813, 0.442, 0.203, 0.075, 0.032, 0.017, 0.0075, 0.0028, 0.0019, 0.0007, 0.0002, 0.000007 }
local option = 1

-- Create multiple point lights
local pointLight1 = {
  Transform = Scene.components.TransformComponent(
    Vec3(0, 1, -3)
  ),
  Light = Scene.components.LightComponent({
    color = Vec3(1, 0, 0),
    intensity = 0.1,
    constant = 1.0,
    linear = linear[option],
    quadratic = quadratic[option]
  })
}

local pointLight2 = {
  Transform = Scene.components.TransformComponent(
    Vec3(0, 2, -3)
  ),
  Light = Scene.components.LightComponent({
    color = Vec3(0, 1, 1),
    intensity = 0.1,
    constant = 1.0,
    linear = linear[option],
    quadratic = quadratic[option]
  })
}

-- Define 14 more lights
local additionalLights = {}
for i = 3, 16 do
  local angle = (i - 3) * (math.pi * 2 / 14) -- Distribute initial positions
  local radius = 8.0                         -- Increased initial radius for wider spread
  local initialX = math.cos(angle) * radius
  local initialZ = -6 + math.sin(angle) * radius
  local initialY = 1.5 + math.cos(angle * 2) -- Vary initial height slightly

  additionalLights[i] = {
    Transform = Scene.components.TransformComponent(
      Vec3(initialX, initialY, initialZ)
    ),
    Light = Scene.components.LightComponent({
      -- Use HSL-like color cycling for variety
      color = Vec3(0.5 * math.sin(angle) + 0.5, 0.5 * math.sin(angle + math.pi * 2 / 3) + 0.5,
        0.5 * math.sin(angle + math.pi * 4 / 3) + 0.5),
      intensity = 0.01, -- Slightly dimmer to avoid oversaturation
      constant = 1.0,
      linear = linear[option],
      quadratic = quadratic[option]
    })
  }
end


function Scene.init()
  for _, system in pairs(Scene.systems) do
    Scene.world:add(system)
  end
  -- Scene.world:add(Grid())
  -- Scene.world:add(VrRig.new()) -- BORKED
  Scene.world:add(pointLight1)
  Scene.world:add(pointLight2)
  -- Add the other lights
  for i = 3, 16 do
    Scene.world:add(additionalLights[i])
  end
  Scene.world:add(box)
  Scene.world:add(box2)
  Scene.world:add(box3)
  Scene.world:add(box4)
  Scene.world:add(box5)
end

function Scene.update(dt)
  local time = lovr.headset.getTime()
  -- --- Light 1 ---
  -- Animate color 1 (more dynamic color cycling)
  local color1 = Vec3(
    0.5 * math.sin(time * 1.3) + 0.5,
    0.5 * math.cos(time * 1.7 + 2.0) + 0.5,
    0.5 * math.sin(time * 0.9 + 4.0) + 0.5
  )
  pointLight1.Light.color = color1

  -- Move light 1 (circular motion with vertical bobbing)
  local radius1 = 1.0
  local speed1 = 0.7
  local verticalSpeed1 = 0.5
  local verticalAmplitude1 = 0.3
  Scene.systems.TransformSystem.setPosition(pointLight1.Transform,
    Vec3(
      math.cos(time * speed1) * radius1,
      2 + math.sin(time * verticalSpeed1) * verticalAmplitude1,
      -6 + math.sin(time * speed1) * radius1
    )
  )

  -- --- Light 2 ---
  -- Animate color 2 (offset and different frequencies)
  local color2 = Vec3(
    0.5 * math.cos(time * 1.1 + 1.0) + 0.5,
    0.5 * math.sin(time * 1.5 + 3.0) + 0.5,
    0.5 * math.cos(time * 0.8) + 0.5
  )
  pointLight2.Light.color = color2

  -- Move light 2 (figure-eight motion)
  local radius2 = 0.8
  local speed2_x = 0.9
  local speed2_y = 1.2
  Scene.systems.TransformSystem.setPosition(pointLight2.Transform,
    Vec3(
      math.sin(time * speed2_x) * radius2,
      2 + math.cos(time * speed2_y) * 0.5,
      -3 + math.cos(time * speed2_x) * radius2
    ))

  -- --- Lights 3-16 ---
  for i = 3, 16 do
    local light = additionalLights[i]
    local baseAngle = (i - 3) * (math.pi * 2 / 14)               -- Base offset for variety
    local speedFactor = 0.5 + (i % 5) * 0.1                      -- Vary speeds
    -- Increase base radius and pulsation amplitude for wider animation paths
    local radius = 5.0 + math.sin(time * 0.1 + baseAngle) * 10.0 -- Pulsating radius

    -- Animate color (slow hue shift)
    local hueSpeed = 0.2
    light.Light.color = Vec3(
      0.5 * math.sin(time * hueSpeed + baseAngle) + 0.5,
      0.5 * math.sin(time * hueSpeed + baseAngle + math.pi * 2 / 3) + 0.5,
      0.5 * math.sin(time * hueSpeed + baseAngle + math.pi * 4 / 3) + 0.5
    )

    -- Animate position (circular/elliptical paths with different speeds and heights)
    local posX = math.cos(time * speedFactor + baseAngle) * radius
    local posZ = -6 + math.sin(time * speedFactor * 1.2 + baseAngle) * radius   -- Elliptical variation
    local posY = 1.5 + math.cos(time * speedFactor * 0.8 + baseAngle * 2) * 0.5 -- Bobbing variation

    Scene.systems.TransformSystem.setPosition(light.Transform, Vec3(posX, posY, posZ))
  end

  Scene.world:update(dt)
end

function Scene.draw(pass)
  Scene.systems.PlayerMotionSystem.transform(pass)
  Scene.systems.RenderSystem.draw(pass)
  pass:setShader()

  -- Draw light 1 visualization
  pass:setColor(
    pointLight1.Light.color.x,
    pointLight1.Light.color.y,
    pointLight1.Light.color.z
  )
  pass:sphere(
    pointLight1.Transform.position.x,
    pointLight1.Transform.position.y,
    pointLight1.Transform.position.z,
    0.1,
    Quat()
  )

  -- Draw light 2 visualization
  pass:setColor(
    pointLight2.Light.color.x,
    pointLight2.Light.color.y,
    pointLight2.Light.color.z
  )
  pass:sphere(
    pointLight2.Transform.position.x,
    pointLight2.Transform.position.y,
    pointLight2.Transform.position.z,
    0.1,
    Quat()
  )

  -- Draw visualizations for lights 3-16
  for i = 3, 16 do
    local light = additionalLights[i]
    pass:setColor(
      light.Light.color.x,
      light.Light.color.y,
      light.Light.color.z
    )
    pass:sphere(
      light.Transform.position.x,
      light.Transform.position.y,
      light.Transform.position.z,
      0.08, -- Slightly smaller sphere for these
      Quat()
    )
  end
end

return Scene
