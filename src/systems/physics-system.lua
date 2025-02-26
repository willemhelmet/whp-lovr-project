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
function PhysicsSystem.newBoxCollider(name, position, scale)
  objects[name] = world:newBoxCollider(position, scale)
  return objects[name]
end

function PhysicsSystem.getObject(name)
  return objects[name]
end

return PhysicsSystem
