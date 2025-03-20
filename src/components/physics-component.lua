-- src/components/physics-component
--
-- Physics Component: Stores physics properties and configuration for entities.
-- Defines collision shapes, physical material properties (friction, restitution),
-- and dynamic behavior settings (kinematic state, mass, damping).
-- Used by the Physics System to simulate realistic physical interactions.

local PhysicsComponent = {}

function PhysicsComponent.new(options)
  local options = options or {}
  return {
    collider = nil, -- Set later by the PhysicsSystem
    shapes = options.shapes or {},
    isKinematic = options.isKinematic or false,
    isSensor = options.isSensor or false,
    friction = options.friction or 0.5,
    restitution = options.restitution or 0.2,
    gravityScale = options.gravityScale or 1,
    mass = options.mass, -- nil means use automatic mass calculation
    linearDamping = options.linearDamping or 0.0,
    angularDamping = options.angularDamping or 0.05,
    continuous = options.continuous or false,
    degreesOfFreedom = options.degreesOfFreedom, -- e.g., { x = true, y = false, z = true }
    collisionGroups = options.collisionGroups or {},
    offset = options.offset or { 0, 0, 0 },      -- Optional offset relative to the TransformComponent
    userData = options.userData or {}            -- metadata
  }
end

return PhysicsComponent
