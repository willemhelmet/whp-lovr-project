-- src/systems/grab-system.lua
--
-- Grab System: Enables objects to be grabbed and manipulated by VR controllers.
-- Handles detection of grabbable objects, grip/release actions, and maintaining
-- the physical connection between controllers and grabbed objects.
-- Provides the core interaction mechanic for a VR physics playground.

local tiny = require 'lib.tiny'
local InputSystem = require 'src.systems.input-system'
local PhysicsSystem = require 'src.systems.physics-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local JointComponent = require 'src.components.joint-component'

local GrabSystem = tiny.processingSystem(class('Grab System'))
GrabSystem.filter = tiny.requireAll("Controller")

local controllerLeft
local controllerRight
local worldRef
local previousGrabLeftState
local previousGrabRightState
local grabbedEntityLeft
local grabbedEntityRight
-- AI: Stores the specific joint definition for the left/right hand grab
local grabbedJointDefLeft
local grabbedJoinfDefIndex
local grabbedJointDefRight

function GrabSystem:onAddToWorld(world)
  worldRef = world
end

function GrabSystem:onAdd(e)
  if e.Hand and e.Hand == 'left' then
    controllerLeft = e
  elseif e.Hand and e.Hand == 'right' then
    controllerRight = e
  end
end

function GrabSystem:preProcess(dt)
end

function GrabSystem:process(e, dt)
end

function GrabSystem:update(dt)
  local currentGrabLeftState = InputSystem:getValue('grabLeft')
  local currentGrabRightState = InputSystem:getValue('grabRight')

  -- Handle left controller
  if currentGrabLeftState == 1 then
    -- TODO: is this the right position to be calling? I don't think so...
    local leftHandPosition = MotionTrackingSystem.getPosition('left')
    local nearestCollider = PhysicsSystem.getWorld():overlapShape(
      lovr.physics.newSphereShape(2), -- WHP: Is this too big?
      leftHandPosition[1],            -- position.x
      leftHandPosition[2],            -- position.y
      leftHandPosition[3],            -- position.z
      1, 0, 0, 0,                     -- orientation
      0,                              -- maxDistance
      "~controller",                  -- filter, will not register "controller" colliders
      nil                             -- callback function
    )
    if nearestCollider and not grabbedEntityLeft then
      local potentialGrabTarget = nearestCollider:getUserData()
      if potentialGrabTarget and potentialGrabTarget.Grabbable then
        grabbedEntityLeft = potentialGrabTarget

        local grabJointDef = {
          type = 'weld',
          entityA = controllerLeft,
          entityB = grabbedEntityLeft
        }
        if not grabbedEntityLeft.Joint then
          grabbedEntityLeft.Joint = JointComponent({ grabJointDef })
          grabbedJointDefLeft = grabbedEntityLeft.Joint.definitions[1]
        else
          table.insert(grabbedEntityLeft.Joint.definitions, grabJointDef)
          grabbedJointDefLeft = grabJointDef
        end
        worldRef:addEntity(grabbedEntityLeft)
      end
    end
  elseif previousGrabLeftState == 1 and currentGrabLeftState == 0 then
    if grabbedEntityLeft and grabbedJointDefLeft then
      if grabbedEntityLeft.Joint and grabbedEntityLeft.Joint.definitions then
        local definitions = grabbedEntityLeft.Joint.definitions
        -- AI: Find the specific grab joint definition in the list
        --     Iterate backwards for safe removal
        for i = #definitions, 1, -1 do
          local definition = definitions[i]
          if definition == grabbedJointDefLeft then
            if definition.lovrJoint and definition.lovrJoint.destroy then
              definition.lovrJoint:destroy()
              definition.lovrJoint = nil -- Clear reference
            end
          end
          table.remove(definitions, i)
          break
        end
        if #definitions == 0 then
          grabbedEntityLeft.Joint = nil
        end
      end
      grabbedEntityLeft = nil
      grabbedJointDefLeft = nil
      worldRef:addEntity(grabbedEntityLeft)
    end
  end
  previousGrabLeftState = currentGrabLeftState

  -- Handle right controller
  if currentGrabRightState == 1 then
    -- TODO: is this the right position to be calling? I don't think so...
    local rightHandPosition = MotionTrackingSystem.getPosition('right')
    local nearestCollider = PhysicsSystem.getWorld():overlapShape(
      lovr.physics.newSphereShape(2), -- WHP: too big?
      rightHandPosition[1],           -- position.x
      rightHandPosition[2],           -- position.y
      rightHandPosition[3],           -- position.z
      1, 0, 0, 0,                     -- orientation
      0,                              -- maxDistance
      "~controller",                  -- filter, will not register "controller" colliders
      nil                             -- callback function
    )
    if nearestCollider and not grabbedEntityRight then
      local potentialGrabTarget = nearestCollider:getUserData()
      if potentialGrabTarget and potentialGrabTarget.Grabbable then
        grabbedEntityRight = potentialGrabTarget
        local grabJointDef = {
          type = 'weld',
          entityA = controllerLeft,
          entityB = grabbedEntityLeft
        }
        if not grabbedEntityRight.Joint then
          grabbedEntityRight.Joint = JointComponent({ grabJointDef })
          grabbedJointDefRight = grabbedEntityRight.Joint.definitions[1]
        else
          table.insert(grabbedEntityRight.Joint.definitions, grabJointDef)
          grabbedJointDefRight = grabJointDef
        end
        -- worldRef:addEntity(grabbedEntityRight)
      end
    end
  elseif previousGrabRightState == 1 and currentGrabRightState == 0 then
    if grabbedEntityRight and grabbedJointDefRight then
      if grabbedEntityRight.Joint and grabbedEntityRight.Joint.definitions then
        local definitions = grabbedEntityRight.Joint.definitions
        -- AI: Find the specific grab joint definition in the list
        --     Iterate backwards for safe removal
        for i = #definitions, 1, -1 do
          local definition = definitions[i]
          if definition == grabbedJointDefRight then
            if definition.lovrJoint and definition.lovrJoint.destroy then
              definition.lovrJoint:destroy()
              definition.lovrJoint = nil
            end
          end
          table.remove(definitions, i)
          break
        end
        if #definitions == 0 then
          grabbedEntityRight.Joint = nil
        end
      end
      grabbedEntityRight = nil
      grabbedJointDefRight = nil
      -- worldRef:addEntity(grabbedEntityRight)
    end
  end
  previousGrabRightState = currentGrabRightState
end

function GrabSystem:postProcess(dt)
end

function GrabSystem:onDestroy(e)
end

return GrabSystem
