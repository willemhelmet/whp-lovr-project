-- src/components/material-component-lua
--
-- Material Component: Defines the visual appearance properties of an entity.
-- Stores shader program and uniform values for rendering.
-- Controls how light interacts with surfaces, textures, colors and other
-- visual characteristics of entities.

local MaterialComponent = class('Material')

function MaterialComponent:init(shader, uniforms)
  self.shader = shader
  self.values = uniforms or {}
end

return MaterialComponent
