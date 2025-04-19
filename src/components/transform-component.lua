-- src/components/transform-component.lua
--
-- Transform Component: Defines the spatial properties of entities in the world.
-- Stores position, orientation, and scale information.
-- The fundamental component for placing and orienting any object in 3D space.

local class = require 'lib.30log'

local TransformComponent = class('Transform')

function TransformComponent:init(position, orientation, scale)
  position = position or Vec3(0, 0, 0)
  orientation = orientation or Quat(1, 0, 0, 0)
  scale = scale or Vec3(1, 1, 1)
  -- world transform values
  self.position = position or Vec3(0, 0, 0)
  self.orientation = orientation or Quat(1, 0, 0, 0)
  self.scale = scale or Vec3(1, 1, 1)

  -- local transform values (relative to parent)
  self.localPosition = position or Vec3(0, 0, 0)
  self.localOrientation = orientation or Quat(1, 0, 0, 0)
  self.localScale = scale or Vec3(1, 1, 1)

  -- Parent reference (nil if no parent)
  self.parent = nil

  -- Children table
  self.children = {}

  -- TODO: Implement dirty optimization
  -- AI: state tracking, used to indicate if world transform needs recalculation
  self.dirty = true
end

function TransformComponent:setPosition(position)
  self.localPosition = position
  self.dirty = true
end

function TransformComponent:setOrientation(orientation)
  self.localOrientation = orientation
  self.dirty = true
end

function TransformComponent:setScale(scale)
  self.localScale = scale
  self.dirty = true
end

return TransformComponent
