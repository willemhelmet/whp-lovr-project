-- src/components/transform-component.lua
--
-- Transform Component: Defines the spatial properties of entities in the world.
-- Stores position, orientation, and scale information.
-- The fundamental component for placing and orienting any object in 3D space.

local lovr = require 'lovr'

local TransformComponent = {}

function TransformComponent.new(position, orientation, scale)
  return {
    -- world transform values
    position = position or lovr.math.newVec3(0, 0, 0),
    orientation = orientation or lovr.math.newQuat(1, 0, 0, 0),
    scale = scale or lovr.math.newVec3(1, 1, 1),

    -- local transform values (relative to parent)
    localPosition = position or lovr.math.newVec3(0, 0, 0),
    localOrientation = orientation or lovr.math.newQuat(1, 0, 0, 0),
    localScale = scale or lovr.math.newVec3(1, 1, 1),

    -- Parent reference (nil if no parent)
    parent = nil,

    -- Children table
    children = {},
  }
end

return TransformComponent
