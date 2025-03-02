-- src/scenes/pass-sidequest.lua

-- lib
local tiny = require 'lib.tiny'

-- entities
local Grid = require 'src.entities.grid'
local Controller = require 'src.entities.controller'

-- Systems
local ExampleRenderSystem = require 'src.systems.example-render-system'
local MotionTrackingSystem = require 'src.systems.motion-tracking-system'

-- Components
local MeshComponent = require 'src.components.mesh-component'
local TransformComponent = require 'src.components.transform-component'
local MaterialComponent = require 'src.components.material-component'
local MotionTrackingComponent = require 'src.components.motion-tracking-component'

-- World
local PassSidequest = {}
PassSidequest.world = tiny.world(ExampleRenderSystem, MotionTrackingSystem)

local balls = {}

function PassSidequest.init()
  -- Controllers
  PassSidequest.world:addEntity(Controller.new('left'))
  PassSidequest.world:addEntity(Controller.new('right'))
  -- Grid
  PassSidequest.world:addEntity(Grid.new())

  -- Sin wave controllers
  for i = 1, 20 do
    local x = (i - 10) * 0.5
    local y = math.sin(i) + 1.5
    local z = -2
    local ball = {
      Transform = TransformComponent.new(x, y, z, 0, 0, 0, 0, 1, 1, 1),
      Mesh = MeshComponent.new("/assets/models/controller-right.glb"),
      Material = MaterialComponent.new(nil, {}),
    }
    balls[i] = ball
    PassSidequest.world:addEntity(ball)
  end
end

function PassSidequest.update(dt)
  PassSidequest.world:update(dt)
end

function PassSidequest.draw(pass)
  ExampleRenderSystem.draw(pass)
  pass:text('pass sidequest', 0, 1.5, -2, 0.25)
end

return PassSidequest
