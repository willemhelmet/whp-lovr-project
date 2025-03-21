-- src/systems/player-motion-system.lua
--
-- Player Motion System: Controls player movement and rotation in the VR environment.
-- Handles locomotion input (joystick/thumbstick), applies movement in the direction
-- of gaze or controller orientation, and manages turning (smooth or snap).
-- Provides the core navigation capabilities for the VR experience.

local tiny = require 'lib.tiny'
local lovr = require 'lovr'
local Input = require 'src.core.input'
local Settings = require 'config.settings'

local PlayerMotionSystem = tiny.processingSystem()
PlayerMotionSystem.filter = tiny.requireAll("Pose", "Velocity")

-- Store previous velocity as a static variable
local previousVelocity = lovr.math.newVec3(0, 0, 0)
-- Keep snapTurn flag outside of update
local hasTurned = false

function PlayerMotionSystem:process(e, dt)
  local pose = e.Pose
  -- Initialize or get velocity component
  if not e.Velocity then
    e.Velocity = lovr.math.vec3(0, 0, 0)
  end
  local velocity = e.Velocity

  -- Handle turning
  -- TODO: Turning currently breaks when the user is not above the origin of
  --       their tracking context. need to account for headset position.
  if Settings.turnStyle == "smooth" then
    -- returns a number from -1 to 1
    -- WHP: I'm not in love with the fact that 'turn' is a vector2 that i
    --      need to extract the correct axis from
    local turnAmount = Input.getValue('turn').x
    if math.abs(turnAmount) > Settings.deadzone then
      local turnSpeed = Settings.smoothTurnSpeed or (2 * math.pi * 1 / 6)
      local rotationAngle = -turnAmount * turnSpeed * dt
      local rotationQuat = lovr.math.quat(rotationAngle, 0, 1, 0)
      pose:rotate(rotationQuat)
    end
  elseif Settings.turnStyle == "snap" then
    -- WHP: I'm not in love with the fact that 'turn' is a vector2 that i
    --      need to extract the correct axis from
    local turnAmount = Input.getValue('turn').x
    if math.abs(turnAmount) > Settings.snapTurnThreshold and not hasTurned then
      local snapAngle = Settings.snapTurnAngle
      local turnDirection = turnAmount > 0 and 1 or -1
      local rotationAngle = -turnDirection * snapAngle
      local rotationQuat = lovr.math.quat(rotationAngle, 0, 1, 0)
      pose:rotate(rotationQuat)
      hasTurned = true
    elseif math.abs(turnAmount) < Settings.deadzone then -- prevent multiple turns
      hasTurned = false
    end
  end

  -- Get movement input and head direction
  local moveAmount = Input.getValue("move")
  local headQuat = lovr.math.quat(lovr.headset.getOrientation('head'))
  local direction = headQuat:direction()

  -- Calculate movement vector
  local movement = lovr.math.vec3(0, 0, 0)

  if math.abs(moveAmount.x) > Settings.deadzone or math.abs(moveAmount.y) > Settings.deadzone then
    -- Forward/backward movement
    if math.abs(moveAmount.y) > Settings.deadzone then
      local forward = direction * moveAmount.y
      movement:add(forward)
    end

    -- Strafe movement
    if math.abs(moveAmount.x) > Settings.deadzone then
      local right = direction:cross(lovr.math.vec3(0, 1, 0))
      local strafe = right * moveAmount.x
      movement:add(strafe)
    end

    -- Normalize movement if magnitude > 1
    if movement:length() > 1 then
      movement:normalize()
    end

    -- Apply walking speed
    local walkingSpeed = e.walkingSpeed or 4
    movement:mul(walkingSpeed * dt)

    -- Smooth acceleration
    local acceleration = 10.0 -- Adjust this value to change responsiveness
    velocity:lerp(movement, acceleration * dt)
  else
    -- Decelerate when no input
    local deceleration = 8.0 -- Adjust this value to change how quickly you stop
    velocity:lerp(lovr.math.vec3(0, 0, 0), deceleration * dt)
  end

  -- get rid of y component
  velocity.y = 0

  -- Apply movement
  pose:translate(velocity)

  -- Store velocity for next frame
  previousVelocity:set(velocity)
end

return PlayerMotionSystem
