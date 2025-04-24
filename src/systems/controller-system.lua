-- src/systems/controller-system.lua

local tiny = require 'lib.tiny'

local ControllerSystem = tiny.processingSystem(class('Controller System'))
ControllerSystem.filter = tiny.requireAny("Hand")

local LocomotionSystem = require 'src.systems.locomotion-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'

function ControllerSystem:onAdd(e)
  if e.Hand == 'left' or e.Hand == 'hand/left' then
    self.leftController = e
  elseif e.Hand == 'right' or e.Hand == 'hand/right' then
    self.rightController = e
  end
end

function ControllerSystem:process(e)
  if LocomotionSystem:getPose() then
    for _, hand in ipairs(ControllerSystem:getControllers()) do
      -- Whenever pose of hand or head is used, need to account for VR movement
      local poseRW = mat4(MotionTrackingSystem.getPose(hand))
      local poseVR = mat4(LocomotionSystem:getPose()):mul(poseRW)
      -- poseVR:scale(radius)
      if hand == 'hand/left' then
        self.leftController.Transform:setPose(poseVR)
      elseif hand == 'hand/right' then
        self.rightController.Transform:setPose(poseVR)
      end
    end
  end
end

function ControllerSystem:getControllers()
  return { self.leftController and 'hand/left' or nil, self.rightController and 'hand/right' or nil }
end

return ControllerSystem
