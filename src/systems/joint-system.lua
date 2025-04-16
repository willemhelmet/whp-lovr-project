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
-- AI: Suggests that 'Physics' is not necessary.
JointSystem.filter = tiny.requireAll("Joint", "Physics")

-- AI: Helper function to create a LOVR joint from a definition
local function createLovrJoint(definition)
  local entityA = definition.entityA
  local entityB = definition.entityB

  -- Ensure both entities and their physics components/colliders exist
  if not entityA or not entityA.Physics or not entityA.Physics.collider then
    -- lovr.log.warn("JointSystem: Entity A or its collider not ready for joint type: " .. definition.type)
    return nil
  end
  if not entityB or not entityB.Physics or not entityB.Physics.collider then
    -- lovr.log.warn("JointSystem: Entity B or its collider not ready for joint type: " .. definition.type)
    return nil
  end

  local colliderA = entityA.Physics.collider
  local colliderB = entityB.Physics.collider
  local anchorPosition = definition.anchorPosition
  local anchorPosition2 = definition.anchorPosition2
  local anchorAxis = definition.anchorAxis
  local sliderAxis = definition.sliderAxis
  local lovrJoint = nil

  -- Create the specific LÖVR joint based on type
  if definition.type == 'weld' then
    lovrJoint = lovr.physics.newWeldJoint(colliderA, colliderB)
  elseif definition.type == 'ball' then
    -- Ball joint requires anchor position
    if not anchorPosition then
      lovr.log.error("Ball joint requires anchorPosition"); return nil
    end
    lovrJoint = lovr.physics.newBallJoint(colliderA, colliderB, anchorPosition)
  elseif definition.type == 'cone' then
    -- Cone joint requires anchor position and axis
    if not anchorPosition then
      lovr.log.error("Cone joint requires anchorPosition"); return nil
    end
    if not anchorAxis then
      lovr.log.error("Cone joint requires anchorAxis"); return nil
    end
    lovrJoint = lovr.physics.newConeJoint(colliderA, colliderB, anchorPosition, anchorAxis)
  elseif definition.type == 'distance' then
    -- Distance joint requires two anchor positions
    if not anchorPosition then
      lovr.log.error("Distance joint requires anchorPosition"); return nil
    end
    if not anchorPosition2 then
      lovr.log.error("Distance joint requires anchorPosition2"); return nil
    end
    lovrJoint = lovr.physics.newDistanceJoint(colliderA, colliderB, anchorPosition, anchorPosition2)
  elseif definition.type == 'hinge' then
    -- Hinge joint requires anchor position and axis
    if not anchorPosition then
      lovr.log.error("Hinge joint requires anchorPosition"); return nil
    end
    if not anchorAxis then
      lovr.log.error("Hinge joint requires anchorAxis"); return nil
    end
    lovrJoint = lovr.physics.newHingeJoint(colliderA, colliderB, anchorPosition, anchorAxis)
  elseif definition.type == 'slider' then
    -- Slider joint requires slider axis
    if not sliderAxis then
      lovr.log.error("Slider joint requires sliderAxis"); return nil
    end
    lovrJoint = lovr.physics.newSliderJoint(colliderA, colliderB, sliderAxis)
  else
    lovr.log.error("Unknown joint type: " .. tostring(definition.type))
  end

  return lovrJoint
end

-- AI: onAdd is now less critical as joint creation is deferred to process,
-- but we can keep it empty or use it for initial setup if needed later.
function JointSystem:onAdd(e)
  -- for i, jointComp in ipairs(e.Joint) do
  --   local entityA = jointComp.entityA
  --   local entityB = jointComp.entityB
  --   local colliderA = entityA.Physics.collider
  --   local colliderB = entityB.Physics.collider
  --   local anchorPosition = jointComp.anchorPosition
  --   local anchorPosition2 = jointComp.anchorPosition2
  --   local anchorAxis = jointComp.anchorAxis
  --   local sliderAxis = jointComp.sliderAxis

  --   if colliderA and colliderB then
  --     if jointComp.type == 'weld' then
  --       jointComp.joint[i] = lovr.physics.newWeldJoint(colliderA, colliderB)
  --     elseif jointComp.type == 'ball' then
  --       jointComp.joint[i] = lovr.physics.newBallJoint(colliderA, colliderB, anchorPosition)
  --     elseif jointComp.type == 'cone' then
  --       jointComp.joint[i] = lovr.physics.newBallJoint(
  --         colliderA,
  --         colliderB,
  --         anchorPosition,
  --         anchorAxis
  --       )
  --     elseif jointComp.type == 'distance' then
  --       jointComp.joint[i] = lovr.physics.newDistanceJoint(
  --         colliderA,
  --         colliderB,
  --         anchorPosition,
  --         anchorPosition2
  --       )
  --     elseif jointComp.type == 'hinge' then
  --       jointComp.joint[i] = lovr.physics.newHingeJoint(
  --         colliderA,
  --         colliderB,
  --         anchorPosition,
  --         anchorAxis
  --       )
  --     elseif jointComp.type == 'slider' then
  --       jointComp.joint[i] = lovr.physics.newSliderJoint(
  --         colliderA,
  --         colliderB,
  --         sliderAxis
  --       )
  --     end
  --   end
  -- end
end

function JointSystem:process(e, dt)
  -- AI: Iterate through all joint definitions within the component
  if e.Joint then
    for _, definition in ipairs(e.Joint.definitions) do
      -- AI: Check if the LÖVR joint object hasn't been created yet
      if not definition.lovrJoint then
        -- AI: Attempt to create the LÖVR joint
        local newLovrJoint = createLovrJoint(definition)
        if newLovrJoint then
          -- AI: Store the created joint back into its definition table
          definition.lovrJoint = newLovrJoint
        end
      end
      -- AI: Update joint properties if needed (e.g., motor targets) - Add later if required
    end
  end
end

function JointSystem:onRemove(e)
  -- AI: Iterate through the definitions and destroy any existing LÖVR joints
  if e.Joint and e.Joint.definitions then
    for _, definition in ipairs(e.Joint.definitions) do
      if definition.lovrJoint then
        -- Check if destroy method exists before calling
        if type(definition.lovrJoint.destroy) == 'function' then
          definition.lovrJoint:destroy()
        else
          -- Fallback or error if destroy is not available (should be for LÖVR joints)
          lovr.log.warn("Could not destroy joint object: " .. definition.type)
        end
        definition.lovrJoint = nil -- Clear the reference
      end
    end
  end
end

return JointSystem
