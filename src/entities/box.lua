-- src/entities/box.lua

local Box = class("Box")

local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local PhysicsComponent = require 'src.components.physics-component'
local MeshComponent = require 'src.components.mesh-component'
local GrabbableComponent = require 'src.components.grabbable-component'

function Box:init(options)
  options = options or {}
  self.Transform = options.Transform or TransformComponent(Vec3(0, 0, 0), Quat(), Vec3(1, 1, 1))
  self.Mesh = options.Mesh or MeshComponent('assets/models/primitives/cube.glb')
  self.Material = options.Material or MaterialComponent()
  self.Physics = options.Physics or PhysicsComponent({
    isKinematic = true,
    shapes = {
      type = 'box',
      width = self.Transform.scale.x,
      height = self.Transform.scale.y,
      depth = self.Transform.scale.z
    },
  })
  self.Physics.userData = self
  self.Grabbable = options.Grabbable or GrabbableComponent()
end

return Box
