-- src/scenes/setup-transform.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
-- entities
local Grid = require 'src.entities.grid'
local Player = require 'src.entities.player'
local Controller = require 'src.entities.controller'
local Box = require 'src.entities.box'
-- components
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local TextComponent = require 'src.components.text-component'
-- systems
local RenderSystem = require 'src.systems.render-system'
local PlayerMotionSystem = require 'src.systems.player-motion-system'
local InputSystem = require 'src.systems.input-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local TransformSystem = require 'src.systems.transform-system'
-- assets
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

SetupTransform = {}
SetupTransform.tiny = tiny.world(TransformSystem, MotionTrackingSystem, RenderSystem)

local boxParent = Box({
  Transform = TransformComponent(
    Vec3(0, 1.5, -4),
    Quat(1, 0, 0, 0),
    Vec3(1, 1, 1)
  ),
  Material = MaterialComponent(UnlitColorMaterial, { color = Vec3(.4, .2, 1) })
})
local boxChild = Box({
  Transform = TransformComponent(
    Vec3(0, 2.6, -4),
    Quat(1, 0, 0, 0),
    Vec3(1, 0.25, 1)
  ),
  Material = MaterialComponent(UnlitColorMaterial, { color = Vec3(1, 1, 1) })
})

function SetupTransform.init()
  SetupTransform.tiny:addEntity(Grid())
  TransformSystem.addChild(boxParent.Transform, boxChild.Transform)
  SetupTransform.tiny:addEntity(boxParent)
  SetupTransform.tiny:addEntity(boxChild)
end

function SetupTransform.animateFloatingSquare()
  TransformSystem.setPosition(boxParent.Transform, Vec3(math.sin(lovr.headset.getTime()), 1.5, -4))
  TransformSystem.setOrientation(boxParent.Transform,
    Quat(lovr.headset.getTime(), 0, 1, math.sin(lovr.headset.getTime())))
  local scale = 0.25 * math.sin(lovr.headset.getTime()) + 0.75
  TransformSystem.setScale(boxParent.Transform, Vec3(scale, scale, scale))
  SetupTransform.tiny:addEntity(boxParent)
end

function SetupTransform.update(dt)
  SetupTransform.animateFloatingSquare()
  SetupTransform.tiny:update(dt)
end

function SetupTransform.draw(pass)
  RenderSystem.draw(pass)
  pass:setShader()
  pass:text('setup transform', 0, 1.5, -2, 0.25)
end

return SetupTransform
