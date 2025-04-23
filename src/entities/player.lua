-- src/entities/player.lua

-- WHP: is this used anymore??
-- no it is not
local class = require 'lib.30log'
local TransformComponent = require 'src.components.transform-component'
local TeleportComponent = require 'src.components.teleport-component'
local PlayerLocomotionComponent = require 'src.components.player-locomotion'

local Player = class('Player')

function Player:init(options)
  options = options or {}
  self.Player = {}
  self.Pose = options.Pose or Mat4()
  self.Transform = options.Transform or TransformComponent()
  self.Velocity = options.Velocity or Vec3(0, 0, 0)
  self.Teleport = options.Teleport or TeleportComponent()
  self.PlayerLocomotion = options.PlayerLocomotion or PlayerLocomotionComponent()
end

function Player:getPose()
  return self.Pose
end

return Player
