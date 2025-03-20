-- src/systems/render-system.lua
--
-- Render System: Responsible for drawing all visible entities to the screen.
-- Processes entities with Transform, Mesh, and Material components.
-- Handles material properties, shader configuration, and model rendering.
-- The central system for all visual output in the application.

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
-- local pretty = require 'lib.pl.pretty'

local RenderSystem = tiny.processingSystem()
-- TODO: How to handle things that aren't meshes? e.g. Text
RenderSystem.filter = tiny.requireAny(
  tiny.requireAll("Transform", "Mesh", "Material"),
  tiny.requireAll("Transform", "Text")
)

-- function RenderSystem.onAdd(e)
-- print(pretty.write(e))
-- end

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
        lovr.math.vec3(
          transform.position[1],
          transform.position[2],
          transform.position[3]
        ),
        lovr.math.vec3(
          transform.scale[1],
          transform.scale[2],
          transform.scale[3]
        ),
        lovr.math.quat(
          transform.orientation[1],
          transform.orientation[2],
          transform.orientation[3],
          transform.orientation[4]
        )
      )
    elseif text then
      pass:text(
        text.text,
        transform.position[1],
        transform.position[2],
        transform.position[3],
        text.size,
        transform.orientation[1],
        transform.orientation[2],
        transform.orientation[3],
        transform.orientation[4]
      )
    end
  end
end

return RenderSystem
