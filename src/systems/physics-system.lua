-- src/systems/physics-system.lua

local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

local PhysicsSystem = tiny.processingSystem()
PhysicsSystem.filter = tiny.requireAll(Physics, Transform)

local world = lovr.physics.newWorld()
local objects = {}


function PhysicsSystem:preProcess(dt)
  world:update(dt)
end

function PhysicsSystem:process(entity, dt)
  local physics = entity.Physics
  local transform = entity.Transform

  -- 1. Create Physics Body if it doesn't exist
  if not physics.body then
    -- physics.body = lovr.physics.newBody(physics.isStatic and "static" or "dynamic")
    -- physics.shape = lovr.physics.newBoxShape(1, 1, 1) -- Example: Box shape
    -- physics.body:setShape(physics.shape)
    -- physics.body:setMass(physics.mass)
    -- physics.body:setRestitution(physics.restitution)
    -- physics.body:setFriction(physics.friction)
    -- physics.body:setPosition(transform.position[1], transform.position[2], transform.position[3])
    -- physics.body:setOrientation(transform.orientation)
    -- lovr.physics.add(physics.body) -- Add body to the physics world
  end

  -- 2. Apply Velocities
  -- physics.body:setLinearVelocity(physics.linearVelocity[1], physics.linearVelocity[2], physics.linearVelocity[3])
  -- physics.body:setAngularVelocity(physics.angularVelocity[1], physics.angularVelocity[2], physics.angularVelocity[3])

  -- 3. Update Transform Component
  -- local pos = physics.body:getPosition()
  -- local ori = physics.body:getOrientation()
  -- transform.position[1], transform.position[2], transform.position[3] = pos:unpack()
  -- transform.orientation = ori

  -- 4. Optionally, apply forces or torques based on other components
  -- Example: If entity has a ForceComponent, apply it to the body.
  -- if entity.ForceComponent then
  --   local force = entity.ForceComponent.force
  --   physics.body:applyForce(force[1], force[2], force[3])
  --   entity.ForceComponent = nil -- Remove the ForceComponent after applying
  -- end
end

-- function PhysicsSystem:onAdd(e)
-- end

-- function PhysicsSystem:onRemove(e)
-- end

function PhysicsSystem.getWorld()
  return world
end

-- TODO: Write all the other collider wrapper functions
-- [x] newBoxCollider	
-- [x] newSphereCollider	
-- [ ] newCapsuleCollider
-- [ ] newCylinderCollider	
-- [ ] newConvexCollider	
-- [ ] newMeshCollider	
-- [ ] newTerrainCollider	
function PhysicsSystem.newBoxCollider(name, position, scale)
  assert(
    type(name) == "string",
    "PhysicsSystem.newBoxCollider: Parameter 'name' must be a string."
  )
  assert(
    type(position) == "userdata",
    "PhysicsSystem.newBoxCollider: Parameter 'position' must be a vec3."
  )
  assert(
    type(scale) == "userdata",
    "PhysicsSystem.newBoxCollider: Parameter 'scale' must be a vec3."
  )
  objects[name] = world:newBoxCollider(position, scale)
  return objects[name]
end

function PhysicsSystem.newSphereCollider(name, position, radius)
  assert(
    type(name) == "string",
    "PhysicsSystem.newSphereCollider: Parameter 'name' must be a string."
  )
  assert(
    type(position) == "userdata",
    "PhysicsSystem.newSphereCollider: Parameter 'position' must be a vec3."
  )
  assert(
    type(radius) == "number",
    "PhysicsSystem.newSphereCollider: Parameter 'radius' must be a number."
  )
  objects[name] = world:newSphereCollider(position, radius)
  return objects[name]
end

-- untested
function PhysicsSystem.newCapsuleCollider(name, position, radius, length)
  assert(
    type(name) == 'string',
    'PhysicsSystem.newCapsuleCollider: Parameter "name" must be a string.'
  )
  assert(
    type(position) == 'userdata',
    'PhysicsSystem.newCapsuleCollider: Parameter "position" must be a vec3.'
  )
  assert(
    type(radius) == 'number',
    'PhysicsSystem.newCapsuleCollider: Parameter "radius" must be a number.'
  )
  assert(
    type(length) == 'number',
    'PhysicsSystem.newCapsuleCollider: Parameter "length" must be a number.'
  )
  objects[name] = world:newCapsuleCollider(position, radius, length)
  return objects[name]
end

function PhysicsSystem.getObject(name)
  return objects[name]
end

return PhysicsSystem
