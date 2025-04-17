-- src/scenes/learn-physics.lua

--lib
local lovr = require 'lovr'
local pretty = require 'lib.pl.pretty'
local tiny = require 'lib.tiny'

-- entities
local Controller = require 'src.entities.controller'
local Grid = require 'src.entities.grid'
local Box = require 'src.entities.box'
local Text = require 'src.entities.text-entitiy'
local drawCallTextEntity

-- components
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local PhysicsComponent = require 'src.components.physics-component'
local TransformComponent = require 'src.components.transform-component'
local GrabbableComponent = require 'src.components.grabbable-component'
local TextComponent = require 'src.components.text-component'

-- systems
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local PhysicsSystem = require 'src.systems.physics-system'
local RenderSystem = require 'src.systems.render-system'

--assets
local UnlitColorMaterial = require 'assets.materials.unlit-color-material'

-- Learn Physics
local LearnPhysics = {}
LearnPhysics.world = tiny.world(RenderSystem, MotionTrackingSystem, PhysicsSystem)

function LearnPhysics:init()
  LearnPhysics.world:addEntity(Grid())
  LearnPhysics.world:addEntity(Controller('left'))

  LearnPhysics.world:addEntity(Text({
    Transform = TransformComponent(
      Vec3(0, 1.5, -4)
    ),
    Text = TextComponent('learn physics', 0.4)
  }))

  for x = -1, 1, .25 do
    for y = .125, 2, .2499 do
      LearnPhysics.world:addEntity(Box({
        Transform = TransformComponent(
          Vec3(x, y, -2 - y / 5),
          Quat(1, 0, 0, 0),
          Vec3(.25, .25, .25)
        ),
        Mesh = MeshComponent("assets/models/primitives/cube.glb"),
        Material = MaterialComponent(
          UnlitColorMaterial,
          { color = Vec3(lovr.math.random(), lovr.math.random(), lovr.math.random()) }
        ),
        Physics = PhysicsComponent({
          isKinematic = false,
          shapes = {
            {
              type = 'box',
              width = 0.25,
              height = 0.25,
              depth = 0.25
            }
          }
        }),
        Grabbable = GrabbableComponent()
      }))
    end
  end

  drawCallTextEntity = Text({
    Transform = TransformComponent(
      Vec3(0, 2.0, -3)
    ),
    Text = TextComponent(
      'number of draw calls', 0.25
    )
  })
  LearnPhysics.world:add(drawCallTextEntity)
end

function LearnPhysics.update(dt)
  LearnPhysics.world:update(dt)
end

function LearnPhysics.draw(pass)
  RenderSystem.draw(pass)
  drawCallTextEntity.Text:setText(RenderSystem.getDrawCalls(pass))
  -- PhysicsSystem.drawDebug(pass)
end

return LearnPhysics
