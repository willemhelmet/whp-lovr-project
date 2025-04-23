-- src/entities/controller.lua

local Controller = class('Controller')

local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
-- local MotionTrackingComponent = require 'src.components.motion-tracking-component'
local PhysicsComponent = require 'src.components.physics-component'
local TransformComponent = require 'src.components.transform-component'

function Controller:init(hand)
  assert(
    hand == 'left' or
    hand == 'hand/left' or
    hand == 'right' or
    hand == 'hand/right',
    'Hand must be "left" or "right"'
  )
  self.Hand = hand
  self.Transform = TransformComponent()
  self.Pose = Mat4()
  self.Mesh = MeshComponent('/assets/models/quest-' .. hand .. '.glb')
  self.Material = MaterialComponent(nil, {})
  -- AI: The motion tracking system conflicts with moving the controllers in VR
  -- self.MotionTracking = MotionTrackingComponent(hand)
  self.Physics = PhysicsComponent({
    isKinematic = true,
    friction = 1.0,
    tag = "controller",
    shapes = {
      {
        type = 'sphere',
        radius = 0.0625
      }
    }
  })
end

return Controller
