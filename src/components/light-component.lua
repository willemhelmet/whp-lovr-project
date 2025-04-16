-- src/components/light-component.lua

local class = require 'lib.30log'
local LightComponent = class('Light')

function LightComponent:init(options)
  options = options or {}
  self.color = options.color or Vec3(1, 1, 1)
  self.intensity = options.intensity or 0.2
  self.constant = options.constant or 1.0
  self.quadratic = options.quadratic or 1.8
  self.linear = options.linear or 0.07
  self.type = options.type or 'point'
  self.cutoff = options.cutoff or 12.5
  self.outerCutoff = options.outerCutoff or 17.5
end

return LightComponent
