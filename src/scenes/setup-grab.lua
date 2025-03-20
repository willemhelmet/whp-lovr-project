--src/scenes/setup-grab.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'
local Box = require 'src.entities.box'
local GrabTextEntity = {}
local TitleTextEntity = {}
local GrabbableBox = {}

-- components
local TransformComponent = require 'src.components.transform-component'
local PhysicsComponent = require 'src.components.physics-component'
local MaterialComponent = require 'src.components.material-component'
local TextComponent = require 'src.components.text-component'
local GrabComponent = require 'src.components.grab-component'

-- systems
local PhysicsSystem = require 'src.systems.physics-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local RenderSystem = require 'src.systems.render-system'
local GrabSystem = require 'src.systems.grab-system'
local InputSystem = require 'src.systems.input-system'

-- assets
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

local GrabSetup = {}
GrabSetup.world = tiny.world(InputSystem, PhysicsSystem, MotionTrackingSystem, RenderSystem, GrabSystem)

function GrabSetup.init()
  GrabSetup.world:addEntity(Grid.new())
  GrabSetup.world:addEntity(Controller.new('left'))

  -- table
  GrabSetup.world:addEntity(Box.new({
    Transform = TransformComponent.new(0, 1, -2, 1, 0, 0, 0, 2, 0.1, 1),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      shapes = {
        {
          type = 'box',
          width = 2,
          height = 0.1,
          depth = 1
        }
      }
    }),
    Material = MaterialComponent.new(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
  }))
  GrabSetup.world:addEntity(Box.new({
    Transform = TransformComponent.new(-0.95, 0.475, -1.55, 1, 0, 0, 0, 0.1, 0.95, 0.1),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      shapes = {
        {
          type = 'box',
          width = 2,
          height = 0.1,
          depth = 1
        }
      }
    }),
    Material = MaterialComponent.new(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
  }))
  GrabSetup.world:addEntity(Box.new({
    Transform = TransformComponent.new(0.95, 0.475, -1.55, 1, 0, 0, 0, 0.1, 0.95, 0.1),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      shapes = {
        {
          type = 'box',
          width = 2,
          height = 0.1,
          depth = 1
        }
      }
    }),
    Material = MaterialComponent.new(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
  }))
  GrabSetup.world:addEntity(Box.new({
    Transform = TransformComponent.new(-0.95, 0.475, -2.45, 1, 0, 0, 0, 0.1, 0.95, 0.1),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      shapes = {
        {
          type = 'box',
          width = 2,
          height = 0.1,
          depth = 1
        }
      }
    }),
    Material = MaterialComponent.new(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
  }))
  GrabSetup.world:addEntity(Box.new({
    Transform = TransformComponent.new(0.95, 0.475, -2.45, 1, 0, 0, 0, 0.1, 0.95, 0.1),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      shapes = {
        {
          type = 'box',
          width = 2,
          height = 0.1,
          depth = 1
        }
      }
    }),
    Material = MaterialComponent.new(UnlitColorMaterial, { color = { 0.1, 0.1, 0.1 } })
  }))

  -- grabbable box
  GrabbableBox = Box.new({
    Transform = TransformComponent.new(0, 2, -2, 1, 0, 0, 0, 0.25, 0.25, 0.25),
    Physics = PhysicsComponent.new({
      isKinematic = false,
      shapes = {
        {
          type = 'box',
          width = 0.25,
          height = 0.25,
          depth = 0.25
        }
      }
    }),
    Grab = GrabComponent.new({
      offset = nil,
      grabRadius = 0.1,
      maintainPhysics = false,
      snapToHand = true,
      isGrabbed = false
    })
  })
  GrabSetup.world:addEntity(GrabbableBox)

  -- text
  TitleTextEntity = {
    Transform = TransformComponent.new(
      0, 1.5, -4
    ),
    Text = TextComponent.new(
      'setup grab system', 0.25
    )
  }
  GrabSetup.world:addEntity(TitleTextEntity)
  GrabTextEntity = {
    Transform = TransformComponent.new(
      0, 2, -4
    ),
    Text = TextComponent.new(
      'left grip: ', 0.25
    )
  }
  GrabSetup.world:addEntity(GrabTextEntity)
end

function GrabSetup.update(dt)
  GrabSetup.world:update(dt)
  GrabTextEntity.Text:setText('left grip: ' .. InputSystem:getValue('grabLeft'))
end

function GrabSetup.draw(pass)
  RenderSystem.draw(pass)
  -- PhysicsSystem.drawDebug(pass)
  -- pass:setShader()
end

return GrabSetup
