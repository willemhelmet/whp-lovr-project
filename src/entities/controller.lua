-- src/entities/controller.lua
local lovr = require 'lovr'

local Controller = {
  Pose = {
    left = {},
    right = {}
  },
  Collider = {
    left = {
      size = lovr.math.vec3(0.25, 0.25, 0.25),
      kinematic = true,
      collider = nil
    },
    right = {
      size = lovr.math.vec3(0.25, 0.25, 0.25),
      kinematic = true,
      collider = nil
    }
  },
  shouldShowCollider = true
}

return Controller
