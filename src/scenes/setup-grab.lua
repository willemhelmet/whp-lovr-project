--src/scenes/setup-grab.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'
local Box = require 'src.entities.box'
local GrabTextEntity = {}
local GrabbableBox = {}
local Table = require 'src.entities.table'

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

local GrabSetup = {}
GrabSetup.world = tiny.world(InputSystem, PhysicsSystem, MotionTrackingSystem, RenderSystem, GrabSystem)

function GrabSetup.init()
  GrabSetup.world:addEntity(Grid.new())
  GrabSetup.world:addEntity(Controller.new('left'))
  GrabSetup.world:add(table.unpack(Table.new({ 0, 0, -2 })))

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
