-- src/entities/controller.lua
local lovr = require 'lovr'

local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local MotionTrackingComponent = require 'src.components.motion-tracking-component'
local PhysicsComponent = require 'src.components.physics-component'
local TransformComponent = require 'src.components.transform-component'

local Controller = {
  Controller = {},
  Transform = nil,
  Physics = nil,
  MotionTracking = nil,
  Render = nil
}

function Controller.new(hand)
  assert(
    hand == "left" or
    hand == "right" or
    'Hand must be "left" or "right"'
  )

  return {
    Controller = {},
    Transform = TransformComponent.new(0, 0, 0, 0, 0, 0, 0, 1, 1, 1),
    Mesh = MeshComponent.new('/assets/models/quest-' .. hand .. '.glb'),
    Material = MaterialComponent.new(nil, {}),
    MotionTracking = MotionTrackingComponent.new(hand),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      friction = 1.0,
      shapes = {
        {
          type = 'sphere',
          radius = 0.0625
        }
      }
    })
  }
end

return Controller
