-- src/components/player-locomotion.lua

local PlayerLocomotion = class('Player Locomotion')

local Settings = require 'config.settings'

function PlayerLocomotion:init()
  self.pose = Mat4()
  self.thumbstickDeadzone = Settings.thumbStickDeadzone
  self.directionFrom = Settings.forwardDirectionFrom
  self.flying = false
  -- Snap Turning
  self.snapTurnAngle = Settings.snapTurnAngle
  self.dashDistance = 1.5
  self.thumbstickCooldownTime = 0.3
  self.thumbstickCooldown = 0
  -- Smooth Motion
  self.turningSpeed = Settings.smoothTurnSpeed
  self.walkingSpeed = 4
  -- Blink Teleport
  self.targetPosition = Vec3()
  self.teleportDistance = 12
  self.blinkTime = 0.15
  self.blinkStopwatch = math.huge
  self.teleportValid = false
  self.teleportCurve = lovr.math.newCurve(3)
end

return PlayerLocomotion
