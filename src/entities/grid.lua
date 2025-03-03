-- src/entities/grid.lua
local lovr = require 'lovr'

-- components
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local PhysicsComponent = require 'src.components.physics-component'
local TransformComponent = require 'src.components.transform-component'

local Grid = {
  Transform = nil,
  Mesh = nil,
  Material = nil
}

function Grid.new()
  local vert = lovr.filesystem.newBlob('assets/shaders/grid/grid.vert')
  local frag = lovr.filesystem.newBlob('assets/shaders/grid/grid.frag')
  local shader = lovr.graphics.newShader(vert, frag)
  return {
    Grid = {},
    Transform = TransformComponent.new(
      0, 0, 0,
      0, 0, 0, 0,
      200,
      200,
      200
    ),
    Mesh = MeshComponent.new('/assets/models/primitives/plane.glb'),
    Material = MaterialComponent.new(
      shader,
      {
        lineWidth = 0.005,
        background = { 0.05, 0.05, 0.05 },
        foreground = { 0.5, 0.5, 0.5 }
      }
    ),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      friction = 1.0,
      restitution = 0.0,
      shapes = {
        {
          type = 'box',
          width = 200,
          height = 0.001,
          depth = 200
        }
      },
    })
  }
end

return Grid
