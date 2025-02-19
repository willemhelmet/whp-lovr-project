-- src/entities/grid.lua
local lovr = require 'lovr'
local Grid = {}

Grid.data = {
  position = { x = 0, y = 0, z = 0 },
  rotation = { w = -math.pi / 2, x = 1, y = 0, z = 0 },
  scale = { x = 200, y = 200 },
  lineWidth = 0.005,
  backgroundColor = { r = 0.05, g = 0.05, b = 0.05 },
  foregroundColor = { r = 0.5, g = 0.5, b = 0.5 }
}
Grid.vert = lovr.filesystem.newBlob('assets/shaders/grid/grid.vert')
Grid.frag = lovr.filesystem.newBlob('assets/shaders/grid/grid.frag')
Grid.shader = lovr.graphics.newShader(Grid.vert, Grid.frag)

function Grid.draw(pass)
  pass:setShader(Grid.shader)
  pass:send('lineWidth', Grid.data.lineWidth)
  pass:send('background', {
    Grid.data.backgroundColor.r,
    Grid.data.backgroundColor.g,
    Grid.data.backgroundColor.b
  })
  pass:send('foreground', {
    Grid.data.foregroundColor.r, Grid.data.foregroundColor.g, Grid.data.foregroundColor.b })
  pass:plane(
    Grid.data.position.x,
    Grid.data.position.y,
    Grid.data.position.z,
    Grid.data.scale.x,
    Grid.data.scale.y,
    Grid.data.rotation.w,
    Grid.data.rotation.x,
    Grid.data.rotation.y,
    Grid.data.rotation.z
  )
end

return Grid
