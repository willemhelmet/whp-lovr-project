-- src/components/mesh-component.lua
--
-- Mesh Component: Defines the 3D geometry of an entity.
-- Stores the model that represents the entity's visual shape.
-- Used by the Render System in conjunction with Material and Transform
-- components to draw the entity in the world.


local MeshComponent = class('Mesh')

function MeshComponent:init(model)
  self.model = lovr.graphics.newModel(model)
end

return MeshComponent
