-- src/entities/input-debug-entity.lua
--TODO: implement
local lovr = require 'lovr'
local InputDebug = {}

local TransformComponent = require 'src.components.transform-component'

function InputDebug.new()
  return {
    Transform = TransformComponent.new(
      0, 1.5, -3,
      0, 0, 0, 0,
      1, 1, 1
    ),

  }
end
