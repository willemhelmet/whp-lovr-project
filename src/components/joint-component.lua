-- src/components/joint-component.lua
--
-- Joint Component: Defines physical constraints between entities.
-- Configures how entities connect to each other through various joint types
-- (weld, ball, hinge, slider, etc.) and their properties (anchor points, axes).
-- Used by the Joint System to create realistic mechanical connections.

local lovr = require 'lovr'
local pretty = require 'lib.pl.pretty'

local JointComponent = {}

function JointComponent.new(options)
  local entity = {}
  for i, option in ipairs(options) do
    entity[i] = {
      joint = {},
      -- 'weld', 'ball', 'cone', 'distance', 'hinge', 'slider'
      type = option.type or "weld",
      colliderA = option.colliderA,
      colliderB = option.colliderB,
      entityA = option.entityA or nil,
      entityB = option.entityB or nil,
      anchorPosition = option.anchorPosition or lovr.math.newVec3(0, 0, 0),
      anchorPosition2 = option.anchorPosition2 or lovr.math.newVec3(0, 0, 0),
      anchorAxis = option.anchorAxis or lovr.math.newVec3(0, 0, 0),
      sliderAxis = option.sliderAxis or lovr.math.newVec3(0, 0, 0),
    }
  end
  return entity
end

return JointComponent
