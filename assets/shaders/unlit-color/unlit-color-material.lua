-- assets/shaders/unlit-color/unlit-color-material.lua
local lovr = require 'lovr'

local UnlitColor = {
  vert = lovr.filesystem.newBlob('assets/shaders/unlit-color/unlit-color.vert'),
  frag = lovr.filesystem.newBlob('assets/shaders/unlit-color/unlit-color.frag')
}
return lovr.graphics.newShader(UnlitColor.vert, UnlitColor.frag, {})
