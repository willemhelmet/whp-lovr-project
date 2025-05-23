-- src/systems/locomotion-system.lua

local tiny = require 'lib.tiny'

local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local InputSystem = require 'src.systems.input-system'
local Settings = require 'config.settings'

local LocomotionSystem = tiny.processingSystem(class('Locomotion System'))
LocomotionSystem.filter = tiny.requireAll('PlayerLocomotion')

function LocomotionSystem:process(e, dt)
  local motion = e.PlayerLocomotion
  -- Toggle between flying and walking mode
  if InputSystem:getValue('grabLeft') == 1 then
    motion.flying = true
  else
    motion.flying = false
    local height = vec3(LocomotionSystem:getPose()).y
    LocomotionSystem:getPose():translate(0, -height, 0)
  end

  -- Toggle between snap and smooth turning
  if InputSystem:getValue('grabRight') == 1 then
    LocomotionSystem:snap(e, dt)
  else
    LocomotionSystem:smooth(e, dt)
  end
  -- Teleportation determining target position and executing jump when triggered
  local handPose = mat4(motion.pose):mul(mat4(MotionTrackingSystem.getPose('hand/left/point')))
  local handPosition = vec3(handPose)
  local handDirection = quat(handPose):direction()
  -- Intersect with ground plane
  local ratio = vec3(handPose).y / handDirection.y
  local intersectionDistance = math.sqrt(handPosition.y ^ 2 + (handDirection.x * ratio) ^ 2 +
    (handDirection.z * ratio) ^ 2)
  motion.targetPosition:set(handPose:translate(0, 0, -intersectionDistance))
  -- Check if target position is a valid teleport target
  motion.teleportValid = motion.targetPosition.y < handPosition.y and
      (handPosition - motion.targetPosition):length() < motion.teleportDistance
  -- Construct teleporter visualization curve
  local midPoint = vec3(handPosition):lerp(motion.targetPosition, 0.3)
  if motion.teleportValid then
    midPoint:add(vec3(0, 0.1 * intersectionDistance, 0)) -- Fake a parabola
  end
  motion.teleportCurve:setPoint(1, handPosition)
  motion.teleportCurve:setPoint(2, midPoint)
  motion.teleportCurve:setPoint(3, motion.targetPosition)
  -- Start timer when jump is triggered, preform jump on half-blink
  if InputSystem:getValue('triggerRight') then
    if InputSystem:getValue('triggerRight') == 1 and motion.teleportValid then
      motion.blinkStopwatch = -motion.blinkTime / 2
    end
  end
  -- Preform jump with VR pose offset by relative distance between here and there
  if motion.blinkStopwatch < 0 and
      motion.blinkStopwatch + dt >= 0 then
    local headsetXZ = vec3(MotionTrackingSystem.getPosition('head'))
    headsetXZ.y = 0
    local newPosition = motion.targetPosition - headsetXZ
    motion.pose:set(newPosition, vec3(1, 1, 1), quat(motion.pose)) -- ZAAPP
  end
  motion.blinkStopwatch = motion.blinkStopwatch + dt
  motion.thumbstickCooldown = motion.thumbstickCooldown - dt
end

function LocomotionSystem:smooth(e, dt)
  local motion = e.PlayerLocomotion
  local turnAmount = InputSystem:getValue('turn').x
  -- Smooth horizontal turning
  if math.abs(turnAmount) > Settings.thumbStickDeadzone then
    motion.pose:rotate(-turnAmount * motion.turningSpeed * dt, 0, 1, 0)
  end

  if MotionTrackingSystem.isTracked('left') then
    local moveAmount
    if InputSystem:getValue('move') then
      moveAmount = InputSystem:getValue('move')
      local direction = quat(MotionTrackingSystem.getOrientation(motion.directionFrom)):direction()
      if not motion.flying then
        direction.y = 0
      end
      -- Smooth strafe movement
      if math.abs(moveAmount.x) > Settings.thumbStickDeadzone then
        local strafeVector = quat(-math.pi / 2, 0, 1, 0):mul(vec3(direction))
        motion.pose:translate(strafeVector * moveAmount.x * motion.walkingSpeed * dt)
      end
      -- Smooth Forward/backward movement
      if math.abs(moveAmount.y) > Settings.thumbStickDeadzone then
        motion.pose:translate(direction * moveAmount.y * motion.walkingSpeed * dt)
      end
    end
  end
end

function LocomotionSystem:snap(e, dt)
  local motion = e.PlayerLocomotion
  -- Snap horizontal turning
  local x = InputSystem:getValue('turn').x
  if math.abs(x) > motion.thumbstickDeadzone and motion.thumbstickCooldown < 0 then
    local angle = -x / math.abs(x) * motion.snapTurnAngle
    motion.pose:rotate(angle, 0, 1, 0)
    motion.thumbstickCooldown = motion.thumbstickCooldownTime
  end
  -- end
  -- Dashing forward/backward
  if InputSystem:getValue('move') then
    local moveAmount = InputSystem:getValue('move')
    if math.abs(moveAmount.y) > motion.thumbstickDeadzone and motion.thumbstickCooldown < 0 then
      local moveVector = quat(MotionTrackingSystem.getOrientation('head'):direction())
      if not motion.flying then
        moveVector.y = 0
      end
      moveVector:mul(moveAmount.y / math.abs(moveAmount.y) * motion.dashDistance)
      motion.pose:translate(moveVector)
      motion.thumbstickCooldown = motion.thumbstickCooldownTime
    end
  end
  motion.thumbstickCooldown = motion.thumbstickCooldown - dt
end

function LocomotionSystem:drawTeleport(pass)
  local entities = self.entities
  if #entities > 0 and entities[1].PlayerLocomotion then
    local motion = entities[1].PlayerLocomotion
    -- Teleport target and curve
    pass:setColor(1, 1, 1, 0.1)
    if motion.teleportValid then
      pass:setColor(1, 1, 0)
      pass:cylinder(motion.targetPosition, 0.4, 0.05, math.pi / 2, 1, 0, 0)
      pass:setColor(1, 1, 1)
    end
    pass:line(motion.teleportCurve:render(30))
    -- Teleport blink, modeled as gaussian function
    local blinkAlpha = math.exp(-(motion.blinkStopwatch / 0.25 / motion.blinkTime) ^ 2)
    pass:setColor(0, 0, 0, blinkAlpha)
    pass:fill()
  end
end

function LocomotionSystem:getPose()
  if self.entities and self.entities[1] then
    return self.entities[1].PlayerLocomotion.pose
  else
    return Mat4()
  end
end

return LocomotionSystem
