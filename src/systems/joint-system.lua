-- src/systems/joint-system.lua
--
-- Joint System: Creates and manages physics joints between entities.
-- Supports various joint types (ball, hinge, distance, etc.) to constrain
-- physics object movement and create realistic mechanical interactions.
-- Essential for complex mechanical assemblies and articulated structures.

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

local JointSystem = tiny.processingSystem()
JointSystem.filter = tiny.requireAll("Joint", "Physics")

function JointSystem:onAdd(e)
  for i, jointComp in ipairs(e.Joint) do
    local entityA = jointComp.entityA
    local entityB = jointComp.entityB
    local colliderA = entityA.Physics.collider
    local colliderB = entityB.Physics.collider
    local anchorPosition = jointComp.anchorPosition
    local anchorPosition2 = jointComp.anchorPosition2
    local anchorAxis = jointComp.anchorAxis
    local sliderAxis = jointComp.sliderAxis

    if colliderA and colliderB then
      if jointComp.type == 'weld' then
        jointComp.joint[i] = lovr.physics.newWeldJoint(colliderA, colliderB)
      elseif jointComp.type == 'ball' then
        jointComp.joint[i] = lovr.physics.newBallJoint(colliderA, colliderB, anchorPosition)
      elseif jointComp.type == 'cone' then
        jointComp.joint[i] = lovr.physics.newBallJoint(
          colliderA,
          colliderB,
          anchorPosition,
          anchorAxis
        )
      elseif jointComp.type == 'distance' then
        jointComp.joint[i] = lovr.physics.newDistanceJoint(
          colliderA,
          colliderB,
          anchorPosition,
          anchorPosition2
        )
      elseif jointComp.type == 'hinge' then
        jointComp.joint[i] = lovr.physics.newHingeJoint(
          colliderA,
          colliderB,
          anchorPosition,
          anchorAxis
        )
      elseif jointComp.type == 'slider' then
        jointComp.joint[i] = lovr.physics.newSliderJoint(
          colliderA,
          colliderB,
          sliderAxis
        )
      end
    end
  end
end

function JointSystem:process(e, dt)
  for i, jointComp in ipairs(e.Joint) do
    if not jointComp.joint and -- Only try to create if joint doesn't exist yet
        jointComp.entityA.Physics and jointComp.entityA.Physics.collider and
        jointComp.entityB.Physics and jointComp.entityB.Physics.collider then
      self:onAdd(e)
    end
  end
end

function JointSystem:onRemove(e)
  for _, jointComp in ipairs(e.Joint) do
    if jointComp.joint then
      jointComp.joint:destroy()
      jointComp.joint = nil
    end
  end
end

return JointSystem
