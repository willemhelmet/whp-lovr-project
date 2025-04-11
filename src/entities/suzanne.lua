-- src/entities/suzanne.lua

local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local TransformComponent = require 'src.components.transform-component'
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

local Suzanne = {}

function Suzanne.new(options)
  local entity = {}
  entity.Transform = options.Transform or TransformComponent.new()
  entity.Material = options.Material or MaterialComponent.new(
    UnlitColorMaterial,
    { color = Vec3(1, 1, 1) }
  )
  entity.Mesh = MeshComponent.new('assets/models/suzanne.glb')

  return entity
end

return Suzanne
