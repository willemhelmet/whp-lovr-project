-- Motion Tracking System: Updates entity transforms based on VR device tracking.
-- Synchronizes the position and orientation of in-game entities with real-world
-- VR controller or headset movements.
-- Essential for controller representation and hand presence in VR.

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'
local Vec3 = lovr.math.newVec3
local Quat = lovr.math.newQuat
local Mat4 = lovr.math.newMat4

local TransformSystem = require 'src.systems.transform-system'

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

function MotionTracking:process(e, dt)
  local transform = e.Transform
  local device = e.MotionTracking.device

  if (lovr.headset.isTracked(device)) then
    -- Update local transform (relative to parent)
    TransformSystem.setPosition(transform, Vec3(MotionTracking.getPosition(device)))
    TransformSystem.setOrientation(transform, Quat(MotionTracking.getOrientation(device)))
  end
end

return MotionTracking
