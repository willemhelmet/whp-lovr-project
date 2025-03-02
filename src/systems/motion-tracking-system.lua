-- src/systems/motion-tracking-system.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'tiny'

local MotionTracking = tiny.processingSystem()
MotionTracking.filter = tiny.require("Transform", "Controller")

function MotionTracking:process(e, dt)
  local transform = e.Transform
  local hand = e.hand
  if (lovr.headset.isTracked(hand)) then
    transform.position[1],
    transform.position[2],
    transform.position[3] = table.unpack(lovr.headset.getPosition(hand))
    transform.orientation[1],
    transform.orientation[2],
    transform.orientation[3],
    transform.orientation[4] = table.unpack(lovr.headset.getOrientation(hand))
  end
end

return MotionTracking
