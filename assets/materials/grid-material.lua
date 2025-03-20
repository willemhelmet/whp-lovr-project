-- assets/materials/grid-material.lua

local lovr = require 'lovr'

return lovr.graphics.newShader(
  lovr.filesystem.newBlob('assets/shaders/grid/grid.vert'),
  lovr.filesystem.newBlob('assets/shaders/grid/grid.frag')
)
