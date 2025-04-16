-- src/scenes/physics-practice-2

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

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
local InputSystem = require 'src.systems.input-system'

-- Materials
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

-- Physics Practice 2
local PhysicsPractice2 = {}

-- setup ecs
PhysicsPractice2.world = tiny.world(InputSystem, PhysicsSystem, MotionTrackingSystem, RenderSystem, JointSystem)

function PhysicsPractice2.init()
  PhysicsPractice2.world:addEntity(Grid())
  PhysicsPractice2.world:addEntity(Controller('left'))

  frame = {
    Transform = TransformComponent(
      Vec3(0, 0.025, -1),
      Quat(0, 0, 0, 0),
      Vec3(2.2, 0.05, 0.2)
    ),
    Mesh = MeshComponent('/assets/models/primitives/cube.glb'),
    Material = MaterialComponent(UnlitColorMaterial, {
      color = Vec3(
        lovr.math.random(),
        lovr.math.random(),
        lovr.math.random())
    }),
    Physics = PhysicsComponent({
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
  door1.Transform = TransformComponent(
    Vec3(0.55, 0.5, -1),
    Quat(0, 0, 0, 0),
    Vec3(1, 1, 0.2)
  )
  door1.Mesh = MeshComponent('/assets/models/primitives/cube.glb')
  door1.Material = MaterialComponent(UnlitColorMaterial, {
    color = Vec3(
      lovr.math.random(),
      lovr.math.random(),
      lovr.math.random())
  })
  door1.Physics = PhysicsComponent({
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
  door1.Joint = JointComponent({
    {
      type = 'hinge',
      entityA = frame,
      entityB = door1,
      anchorPosition = Vec3(1, 0, -1),
      anchorAxis = Vec3(0, 1, 0)
    },
  })
  PhysicsPractice2.world:addEntity(door1)

  door2 = {}
  door2.Transform = TransformComponent(
    Vec3(-0.55, 0.5, -1),
    Quat(1, 0, 0, 0),
    Vec3(1, 1, 0.2)
  )
  door2.Mesh = MeshComponent('/assets/models/primitives/cube.glb')
  door2.Material = MaterialComponent(UnlitColorMaterial, {
    color = Vec3(
      lovr.math.random(),
      lovr.math.random(),
      lovr.math.random())
  })
  door2.Physics = PhysicsComponent({
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
  door2.Joint = JointComponent({
    {
      type = 'hinge',
      entityA = frame,
      entityB = door2,
      anchorPosition = Vec3(-1, 0, -1),
      anchorAxis = Vec3(0, 1, 0)
    },
    {
      type = 'distance',
      entityA = door1,
      entityB = door2,
      anchorPosition = door1.Transform.position,
      anchorPosition2 = door2.Transform.position
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
