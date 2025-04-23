-- src/systems/motion-tracking-system.lua

local tiny = require 'lib.tiny'

local MotionTracking = tiny.processingSystem()
MotionTracking.filter = tiny.requireAll("Transform", "MotionTracking")

function MotionTracking.getPosition(device)
  local x, y, z = lovr.headset.getPosition(device)
  return Vec3(x, y, z)
end

function MotionTracking.getOrientation(device)
  local angle, ax, ay, az = lovr.headset.getOrientation(device)
  return Quat(angle, ax, ay, az)
end

function MotionTracking.getPose(device)
  local x, y, z, angle, ax, ay, az = lovr.headset.getPose(device)
  return Mat4(Vec3(x, y, z), Vec3(1, 1, 1), Quat(angle, ax, ay, az))
end

function MotionTracking.isTracked(device)
  return lovr.headset.isTracked(device)
end

function MotionTracking.getHands()
  return lovr.headset.getHands()
end

function MotionTracking:process(e, dt)
  local transform = e.Transform
  local device = e.MotionTracking.device

  if (lovr.headset.isTracked(device)) then
    transform:setPosition(Vec3(MotionTracking.getPosition(device)))
    transform:setOrientation(Quat(MotionTracking.getOrientation(device)))
  end
end

return MotionTracking
