-- src/entities/suzanne.lua

local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local TransformComponent = require 'src.components.transform-component'
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

local Suzanne = class('Suzanne')

function Suzanne:init(options)
  options = options or {}
  self.Transform = options.Transform or TransformComponent()
  self.Material = options.Material or MaterialComponent(
    UnlitColorMaterial,
    { color = Vec3(1, 1, 1) }
  )
  self.Mesh = MeshComponent('assets/models/suzanne.glb')
end

return Suzanne
