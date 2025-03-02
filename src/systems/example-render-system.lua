-- src/systems/example-render-system.lua

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

local ExampleRenderSystem = tiny.processingSystem()
ExampleRenderSystem.filter = tiny.requireAll("Transform", "Mesh", "Material")

function ExampleRenderSystem.draw(pass)
  local renderables = ExampleRenderSystem.entities
  for _, renderable in pairs(renderables) do
    local transform = renderable.Transform
    local mesh = renderable.Mesh
    local material = renderable.Material

    if mesh.model then
      if material then
        pass:setShader(material.shader)
        for name, value in pairs(material.values) do
          pass:send(name, value)
        end
      else
        pass:setShader()
      end
    end
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
  end
end

return ExampleRenderSystem
