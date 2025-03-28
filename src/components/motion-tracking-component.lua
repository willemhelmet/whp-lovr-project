-- src/components/motion-tracking-component.lua
--
-- Motion Tracking Component: Links an entity to a VR tracking device.
-- Identifies which hand/controller this entity follows.
-- Used by the Motion Tracking System to synchronize virtual objects
-- with real-world VR controller movements.

local lovr = require 'lovr'

local MotionTrackingComponent = {}

function MotionTrackingComponent.new(device)
  return {
    device = device
  }
end

return MotionTrackingComponent
