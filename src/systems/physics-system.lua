-- src/systems/physics-system.lua
--
-- Physics System: Manages physics simulation for all entities with physics components.
-- Handles the creation, updating, and destruction of physics bodies and colliders.
-- Synchronizes physics state with entity transforms (position and orientation).
-- For kinematic objects, updates the physics from transforms.
-- For dynamic objects, updates transforms from physics simulation results.

local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local phywire = require 'lib.phywire'

local PhysicsSystem = tiny.processingSystem(class('Physics System'))
PhysicsSystem.filter = tiny.requireAll('Physics', 'Transform')

local TransformSystem = require 'src.systems.transform-system'

local world = lovr.physics.newWorld({
  restitutionThreshold = .05,
  tags = {
    "default", "controller"
  }
})

function PhysicsSystem:onAdd(e)
  local physics = e.Physics
  local transform = e.Transform

  if not physics.collider then
    local pos = transform.position
    local offset = physics.offset
    local finalX = pos[1] + offset[1]
    local finalY = pos[2] + offset[2]
    local finalZ = pos[3] + offset[3]

    if physics.shapes and #physics.shapes > 0 then
      physics.collider = world:newCollider(finalX, finalY, finalZ)

      for _, shapeDef in ipairs(physics.shapes) do
        local shape = nil
        if shapeDef.type == 'box' then
          shape = lovr.physics.newBoxShape(shapeDef.width, shapeDef.height, shapeDef.depth)
        elseif shapeDef.type == 'sphere' then
          shape = lovr.physics.newSphereShape(shapeDef.radius)
        elseif shapeDef.type == 'capsule' then
          shape = lovr.physics.newCapsuleShape(shapeDef.radius, shapeDef.length)
        elseif shapeDef.type == 'cylinder' then
          shape = lovr.physics.newCylinderShape(shapeDef.radius, shapeDef.length)
        elseif shapeDef.type == 'convex' then
          shape = lovr.physics.newConvexShape(shapeDef.model, shapeDef.scale or 1)
        elseif shapeDef.type == 'terrain' then
          shape = lovr.physics.newTerrainShape(shapeDef.scale, shapeDef.heightmap, shapeDef.stretch)
        end
        if shape then
          physics.collider:addShape(shape)
        end
      end
    else
      -- If no shapes were provided, default to a box collider.
      local width      = physics.width or 1
      local height     = physics.height or 1
      local depth      = physics.depth or 1
      physics.collider = world:newBoxCollider(finalX, finalY, finalZ, width, height, depth)
    end
  end
  physics.collider:setKinematic(physics.isKinematic)
  physics.collider:setFriction(physics.friction)
  physics.collider:setRestitution(physics.restitution)
  physics.collider:setGravityScale(physics.gravityScale)
  physics.collider:setLinearDamping(physics.linearDamping)
  physics.collider:setAngularDamping(physics.angularDamping)
  physics.collider:setContinuous(physics.continuous)
  physics.collider:setTag(physics.tag)
  if physics.userData then
    physics.collider:setUserData(physics.userData)
  end
end

function PhysicsSystem:preProcess(dt)
  world:update(dt)
end

function PhysicsSystem:process(e, dt)
  local physics = e.Physics
  local transform = e.Transform

  if physics.collider and physics.collider:isEnabled() then
    if not physics.isKinematic then
      -- For dynamic objects, update the Transform from the physics simulation.
      local x, y, z = physics.collider:getPosition()
      TransformSystem.setPosition(transform, Vec3(x, y, z))
      local angle, ax, ay, az = physics.collider:getOrientation()
      TransformSystem.setOrientation(transform, Quat(angle, ax, ay, az))
    else
      -- For kinematic objects, push the Transform's data into the physics collider.
      local pos = Vec3(transform.localPosition)
      local angle, ax, ay, az = transform.localOrientation
      physics.collider:setPose(pos.x, pos.y, pos.z, angle, ax, ay, az)
    end
  end
end

function PhysicsSystem:onRemove(e)
  local physics = e.Physics
  if physics.collider then
    physics.collider:destroy()
    physics.collider = nil
  end
end

function PhysicsSystem.drawDebug(pass)
  phywire.draw(pass, world)
  phywire.drawJoints(pass, world)
end

function PhysicsSystem.getWorld()
  return world
end

return PhysicsSystem
