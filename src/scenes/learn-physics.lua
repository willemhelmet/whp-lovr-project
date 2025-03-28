-- src/scenes/learn-physics.lua

--lib
local lovr = require 'lovr'
local pretty = require 'lib.pl.pretty'
local tiny = require 'lib.tiny'

-- entities
local Controller = require 'src.entities.controller'
local Grid = require 'src.entities.grid'
local Box = require 'src.entities.box'

-- components
local MaterialComponent = require 'src.components.material-component'
local MeshComponent = require 'src.components.mesh-component'
local PhysicsComponent = require 'src.components.physics-component'
local TransformComponent = require 'src.components.transform-component'
local GrabComponent = require 'src.components.grab-component'

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
  LearnPhysics.world:addEntity(Grid.new())
  LearnPhysics.world:addEntity(Controller.new('left'))

  for x = -1, 1, .25 do
    for y = .125, 2, .2499 do
      LearnPhysics.world:addEntity(Box.new({
        Transform = TransformComponent.new(x, y, -2 - y / 5, 0, 0, 0, 0, .25, .25, .25),
        Mesh = MeshComponent.new("assets/models/primitives/cube.glb"),
        Material = MaterialComponent.new(
          UnlitColorMaterial,
          { color = lovr.math.newVec3(lovr.math.random(), lovr.math.random(), lovr.math.random()) }
        ),
        Physics = PhysicsComponent.new({
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
        Grab = GrabComponent.new({})
      }))
    end
  end
end

function LearnPhysics.update(dt)
  -- Update ECS
  LearnPhysics.world:update(dt)
end

function LearnPhysics.draw(pass)
  RenderSystem.draw(pass)

  pass:setShader()
  pass:text('learn physics', 0, 1.5, -4, .4)
end

return LearnPhysics
