-- src/components/transform-component.lua
--
-- Transform Component: Defines the spatial properties of entities in the world.
-- Stores position, orientation, and scale information.
-- The fundamental component for placing and orienting any object in 3D space.

local TransformComponent = {}

-- TODO: Turn the inputs into a vec3, a quat, and a vec3. easier to understand at a glance
function TransformComponent.new(tx, ty, tz, angle, ax, ay, az, sx, sy, sz)
  return {
    position = { tx, ty, tz },
    orientation = { angle, ax, ay, az },
    scale = { sx or 1, sy or 1, sz or 1 }
  }
end

return TransformComponent
