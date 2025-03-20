-- src/components/grabbable-component.lua
--
-- Grab Component: Marks an entity as grabbable by VR controllers.
-- Configures how the object behaves when grabbed (offset from hand,
-- whether it maintains physics properties, grab detection radius).
-- Used by the Grab System to determine which objects can be interacted with.

local lovr = require 'lovr'

local GrabbableComponent = {
  -- WHP: Should this be a TransformComponent?
  -- offset = lovr.math.newVec3(0, 0, 0),

  -- grabRadius = 0.1,
  -- maintainPhysics = true, -- If true, use joint rather than kinematic mode
}

function GrabbableComponent.new(options)
  -- local component = {}
  -- component.offset = options.offset or lovr.math.newVec3(0, 0, 0)
  -- component.grabRadius = options.grabRadius or 0.1
  -- component.maintainPhysics = options.maintainPhysics or true
  -- return component
  return {}
end

return GrabbableComponent
