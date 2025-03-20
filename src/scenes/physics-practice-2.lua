-- src/scenes/physics-practice-2

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

-- core
local Input = require 'src.core.input'

-- entities
local Grid = require 'src.entities.Grid'
local Controller = require 'src.entities.controller'
local door1, door2, frame

-- components
local JointComponent = require 'src.components.joint-component'
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local PhysicsComponent = require 'src.components.physics-component'

-- systems
local PhysicsSystem = require 'src.systems.physics-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local RenderSystem = require 'src.systems.render-system'
local JointSystem = require 'src.systems.joint-system'

-- Materials
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

-- Physics Practice 2
local PhysicsPractice2 = {}

-- setup ecs
PhysicsPractice2.world = tiny.world(PhysicsSystem, MotionTrackingSystem, RenderSystem, JointSystem)

function PhysicsPractice2.init()
  PhysicsPractice2.world:addEntity(Grid.new())
  PhysicsPractice2.world:addEntity(Controller.new('left'))

  frame = {
    Transform = TransformComponent.new(0, 0.025, -1, 0, 0, 0, 0, 2.2, 0.05, 0.2),
    Mesh = MeshComponent.new('/assets/models/primitives/cube.glb'),
    Material = MaterialComponent.new(UnlitColorMaterial, {
      color = lovr.math.newVec3(
        lovr.math.random(),
        lovr.math.random(),
        lovr.math.random())
    }),
    Physics = PhysicsComponent.new({
      isKinematic = true,
      shapes = {
        {
          type = 'box',
          width = 2.2,
          height = 0.05,
          depth = 0.2
        }
      }
    })
  }
  PhysicsPractice2.world:addEntity(frame)

  door1 = {}
  door1.Transform = TransformComponent.new(0.55, 0.5, -1, 0, 0, 0, 0, 1, 1, 0.2)
  door1.Mesh = MeshComponent.new('/assets/models/primitives/cube.glb')
  door1.Material = MaterialComponent.new(UnlitColorMaterial, {
    color = lovr.math.newVec3(
      lovr.math.random(),
      lovr.math.random(),
      lovr.math.random())
  })
  door1.Physics = PhysicsComponent.new({
    isKinematic = false,
    angularDamping = 0.01,
    shapes = {
      {
        type = 'box',
        width = 1,
        height = 1,
        depth = 0.2
      }
    }
  })
  door1.Joint = JointComponent.new({
    {
      type = 'hinge',
      entityA = frame,
      entityB = door1,
      anchorPosition = lovr.math.newVec3(1, 0, -1),
      anchorAxis = lovr.math.newVec3(0, 1, 0)
    },
  })
  PhysicsPractice2.world:addEntity(door1)

  door2 = {}
  door2.Transform = TransformComponent.new(-0.55, 0.5, -1, 0, 0, 0, 0, 1, 1, 0.2)
  door2.Mesh = MeshComponent.new('/assets/models/primitives/cube.glb')
  door2.Material = MaterialComponent.new(UnlitColorMaterial, {
    color = lovr.math.newVec3(
      lovr.math.random(),
      lovr.math.random(),
      lovr.math.random())
  })
  door2.Physics = PhysicsComponent.new({
    isKinematic = false,
    angularDamping = 0.01,
    shapes = {
      {
        type = 'box',
        width = 1,
        height = 1,
        depth = 0.2
      }
    }
  })
  door2.Joint = JointComponent.new({
    {
      type = 'hinge',
      entityA = frame,
      entityB = door2,
      anchorPosition = lovr.math.newVec3(-1, 0, -1),
      anchorAxis = lovr.math.newVec3(0, 1, 0)
    },
    {
      type = 'distance',
      entityA = door1,
      entityB = door2,
      anchorPosition = lovr.math.newVec3(table.unpack(door1.Transform.position)),
      anchorPosition2 = lovr.math.newVec3(table.unpack(door2.Transform.position))
    }
  })
  PhysicsPractice2.world:addEntity(door2)
end

function PhysicsPractice2.update(dt)
  PhysicsPractice2.world:update(dt)
end

function PhysicsPractice2.draw(pass)
  RenderSystem.draw(pass)
  -- PhysicsSystem.drawDebug(pass)

  pass:setShader()
  pass:text('physics practice 2', 0, 1.5, -2, 0.25)
end

return PhysicsPractice2
