-- src/core/system-registry.lua

-- WHP: unordered table of systems
--      pro: easy to access a system
--      con: no order
-- local Systems = {
--   InputSystem = require 'src.systems.input-system',
--   MotionTrackingSystem = require 'src.systems.motion-tracking-system',
--   GrabSystem = require 'src.systems.grab-system',
--   PlayerMotionSystem = require 'src.systems.player-motion-system',
--   TransformSystem = require 'src.systems.transform-system',
--   PhysicsSystem = require 'src.systems.physics-system',
--   JointSystem = require 'src.systems.joint-system',
--   LightingSystem = require 'src.systems.lighting-system',
--   RenderSystem = require 'src.systems.render-system',
-- }

-- WHP: Ordered table of systems
--      pro: ordered, easy to set processing order for tiny
--      con: more repetitive actions to access a System
local Systems = {
  { require 'src.systems.input-system' },
  { require 'src.systems.motion-tracking-system' },
  { require 'src.systems.controller-system' },
  { require 'src.systems.grab-system' },
  { require 'src.systems.player-motion-system' }, -- will prob be replaced by teleport system
  { require 'src.systems.teleport-system' },
  { require 'src.systems.transform-system' },
  { require 'src.systems.physics-system' },
  { require 'src.systems.joint-system' },
  { require 'src.systems.lighting-system' },
  { require 'src.systems.render-system' }
}

return Systems
