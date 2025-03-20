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
  if InputSystem:getValue('grabLeft') == 1 then
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
      local nearestComponent = nearestCollider:getUserData()

      if nearestComponent and nearestComponent.Grabbable then
        if not nearestComponent.Joint then
          nearestComponent.Joint = JointComponent.new({
            {
              type = 'weld',
              entityA = controllerLeft,
              entityB = nearestComponent
            }
          })
        end
        worldRef:addEntity(nearestComponent)
      end
    end
  end
end

-- function GrabSystem:getNearbyGrabbableObjects(controller, radius)
-- end

-- function GrabSystem:grabObject(controller, object)
-- end

-- function GrabSystem:releaseObject(controller)
-- end

function GrabSystem:postProcess(dt)
end

function GrabSystem:onDestroy(e)
end

return GrabSystem
