-- src/components/physics-component

local PhysicsComponent = {
  body = nil,                    -- lovr.physics.Body object
  shape = nil,                   -- lovr.physics.Shape object
  mass = 1,                      -- Mass of the object
  restitution = 0,               -- Bounciness
  friction = 0.5,                -- Surface friction
  linearVelocity = { 0, 0, 0 },  -- Current linear velocity
  angularVelocity = { 0, 0, 0 }, -- Current angular velocity
  isStatic = false,              -- Whether the object is static
  isSensor = false,              -- Whether the object is a sensor (no collisions)
  -- Add other properties as needed (e.g., gravity scale, damping)
}
