-- src/entities/player.lua
local lovr = require 'lovr'

local Player = {
  Pose = lovr.math.newMat4(),
  Velocity = lovr.math.newVec3(0, 0, 0),
}

return Player
