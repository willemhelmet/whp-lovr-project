-- src/systems/motion-tracking-system.lua
--
-- Motion Tracking System: Updates entity transforms based on VR device tracking.
-- Synchronizes the position and orientation of in-game entities with real-world
-- VR controller or headset movements.
-- Essential for controller representation and hand presence in VR.

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

local MotionTracking = tiny.processingSystem()
MotionTracking.filter = tiny.requireAll("Transform", "MotionTracking")

function MotionTracking:process(e, dt)
  local transform = e.Transform
  local motionTracking = e.MotionTracking
  local hand = motionTracking.hand

  if (lovr.headset.isTracked(hand)) then
    transform.position = { lovr.headset.getPosition(hand) }
    transform.orientation = { lovr.headset.getOrientation(hand) }
  end
end

return MotionTracking
