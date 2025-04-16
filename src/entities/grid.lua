-- src/entities/grid.lua
local lovr = require 'lovr'
local class = require 'lib.30log'

-- components
local TransformComponent = require 'src.components.transform-component'
local MeshComponent = require 'src.components.mesh-component'
local MaterialComponent = require 'src.components.material-component'
local PhysicsComponent = require 'src.components.physics-component'
-- materials
local GridMaterial = require 'assets.materials.grid-material'

local Grid = class('Grid')

function Grid:init()
  self.Transform = TransformComponent(
    Vec3(0, 0, 0),
    Quat(1, 0, 0, 0),
    Vec3(200, 200, 200)
  )
  self.Mesh = MeshComponent('/assets/models/primitives/plane.glb')
  self.Material = MaterialComponent(
    GridMaterial,
    {
      lineWidth = 0.005,
      background = { 0.05, 0.05, 0.05 },
      foreground = { 0.5, 0.5, 0.5 }
    }
  )
  self.Physics = PhysicsComponent({
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
end

return Grid
