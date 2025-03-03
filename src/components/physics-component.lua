-- src/components/physics-component

local PhysicsComponent = {}

function PhysicsComponent.new(options)
  local options = options or {}
  return {
    -- Collider-related
    collider = nil, -- Set later by the PhysicsSystem
    shapes = options.shapes or {},

    isKinematic = options.isKinematic or false,
    isSensor = options.isSensor or false,
    friction = options.friction or 0.5,
    restitution = options.restitution or 0.2,
    gravityScale = options.gravityScale or 1,
    mass = options.mass, -- nil means use automatic mass calculation
    linearDamping = options.linearDamping or 0.0,
    angularDamping = options.angularDamping or 0.0,
    continuous = options.continuous or false,
    degreesOfFreedom = options.degreesOfFreedom, -- e.g., { x = true, y = false, z = true }
    collisionGroups = options.collisionGroups or {},
    offset = options.offset or { 0, 0, 0 },      -- Optional offset relative to the TransformComponent
    userData = options.userData or {}            -- metadata
  }
end

return PhysicsComponent
