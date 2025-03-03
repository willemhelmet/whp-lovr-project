-- src/scenes/physics-practice-2

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

-- core
local Input = require 'src.core.input'

-- entities
local Grid = require 'src.entities.Grid'
local Controller = require 'src.entities.controller'

-- components

-- systems
local PhysicsSystem = require 'src.systems.physics-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'
local RenderSystem = require 'src.systems.render-system'

-- Physics Practice 2
local PhysicsPractice2 = {}

-- setup ecs
PhysicsPractice2.world = tiny.world(PhysicsSystem, MotionTrackingSystem, RenderSystem)

local controllers = {
  left = nil,
  right = nil
}

function PhysicsPractice2.init()
  PhysicsPractice2.world:addEntity(Grid.new())
  PhysicsPractice2.world:addEntity(Controller.new('left'))
end

function PhysicsPractice2.update(dt)
  PhysicsPractice2.world:update(dt)
end

function PhysicsPractice2.draw(pass)
  RenderSystem.draw(pass)

  pass:setShader()
  pass:text('physics practice 2', 0, 1.5, -2, 0.25)
end

return PhysicsPractice2
