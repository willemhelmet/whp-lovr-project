-- src/components/render-component.lua

local lovr = require 'lovr'

local RenderComponent = {
  model = nil,
  material = nil,
  debug = false
}

function RenderComponent.new(model, material, debug)
  local entity = {
    model = lovr.graphics.newModel(model),
    material = material,
    debug = debug
  }
  return entity
end

return RenderComponent
