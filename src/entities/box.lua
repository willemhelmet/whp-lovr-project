-- src/entities/box.lua

local Box = {}

local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local PhysicsComponent = require 'src.components.physics-component'
local MeshComponent = require 'src.components.mesh-component'
local GrabbableComponent = require 'src.components.grabbable-component'

function Box.new(options)
  local box = {}
  box.Transform = options.Transform or TransformComponent.new(0, 0, 0, 1, 0, 0, 0, 1, 1, 1)
  box.Material = options.Material or MaterialComponent.new()
  box.Mesh = MeshComponent.new('assets/models/primitives/cube.glb')
  if options.Grabbable then
    box.Grabbable = options.Grabbable
  end
  box.Physics = options.Physics or PhysicsComponent.new({
    isKinematic = true,
    shapes = {
      type = 'box',
      width = box.Transform.scale.x,
      height = box.Transform.scale.y,
      depth = box.Transform.scale.z
    },
  })
  box.Physics.userData = box
  return box
end

return Box
