-- src/systems/player-motion-system.lua
local tiny = require 'lib.tiny'
local lovr = require 'lovr'
local Input = require 'src.core.input'
local Settings = require 'config.settings'
local quat = require 'lib.cpml.modules.quat'

local PlayerMotionSystem = tiny.processingSystem()
PlayerMotionSystem.filter = tiny.requireAll("Pose")

-- Store previous velocity as a static variable
local previousVelocity = lovr.math.newVec3(0, 0, 0)

function PlayerMotionSystem:process(e, dt)
  local pose = e.Pose
  -- Initialize or get velocity component
  if not e.Velocity then
    e.Velocity = lovr.math.vec3(0, 0, 0)
  end
  local velocity = e.Velocity

  -- Handle smooth turning
  if Settings.turnStyle == "smooth" then
    local turnAmount = Input.getValue('smoothTurn')
    if math.abs(turnAmount.x) > Settings.deadzone then
      local turnSpeed = e.turningSpeed or (2 * math.pi * 1 / 6)
      local rotationAngle = -turnAmount.x * turnSpeed * dt
      local rotationQuat = lovr.math.quat(rotationAngle, 0, 1, 0)
      pose:rotate(rotationQuat)
    end
  elseif Settings.turnStyle == "snap" then
    -- TODO:
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
