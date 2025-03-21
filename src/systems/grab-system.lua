-- src/systems/grab-system.lua
--
-- Grab System: Enables objects to be grabbed and manipulated by VR controllers.
-- Handles detection of grabbable objects, grip/release actions, and maintaining
-- the physical connection between controllers and grabbed objects.
-- Provides the core interaction mechanic for a VR physics playground.

local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local InputSystem = require 'src.systems.input-system'
local PhysicsSystem = require 'src.systems.physics-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local JointComponent = require 'src.components.joint-component'

local pretty = require 'lib.pl.pretty'

local GrabSystem = tiny.processingSystem()
GrabSystem.filter = tiny.requireAll("Controller")

local controllerLeft
local controllerRight
local worldRef
local previousGrabLeftState
local previousGrabRightState
local grabbedEntityLeft
local grabbedEntityRight

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
    local leftHandPosition = MotionTrackingSystem.getPosition('left')
    local nearestCollider = PhysicsSystem.getWorld():overlapShape(
      lovr.physics.newSphereShape(2),
      leftHandPosition[1], -- position.x
      leftHandPosition[2], -- position.y
      leftHandPosition[3], -- position.z
      1, 0, 0, 0,          -- orientation
      0,                   -- maxDistance
      "~controller",       -- filter, will not register "controller" colliders
      nil                  -- callback function
    )

    if nearestCollider then
      grabbedEntityLeft = nearestCollider:getUserData()
      if grabbedEntityLeft and grabbedEntityLeft.Grabbable then
        if not grabbedEntityLeft.Joint then
          grabbedEntityLeft.Joint = JointComponent.new({
            {
              type = 'weld',
              entityA = controllerLeft,
              entityB = grabbedEntityLeft
            }
          })
        end
        worldRef:addEntity(grabbedEntityLeft)
      end
    end
  elseif previousGrabLeftState == 1 and currentGrabLeftState == 0 then
    if grabbedEntityLeft and grabbedEntityLeft.Joint then
      grabbedEntityLeft.Joint[1].joint[1]:destroy()
      grabbedEntityLeft.Joint = nil
      worldRef:addEntity(grabbedEntityLeft)
    end
  end
  previousGrabLeftState = currentGrabLeftState

  -- Handle right controller
  if currentGrabRightState == 1 then
    local rightHandPosition = MotionTrackingSystem.getPosition('right')
    local nearestCollider = PhysicsSystem.getWorld():overlapShape(
      lovr.physics.newSphereShape(2),
      rightHandPosition[1], -- position.x
      rightHandPosition[2], -- position.y
      rightHandPosition[3], -- position.z
      1, 0, 0, 0,           -- orientation
      0,                    -- maxDistance
      "~controller",        -- filter, will not register "controller" colliders
      nil                   -- callback function
    )

    if nearestCollider then
      grabbedEntityRight = nearestCollider:getUserData()
      if grabbedEntityRight and grabbedEntityRight.Grabbable then
        if not grabbedEntityRight.Joint then
          grabbedEntityRight.Joint = JointComponent.new({
            {
              type = 'weld',
              entityA = controllerRight,
              entityB = grabbedEntityRight
            }
          })
        end
        worldRef:addEntity(grabbedEntityRight)
      end
    end
  elseif previousGrabRightState == 1 and currentGrabRightState == 0 then
    if grabbedEntityRight and grabbedEntityRight.Joint then
      grabbedEntityRight.Joint[1].joint[1]:destroy()
      grabbedEntityRight.Joint = nil
      worldRef:addEntity(grabbedEntityRight)
    end
  end
  previousGrabRightState = currentGrabRightState
end

function GrabSystem:postProcess(dt)
end

function GrabSystem:onDestroy(e)
end

return GrabSystem
