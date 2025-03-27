-- assets/materials/unlit-color-material.lua
local lovr = require 'lovr'

return lovr.graphics.newShader(
  lovr.filesystem.newBlob('assets/shaders/unlit-color/unlit-color.vert'),
  lovr.filesystem.newBlob('assets/shaders/unlit-color/unlit-color.frag'),
  {}
)
