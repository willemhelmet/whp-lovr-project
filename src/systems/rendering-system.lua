-- src/systems/rendering-system.lua

local tiny = require 'lib.tiny'
local lovr = require 'lovr'

local RenderingSystem = tiny.processingSystem()
RenderingSystem.filter = tiny.requireAll("Transform", "Render")

function RenderingSystem.process(e, dt)
  local pass = lovr.headset.getPass()
  local transform = e.Transform
  local render = e.Render

  if render.model then
    render.model:animate(1, lovr.headset.getTime())
    pass:setShader(render.material)
    pass:draw(
      model,
      table.unpack(transform.position),
      1,
      table.unpack(transform.orientation)
    )
  end
end
