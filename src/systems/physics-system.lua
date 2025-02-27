-- src/systems/physics-system.lua

local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

local PhysicsSystem = tiny.processingSystem()
-- PhysicsSystem.filter = tiny.requireAll(PhysicsComponent)

local world = lovr.physics.newWorld()
local objects = {}

function PhysicsSystem:preProcess(dt)
  world:update(dt)
end

function PhysicsSystem:process(e, dt)
  print(pretty.write(e))
end

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
