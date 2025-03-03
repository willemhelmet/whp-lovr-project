-- src/components/transform-component.lua

local TransformComponent = {
  position = { 0, 0, 0 },       -- x, y, z
  orientation = { 0, 0, 0, 0 }, -- angle, ax, ay, az
  scale = { 1, 1, 1 }           -- x, y, z
}

-- TODO: Turn the inputs into a vec3, a quat, and a vec3. easier to understand at a glance
function TransformComponent.new(tx, ty, tz, angle, ax, ay, az, sx, sy, sz)
  return {
    position = { tx, ty, tz },
    orientation = { angle, ax, ay, az },
    scale = { sx, sy, sz }
  }
end

return TransformComponent
