-- src/systems/render-system.lua
--
-- Render System: Responsible for drawing all visible entities to the screen.
-- Processes entities with Transform, Mesh, and Material components.
-- Handles material properties, shader configuration, and model rendering.
-- The central system for all visual output in the application.

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

local RenderSystem = tiny.processingSystem()
RenderSystem.filter = tiny.requireAny(
  tiny.requireAll("Transform", "Mesh", "Material"),
  tiny.requireAll("Transform", "Text")
)

function RenderSystem.onAdd(e)
  -- print(pretty.write(e))
end

function RenderSystem.draw(pass)
  local renderables = RenderSystem.entities
  for _, renderable in pairs(renderables) do
    local transform = renderable.Transform

    -- 3D model
    local mesh = renderable.Mesh
    local material = renderable.Material

    -- text
    local text = renderable.Text

    -- handle material
    if material and material.shader then
      pass:setShader(material.shader)
      for name, value in pairs(material.values) do
        pass:send(name, value)
      end
    else
      pass:setShader(nil)
    end

    if mesh and mesh.model then
      -- handle mesh
      pass:draw(
        mesh.model,
        transform.localPosition,
        transform.localScale,
        transform.localOrientation
      )
    elseif text then
      pass:text(
        text.text,
        transform.localPosition,
        text.size,
        transform.localOrientation,
        0, -- text.wrap, not implemented
        text.halign,
        text.valign
      )
    end
  end
end

function RenderSystem.setUniform(material, uniformName, value)
  if material and material.values then
    material.values[uniformName] = value
  end
end

return RenderSystem
