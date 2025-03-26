-- src/entities/player.lua
local lovr = require 'lovr'

local TransformComponent = require 'src.components.transform-component'

local Player = {}

function Player.new(options)
  return {
    Name = "Player",
    Player = {},
    -- Pose = options.Pose or lovr.math.newMat4(),
    Transform = options.Transform or TransformComponent.new(),
    Velocity = options.Velocity or lovr.math.newVec3(0, 0, 0)
  }
end

return Player
