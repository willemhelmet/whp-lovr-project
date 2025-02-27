-- src/entities/controller.lua
local lovr = require 'lovr'

local Controller = {
  Pose = {
    left = {
      x = 0,
      y = 0,
      z = 0,
      angle = 0,
      ax = 0,
      ay = 0,
      az = 0
    },
    right = {
      x = 0,
      y = 0,
      z = 0,
      angle = 0,
      ax = 0,
      ay = 0,
      az = 0
    }
  },
  Model = {
    left = lovr.graphics.newModel("/assets/models/controller-left.glb"),
    right = lovr.graphics.newModel("/assets/models/controller-right.glb")
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
  }
}

return Controller
