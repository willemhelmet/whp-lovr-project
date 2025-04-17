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
-- systems
local LightingSystem = require('src.systems.lighting-system')

local RenderSystem = tiny.processingSystem()
RenderSystem.filter = tiny.requireAny(
  tiny.requireAll("Transform", "Mesh", "Material"),
  tiny.requireAll("Transform", "Text")
)

-- function RenderSystem:onAdd(e)
-- if e.name then
--   print(e.name)
-- else
--   print(pretty.write(e))
-- end
-- end

function RenderSystem.draw(pass)
  local renderables = RenderSystem.entities

  if renderables then
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

        -- Always set the light buffer for shaders that need it
        -- Get lighting system info once per frame
        local lightBuffer = LightingSystem.getLightBuffer()
        local lightCount = LightingSystem.getLightCount()
        if material.shader == require('assets.materials.phong-material') and lightBuffer then
          pass:send('Lights', lightBuffer)
        end

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
end

function RenderSystem.setUniform(material, uniformName, value)
  if material and material.values then
    material.values[uniformName] = value
  end
end

function RenderSystem.getDrawCalls(pass)
  return pass:getStats().draws
end

return RenderSystem
