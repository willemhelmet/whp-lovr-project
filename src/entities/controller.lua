-- src/entities/controller.lua
local lovr = require 'lovr'

local Controller = {
  Controller = {},
  Pose = {
    left = {},
    right = {}
  },
  shouldShowCollider = true,
  Transform = nil,
  Physics = nil,
  hand = nil
}

function Controller.new(hand)
  assert(hand == "left" or hand == "right", "Hand must be 'left' or 'right'")

  local entity = {
    Controller = {},
    Pose = {
      left = {},
      right = {}
    },
    shouldShowCollider = true,
    Transform = {
      position = { 0, 0, 0 },       -- x, y, z
      orientation = { 0, 0, 0, 0 }, -- angle, ax, ay, az
      scale = { 1, 1, 1 }           -- x, y, z
    },
    Physics = {
      body = nil,                    -- lovr.physics.Body object
      shape = nil,                   -- lovr.physics.Shape object
      mass = 1,                      -- Mass of the object
      restitution = 0,               -- Bounciness
      friction = 0.5,                -- Surface friction
      linearVelocity = { 0, 0, 0 },  -- Current linear velocity
      angularVelocity = { 0, 0, 0 }, -- Current angular velocity
      isStatic = true,               -- Whether the object is static (kinematic)
      isSensor = false,              -- Whether the object is a sensor (no collisions)
    },
    hand = hand
  }
  return entity
end

return Controller
