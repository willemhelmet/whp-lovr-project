-- src/entities/controller.lua

local lovr = require 'lovr'

local Controller = {
  Poses = {
    left = lovr.math.newMat4(),
    right = lovr.math.newMat4(),
  },
  Models = {
    left = lovr.graphics.newModel("/assets/models/controller-left.glb"),
    right = lovr.graphics.newModel("/assets/models/controller-right.glb")
  }
}

return Controller
