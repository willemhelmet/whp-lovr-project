-- src/systems/player-motion-system.lua
--
-- Player Motion System: Controls player movement and rotation in the VR environment.
-- Handles locomotion input (joystick/thumbstick), applies movement in the direction
-- of gaze or controller orientation, and manages turning (smooth or snap).
-- Provides the core navigation capabilities for the VR experience.

-- lib
local tiny = require 'lib.tiny'
local lovr = require 'lovr'
local vec3 = lovr.math.vec3
local Vec3 = lovr.math.newVec3
local Mat4 = lovr.math.newMat4
local mat4 = lovr.math.mat4
local pretty = require 'lib.pl.pretty'
-- components
local TransformComponent = require 'src.components.transform-component'
-- systems
local InputSystem = require 'src.systems.input-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local TransformSystem = require 'src.systems.transform-system'
-- etc
local Settings = require 'config.settings'

local PlayerMotionSystem = tiny.processingSystem()
PlayerMotionSystem.filter = tiny.requireAny("Player", "VRRig")

-- Keep snapTurn flag outside of update
local hasTurned = false
local vrRig = nil

function PlayerMotionSystem:onAdd(e)
  if not vrRig then
    vrRig = e
  end
end

function PlayerMotionSystem:process(e, dt)
  local transform = e.Transform

  local playerPose = mat4()
  playerPose:translate(transform.localPosition)
  playerPose:rotate(transform.localOrientation)

  -- Initialize or get velocity component
  if not e.Velocity then
    e.Velocity = Vec3(0, 0, 0)
  end
  local velocity = e.Velocity

  -- Handle turning
  local turnAmount
  if InputSystem:getValue('turn') then
    turnAmount = InputSystem:getValue('turn').x
  end
  local AIRotationQuat = quat()
  if Settings.turnStyle == "smooth" then
    -- WHP: I'm not in love with the fact that 'turn' is a vector2 that i
    --      need to extract the correct axis from
    if turnAmount and math.abs(turnAmount) > Settings.deadzone then
      local turnSpeed = Settings.smoothTurnSpeed or (2 * math.pi * 1 / 6)
      local rotationAngle = -turnAmount * turnSpeed * dt
      local rotationQuat = lovr.math.quat(rotationAngle, 0, 1, 0)
      AIRotationQuat:set(rotationQuat)
      transform.localOrientation:mul(rotationQuat):normalize()
      -- local pos = vec3(transform.localPosition):add(vec3(lovr.headset.getPosition()))
      -- playerPose:translate(pos.x, 0, pos.z)
      -- playerPose:rotate(rotationQuat)
      -- playerPose:translate(-pos.x, 0, -pos.z)
    end
  elseif Settings.turnStyle == "snap" then
    -- WHP: I'm not in love with the fact that 'turn' is a vector2 that i
    --      need to extract the correct axis from
    if turnAmount and math.abs(turnAmount) > Settings.snapTurnThreshold and not hasTurned then
      local snapAngle = Settings.snapTurnAngle
      local turnDirection = turnAmount > 0 and 1 or -1
      local rotationAngle = -turnDirection * snapAngle
      local rotationQuat = lovr.math.quat(rotationAngle, 0, 1, 0)
      -- local pos = transform.position
      local pos = vec3(transform.position):add(vec3(lovr.headset.getPosition()))
      playerPose:translate(pos.x, 0, pos.z)
      playerPose:rotate(rotationQuat)
      playerPose:translate(-pos.x, 0, -pos.z)
      hasTurned = true
    elseif math.abs(turnAmount) < Settings.deadzone then -- prevent multiple turns
      hasTurned = false
    end
  end
  -- apply quaternion
  -- TransformSystem.setOrientation(transform, lovr.math.newQuat(playerPose:getOrientation()))

  -- Get movement input and head direction
  local moveAmount = nil
  if InputSystem:getValue("move") then
    moveAmount = InputSystem:getValue("move")
  end
  -- local headQuat = lovr.math.quat(lovr.headset.getOrientation('head'))
  local headQuat = transform.localOrientation
  local direction = lovr.math.newVec3(headQuat:direction())

  -- Calculate movement vector
  local movement = lovr.math.vec3(0, 0, 0)

  if moveAmount and math.abs(moveAmount.x) > Settings.deadzone or moveAmount and math.abs(moveAmount.y) > Settings.deadzone then
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
    velocity:lerp(Vec3(0, 0, 0), deceleration * dt)
  end

  -- get rid of y component
  velocity.y = 0

  -- Update player's position
  local newX = transform.position.x + velocity.x
  local newY = transform.position.y + velocity.y
  local newZ = transform.position.z + velocity.z
  TransformSystem.setPosition(transform, lovr.math.newVec3(newX, newY, newZ))
end

function PlayerMotionSystem.transform(pass)
  if vrRig then
    pass:transform(TransformSystem.toMat4(vrRig.Transform):invert())
  end
end

return PlayerMotionSystem
