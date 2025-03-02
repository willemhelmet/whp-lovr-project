-- src/scenes/physics-practice-2

-- lib
local lovr = require 'lovr'
local tiny = require 'lib.tiny'

-- core
local Input = require 'src.core.input'

-- systems
local PhysicsSystem = require 'src.systems.physics-system'
local ControllerSystem = require 'src.systems.controller-system'
local ControllerRenderingSystem = require 'src.systems.controller-rendering-system'

-- entities
local Grid = require 'src.entities.Grid'
local Controller = require 'src.entities.controller'

-- Physics Practice 2
local PhysicsPractice2 = {}

-- setup ecs
PhysicsPractice2.world = tiny.world(PhysicsSystem, ControllerSystem, ControllerRenderingSystem)

local controllers = {
  left = nil,
  right = nil
}

function PhysicsPractice2.init()
  for _, hand in ipairs(Input.getHands()) do
    if lovr.headset.isTracked(hand) then
      controllers[hand:sub(6)] = Controller.new(hand:sub(6))
      PhysicsPractice2.world:addEntity(controllers[hand])
    end
  end
end

function PhysicsPractice2.update(dt)
  PhysicsPractice2.world:update(dt)
end

function PhysicsPractice2.draw(pass)
  Grid.draw(pass)

  pass:setShader()
  ControllerRenderingSystem.draw(pass)

  pass:text('physics practice 2', 0, 1.5, -2, 0.25)
end

return PhysicsPractice2
