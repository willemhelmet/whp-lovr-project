-- src/scenes/physics-practice-1.lua

-- core
-- local Input = require 'src.core.input'

-- libraries
local lovr = require 'lovr'
local tiny = require 'lib.tiny'
local pretty = require 'lib.pl.pretty'

-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'

-- components
local JointComponent = require 'src.components.joint-component'
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local PhysicsComponent = require 'src.components.physics-component'

-- systems
local JointSystem = require 'src.systems.joint-system'
local PhysicsSystem = require 'src.systems.physics-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local RenderSystem = require 'src.systems.render-system'
local InputSystem = require 'src.systems.input-system'

-- assets
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

local NewtonsCradle = {}
NewtonsCradle.world = tiny.world(InputSystem, PhysicsSystem, MotionTrackingSystem, RenderSystem, JointSystem)
NewtonsCradle.world:setSystemIndex(PhysicsSystem, 1)
NewtonsCradle.world:setSystemIndex(JointSystem, 2)

local frame
local framePose
local balls = {}
local count = 10
local radius = 1 / count / 2

local gap = 0.01

local controllerBoxes = {}

function NewtonsCradle.init()
  NewtonsCradle.world:addEntity(Grid())
  -- static geometry from which balls are suspended
  local size = lovr.math.vec3(1.2, 0.1, 0.3)
  frame = {
    Transform = TransformComponent(
      Vec3(0, 2, -2),
      Quat(0, 0, 0, 0),
      Vec3(1.2, 0.1, 0.3)
    ),
    Mesh = MeshComponent("/assets/models/primitives/cube.glb"),
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
          width = 1.2,
          height = 0.1,
          depth = 0.3
        }
      }
    })
  }
  NewtonsCradle.world:addEntity(frame)
  -- create balls along length of frame
  for x = -0.5, 0.5, 1 / count do
    local ball = {}
    ball.Transform = TransformComponent(
      Vec3(x, 1, -2),
      Quat(0, 0, 0, 0),
      Vec3(radius, radius, radius)
    )
    ball.Mesh = MeshComponent('/assets/models/primitives/sphere.glb')
    ball.Material = MaterialComponent(UnlitColorMaterial, {
      color = Vec3(
        lovr.math.random(),
        lovr.math.random(),
        lovr.math.random())
    })
    ball.Physics = PhysicsComponent({
      restitution = 1.0,
      shapes = {
        {
          type = 'sphere',
          radius = radius - gap
        }
      }
    })
    ball.Joint = JointComponent({
      {
        type = 'distance',
        entityA = frame,
        entityB = ball,
        anchorPosition = Vec3(x, 2, -2 + 0.25),
        anchorPosition2 = Vec3(x, 1, -2)
      },
      {
        type = 'distance',
        entityA = frame,
        entityB = ball,
        anchorPosition = Vec3(x, 2, -2 - 0.25),
        anchorPosition2 = Vec3(x, 1, -2)
      }
    })
    NewtonsCradle.world:addEntity(ball)
    table.insert(balls, ball)
  end
end

local hasAppliedInitialImpulse = false
function NewtonsCradle.update(dt)
  NewtonsCradle.world:update(dt)
  if not hasAppliedInitialImpulse then
    local lastBall = balls[#balls].Physics.collider
    lastBall:applyLinearImpulse(0.6, 0, 0)
    hasAppliedInitialImpulse = true
  end
end

function NewtonsCradle.draw(pass)
  -- PhysicsSystem.drawDebug(pass)
  RenderSystem.draw(pass)

  pass:setShader()
  pass:setColor(1, 1, 1)
  pass:text('newtons cradle', 0, 1.5, -4, 0.35)
end

return NewtonsCradle
