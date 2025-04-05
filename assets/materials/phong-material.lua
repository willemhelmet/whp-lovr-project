-- assets/materials/phong-material.lua

local lovr = require 'lovr'


return lovr.graphics.newShader(
  lovr.filesystem.newBlob('assets/shaders/phong/phong.vert'),
  lovr.filesystem.newBlob('assets/shaders/phong/phong.frag')
)
