-- src/components/physics-component
--
-- Physics Component: Stores physics properties and configuration for entities.
-- Defines collision shapes, physical material properties (friction, restitution),
-- and dynamic behavior settings (kinematic state, mass, damping).
-- Used by the Physics System to simulate realistic physical interactions.

local PhysicsComponent = {}

function PhysicsComponent.new(options)
  local options = options or {}
  local comp = {}
  comp.collider = nil -- Set later by the PhysicsSystem
  comp.shapes = options.shapes or {}
  comp.tag = options.tag or "default"
  comp.isKinematic = options.isKinematic or false
  comp.isSensor = options.isSensor or false
  comp.friction = options.friction or 0.5
  comp.restitution = options.restitution or 0.2
  comp.gravityScale = options.gravityScale or 1
  comp.mass = options.mass -- nil means use automatic mass calculation
  comp.linearDamping = options.linearDamping or 0.0
  comp.angularDamping = options.angularDamping or 0.05
  comp.continuous = options.continuous or false
  comp.degreesOfFreedom = options.degreesOfFreedom -- e.g., { x = true, y = false, z = true }
  comp.collisionGroups = options.collisionGroups or {}
  comp.offset = options.offset or { 0, 0, 0 }      -- Optional offset relative to the TransformComponent
  comp.userData = options.userData or nil
  return comp
end

return PhysicsComponent
