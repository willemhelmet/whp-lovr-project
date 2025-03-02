-- src/components/mesh-component.lua

local lovr = require 'lovr'

local MeshComponent = {
  model = nil,
}

function MeshComponent.new(model)
  return {
    model = lovr.graphics.newModel(model),
  }
end

return MeshComponent
