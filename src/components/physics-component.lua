-- src/components/physics-component
--
-- Physics Component: Stores physics properties and configuration for entities.
-- Defines collision shapes, physical material properties (friction, restitution),
-- and dynamic behavior settings (kinematic state, mass, damping).
-- Used by the Physics System to simulate realistic physical interactions.

local PhysicsComponent = class('Physics')

function PhysicsComponent:init(options)
  local options = options or {}

  self.collider = nil -- Set later by the PhysicsSystem
  self.shapes = options.shapes or {}
  self.tag = options.tag or "default"
  self.isKinematic = options.isKinematic or false
  self.isSensor = options.isSensor or false
  self.friction = options.friction or 0.5
  self.restitution = options.restitution or 0.2
  self.gravityScale = options.gravityScale or 1
  self.mass = options.mass -- nil means use automatic mass calculation
  self.linearDamping = options.linearDamping or 0.0
  self.angularDamping = options.angularDamping or 0.05
  self.continuous = options.continuous or false
  self.degreesOfFreedom = options.degreesOfFreedom -- e.g., { x = true, y = false, z = true }
  self.collisionGroups = options.collisionGroups or {}
  self.offset = options.offset or { 0, 0, 0 }      -- Optional offset relative to the TransformComponent
  self.userData = options.userData or nil
end

return PhysicsComponent
