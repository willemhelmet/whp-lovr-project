-- src/entities/controller.lua
local lovr = require 'lovr'

local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local MotionTrackingComponent = require 'src.components.motion-tracking-component'
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
    Mesh = MeshComponent.new('/assets/models/controller-' .. hand .. '.glb'),
    Material = MaterialComponent.new(nil, {}),
    MotionTracking = MotionTrackingComponent.new(hand)
    -- TODO: Create PhysicsComponent initializer
    -- Physics = {
    --   body = nil,                    -- lovr.physics.Body object
    --   shape = nil,                   -- lovr.physics.Shape object
    --   mass = 1,                      -- Mass of the object
    --   restitution = 0,               -- Bounciness
    --   friction = 0.5,                -- Surface friction
    --   linearVelocity = { 0, 0, 0 },  -- Current linear velocity
    --   angularVelocity = { 0, 0, 0 }, -- Current angular velocity
    --   isStatic = true,               -- Whether the object is static (kinematic)
    --   isSensor = false               -- Whether the object is a sensor (no collisions)
    -- },
  }
end

return Controller
