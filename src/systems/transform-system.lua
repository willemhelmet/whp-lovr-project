-- src/systems/transform-system.lua
--
-- Transform System: Manages the hierarchy of transforms, updating world matrices
-- and handling parent-child relationships.

local lovr = require 'lovr'
local Vec3 = lovr.math.newVec3
local Quat = lovr.math.newQuat
local Mat4 = lovr.math.newMat4
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

local TransformSystem = tiny.processingSystem()
TransformSystem.filter = tiny.requireAll("Transform")

-- function TransformSystem:onAdd(e)
-- end

-- Update world transform based on local transform and parent
function TransformSystem.updateWorldTransform(transform)
  if transform.parent then
    -- Compute world position
    transform.position = Vec3(transform.parent.position):add(
      transform.parent.orientation:mul(
        Vec3(transform.localPosition):mul(
          transform.parent.scale
        )
      )
    )
    -- Compute world orientation
    transform.orientation = Quat(transform.parent.orientation):mul(transform.localOrientation):normalize()

    -- Compute world scale (component-wise multiplication)
    transform.scale = Vec3(
      transform.parent.scale
    ):mul(
      transform.localScale
    )
  else
    -- If no parent, world transform is same as local
    transform.position:set(transform.localPosition)
    transform.orientation:set(transform.localOrientation)
    transform.scale:set(transform.localScale)
  end

  -- Recursively update children
  for _, child in ipairs(transform.children) do
    TransformSystem.updateWorldTransform(child)
  end
end

function TransformSystem:process(e, dt)
  local transform = e.Transform
  TransformSystem.updateWorldTransform(transform)
end

-- function TransformSystem:onRemove(e)
-- end

-- Add a child to a parent transform
function TransformSystem.addChild(parent, child)
  -- Ensure the child is not already in the list
  for _, existingChild in ipairs(parent.children) do
    if existingChild == child then
      return
    end
  end

  -- Add the child and set its parent
  table.insert(parent.children, child)
  child.parent = parent
  -- Compute initial local transform
  child.localPosition:set(
    lovr.math.quat(parent.localOrientation):conjugate():mul(
      (lovr.math.vec3(child.localPosition):sub(parent.localPosition))
    )
  )
  child.localOrientation:set(
    lovr.math.quat(parent.localOrientation):conjugate():mul(child.localOrientation)
  )
  child.localScale:set(
    lovr.math.vec3(child.localScale):div(parent.localScale)
  )
end

-- Remove a child from a parent transform
function TransformSystem.removeChild(parent, child)
  for i, existingChild in ipairs(parent.children) do
    if existingChild == child then
      table.remove(parent.children, i)
      child.parent = nil
      return
    end
  end
end

function TransformSystem.setPosition(transform, position)
  transform.localPosition = Vec3(position.x, position.y, position.z)
end

function TransformSystem.setOrientation(transform, quaternion)
  transform.localOrientation = quaternion
end

function TransformSystem.setScale(transform, scale)
  transform.localScale = scale
end

function TransformSystem.toMat4(transform)
  return Mat4(transform.position, transform.scale, transform.orientation)
end

return TransformSystem
