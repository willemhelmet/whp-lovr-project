-- src/components/motion-tracking-component.lua

local MotionTrackingComponent = class('Motion Tracking')

function MotionTrackingComponent:init(device)
  self.device = device
end

return MotionTrackingComponent
