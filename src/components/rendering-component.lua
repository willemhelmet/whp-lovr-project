-- src/components/rendering-component.lua
--
-- Rendering Component: Defines the visual representation of an entity.
-- Stores the 3D model to be rendered and associated material properties.
-- Used by the Render System to draw entities in the world.

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
