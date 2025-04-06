-- src/components/light-component.lua

local LightComponent = {}

local lovr = require 'lovr'
local Vec3 = lovr.math.newVec3

local defaults = {
  color = Vec3(1, 1, 1),
  intensity = 1.0,
  -- Attenuation factors matching common OpenGL tutorials
  -- See: https://learnopengl.com/Lighting/Light-casters
  -- Constant | Linear | Quadratic
  -- 1.0      | 0.7    | 1.8
  -- 1.0      | 0.35   | 0.44
  -- 1.0      | 0.22   | 0.20
  -- 1.0      | 0.14   | 0.07
  -- 1.0      | 0.09   | 0.032
  -- 1.0      | 0.07   | 0.017
  -- 1.0      | 0.045  | 0.0075
  -- 1.0      | 0.027  | 0.0028
  -- 1.0      | 0.022  | 0.0019
  -- 1.0      | 0.014  | 0.0007
  -- 1.0      | 0.007  | 0.0002
  -- 1.0      | 0.0014 | 0.000007
  constant = 1.0,
  linear = 0.07,
  quadratic = 1.8,
  type = 'point', -- Future: 'directional', 'spot'
  cutoff = 12.5,
  outerCutoff = 17.5
}

function LightComponent.new(options)
  if options == nil then
    options = defaults
  end
  local entity = {}
  entity.color = options.color or defaults.color
  entity.intensity = options.intensity or 1
  entity.constant = options.constant or defaults.constant
  entity.quadratic = options.quadratic or defaults.quadratic
  entity.linear = options.linear or defaults.linear
  entity.type = options.type or defaults.type
  entity.cutoff = options.cutoff or defaults.cutoff
  entity.outerCutoff = options.outerCutoff or defaults.outerCutoff
  return entity
end

return LightComponent
