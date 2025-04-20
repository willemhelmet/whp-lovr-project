-- src/scenes/setup-teleportation.lua

-- TODO: this whole Scene setup seems like a great opportunity to use OOP!
--      The Scene class can have all of these components and systems
--      already setup, so all i need to do is create an instance
--      of the Scene class whenever I want to create a new level

-- lib
local tiny = require 'lib.tiny'
local Settings = require 'config.settings'
-- scene
local Scene = {}
Scene.world = tiny.world()
-- entities
local Grid = require 'src.entities.grid'
local Box = require 'src.entities.box'
local Controller = require 'src.entities.controller'
local InputDebug = require 'src.entities.input-debug-entity'
local leftController
-- components
-- systems
local RenderSystem = require 'src.systems.render-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local InputSystem = require 'src.systems.input-system'
local ControllerSystem = require 'src.systems.controller-system'
-- assets

local motion = {
  pose = Mat4(),                                 -- Transformation in VR initialized to origin (0,0,0) looking down -Z
  thumbstickDeadzone = Settings.deadzone,        -- Smaller thumbstick displacements are ignored (too much noise)
  directionFrom = Settings.forwardDirectionFrom, -- Movement can be relative to orientation of head or left controller
  flying = false,
  -- Snap motion parameters
  snapTurnAngle = Settings.snapTurnAngle,
  dashDistance = 1.5,
  thumbstickCooldownTime = 0.3,
  thumbstickCooldown = 0,
  -- Smooth motion parameters
  turningSpeed = Settings.smoothTurnSpeed,
  walkingSpeed = 4,
  -- Teleport motion parameters
  teleportDistance = 12,
  blinkTime = 0.15,
  blinkStopwatch = math.huge,
  teleportValid = false,
  targetPosition = Vec3(),
  teleportCurve = lovr.math.newCurve(3),
}

function motion.teleport(dt)
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

function motion.drawTeleport(pass)
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

function motion.smooth(dt)
  -- if MotionTrackingSystem.isTracked('right') then
  local x = InputSystem:getValue('turn').x
  -- Smooth horizontal turning
  if math.abs(x) > motion.thumbstickDeadzone then
    motion.pose:rotate(-x * motion.turningSpeed * dt, 0, 1, 0)
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
      if math.abs(moveAmount.x) > motion.thumbstickDeadzone then
        local strafeVector = quat(-math.pi / 2, 0, 1, 0):mul(vec3(direction))
        motion.pose:translate(strafeVector * moveAmount.x * motion.walkingSpeed * dt)
      end
      -- Smooth Forward/backward movement
      if math.abs(moveAmount.y) > motion.thumbstickDeadzone then
        motion.pose:translate(direction * moveAmount.y * motion.walkingSpeed * dt)
      end
    end
  end
end

function motion.snap(dt)
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

function Scene.init()
  for i, system in ipairs(require 'src.core.system-registry') do
    Scene.world:add(system[1])
    tiny.setSystemIndex(Scene.world, system[1], i)
  end

  leftController = Controller('left')
  Scene.world:add(leftController)
  Scene.world:add(table.unpack(InputDebug().entities))
  Scene.world:add(Grid())
end

function Scene.update(dt)
  motion.teleport(dt)
  local poseRW = mat4(MotionTrackingSystem.getPose('left'))
  local poseVR = mat4(motion.pose):mul(poseRW)
  leftController.Transform:setPose(poseVR)
  Scene.world:update(dt)
  if InputSystem:getValue('grabLeft') == 1 then
    motion.flying = true
  else
    motion.flying = false
    local height = vec3(motion.pose).y
    motion.pose:translate(0, -height, 0)
  end
  if InputSystem:getValue('grabRight') == 1 then
    motion.snap(dt)
  else
    motion.smooth(dt)
  end
end

function Scene.draw(pass)
  pass:transform(mat4(motion.pose):invert())
  RenderSystem.draw(pass)
  -- Render hands
  if InputSystem:getValue('grabRight') == 1 or motion.flying then
    pass:setColor(0, InputSystem:getValue('grabRight'), motion.flying and 1 or 0)
  else
    pass:setColor(1, 1, 1)
  end
  local radius = 0.05
  for _, hand in ipairs(ControllerSystem:getControllers()) do
    -- Whenever pose of hand or head is used, need to account for VR movement
    local poseRW = mat4(MotionTrackingSystem.getPose(hand))
    local poseVR = mat4(motion.pose):mul(poseRW)
    poseVR:scale(radius)
    if hand == 'hand/left' then
      -- TODO: for some reason I cannot currently get the contorllers to follow the pose
      leftController.Transform:setPose(poseVR)
    end
  end
  pass:setShader()
  motion.drawTeleport(pass)
end

return Scene
