-- src/core/system-registry.lua

local Systems = {
  GrabSystem = require 'src.systems.grab-system',
  InputSystem = require 'src.systems.input-system',
  JointSystem = require 'src.systems.joint-system',
  MotionTrackingSystem = require 'src.systems.motion-tracking-system',
  PhysicsSystem = require 'src.systems.physics-system',
  RenderSystem = require 'src.systems.render-system',
  TransformSystem = require 'src.systems.transform-system',
  PlayerMotionSystem = require 'src.systems.player-motion-system',
  LightingSystem = require 'src.systems.lighting-system'
}

return Systems
