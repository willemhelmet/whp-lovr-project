-- src/systems/locomotion-system.lua

local tiny = require 'lib.tiny'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local InputSystem = require 'src.systems.input-system'
local Settings = require 'config.settings'

local TeleportSystem = tiny.processingSystem(class('Teleport System'))
TeleportSystem.filter = tiny.requireAll('PlayerLocomotion')

function TeleportSystem:init()
  self.motion = nil
end

function TeleportSystem:onAdd(e)
  self.motion = e.PlayerLocomotion
end

function TeleportSystem:process(e, dt)
  -- Toggle between flying and walking mode
  if InputSystem:getValue('grabLeft') == 1 then
    self.motion.flying = true
  else
    self.motion.flying = false
    local height = vec3(TeleportSystem:getPose()).y
    TeleportSystem:getPose():translate(0, -height, 0)
  end

  -- Toggle between snap and smooth turning
  if InputSystem:getValue('grabRight') == 1 then
    TeleportSystem:snap(dt)
  else
    TeleportSystem:smooth(dt)
  end
  -- Teleportation determining target position and executing jump when triggered
  local handPose = mat4(self.motion.pose):mul(mat4(MotionTrackingSystem.getPose('hand/left/point')))
  local handPosition = vec3(handPose)
  local handDirection = quat(handPose):direction()
  -- Intersect with ground plane
  local ratio = vec3(handPose).y / handDirection.y
  local intersectionDistance = math.sqrt(handPosition.y ^ 2 + (handDirection.x * ratio) ^ 2 +
    (handDirection.z * ratio) ^ 2)
  self.motion.targetPosition:set(handPose:translate(0, 0, -intersectionDistance))
  -- Check if target position is a valid teleport target
  self.motion.teleportValid = self.motion.targetPosition.y < handPosition.y and
      (handPosition - self.motion.targetPosition):length() < self.motion.teleportDistance
  -- Construct teleporter visualization curve
  local midPoint = vec3(handPosition):lerp(self.motion.targetPosition, 0.3)
  if self.motion.teleportValid then
    midPoint:add(vec3(0, 0.1 * intersectionDistance, 0)) -- Fake a parabola
  end
  self.motion.teleportCurve:setPoint(1, handPosition)
  self.motion.teleportCurve:setPoint(2, midPoint)
  self.motion.teleportCurve:setPoint(3, self.motion.targetPosition)
  -- Start timer when jump is triggered, preform jump on half-blink
  if InputSystem:getValue('triggerRight') then
    if InputSystem:getValue('triggerRight') == 1 and self.motion.teleportValid then
      self.motion.blinkStopwatch = -self.motion.blinkTime / 2
    end
  end
  -- Preform jump with VR pose offset by relative distance between here and there
  if self.motion.blinkStopwatch < 0 and
      self.motion.blinkStopwatch + dt >= 0 then
    local headsetXZ = vec3(MotionTrackingSystem.getPosition('head'))
    headsetXZ.y = 0
    local newPosition = self.motion.targetPosition - headsetXZ
    self.motion.pose:set(newPosition, vec3(1, 1, 1), quat(self.motion.pose)) -- ZAAPP
  end
  self.motion.blinkStopwatch = self.motion.blinkStopwatch + dt
  self.motion.thumbstickCooldown = self.motion.thumbstickCooldown - dt
end

function TeleportSystem:drawTeleport(pass)
  -- Teleport target and curve
  pass:setColor(1, 1, 1, 0.1)
  if self.motion.teleportValid then
    pass:setColor(1, 1, 0)
    pass:cylinder(self.motion.targetPosition, 0.4, 0.05, math.pi / 2, 1, 0, 0)
    pass:setColor(1, 1, 1)
  end
  pass:line(self.motion.teleportCurve:render(30))
  -- Teleport blink, modeled as gaussian function
  local blinkAlpha = math.exp(-(self.motion.blinkStopwatch / 0.25 / self.motion.blinkTime) ^ 2)
  pass:setColor(0, 0, 0, blinkAlpha)
  pass:fill()
end

function TeleportSystem:smooth(dt)
  local turnAmount = InputSystem:getValue('turn').x
  -- Smooth horizontal turning
  if math.abs(turnAmount) > Settings.thumbStickDeadzone then
    self.motion.pose:rotate(-turnAmount * self.motion.turningSpeed * dt, 0, 1, 0)
  end

  if MotionTrackingSystem.isTracked('left') then
    local moveAmount
    if InputSystem:getValue('move') then
      moveAmount = InputSystem:getValue('move')
      local direction = quat(MotionTrackingSystem.getOrientation(self.motion.directionFrom)):direction()
      if not self.motion.flying then
        direction.y = 0
      end
      -- Smooth strafe movement
      if math.abs(moveAmount.x) > Settings.thumbStickDeadzone then
        local strafeVector = quat(-math.pi / 2, 0, 1, 0):mul(vec3(direction))
        self.motion.pose:translate(strafeVector * moveAmount.x * self.motion.walkingSpeed * dt)
      end
      -- Smooth Forward/backward movement
      if math.abs(moveAmount.y) > Settings.thumbStickDeadzone then
        self.motion.pose:translate(direction * moveAmount.y * self.motion.walkingSpeed * dt)
      end
    end
  end
end

function TeleportSystem:snap(dt)
  -- Snap horizontal turning
  local x = InputSystem:getValue('turn').x
  if math.abs(x) > self.motion.thumbstickDeadzone and self.motion.thumbstickCooldown < 0 then
    local angle = -x / math.abs(x) * self.motion.snapTurnAngle
    self.motion.pose:rotate(angle, 0, 1, 0)
    self.motion.thumbstickCooldown = self.motion.thumbstickCooldownTime
  end
  -- end
  -- Dashing forward/backward
  if InputSystem:getValue('move') then
    local moveAmount = InputSystem:getValue('move')
    if math.abs(moveAmount.y) > self.motion.thumbstickDeadzone and self.motion.thumbstickCooldown < 0 then
      local moveVector = quat(MotionTrackingSystem.getOrientation('head'):direction())
      if not self.motion.flying then
        moveVector.y = 0
      end
      moveVector:mul(moveAmount.y / math.abs(moveAmount.y) * self.motion.dashDistance)
      self.motion.pose:translate(moveVector)
      self.motion.thumbstickCooldown = self.motion.thumbstickCooldownTime
    end
  end
  self.motion.thumbstickCooldown = self.motion.thumbstickCooldown - dt
end

function TeleportSystem:getPose()
  if self.entities and self.entities[1] then
    return self.entities[1].PlayerLocomotion.pose
  else
    return Mat4()
  end
end

return TeleportSystem
