-- src/components/motion-tracking-component.lua

local lovr = require 'lovr'

local MotionTrackingComponent = {
  hand = nil
}

function MotionTrackingComponent.new(hand)
  return {
    hand = hand
  }
end

return MotionTrackingComponent
