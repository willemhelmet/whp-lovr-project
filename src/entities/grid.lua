-- src/entities/grid.lua
local Grid = {}

-- components
local TransformComponent = require 'src.components.transform-component'
local MeshComponent = require 'src.components.mesh-component'
local MaterialComponent = require 'src.components.material-component'
local PhysicsComponent = require 'src.components.physics-component'

-- materials
local GridMaterial = require 'assets.materials.grid-material'

function Grid.new()
  return {
    Transform = TransformComponent.new(
      0, 0, 0,
      0, 0, 0, 0,
      200,
      200,
      200
    ),
    Mesh = MeshComponent.new('/assets/models/primitives/plane.glb'),
    Material = MaterialComponent.new(
      GridMaterial,
      {
        lineWidth = 0.005,
        background = { 0.05, 0.05, 0.05 },
        foreground = { 0.5, 0.5, 0.5 }
      }
    ),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      offset = { 0, -0.005, 0 },
      shapes = {
        {
          type = 'box',
          width = 200,
          height = 0.01,
          depth = 200
        }
      }
    }

    )
  }
end

return Grid
